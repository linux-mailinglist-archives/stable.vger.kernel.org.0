Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B888788DF8
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfHJUuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:50:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54394 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbfHJUnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:55 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-00053h-S5; Sat, 10 Aug 2019 21:43:51 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003gZ-NA; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.281970616@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 100/157] USB: core: Fix bug caused by duplicate
 interface PM usage counter
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16:
 - Adjust documentation filename
 - Don't add ReST markup in documentation
 - Update use of pm_usage_cnt in poseidon driver, which has been
   removed upstream]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/usb/power-management.txt
+++ b/Documentation/usb/power-management.txt
@@ -345,11 +345,15 @@ autosuspend the interface's device.  Whe
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
+the usb_autopm_* functions even after their disconnect routine
+has returned -- say from within a work-queue routine -- provided they
+retain an active reference to the interface (via usb_get_intf and
+usb_put_intf).
 
 Drivers using the async routines are responsible for their own
 synchronization and mutual exclusion.
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -483,11 +483,6 @@ static int usb_unbind_interface(struct d
 		pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 
-	/* Undo any residual pm_autopm_get_interface_* calls */
-	for (r = atomic_read(&intf->pm_usage_cnt); r > 0; --r)
-		usb_autopm_put_interface_no_suspend(intf);
-	atomic_set(&intf->pm_usage_cnt, 0);
-
 	if (!error)
 		usb_autosuspend_device(udev);
 
@@ -1638,7 +1633,6 @@ void usb_autopm_put_interface(struct usb
 	int			status;
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	status = pm_runtime_put_sync(&intf->dev);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
@@ -1667,7 +1661,6 @@ void usb_autopm_put_interface_async(stru
 	int			status;
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	status = pm_runtime_put(&intf->dev);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
@@ -1689,7 +1682,6 @@ void usb_autopm_put_interface_no_suspend
 	struct usb_device	*udev = interface_to_usbdev(intf);
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	pm_runtime_put_noidle(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(usb_autopm_put_interface_no_suspend);
@@ -1720,8 +1712,6 @@ int usb_autopm_get_interface(struct usb_
 	status = pm_runtime_get_sync(&intf->dev);
 	if (status < 0)
 		pm_runtime_put_sync(&intf->dev);
-	else
-		atomic_inc(&intf->pm_usage_cnt);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
@@ -1755,8 +1745,6 @@ int usb_autopm_get_interface_async(struc
 	status = pm_runtime_get(&intf->dev);
 	if (status < 0 && status != -EINPROGRESS)
 		pm_runtime_put_noidle(&intf->dev);
-	else
-		atomic_inc(&intf->pm_usage_cnt);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
@@ -1780,7 +1768,6 @@ void usb_autopm_get_interface_no_resume(
 	struct usb_device	*udev = interface_to_usbdev(intf);
 
 	usb_mark_last_busy(udev);
-	atomic_inc(&intf->pm_usage_cnt);
 	pm_runtime_get_noresume(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(usb_autopm_get_interface_no_resume);
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -767,18 +767,16 @@ static void rts51x_suspend_timer_fn(unsi
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
@@ -811,11 +809,10 @@ static void rts51x_invoke_transport(stru
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
@@ -125,7 +125,6 @@ enum usb_interface_condition {
  * @dev: driver model's view of this device
  * @usb_dev: if an interface is bound to the USB major, this will point
  *	to the sysfs representation for that device.
- * @pm_usage_cnt: PM usage counter for this interface
  * @reset_ws: Used for scheduling resets from atomic context.
  * @reset_running: set to 1 if the interface is currently running a
  *      queued reset so that usb_cancel_queued_reset() doesn't try to
@@ -186,7 +185,6 @@ struct usb_interface {
 
 	struct device dev;		/* interface specific device info */
 	struct device *usb_dev;
-	atomic_t pm_usage_cnt;		/* usage counter for autosuspend */
 	struct work_struct reset_ws;	/* for resets in atomic context */
 };
 #define	to_usb_interface(d) container_of(d, struct usb_interface, dev)
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -257,7 +257,7 @@ void set_debug_mode(struct video_device
 #else
 #define in_hibernation(pd) (0)
 #endif
-#define get_pm_count(p) (atomic_read(&(p)->interface->pm_usage_cnt))
+#define get_pm_count(p) (atomic_read(&(p)->interface->dev.power.usage_count))
 
 #define log(a, ...) printk(KERN_DEBUG "\t[ %s : %.3d ] "a"\n", \
 				__func__, __LINE__,  ## __VA_ARGS__)

