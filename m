Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0742AF5045
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKHPzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 10:55:16 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49444 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHPzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 10:55:16 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3DDE12D1;
        Fri,  8 Nov 2019 16:55:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1573228513;
        bh=YRsA6vcCgdk4mfuNf52nuEX3rzRLI9LEz84JKn/0KI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H1ot3bDSK5ws2hJLk+trov2yH6k6/jcIaz8RQju9T4Rim1qY9qFZ7vc73D0616kbQ
         RsQ1jwst9TaQ3AAl8P/pTaK+dse5Lz+BZuOxXhpSaQp9UmaXrjTOtUA1KZSxbsRQYG
         J35uk5d5/VLCYaQbv96KU/Bfih6N4lec9bbsvzPQ=
Date:   Fri, 8 Nov 2019 17:55:03 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Will Deacon <will@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreyknvl@google.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
Message-ID: <20191108155503.GB15731@pendragon.ideasonboard.com>
References: <20191108154838.21487-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191108154838.21487-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

Thank you for the patch.

I'm sorry for the delay, and will have to ask you to be a bit more
patient I'm afraid. I will leave tomorrow for a week without computer
access and will only be able to go through my backlog when I will be
back on the 17th.

On Fri, Nov 08, 2019 at 03:48:38PM +0000, Will Deacon wrote:
> Way back in 2017, fuzzing the 4.14-rc2 USB stack with syzkaller kicked
> up the following WARNING from the UVC chain scanning code:
> 
>   | list_add double add: new=ffff880069084010, prev=ffff880069084010,
>   | next=ffff880067d22298.
>   | ------------[ cut here ]------------
>   | WARNING: CPU: 1 PID: 1846 at lib/list_debug.c:31 __list_add_valid+0xbd/0xf0
>   | Modules linked in:
>   | CPU: 1 PID: 1846 Comm: kworker/1:2 Not tainted
>   | 4.14.0-rc2-42613-g1488251d1a98 #238
>   | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>   | Workqueue: usb_hub_wq hub_event
>   | task: ffff88006b01ca40 task.stack: ffff880064358000
>   | RIP: 0010:__list_add_valid+0xbd/0xf0 lib/list_debug.c:29
>   | RSP: 0018:ffff88006435ddd0 EFLAGS: 00010286
>   | RAX: 0000000000000058 RBX: ffff880067d22298 RCX: 0000000000000000
>   | RDX: 0000000000000058 RSI: ffffffff85a58800 RDI: ffffed000c86bbac
>   | RBP: ffff88006435dde8 R08: 1ffff1000c86ba52 R09: 0000000000000000
>   | R10: 0000000000000002 R11: 0000000000000000 R12: ffff880069084010
>   | R13: ffff880067d22298 R14: ffff880069084010 R15: ffff880067d222a0
>   | FS:  0000000000000000(0000) GS:ffff88006c900000(0000) knlGS:0000000000000000
>   | CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   | CR2: 0000000020004ff2 CR3: 000000006b447000 CR4: 00000000000006e0
>   | Call Trace:
>   |  __list_add ./include/linux/list.h:59
>   |  list_add_tail+0x8c/0x1b0 ./include/linux/list.h:92
>   |  uvc_scan_chain_forward.isra.8+0x373/0x416
>   | drivers/media/usb/uvc/uvc_driver.c:1471
>   |  uvc_scan_chain drivers/media/usb/uvc/uvc_driver.c:1585
>   |  uvc_scan_device drivers/media/usb/uvc/uvc_driver.c:1769
>   |  uvc_probe+0x77f2/0x8f00 drivers/media/usb/uvc/uvc_driver.c:2104
> 
> Looking into the output from usbmon, the interesting part is the
> following data packet:
> 
>   ffff880069c63e00 30710169 C Ci:1:002:0 0 143 = 09028f00 01030080
>   00090403 00000e01 00000924 03000103 7c003328 010204db
> 
> If we drop the lead configuration and interface descriptors, we're left
> with an output terminal descriptor describing a generic display:
> 
>   /* Output terminal descriptor */
>   buf[0]	09
>   buf[1]	24
>   buf[2]	03	/* UVC_VC_OUTPUT_TERMINAL */
>   buf[3]	00	/* ID */
>   buf[4]	01	/* type == 0x0301 (UVC_OTT_DISPLAY) */
>   buf[5]	03
>   buf[6]	7c
>   buf[7]	00	/* source ID refers to self! */
>   buf[8]	33
> 
> The problem with this descriptor is that it is self-referential: the
> source ID of 0 matches itself! This causes the 'struct uvc_entity'
> representing the display to be added to its chain list twice during
> 'uvc_scan_chain()': once via 'uvc_scan_chain_entity()' when it is
> processed directly from the 'dev->entities' list and then again
> immediately afterwards when trying to follow the source ID in
> 'uvc_scan_chain_forward()'
> 
> Add a check before adding an entity to a chain list to ensure that the
> entity is not already part of a chain.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Link: https://lore.kernel.org/linux-media/CAAeHK+z+Si69jUR+N-SjN9q4O+o5KFiNManqEa-PjUta7EOb7A@mail.gmail.com/
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> That's right, it's the same patch again! No changes since either of:
> 
>   http://lkml.kernel.org/r/20191002112753.21630-1-will@kernel.org
>   https://lore.kernel.org/lkml/20191016195800.22099-1-will@kernel.org
> 
> Please consider merging.
> 
>  drivers/media/usb/uvc/uvc_driver.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 66ee168ddc7e..e24420b1750a 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1493,6 +1493,11 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
>  			break;
>  		if (forward == prev)
>  			continue;
> +		if (forward->chain.next || forward->chain.prev) {
> +			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> +				"entity %d already in chain.\n", forward->id);
> +			return -EINVAL;
> +		}
>  
>  		switch (UVC_ENTITY_TYPE(forward)) {
>  		case UVC_VC_EXTENSION_UNIT:
> @@ -1574,6 +1579,13 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
>  				return -1;
>  			}
>  
> +			if (term->chain.next || term->chain.prev) {
> +				uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> +					"entity %d already in chain.\n",
> +					term->id);
> +				return -EINVAL;
> +			}
> +
>  			if (uvc_trace_param & UVC_TRACE_PROBE)
>  				printk(KERN_CONT " %d", term->id);
>  
> -- 
> 2.24.0.rc1.363.gb1bccd3e3d-goog
> 

-- 
Regards,

Laurent Pinchart
