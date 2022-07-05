Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7D566271
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 06:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiGEEjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 00:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGEEjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 00:39:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3163810FEE
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 21:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5BE5618DC
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 04:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CEFC341C7;
        Tue,  5 Jul 2022 04:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656995947;
        bh=/YhtlBZVkiY3b+YhyAzl0WObXYbUdNxcQoMFOxViWVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cmVCiU8M+/rMoCETlBgHsxS3ba8yMp5h2bR4SK98r7p2EhT2X91+VOSyXq/cDyj+t
         T4Vgyz8o3pM6avNOUWZlVMOY1W7VjnkL7RJ3wcbd3zLf3geVP8ScD/We12TBlNrWgu
         JjFlN341rncFgL7HPsSOulxekpfTrDrClx4H7K90=
Date:   Tue, 5 Jul 2022 06:39:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Message-ID: <YsPAaNKwTWfkiZTy@kroah.com>
References: <20220704154508.13317-1-wenyang@linux.alibaba.com>
 <YsMOWwHRUdQ/zLmx@kroah.com>
 <36b71543-fc3f-2787-06b8-2d38f1ee5b93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36b71543-fc3f-2787-06b8-2d38f1ee5b93@linux.alibaba.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 11:45:29AM +0800, Wen Yang wrote:
> 
> 
> 在 2022/7/4 下午11:59, Greg Kroah-Hartman 写道:
> > On Mon, Jul 04, 2022 at 11:45:08PM +0800, Wen Yang wrote:
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > commit ddd07b750382adc2b78fdfbec47af8a6e0d8ef37 upstream.
> > > 
> > > CAT has happened, WBINDV is bad (even before CAT blowing away the
> > > entire cache on a multi-core platform wasn't nice), try not to use it
> > > ever.
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Reviewed-by: Dave Hansen <dave.hansen@intel.com>
> > > Cc: Bin Yang <bin.yang@intel.com>
> > > Cc: Mark Gross <mark.gross@intel.com>
> > > Link: https://lkml.kernel.org/r/20180919085947.933674526@infradead.org
> > > Cc: <stable@vger.kernel.org> # 4.19.x
> > > Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> > > ---
> > >   arch/x86/mm/pageattr.c | 18 ++----------------
> > >   1 file changed, 2 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > > index 101f3ad0d6ad..ab87da7a6043 100644
> > > --- a/arch/x86/mm/pageattr.c
> > > +++ b/arch/x86/mm/pageattr.c
> > > @@ -239,26 +239,12 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
> > >   			    int in_flags, struct page **pages)
> > >   {
> > >   	unsigned int i, level;
> > > -#ifdef CONFIG_PREEMPT
> > > -	/*
> > > -	 * Avoid wbinvd() because it causes latencies on all CPUs,
> > > -	 * regardless of any CPU isolation that may be in effect.
> > > -	 *
> > > -	 * This should be extended for CAT enabled systems independent of
> > > -	 * PREEMPT because wbinvd() does not respect the CAT partitions and
> > > -	 * this is exposed to unpriviledged users through the graphics
> > > -	 * subsystem.
> > > -	 */
> > > -	unsigned long do_wbinvd = 0;
> > > -#else
> > > -	unsigned long do_wbinvd = cache && numpages >= 1024; /* 4M threshold */
> > > -#endif
> > >   	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
> > > -	on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
> > > +	flush_tlb_all();
> > > -	if (!cache || do_wbinvd)
> > > +	if (!cache)
> > >   		return;
> > >   	/*
> > > -- 
> > > 2.19.1.6.gb485710b
> > > 
> > 
> > Why is this needed on 4.19.y?  What problem does it solve, it looks only
> > like an optimization, not a bugfix.
> > 
> > And if it's a bugfix, why only 4.19.y, why not older kernels too?
> > 
> > We need more information here please.
> > 
> 
> On a 128-core Intel(R) Xeon(R) Platinum 8369B CPU @ 2.90GHz server, when the
> user program frequently calls nv_alloc_system_pages to allocate large
> memory, it often causes a delay of about 200 milliseconds for the entire
> system. In this way, other latency-sensitive tasks on this system are
> heavily impacted, causing stability issues in large-scale clusters as well.
> 
> nv_alloc_system_pages
> -> _set_memory_array
> -> change_page_attr_set_clr
> -> cpa_flush_array
> -> on_each_cpu(__cpa_flush_all, (void *) do_wbinvd, 1);
> 
> 
> This patch can be directly merged into the 4.19 kernel to solve this
> problem, and most of the machines in our production environment are 4.19
> kernels.

Ah.  So what has changed from last year when I rejected this then:
	https://lore.kernel.org/all/9c415df9-9575-8217-03e9-a6bbf20a491a@linux.alibaba.com/T/#m06369d080fa97eda3dd6a8eaf54a8ca2d430b3ab

Please do not try to submit previously-rejected patches, that is very
disingenuous.

greg k-h
