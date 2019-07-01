Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA37A14D8E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfEFOrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbfEFOrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE7122053B;
        Mon,  6 May 2019 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154070;
        bh=KPIeTyq7PxXZiBToaDQs9eXpEPUH3/KdEReEwxZlQoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DT7lt69f/fgC/KOmiTIPpbAu5qmB9AwWgyLNmHY2J1lpSqa7qpXSz/23KOlMw60g7
         STx0wbXYaAoyl6o9T4F+aBxOeksA3FENaBplDXEpPYPyottmPBTA3ZVqr4RtMu6seG
         F7Ibcd2HyA3PaW/V7FdC2zBnUDo08epOK0uRMVv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+7634edaea4d0b341c625@syzkaller.appspotmail.com
Subject: [PATCH 4.9 26/62] USB: core: Fix bug caused by duplicate interface PM usage counter
Date:   Mon,  6 May 2019 16:32:57 +0200
Message-Id: <20190506143053.307728350@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit c2b71462d294cf517a0bc6e4fd6424d7cee5596f upstream.

The syzkaller fuzzer reported a bug in the USB hub driver which turned
out to be caused by a negative runtime-PM usage counter.  This allowed
a hub to be runtime suspended at a time when the driver did not expect
it.  The symptom is a WARNING issued because the hub's status URB is
submitted while it is already active:

	URB 0000000031fb463e submitted while active
	WARNING: CPU: 0 PID: 2917 at drivers/usb/core/urb.c:363

The negative runtime-PM usage count was caused by an unfortunate
design decision made when runtime PM was first implemented for USB.
At that time, USB class drivers were allowed to unbind from their
interfaces without balancing the usage counter (i.e., leaving it with
a positive count).  The core code would take care of setting the
counter back to 0 before allowing another driver to bind to the
interface.

Later on when runtime PM was implemented for the entire kernel, the
opposite decision was made: Drivers were required to balance their
runtime-PM get and put calls.  In order to maintain backward
compatibility, however, the USB subsystem adapted to the new
implementation by keeping an independent usage counter for each
interface and using it to automatically adjust the normal usage
counter back to 0 whenever a driver was unbound.

This approach involves duplicating information, but what is worse, it
doesn't work properly in cases where a USB class driver delays
decrementing the usage counter until after the driver's disconnect()
routine has returned and the counter has been adjusted back to 0.
Doing so would cause the usage counter to become negative.  There's
even a warning about this in the USB power management documentation!

As it happens, this is exactly what the hub driver does.  The
kick_hub_wq() routine increments the runtime-PM usage counter, and the
corresponding decrement is carried out by hub_event() in the context
of the hub_wq work-queue thread.  This work routine may sometimes run
after the driver has been unbound from its interface, and when it does
it causes the usage counter to go negative.

It is not possible for hub_disconnect() to wait for a pending
hub_event() call to finish, because hub_disconnect() is called with
the device lock held and hub_event() acquires that lock.  The only
feasible fix is to reverse the original design decision: remove the
duplicate interface-specific usage counter and require USB drivers to
balance their runtime PM gets and puts.  As far as I know, all
existing drivers currently do this.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+7634edaea4d0b341c625@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/usb/power-management.txt |   14 +++++++++-----
 drivers/usb/core/driver.c              |   13 -------------
 drivers/usb/storage/realtek_cr.c       |   13 +++++--------
 include/linux/usb.h                    |    2 --
 4 files changed, 14 insertions(+), 28 deletions(-)

--- a/Documentation/usb/power-management.txt
+++ b/Documentation/usb/power-management.txt
@@ -365,11 +365,15 @@ autosuspend the interface's device.  Whe
 then the interface is considered to be idle, and the kernel may
 autosuspend the device.
 
