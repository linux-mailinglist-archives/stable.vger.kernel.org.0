Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FED4AB88E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 11:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352382AbiBGKQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 05:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352419AbiBGKAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 05:00:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C704C043188;
        Mon,  7 Feb 2022 02:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A5DB810EE;
        Mon,  7 Feb 2022 10:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0005C004E1;
        Mon,  7 Feb 2022 10:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644228040;
        bh=+uR/PXZaEfd9UqPJTuut/61nSBPBE3DGkzWve6F8gaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXRRaHgHdwkUbr9O/4nBs34+9UZYbK309UgnigZAuHEmeXnT1CqU194OYHDahrtom
         He8FMYCU2bt26N6nhJ/4vPMswhElHKIyeXhc//GOxQS6c26+glWn+U3MsfuA23oVGo
         8cmp69w6SuUX0axXdPO3/6SA1m0We0QJktDzheBo=
Date:   Mon, 7 Feb 2022 11:00:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     luofei <luofei@unicloud.com>, stable@vger.kernel.org,
        tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm, mm/hwpoison: fix unmap kernel 1:1 pages
Message-ID: <YgDtxR0V7cqOZSe3@kroah.com>
References: <20220207075242.830685-1-luofei@unicloud.com>
 <YgDU3+KsiaQ54J5N@kroah.com>
 <YgDn7WWdcD5xaprX@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgDn7WWdcD5xaprX@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 10:35:41AM +0100, Borislav Petkov wrote:
> On Mon, Feb 07, 2022 at 09:14:23AM +0100, Greg KH wrote:
> > On Mon, Feb 07, 2022 at 02:52:42AM -0500, luofei wrote:
> > > Only unmap the page when the memory error is properly handled
> > > by calling memory_failure(), not the other way around.
> > > 
> > > Fixes: 26f8c38bb466("x86/mm, mm/hwpoison: Don't unconditionally unmap kernel 1:1 pages")
> > 
> > This commit is not in Linus's tree.  Please use the correct commit id.
> 
> I think he's trying to fix the backport:
> 
> see 26f8c38bb466c1a2d232d7609fb4bfb4bc121678 which is the stable tree backport:
> 
> @@ -582,7 +586,8 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
>  
>         if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
>                 pfn = mce->addr >> PAGE_SHIFT;
> -               memory_failure(pfn, MCE_VECTOR, 0);
> +               if (memory_failure(pfn, MCE_VECTOR, 0))
> +                       mce_unmap_kpfn(pfn);
>         }
> 
> 
> vs the upstream commit:
> 
> fd0e786d9d09024f67bd71ec094b110237dc3840
> 
> @@ -590,7 +594,8 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
>  
>         if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
>                 pfn = mce->addr >> PAGE_SHIFT;
> -               memory_failure(pfn, 0);
> +               if (!memory_failure(pfn, 0))
> +                       mce_unmap_kpfn(pfn);
>         }
>  
>         return NOTIFY_OK;
> 

Ah, ok, if so, this needs to be documented really really well in the
changelog text so no one is confused.  Like me :)

thanks,

greg k-h
