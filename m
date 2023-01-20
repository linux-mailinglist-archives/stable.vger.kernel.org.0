Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA00675E4D
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 20:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjATTrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 14:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjATTrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 14:47:39 -0500
X-Greylist: delayed 1211 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Jan 2023 11:47:37 PST
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B0DAD05;
        Fri, 20 Jan 2023 11:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description;
        bh=ZJQlitPvheLgTn5pg5fdsIiQ+sIEYmT+P0zLOST5EzU=; b=797cgTNIKUzXelhOsGhzmjixs1
        zyXCvisyyi/gTTlHXvQOWyCG4+47K1tgwfwB7UCWuEfPHkYp31fxpnCO9tTcgsaG7QsNZZILtw0l6
        6KMENccs4loP3WbJhYnSg+3JtbxzFN5BXy/dNoUT9vbRC18GYoyDjs2cK1F4mHaDz2jjfhH/GACuX
        2y8sdgB7g8s5jQtmGk6zDJR0oyN6EGH6PaYQJmg1wV2/x0bBa86vUrr/0jbRsCMWeNM99Oxl2PzaM
        cLQp/pbzH+2N0rldJjezc9B1IjGpO6jISV8S+LNXuznQLct1JuO/QzzuQN1G+zN7F9BCKl0zeYrV3
        4m3mAlow==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <john@metanate.com>)
        id 1pIx2o-00014S-8t;
        Fri, 20 Jan 2023 19:27:22 +0000
Date:   Fri, 20 Jan 2023 19:27:21 +0000
From:   John Keeping <john@metanate.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Carlos Llamas <cmllamas@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_ncm: fix potential NULL ptr deref in
 ncm_bitrate()
Message-ID: <Y8rrGaaDnIQyBSD0@donbot>
References: <20230117131839.1138208-1-maze@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230117131839.1138208-1-maze@google.com>
X-Authenticated: YES
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 05:18:39AM -0800, Maciej Żenczykowski wrote:
> In Google internal bug 265639009 we've received an (as yet) unreproducible
> crash report from an aarch64 GKI 5.10.149-android13 running device.
> 
> AFAICT the source code is at:
>   https://android.googlesource.com/kernel/common/+/refs/tags/ASB-2022-12-05_13-5.10
> 
> The call stack is:
>   ncm_close() -> ncm_notify() -> ncm_do_notify()
> with the crash at:
>   ncm_do_notify+0x98/0x270
> Code: 79000d0b b9000a6c f940012a f9400269 (b9405d4b)
> 
> Which I believe disassembles to (I don't know ARM assembly, but it looks sane enough to me...):
> 
>   // halfword (16-bit) store presumably to event->wLength (at offset 6 of struct usb_cdc_notification)
>   0B 0D 00 79    strh w11, [x8, #6]
> 
>   // word (32-bit) store presumably to req->Length (at offset 8 of struct usb_request)
>   6C 0A 00 B9    str  w12, [x19, #8]
> 
>   // x10 (NULL) was read here from offset 0 of valid pointer x9
>   // IMHO we're reading 'cdev->gadget' and getting NULL
>   // gadget is indeed at offset 0 of struct usb_composite_dev
>   2A 01 40 F9    ldr  x10, [x9]
> 
>   // loading req->buf pointer, which is at offset 0 of struct usb_request
>   69 02 40 F9    ldr  x9, [x19]
> 
>   // x10 is null, crash, appears to be attempt to read cdev->gadget->max_speed
>   4B 5D 40 B9    ldr  w11, [x10, #0x5c]
> 
> which seems to line up with ncm_do_notify() case NCM_NOTIFY_SPEED code fragment:
> 
>   event->wLength = cpu_to_le16(8);
>   req->length = NCM_STATUS_BYTECOUNT;
> 
>   /* SPEED_CHANGE data is up/down speeds in bits/sec */
>   data = req->buf + sizeof *event;
>   data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));
> 
> My analysis of registers and NULL ptr deref crash offset
>   (Unable to handle kernel NULL pointer dereference at virtual address 000000000000005c)
> heavily suggests that the crash is due to 'cdev->gadget' being NULL when executing:
>   data[0] = cpu_to_le32(ncm_bitrate(cdev->gadget));
> which calls:
>   ncm_bitrate(NULL)
> which then calls:
>   gadget_is_superspeed(NULL)
> which reads
>   ((struct usb_gadget *)NULL)->max_speed
> and hits a panic.
> 
> AFAICT, if I'm counting right, the offset of max_speed is indeed 0x5C.
> (remember there's a GKI KABI reservation of 16 bytes in struct work_struct)
> 
> It's not at all clear to me how this is all supposed to work...
> but returning 0 seems much better than panic-ing...
> 
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  drivers/usb/gadget/function/f_ncm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
> index c36bcfa0e9b4..424bb3b666db 100644
> --- a/drivers/usb/gadget/function/f_ncm.c
> +++ b/drivers/usb/gadget/function/f_ncm.c
> @@ -83,7 +83,9 @@ static inline struct f_ncm *func_to_ncm(struct usb_function *f)
>  /* peak (theoretical) bulk transfer rate in bits-per-second */
>  static inline unsigned ncm_bitrate(struct usb_gadget *g)
>  {
> -	if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
> +	if (!g)
> +		return 0;
> +	else if (gadget_is_superspeed(g) && g->speed >= USB_SPEED_SUPER_PLUS)
>  		return 4250000000U;
>  	else if (gadget_is_superspeed(g) && g->speed == USB_SPEED_SUPER)
>  		return 3750000000U;

This looks like the wrong place to fix things - if this case is hit,
don't we go on to call usb_eq_queue() which can't be valid if the gadget
has been destroyed?

I don't see how cdev->gadget can be set to null without cdev being freed
so is this actually a use-after-free not a simple null-dereference?

My guess is that somehow the gadget is being destroyed while the network
interface is held open (we've seen similar issues in other, non-network,
gadget functions), but I don't know enough about the network side of
things to know how to cause that from userspace.


John
