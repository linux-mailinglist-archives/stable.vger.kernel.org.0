Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0ECB875A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405150AbfISWGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405163AbfISWGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:06:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F8821920;
        Thu, 19 Sep 2019 22:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930776;
        bh=uXApcOOq8pqdlMRIhJGKNROJNJSxxs2fvJOtJZSJMgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwCfc7vqteIs8D9DbRGatAkdRo/qWKBeGYi4wwiQFd4nKhF+mbKCBKTUka8atGocm
         BD7BTQf3Ig4RWy3RMNhHsgzrnEsyMGeQ7nReDMX3eIkVgXVfxIDasKaJJAcNCxqn3O
         4Yissz8EPHruRhKTMHS7Gx/MFN+nhrgbxihJB5vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.2 002/124] media: tm6000: double free if usb disconnect while streaming
Date:   Fri, 20 Sep 2019 00:01:30 +0200
Message-Id: <20190919214819.284996880@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 699bf94114151aae4dceb2d9dbf1a6312839dcae upstream.

The usb_bulk_urb will kfree'd on disconnect, so ensure the pointer is set
to NULL after each free.

stop stream
urb killing
urb buffer free
tm6000: got start feed request tm6000_start_feed
tm6000: got start stream request tm6000_start_stream
tm6000: pipe reset
tm6000: got start feed request tm6000_start_feed
tm6000: got start feed request tm6000_start_feed
tm6000: got start feed request tm6000_start_feed
tm6000: got start feed request tm6000_start_feed
tm6000: IR URB failure: status: -71, length 0
xhci_hcd 0000:00:14.0: ERROR unknown event type 37
xhci_hcd 0000:00:14.0: ERROR unknown event type 37
tm6000:  error tm6000_urb_received
usb 1-2: USB disconnect, device number 5
tm6000: disconnecting tm6000 #0
==================================================================
BUG: KASAN: use-after-free in dvb_fini+0x75/0x140 [tm6000_dvb]
Read of size 8 at addr ffff888241044060 by task kworker/2:0/22

CPU: 2 PID: 22 Comm: kworker/2:0 Tainted: G        W         5.3.0-rc4+ #1
Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET65W (1.40 ) 07/02/2019
Workqueue: usb_hub_wq hub_event
Call Trace:
 dump_stack+0x9a/0xf0
 print_address_description.cold+0xae/0x34f
 __kasan_report.cold+0x75/0x93
 ? tm6000_fillbuf+0x390/0x3c0 [tm6000_alsa]
 ? dvb_fini+0x75/0x140 [tm6000_dvb]
 kasan_report+0xe/0x12
 dvb_fini+0x75/0x140 [tm6000_dvb]
 tm6000_close_extension+0x51/0x80 [tm6000]
 tm6000_usb_disconnect.cold+0xd4/0x105 [tm6000]
 usb_unbind_interface+0xe4/0x390
 device_release_driver_internal+0x121/0x250
 bus_remove_device+0x197/0x260
 device_del+0x268/0x550
 ? __device_links_no_driver+0xd0/0xd0
 ? usb_remove_ep_devs+0x30/0x3b
 usb_disable_device+0x122/0x400
 usb_disconnect+0x153/0x430
 hub_event+0x800/0x1e40
 ? trace_hardirqs_on_thunk+0x1a/0x20
 ? hub_port_debounce+0x1f0/0x1f0
 ? retint_kernel+0x10/0x10
 ? lock_is_held_type+0xf1/0x130
 ? hub_port_debounce+0x1f0/0x1f0
 ? process_one_work+0x4ae/0xa00
 process_one_work+0x4ba/0xa00
 ? pwq_dec_nr_in_flight+0x160/0x160
 ? do_raw_spin_lock+0x10a/0x1d0
 worker_thread+0x7a/0x5c0
 ? process_one_work+0xa00/0xa00
 kthread+0x1d5/0x200
 ? kthread_create_worker_on_cpu+0xd0/0xd0
 ret_from_fork+0x3a/0x50

Allocated by task 2682:
 save_stack+0x1b/0x80
 __kasan_kmalloc.constprop.0+0xc2/0xd0
 usb_alloc_urb+0x28/0x60
 tm6000_start_feed+0x10a/0x300 [tm6000_dvb]
 dmx_ts_feed_start_filtering+0x86/0x120 [dvb_core]
 dvb_dmxdev_start_feed+0x121/0x180 [dvb_core]
 dvb_dmxdev_filter_start+0xcb/0x540 [dvb_core]
 dvb_demux_do_ioctl+0x7ed/0x890 [dvb_core]
 dvb_usercopy+0x97/0x1f0 [dvb_core]
 dvb_demux_ioctl+0x11/0x20 [dvb_core]
 do_vfs_ioctl+0x5d8/0x9d0
 ksys_ioctl+0x5e/0x90
 __x64_sys_ioctl+0x3d/0x50
 do_syscall_64+0x74/0xe0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 22:
 save_stack+0x1b/0x80
 __kasan_slab_free+0x12c/0x170
 kfree+0xfd/0x3a0
 xhci_giveback_urb_in_irq+0xfe/0x230
 xhci_td_cleanup+0x276/0x340
 xhci_irq+0x1129/0x3720
 __handle_irq_event_percpu+0x6e/0x420
 handle_irq_event_percpu+0x6f/0x100
 handle_irq_event+0x55/0x84
 handle_edge_irq+0x108/0x3b0
 handle_irq+0x2e/0x40
 do_IRQ+0x83/0x1a0

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/tm6000/tm6000-dvb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -97,6 +97,7 @@ static void tm6000_urb_received(struct u
 			printk(KERN_ERR "tm6000:  error %s\n", __func__);
 			kfree(urb->transfer_buffer);
 			usb_free_urb(urb);
+			dev->dvb->bulk_urb = NULL;
 		}
 	}
 }
@@ -127,6 +128,7 @@ static int tm6000_start_stream(struct tm
 	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
 	if (!dvb->bulk_urb->transfer_buffer) {
 		usb_free_urb(dvb->bulk_urb);
+		dvb->bulk_urb = NULL;
 		return -ENOMEM;
 	}
 
@@ -153,6 +155,7 @@ static int tm6000_start_stream(struct tm
 
 		kfree(dvb->bulk_urb->transfer_buffer);
 		usb_free_urb(dvb->bulk_urb);
+		dvb->bulk_urb = NULL;
 		return ret;
 	}
 


