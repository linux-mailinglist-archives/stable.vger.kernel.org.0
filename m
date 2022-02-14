Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EAB4B4CD8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349007AbiBNKtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:49:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbiBNKtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:49:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D29BDA77
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C680660F60
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 10:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27F2C340E9;
        Mon, 14 Feb 2022 10:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833534;
        bh=0Fki6Qrsz5EBpEZEcQdF3FhQFvs87f9a7L4BZWvRfFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ujdPlLCBtP3/rWARoWqvRPye6OXHpjhwEkuh5ghmGnyHooXn7irz0NSm7D3HnZOnu
         +F5hgMjxveF9+SwQNswp5hoYKz/x2s32UYRfZhaBHfbercnNvmbh9kgLDpBxf0OvMe
         MA/q68EvuYEn35lOtDkAD0WkhR1VdqLFkZvAH0m4=
Date:   Mon, 14 Feb 2022 10:29:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Self <jason@bluehome.net>
Cc:     stable@vger.kernel.org
Subject: Re: m68k: ERROR: "usb_hid_driver" [drivers/hid/wacom.ko] undefined
Message-ID: <Ygog/2DBVa5nWT+H@kroah.com>
References: <20220213115928.4f3cab59@valencia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213115928.4f3cab59@valencia>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 13, 2022 at 11:59:28AM -0800, Jason Self wrote:
> Since version 4.9.293 I have been getting this USB error when building
> the kernel. m68k is too old to have USB.
> 
> cp vmlinux vmlinux.tmp
> m68k-linux-strip vmlinux.tmp
>   Building modules, stage 2.
> gzip -9c vmlinux.tmp >vmlinux.gz
>   MODPOST 894 modules
> rm vmlinux.tmp
> ERROR: "usb_hid_driver" [drivers/hid/wacom.ko] undefined!
> scripts/Makefile.modpost:91: recipe for target '__modpost' failed
> make[1]: *** [__modpost] Error 1
> Makefile:1251: recipe for target 'modules' failed
> make: *** [modules] Error 2
> 
> Version 4.9.292 works. Running git bisect tells me:
> 
> 1309eb2ef1001c4cc7e07b867ad9576d2cfeab47 is the first bad commit
> commit 1309eb2ef1001c4cc7e07b867ad9576d2cfeab47
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Wed Dec 1 19:35:02 2021 +0100
> 
>     HID: wacom: fix problems when device is not a valid USB device
>     
>     commit 720ac467204a70308bd687927ed475afb904e11b upstream.
>     
>     The wacom driver accepts devices of more than just USB types, but
>     some code paths can cause problems if the device being controlled
>     is not a USB device due to a lack of checking.  Add the needed
>     checks to ensure that the USB device accesses are only happening on
>     a "real" USB device, and not one on some other bus.
>     
>     Cc: Jiri Kosina <jikos@kernel.org>
>     Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Cc: linux-input@vger.kernel.org
>     Cc: stable@vger.kernel.org
>     Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Link:
>     https://lore.kernel.org/r/20211201183503.2373082-2-gregkh@linuxfoundation.org
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>  drivers/hid/wacom_sys.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)



Ah, looks like I need to backport 9d14201c7444 ("HID: wacom: add USB_HID
dependency") to the 4.9 tree.  I'll go do that now.

thanks,

greg k-h
