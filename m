Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33918C894B
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfJBNJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 09:09:29 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:34130 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfJBNJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 09:09:29 -0400
Received: from pendragon.ideasonboard.com (unknown [132.205.230.1])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7D0242BB;
        Wed,  2 Oct 2019 15:09:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1570021766;
        bh=urSjyYGTYx0kiUGUdpd7omjpLbcIVpHhGw+J0SSuZv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kS7E0aNeMthVFN4Ydg0yiALmodwlY6cX+t17XcwKm8EewdEng6mbgr3+h+gAn8Uhe
         slljWm3ZCSEav/Z10uO3rxXjKtXc1n88Ce9QeSEJa3kXzfEGwTe7vAwTG/NfQsNNAc
         3ceTiqwS2AX9kOM5uv4rJdm/PKP4cLZe2QLys+HA=
Date:   Wed, 2 Oct 2019 16:09:13 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Will Deacon <will@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreyknvl@google.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvc: Avoid cyclic entity chains due to malformed
 USB descriptors
Message-ID: <20191002130913.GA5262@pendragon.ideasonboard.com>
References: <20191002112753.21630-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002112753.21630-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will,

Thank you for the patch.

On Wed, Oct 02, 2019 at 12:27:53PM +0100, Will Deacon wrote:
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
> I don't have a way to reproduce the original issue, so this change is
> based purely on inspection. Considering I'm not familiar with USB nor
> UVC, I may well have missed something!

I may also be missing something, I haven't touched this code for a long
time :-)

uvc_scan_chain_entity(), at the end of the function, adds the entity to
the list of entities in the chain with

	list_add_tail(&entity->chain, &chain->entities);

uvc_scan_chain_forward() is then called (from uvc_scan_chain()), and
iterates over all entities connected to the entity being scanned.

	while (1) {
		forward = uvc_entity_by_reference(chain->dev, entity->id,
			forward);

At this point forward may be equal to entity, if entity references
itself.

		if (forward == NULL)
			break;
		if (forward == prev)
			continue;
		if (forward->chain.next || forward->chain.prev) {
			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
				"entity %d already in chain.\n", forward->id);
			return -EINVAL;
		}

But then this check should trigger, as forward == entity and entity is
in the chain's list of entities.

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

-- 
Regards,

Laurent Pinchart