-Drivers need not be concerned about balancing changes to the usage
-counter; the USB core will undo any remaining "get"s when a driver
-is unbound from its interface.  As a corollary, drivers must not call
-any of the usb_autopm_* functions after their disconnect() routine has
-returned.
+Drivers must be careful to balance their overall changes to the usage
+counter.  Unbalanced "get"s will remain in effect when a driver is
+unbound from its interface, preventing the device from going into
+runtime suspend should the interface be bound to a driver again.  On
+the other hand, drivers are allowed to achieve this balance by calling
+the ``usb_autopm_*`` functions even after their ``disconnect`` routine
+has returned -- say from within a work-queue routine -- provided they
+retain an active reference to the interface (via ``usb_get_intf`` and
+``usb_put_intf``).
 
 Drivers using the async routines are responsible for their own
 synchronization and mutual exclusion.
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -470,11 +470,6 @@ static int usb_unbind_interface(struct d
 		pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 
-	/* Undo any residual pm_autopm_get_interface_* calls */
-	for (r = atomic_read(&intf->pm_usage_cnt); r > 0; --r)
-		usb_autopm_put_interface_no_suspend(intf);
-	atomic_set(&intf->pm_usage_cnt, 0);
-
 	if (!error)
 		usb_autosuspend_device(udev);
 
@@ -1625,7 +1620,6 @@ void usb_autopm_put_interface(struct usb
 	int			status;
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	status = pm_runtime_put_sync(&intf->dev);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
@@ -1654,7 +1648,6 @@ void usb_autopm_put_interface_async(stru
 	int			status;
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	status = pm_runtime_put(&intf->dev);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
@@ -1676,7 +1669,6 @@ void usb_autopm_put_interface_no_suspend
 	struct usb_device	*udev = interface_to_usbdev(intf);
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	pm_runtime_put_noidle(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(usb_autopm_put_interface_no_suspend);
@@ -1707,8 +1699,6 @@ int usb_autopm_get_interface(struct usb_
 	status = pm_runtime_get_sync(&intf->dev);
 	if (status < 0)
 		pm_runtime_put_sync(&intf->dev);
-	else
-		atomic_inc(&intf->pm_usage_cnt);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
@@ -1742,8 +1732,6 @@ int usb_autopm_get_interface_async(struc
 	status = pm_runtime_get(&intf->dev);
 	if (status < 0 && status != -EINPROGRESS)
 		pm_runtime_put_noidle(&intf->dev);
-	else
-		atomic_inc(&intf->pm_usage_cnt);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
@@ -1767,7 +1755,6 @@ void usb_autopm_get_interface_no_resume(
 	struct usb_device	*udev = interface_to_usbdev(intf);
 
 	usb_mark_last_busy(udev);
-	atomic_inc(&intf->pm_usage_cnt);
 	pm_runtime_get_noresume(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(usb_autopm_get_interface_no_resume);
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -776,18 +776,16 @@ static void rts51x_suspend_timer_fn(unsi
 		break;
 	case RTS51X_STAT_IDLE:
 	case RTS51X_STAT_SS:
-		usb_stor_dbg(us, "RTS51X_STAT_SS, intf->pm_usage_cnt:%d, power.usage:%d\n",
-			     atomic_read(&us->pusb_intf->pm_usage_cnt),
+		usb_stor_dbg(us, "RTS51X_STAT_SS, power.usage:%d\n",
 			     atomic_read(&us->pusb_intf->dev.power.usage_count));
 
-		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
+		if (atomic_read(&us->pusb_intf->dev.power.usage_count) > 0) {
 			usb_stor_dbg(us, "Ready to enter SS state\n");
 			rts51x_set_stat(chip, RTS51X_STAT_SS);
 			/* ignore mass storage interface's children */
 			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
 			usb_autopm_put_interface_async(us->pusb_intf);
-			usb_stor_dbg(us, "RTS51X_STAT_SS 01, intf->pm_usage_cnt:%d, power.usage:%d\n",
-				     atomic_read(&us->pusb_intf->pm_usage_cnt),
+			usb_stor_dbg(us, "RTS51X_STAT_SS 01, power.usage:%d\n",
 				     atomic_read(&us->pusb_intf->dev.power.usage_count));
 		}
 		break;
@@ -820,11 +818,10 @@ static void rts51x_invoke_transport(stru
 	int ret;
 
 	if (working_scsi(srb)) {
-		usb_stor_dbg(us, "working scsi, intf->pm_usage_cnt:%d, power.usage:%d\n",
-			     atomic_read(&us->pusb_intf->pm_usage_cnt),
+		usb_stor_dbg(us, "working scsi, power.usage:%d\n",
 			     atomic_read(&us->pusb_intf->dev.power.usage_count));
 
-		if (atomic_read(&us->pusb_intf->pm_usage_cnt) <= 0) {
+		if (atomic_read(&us->pusb_intf->dev.power.usage_count) <= 0) {
 			ret = usb_autopm_get_interface(us->pusb_intf);
 			usb_stor_dbg(us, "working scsi, ret=%d\n", ret);
 		}
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -129,7 +129,6 @@ enum usb_interface_condition {
  * @dev: driver model's view of this device
  * @usb_dev: if an interface is bound to the USB major, this will point
  *	to the sysfs representation for that device.
- * @pm_usage_cnt: PM usage counter for this interface
  * @reset_ws: Used for scheduling resets from atomic context.
  * @resetting_device: USB core reset the device, so use alt setting 0 as
  *	current; needs bandwidth alloc after reset.
@@ -186,7 +185,6 @@ struct usb_interface {
 
 	struct device dev;		/* interface specific device info */
 	struct device *usb_dev;
-	atomic_t pm_usage_cnt;		/* usage counter for autosuspend */
 	struct work_struct reset_ws;	/* for resets in atomic context */
 };
 #define	to_usb_interface(d) container_of(d, struct usb_interface, dev)


