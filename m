Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C40F62FF78
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 22:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiKRVml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 16:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKRVml (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 16:42:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E300A5715;
        Fri, 18 Nov 2022 13:42:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E777DB8255A;
        Fri, 18 Nov 2022 21:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EA1C433D6;
        Fri, 18 Nov 2022 21:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668807757;
        bh=WCPSd68RHGDTmUGJSNAlMJajTd8lyzv3UTFrUTuu6Pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fG5ssDEhHsnZ7cCi8hoDKZ3Yq44Q4NZanE7eKUfA0v6WD0+fd7vKP1VUJF7Cnby2k
         hYyck5qs0LoBNYqW0o2VfQEx2vhdzmTKhJ5TERW3t339NYh46eAX+KR2eGN6QNv6/g
         SUCnfJ4eIMwT+2yuiHyMtCNfetPUPcHFJp76co+4=
Date:   Fri, 18 Nov 2022 13:42:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     akinobu.mita@gmail.com, dvyukov@google.com, jgg@nvidia.com,
        willy@infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Message-Id: <20221118134236.17a67804b3b6e6c157d8ea02@linux-foundation.org>
In-Reply-To: <20221118100011.2634-1-zhengqi.arch@bytedance.com>
References: <20221118100011.2634-1-zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Nov 2022 18:00:11 +0800 Qi Zheng <zhengqi.arch@bytedance.com> wrote:

> When we specify __GFP_NOWARN, we only expect that no warnings
> will be issued for current caller. But in the __should_failslab()
> and __should_fail_alloc_page(), the local GFP flags alter the
> global {failslab|fail_page_alloc}.attr, which is persistent and
> shared by all tasks. This is not what we expected, let's fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
>
> ...
>
> -bool should_fail(struct fault_attr *attr, ssize_t size)
> +bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
>  {
>  	bool stack_checked = false;
>  
> @@ -152,13 +149,20 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
>  		return false;
>  
>  fail:
> -	fail_dump(attr);
> +	if (!(flags & FAULT_NOWARN))
> +		fail_dump(attr);
>  
>  	if (atomic_read(&attr->times) != -1)
>  		atomic_dec_not_zero(&attr->times);
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(should_fail_ex);

I don't see a need to export this?


