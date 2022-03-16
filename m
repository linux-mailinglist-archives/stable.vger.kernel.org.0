Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6304DB9E8
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 22:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243953AbiCPVKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 17:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiCPVKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 17:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0A0C05;
        Wed, 16 Mar 2022 14:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42FB4B81D66;
        Wed, 16 Mar 2022 21:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917E4C340EC;
        Wed, 16 Mar 2022 21:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647464946;
        bh=oWK3VcNvpXGTNhy85nGsEuBb0xLj+hGobYNogj8xemA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7h37YQ6uAvKEsqQZ/qS24pnWVadk3WbVxPK1DDYOhSGSuTASwzPaNBR/gUruokiX
         rGftaV3gnwWPlFCmHHKM2zZ9tWQcC+cAOBryIHekRu2sTKBWaeIqbN5YS6QGRqtasn
         NphHE2JPraITErtwDaRJOE6rN9QbiIl7banPPseI=
Date:   Wed, 16 Mar 2022 14:09:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Dong Aisheng <dongas86@gmail.com>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawnguo@kernel.org, linux-imx@nxp.com, m.szyprowski@samsung.com,
        lecopzer.chen@mediatek.com, david@redhat.com, vbabka@suse.cz,
        stable@vger.kernel.org, shijie.qin@nxp.com
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
Message-Id: <20220316140904.513fe0e8180b4e3fcad24e3b@linux-foundation.org>
In-Reply-To: <CAA+hA=Ss=YBt-3f=r1BL1NuO7FK56kTf31zWzNjMBkAKQE41Rg@mail.gmail.com>
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
        <20220315144521.3810298-2-aisheng.dong@nxp.com>
        <20220315155837.2dcef6eb226ad74e37ca31ca@linux-foundation.org>
        <CAA+hA=Ss=YBt-3f=r1BL1NuO7FK56kTf31zWzNjMBkAKQE41Rg@mail.gmail.com>
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

On Wed, 16 Mar 2022 11:41:37 +0800 Dong Aisheng <dongas86@gmail.com> wrote:

> On Wed, Mar 16, 2022 at 6:58 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 15 Mar 2022 22:45:20 +0800 Dong Aisheng <aisheng.dong@nxp.com> wrote:
> >
> > > --- a/mm/cma.c
> > > +++ b/mm/cma.c
> > >
> > > ...
> > >
> > > @@ -457,6 +458,16 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
> > >                               offset);
> > >               if (bitmap_no >= bitmap_maxno) {
> > >                       spin_unlock_irq(&cma->lock);
> > > +                     pr_debug("%s(): alloc fail, retry loop %d\n", __func__, loop++);
> > > +                     /*
> > > +                      * rescan as others may finish the memory migration
> > > +                      * and quit if no available CMA memory found finally
> > > +                      */
> > > +                     if (start) {
> > > +                             schedule();
> > > +                             start = 0;
> > > +                             continue;
> > > +                     }
> > >                       break;
> >
> > The schedule() is problematic. For a start, we'd normally use
> > cond_resched() here, so we avoid calling the more expensive schedule()
> > if we know it won't perform any action.
> >
> > But cond_resched() is problematic if this thread has realtime
> > scheduling policy and the process we're waiting on does not.  One way
> > to address that is to use an unconditional msleep(1), but that's still
> > just a hack.
> >
> 
> I think we can simply drop schedule() here during the second round of retry
> as the estimated delay may not be really needed.

That will simply cause a tight loop, so I'm obviously not understanding
the proposal.

