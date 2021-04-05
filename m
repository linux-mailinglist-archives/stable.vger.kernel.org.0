Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A46353DC6
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhDEJCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237297AbhDEJCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E17B613A8;
        Mon,  5 Apr 2021 09:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613316;
        bh=+Yo8fV+SsTxBvZ0FF5pddzZGxTMbIV+e2DXj3NcrIVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRUoZev6x/zs5ILgM85V2sZ6BiztMXmbInmlZo9k1pEadUT0jFqNCgulvc8e12o9/
         ifk6IyxLvwhTnWBokVR6aUr0DEnY94nsnNgHt70gwOQyet+5KJpoR8BcO4Lfsd5Z7n
         BaKfCugfHMB285rg1XTmQ8zrlfK+EIRJmmzbTyAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 48/56] USB: cdc-acm: untangle a circular dependency between callback and softint
Date:   Mon,  5 Apr 2021 10:54:19 +0200
Message-Id: <20210405085024.060215410@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 6069e3e927c8fb3a1947b07d1a561644ea960248 upstream.

We have a cycle of callbacks scheduling works which submit
URBs with thos callbacks. This needs to be blocked, stopped
and unblocked to untangle the circle.

The issue leads to faults like:

[   55.068392] Unable to handle kernel paging request at virtual address 6b6b6c03
[   55.075624] pgd = be866494
[   55.078335] [6b6b6c03] *pgd=00000000
[   55.081924] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[   55.087238] Modules linked in: ppp_async crc_ccitt ppp_generic slhc
xt_TCPMSS xt_tcpmss xt_hl nf_log_ipv6 nf_log_ipv4 nf_log_common
xt_policy xt_limit xt_conntrack xt_tcpudp xt_pkttype ip6table_mangle
iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables
des_generic md5 sch_fq_codel cdc_mbim cdc_wdm cdc_ncm usbnet mii
cdc_acm usb_storage ip_tunnel xfrm_user xfrm6_tunnel tunnel6
xfrm4_tunnel tunnel4 esp6 esp4 ah6 ah4 xfrm_algo xt_LOG xt_LED
xt_comment x_tables ipv6
[   55.134954] CPU: 0 PID: 82 Comm: kworker/0:2 Tainted: G
   T 5.8.17 #1
[   55.142526] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   55.148304] Workqueue: events acm_softint [cdc_acm]
[   55.153196] PC is at kobject_get+0x10/0xa4
[   55.157302] LR is at usb_get_dev+0x14/0x1c
[   55.161402] pc : [<8047c06c>]    lr : [<80560448>]    psr: 20000193
[   55.167671] sp : bca39ea8  ip : 00007374  fp : bf6cbd80
[   55.172899] r10: 00000000  r9 : bdd92284  r8 : bdd92008
[   55.178128] r7 : 6b6b6b6b  r6 : fffffffe  r5 : 60000113  r4 : 6b6b6be3
[   55.184658] r3 : 6b6b6b6b  r2 : 00000111  r1 : 00000000  r0 : 6b6b6be3
[   55.191191] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM Segment none
[   55.198417] Control: 10c5387d  Table: bcf0c06a  DAC: 00000051
[   55.204168] Process kworker/0:2 (pid: 82, stack limit = 0x9bdd2a89)
[   55.210439] Stack: (0xbca39ea8 to 0xbca3a000)
[   55.214805] 9ea0:                   bf6cbd80 80769a50 6b6b6b6b 80560448 bdeb0500 8056bfe8
[   55.222991] 9ec0: 00000002 b76da000 00000000 bdeb0500 bdd92448 bca38000 bdeb0510 8056d69c
[   55.231177] 9ee0: bca38000 00000000 80c050fc 00000000 bca39f44 09d42015 00000000 00000001
[   55.239363] 9f00: bdd92448 bdd92438 bdd92000 7f1158c4 bdd92448 bca2ee00 bf6cbd80 bf6cef00
[   55.247549] 9f20: 00000000 00000000 00000000 801412d8 bf6cbd98 80c03d00 bca2ee00 bf6cbd80
[   55.255735] 9f40: bca2ee14 bf6cbd98 80c03d00 00000008 bca38000 80141568 00000000 80c446ae
[   55.263921] 9f60: 00000000 bc9ed880 bc9f0700 bca38000 bc117eb4 80141524 bca2ee00 bc9ed8a4
[   55.272107] 9f80: 00000000 80147cc8 00000000 bc9f0700 80147b84 00000000 00000000 00000000
[   55.280292] 9fa0: 00000000 00000000 00000000 80100148 00000000 00000000 00000000 00000000
[   55.288477] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   55.296662] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[   55.304860] [<8047c06c>] (kobject_get) from [<80560448>] (usb_get_dev+0x14/0x1c)
[   55.312271] [<80560448>] (usb_get_dev) from [<8056bfe8>] (usb_hcd_unlink_urb+0x50/0xd8)
[   55.320286] [<8056bfe8>] (usb_hcd_unlink_urb) from [<8056d69c>] (usb_kill_urb.part.0+0x44/0xd0)
[   55.329004] [<8056d69c>] (usb_kill_urb.part.0) from [<7f1158c4>] (acm_softint+0x4c/0x10c [cdc_acm])
[   55.338082] [<7f1158c4>] (acm_softint [cdc_acm]) from [<801412d8>] (process_one_work+0x19c/0x3e8)
[   55.346969] [<801412d8>] (process_one_work) from [<80141568>] (worker_thread+0x44/0x4dc)
[   55.355072] [<80141568>] (worker_thread) from [<80147cc8>] (kthread+0x144/0x180)
[   55.362481] [<80147cc8>] (kthread) from [<80100148>] (ret_from_fork+0x14/0x2c)
[   55.369706] Exception stack(0xbca39fb0 to 0xbca39ff8)

