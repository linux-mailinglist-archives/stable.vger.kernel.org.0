Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456923373A6
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhCKNWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233192AbhCKNVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:21:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EE8A64ECD;
        Thu, 11 Mar 2021 13:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615468913;
        bh=wsC3XxEEsfDn12VQ71YIp8+OCzYDl4L4E6+YZCOvAvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffvK1FiF9AfRvIq6vAIj1esPJw01HiKiVSD1CEgw9Vpj12+i6QVy0Wy5WjGlkbEmS
         ucs0XLh4Yyl8/8s1Gz1pzu+G/4zsQtRdFJvbkJONV4SXGusJe6OM09GhO6f1k5XQkX
         3GjEg8eCLR/0WQH0Rz30I3ERdU8f04RxzSOJCXDw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.261
Date:   Thu, 11 Mar 2021 14:21:45 +0100
Message-Id: <1615468904161180@kroah.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <161546890424630@kroah.com>
References: <161546890424630@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/Makefile b/Makefile
index 7efb6921d9de..607f1b19555f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 260
+SUBLEVEL = 261
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 620a3a67cdd5..0d9137408e3c 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -180,15 +180,17 @@ static ssize_t rsxx_cram_read(struct file *fp, char __user *ubuf,
 {
 	struct rsxx_cardinfo *card = file_inode(fp)->i_private;
 	char *buf;
-	ssize_t st;
+	int st;
 
 	buf = kzalloc(cnt, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	st = rsxx_creg_read(card, CREG_ADD_CRAM + (u32)*ppos, cnt, buf, 1);
-	if (!st)
-		st = copy_to_user(ubuf, buf, cnt);
+	if (!st) {
+		if (copy_to_user(ubuf, buf, cnt))
+			st = -EFAULT;
+	}
 	kfree(buf);
 	if (st)
 		return st;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a5a6c7f073af..7ee520d4d216 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1210,6 +1210,46 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+/*
+ * type->iterate_devices() should be called when the sanity check needs to
+ * iterate and check all underlying data devices. iterate_devices() will
+ * iterate all underlying data devices until it encounters a non-zero return
+ * code, returned by whether the input iterate_devices_callout_fn, or
+ * iterate_devices() itself internally.
+ *
+ * For some target type (e.g. dm-stripe), one call of iterate_devices() may
+ * iterate multiple underlying devices internally, in which case a non-zero
+ * return code returned by iterate_devices_callout_fn will stop the iteration
+ * in advance.
+ *
+ * Cases requiring _any_ underlying device supporting some kind of attribute,
+ * should use the iteration structure like dm_table_any_dev_attr(), or call
+ * it directly. @func should handle semantics of positive examples, e.g.
+ * capable of something.
+ *
+ * Cases requiring _all_ underlying devices supporting some kind of attribute,
+ * should use the iteration structure like dm_table_supports_nowait() or
+ * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
+ * uses an @anti_func that handle semantics of counter examples, e.g. not
+ * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
+ */
+static bool dm_table_any_dev_attr(struct dm_table *t,
+				  iterate_devices_callout_fn func)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, func, NULL))
+			return true;
+        }
+
+	return false;
+}
+
 static int count_device(struct dm_target *ti, struct dm_dev *dev,
 			sector_t start, sector_t len, void *data)
 {
@@ -1380,12 +1420,12 @@ static bool dm_table_discard_zeroes_data(struct dm_table *t)
 	return true;
 }
 
-static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
-			    sector_t start, sector_t len, void *data)
+static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && blk_queue_nonrot(q);
+	return q && !blk_queue_nonrot(q);
 }
 
 static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
@@ -1396,29 +1436,12 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 	return q && !blk_queue_add_random(q);
 }
 
-static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
-				   sector_t start, sector_t len, void *data)
+static int queue_no_sg_merge(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
-}
-
-static bool dm_table_all_devices_attribute(struct dm_table *t,
-					   iterate_devices_callout_fn func)
-{
-	struct dm_target *ti;
-	unsigned i = 0;
-
-	while (i < dm_table_get_num_targets(t)) {
-		ti = dm_table_get_target(t, i++);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, func, NULL))
-			return false;
-	}
-
-	return true;
+	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
@@ -1511,18 +1534,18 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		q->limits.discard_zeroes_data = 0;
 
 	/* Ensure that all underlying devices are non-rotational. */
