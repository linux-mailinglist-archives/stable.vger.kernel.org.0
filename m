Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347984AB8CB
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 11:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiBGKfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 05:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237462AbiBGKS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 05:18:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B339BC043181;
        Mon,  7 Feb 2022 02:18:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D37261297;
        Mon,  7 Feb 2022 10:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E65C004E1;
        Mon,  7 Feb 2022 10:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644229134;
        bh=5ldiobl7gosz7YWwdwT3byG6YkZL6Tnfq+gbfeJhlUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQm7hMFL0uFUzmJUAL4jkDCy/+B5DeaaldeK1PH7aTnzFnYMDKnLTtbVivvJsyyf4
         XU2e9HyLROB41Loltr3JkxyGIWX7CirRQNQbfTHDdMhPzSrMao9ydNycTYR5vCaruY
         KacETv/NQNZClWaHOyfOZNFGeVbBNwE8t1Zyb5/U=
Date:   Mon, 7 Feb 2022 11:18:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?572X6aOe?= <luofei@unicloud.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH] x86/mm,
 mm/hwpoison: fix unmap kernel 1:1 pages
Message-ID: <YgDyCwOtt8+UfBMN@kroah.com>
References: <20220207075242.830685-1-luofei@unicloud.com>
 <YgDU3+KsiaQ54J5N@kroah.com>
 <YgDn7WWdcD5xaprX@zn.tnic>
 <2a4b69472f034fc995a047c7ec945cd3@unicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a4b69472f034fc995a047c7ec945cd3@unicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 10:03:29AM +0000, 罗飞 wrote:
> >I think he's trying to fix the backport:
> >
> >see 26f8c38bb466c1a2d232d7609fb4bfb4bc121678 which is the stable tree backport:
> >
> >@@ -582,7 +586,8 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
> >
> >       if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
> >               pfn = mce->addr >> PAGE_SHIFT;
> >-               memory_failure(pfn, MCE_VECTOR, 0);
> >+               if (memory_failure(pfn, MCE_VECTOR, 0))
> >+                       mce_unmap_kpfn(pfn);
>  >       }
> >
> >
> >vs the upstream commit:
> >
> >fd0e786d9d09024f67bd71ec094b110237dc3840
> >
> >@@ -590,7 +594,8 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
> >
> >        if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
> >               pfn = mce->addr >> PAGE_SHIFT;
> >-               memory_failure(pfn, 0);
> >+               if (!memory_failure(pfn, 0))
> >+                       mce_unmap_kpfn(pfn);
> >       }
> >
> >        return NOTIFY_OK;
> 
> 
> Sorry for my not familiar with submitting patches to stable kernel tree, and here Borislav Petkov said exactly what I meant

Great, can you please resend this and document what this patch is doing
and why it is not in upstream and why is it needed only in this one
branch?

thanks,

greg k-h