Tested-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311130126.15972-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   48 +++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 16 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -147,17 +147,29 @@ static inline int acm_set_control(struct
 #define acm_send_break(acm, ms) \
 	acm_ctrl_msg(acm, USB_CDC_REQ_SEND_BREAK, ms, NULL, 0)
 
-static void acm_kill_urbs(struct acm *acm)
+static void acm_poison_urbs(struct acm *acm)
 {
 	int i;
 
-	usb_kill_urb(acm->ctrlurb);
+	usb_poison_urb(acm->ctrlurb);
 	for (i = 0; i < ACM_NW; i++)
-		usb_kill_urb(acm->wb[i].urb);
+		usb_poison_urb(acm->wb[i].urb);
 	for (i = 0; i < acm->rx_buflimit; i++)
-		usb_kill_urb(acm->read_urbs[i]);
+		usb_poison_urb(acm->read_urbs[i]);
+}
+
+static void acm_unpoison_urbs(struct acm *acm)
+{
+	int i;
+
+	for (i = 0; i < acm->rx_buflimit; i++)
+		usb_unpoison_urb(acm->read_urbs[i]);
+	for (i = 0; i < ACM_NW; i++)
+		usb_unpoison_urb(acm->wb[i].urb);
+	usb_unpoison_urb(acm->ctrlurb);
 }
 
+
 /*
  * Write buffer management.
  * All of these assume proper locks taken by the caller.
@@ -225,9 +237,10 @@ static int acm_start_wb(struct acm *acm,
 
 	rc = usb_submit_urb(wb->urb, GFP_ATOMIC);
 	if (rc < 0) {
-		dev_err(&acm->data->dev,
-			"%s - usb_submit_urb(write bulk) failed: %d\n",
-			__func__, rc);
+		if (rc != -EPERM)
+			dev_err(&acm->data->dev,
+				"%s - usb_submit_urb(write bulk) failed: %d\n",
+				__func__, rc);
 		acm_write_done(acm, wb);
 	}
 	return rc;
@@ -482,11 +495,6 @@ static void acm_read_bulk_callback(struc
 	dev_vdbg(&acm->data->dev, "got urb %d, len %d, status %d\n",
 		rb->index, urb->actual_length, status);
 
-	if (!acm->dev) {
-		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
-		return;
-	}
-
 	switch (status) {
 	case 0:
 		usb_mark_last_busy(acm->dev);
@@ -741,6 +749,7 @@ static void acm_port_shutdown(struct tty
 	 * Need to grab write_lock to prevent race with resume, but no need to
 	 * hold it due to the tty-port initialised flag.
 	 */
+	acm_poison_urbs(acm);
 	spin_lock_irq(&acm->write_lock);
 	spin_unlock_irq(&acm->write_lock);
 
@@ -757,7 +766,8 @@ static void acm_port_shutdown(struct tty
 		usb_autopm_put_interface_async(acm->control);
 	}
 
-	acm_kill_urbs(acm);
+	acm_unpoison_urbs(acm);
+
 }
 
 static void acm_tty_cleanup(struct tty_struct *tty)
@@ -1587,8 +1597,14 @@ static void acm_disconnect(struct usb_in
 	if (!acm)
 		return;
 
-	mutex_lock(&acm->mutex);
 	acm->disconnected = true;
+	/*
+	 * there is a circular dependency. acm_softint() can resubmit
+	 * the URBs in error handling so we need to block any
+	 * submission right away
+	 */
+	acm_poison_urbs(acm);
+	mutex_lock(&acm->mutex);
 	if (acm->country_codes) {
 		device_remove_file(&acm->control->dev,
 				&dev_attr_wCountryCodes);
@@ -1607,7 +1623,6 @@ static void acm_disconnect(struct usb_in
 		tty_kref_put(tty);
 	}
 
-	acm_kill_urbs(acm);
 	cancel_delayed_work_sync(&acm->dwork);
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
@@ -1649,7 +1664,7 @@ static int acm_suspend(struct usb_interf
 	if (cnt)
 		return 0;
 
-	acm_kill_urbs(acm);
+	acm_poison_urbs(acm);
 	cancel_delayed_work_sync(&acm->dwork);
 	acm->urbs_in_error_delay = 0;
 
@@ -1662,6 +1677,7 @@ static int acm_resume(struct usb_interfa
 	struct urb *urb;
 	int rv = 0;
 
+	acm_unpoison_urbs(acm);
 	spin_lock_irq(&acm->write_lock);
 
 	if (--acm->susp_count)