-	if (dm_table_all_devices_attribute(t, device_is_nonrot))
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
-	else
+	if (dm_table_any_dev_attr(t, device_is_rotational))
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	if (!dm_table_supports_write_same(t))
 		q->limits.max_write_same_sectors = 0;
 
-	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
-		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
-	else
+	if (dm_table_any_dev_attr(t, queue_no_sg_merge))
 		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
+	else
+		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
 
 	dm_table_verify_integrity(t);
 
@@ -1532,7 +1555,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
 	 * have it set.
 	 */
-	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
+	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 
 	/*
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index bdaeccafa261..bc0aa0849e72 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3649,6 +3649,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x917a,
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c46 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x91a0,
 			 quirk_dma_func1_alias);
+/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c135 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9215,
+			 quirk_dma_func1_alias);
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c127 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9220,
 			 quirk_dma_func1_alias);
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index b336f2620f9d..e4f278fa6d69 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -229,6 +229,7 @@ static int mailled = -1;
 static int brightness = -1;
 static int threeg = -1;
 static int force_series;
+static int force_caps = -1;
 static bool ec_raw_mode;
 static bool has_type_aa;
 static u16 commun_func_bitmap;
@@ -238,11 +239,13 @@ module_param(mailled, int, 0444);
 module_param(brightness, int, 0444);
 module_param(threeg, int, 0444);
 module_param(force_series, int, 0444);
+module_param(force_caps, int, 0444);
 module_param(ec_raw_mode, bool, 0444);
 MODULE_PARM_DESC(mailled, "Set initial state of Mail LED");
 MODULE_PARM_DESC(brightness, "Set initial LCD backlight brightness");
 MODULE_PARM_DESC(threeg, "Set initial state of 3G hardware");
 MODULE_PARM_DESC(force_series, "Force a different laptop series");
+MODULE_PARM_DESC(force_caps, "Force the capability bitmask to this value");
 MODULE_PARM_DESC(ec_raw_mode, "Enable EC raw mode");
 
 struct acer_data {
@@ -2150,7 +2153,7 @@ static int __init acer_wmi_init(void)
 		}
 		/* WMID always provides brightness methods */
 		interface->capability |= ACER_CAP_BRIGHTNESS;
-	} else if (!wmi_has_guid(WMID_GUID2) && interface && !has_type_aa) {
+	} else if (!wmi_has_guid(WMID_GUID2) && interface && !has_type_aa && force_caps == -1) {
 		pr_err("No WMID device detection method found\n");
 		return -ENODEV;
 	}
@@ -2180,6 +2183,9 @@ static int __init acer_wmi_init(void)
 	if (acpi_video_get_backlight_type() != acpi_backlight_vendor)
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 
+	if (force_caps != -1)
+		interface->capability = force_caps;
+
 	if (wmi_has_guid(WMID_GUID3)) {
 		if (ec_raw_mode) {
 			if (ACPI_FAILURE(acer_wmi_enable_ec_raw())) {
diff --git a/kernel/futex.c b/kernel/futex.c
index a14b7ef90e5c..95cdc11c89f8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -874,7 +874,9 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		pi_state_update_owner(pi_state, NULL);
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 
@@ -1406,7 +1408,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this,
 	if (pi_state->owner != current)
 		return -EINVAL;
 
-	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index d86678c2a957..5beb4a3d203b 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -995,7 +995,7 @@ static int daio_mgr_dao_init(void *blk, unsigned int idx, unsigned int conf)
 
 	if (idx < 4) {
 		/* S/PDIF output */
-		switch ((conf & 0x7)) {
+		switch ((conf & 0xf)) {
 		case 1:
 			set_field(&ctl->txctl[idx], ATXCTL_NUC, 0);
 			break;
