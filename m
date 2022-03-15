Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF94DA5D5
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 23:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiCOW7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 18:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352433AbiCOW7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED89A4C418;
        Tue, 15 Mar 2022 15:58:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A985614A4;
        Tue, 15 Mar 2022 22:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEF8C340E8;
        Tue, 15 Mar 2022 22:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647385119;
        bh=nAaYL5YjCg97b7NBxM3k75M3xEa2Xha1to1xC1/Cx0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GYvfeIORbleDqEAFiLNYtWqvdjKjkaNBDGOq6DzMhVo9mDsIVxLE4o3mgIC5tUR6E
         5yojWb/x1d0ZA5xiCcuGAzNq2Yx3k0eQt+i2ocKA3Yv1Kx0P0Njjwos8KdjTEnoh6c
         /9zvEUx+SFWPDb9NyMOFImyK9MMjtyRD16u0mxTQ=
Date:   Tue, 15 Mar 2022 15:58:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Dong Aisheng <aisheng.dong@nxp.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dongas86@gmail.com,
        shawnguo@kernel.org, linux-imx@nxp.com, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
Message-Id: <20220315155837.2dcef6eb226ad74e37ca31ca@linux-foundation.org>
In-Reply-To: <20220315144521.3810298-2-aisheng.dong@nxp.com>
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
        <20220315144521.3810298-2-aisheng.dong@nxp.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Mar 2022 22:45:20 +0800 Dong Aisheng <aisheng.dong@nxp.com> wrote:

> --- a/mm/cma.c
> +++ b/mm/cma.c
>
> ...
>
> @@ -457,6 +458,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>  				offset);
>  		if (bitmap_no >= bitmap_maxno) {
>  			spin_unlock_irq(&cma->lock);
> +			pr_debug("%s(): alloc fail, retry loop %d\n", __func__, loop++);
> +			/*
> +			 * rescan as others may finish the memory migration
> +			 * and quit if no available CMA memory found finally
> +			 */
> +			if (start) {
> +				schedule();
> +				start = 0;
> +				continue;
> +			}
>  			break;

The schedule() is problematic.  For a start, we'd normally use
cond_resched() here, so we avoid calling the more expensive schedule()
if we know it won't perform any action.

But cond_resched() is problematic if this thread has realtime
scheduling policy and the process we're waiting on does not.  One way
to address that is to use an unconditional msleep(1), but that's still
just a hack.

A much cleaner solution is to use appropriate locking so that various
threads run this code in order, without messing each other up.

And it looks like the way to do that is to simply revert the commit
which caused this regression, a4efc174b382 ("mm/cma.c: remove redundant
cma_mutex lock")?
