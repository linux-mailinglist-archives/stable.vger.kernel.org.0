Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7013A3BCD06
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbhGFLUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232890AbhGFLTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5FB361C6F;
        Tue,  6 Jul 2021 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570206;
        bh=Nl+PYIWG95sZHp9MXazZtG5WSqqsrtRYv9i/nWQCgAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6pnkyYjZtN8icltYrw7qk7nn/ks/VPUhftm+25dYs549EDiMqQf6q7Hnf+0Px4iE
         QOi+1rH/jSNVz814RG0AE6fqc9eLmoqbi4IzaXrcIj4sOTc8ySU1B98tkvUHhe9mzY
         RfnuUvY+0O5/s2LdOvs6u8i6zilLCnc+nrE6ndrESGJm8Ujwt5CC3H/skB1EYqI0Wy
         0fIGwNbO46yicRz789ACAswP+b+r5Mnl4cMlQZJY3oWJjlN6T1FIwGKHnd2p7jWrx8
         oqG/o/Fz+gj+F7/HtZ2psfHLYzHfV7zNVQuMhM69grLCz3MvKd/Bxi4rDLlSS6FyC9
         qARNTjGVmajeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 117/189] RDMA/hfi1: Use attributes for the port sysfs
Date:   Tue,  6 Jul 2021 07:12:57 -0400
Message-Id: <20210706111409.2058071-117-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8f1708f19f919135a5d7eddcdccc15b7fd7d524d ]

hfi1 should not be creating a mess of kobjects to attach to the port
kobject - this is all attributes. The proper API is to create an
attribute_group list and create it against the port's kobject.

Link: https://lore.kernel.org/r/cbe0ccb6175dd22274359b6ad803a37435a70e91.1623427137.git.leonro@nvidia.com
Tested-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/hfi.h   |   4 -
 drivers/infiniband/hw/hfi1/sysfs.c | 530 +++++++++++------------------
 2 files changed, 194 insertions(+), 340 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 867ae0b1aa95..87e101fb1f65 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -772,10 +772,6 @@ struct hfi1_pportdata {
 	struct hfi1_ibport ibport_data;
 
 	struct hfi1_devdata *dd;
-	struct kobject pport_cc_kobj;
-	struct kobject sc2vl_kobj;
-	struct kobject sl2sc_kobj;
-	struct kobject vl2mtu_kobj;
 
 	/* PHY support */
 	struct qsfp_data qsfp_info;
diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index eaf441ece25e..98bb0b3aac09 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -45,11 +45,21 @@
  *
  */
 #include <linux/ctype.h>
+#include <rdma/ib_sysfs.h>
 
 #include "hfi.h"
 #include "mad.h"
 #include "trace.h"
 
+static struct hfi1_pportdata *hfi1_get_pportdata_kobj(struct kobject *kobj)
+{
+	u32 port_num;
+	struct ib_device *ibdev = ib_port_sysfs_get_ibdev_kobj(kobj, &port_num);
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+
+	return &dd->pport[port_num - 1];
+}
+
 /*
  * Start of per-port congestion control structures and support code
  */
@@ -57,13 +67,12 @@
 /*
  * Congestion control table size followed by table entries
  */
-static ssize_t read_cc_table_bin(struct file *filp, struct kobject *kobj,
-				 struct bin_attribute *bin_attr,
-				 char *buf, loff_t pos, size_t count)
+static ssize_t cc_table_bin_read(struct file *filp, struct kobject *kobj,
+				 struct bin_attribute *bin_attr, char *buf,
+				 loff_t pos, size_t count)
 {
 	int ret;
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, pport_cc_kobj);
+	struct hfi1_pportdata *ppd = hfi1_get_pportdata_kobj(kobj);
 	struct cc_state *cc_state;
 
 	ret = ppd->total_cct_entry * sizeof(struct ib_cc_table_entry_shadow)
@@ -89,30 +98,19 @@ static ssize_t read_cc_table_bin(struct file *filp, struct kobject *kobj,
 
 	return count;
 }
-
-static void port_release(struct kobject *kobj)
-{
-	/* nothing to do since memory is freed by hfi1_free_devdata() */
-}
-
-static const struct bin_attribute cc_table_bin_attr = {
-	.attr = {.name = "cc_table_bin", .mode = 0444},
-	.read = read_cc_table_bin,
-	.size = PAGE_SIZE,
-};
+static BIN_ATTR_RO(cc_table_bin, PAGE_SIZE);
 
 /*
  * Congestion settings: port control, control map and an array of 16
  * entries for the congestion entries - increase, timer, event log
  * trigger threshold and the minimum injection rate delay.
  */
-static ssize_t read_cc_setting_bin(struct file *filp, struct kobject *kobj,
+static ssize_t cc_setting_bin_read(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buf, loff_t pos, size_t count)
 {
+	struct hfi1_pportdata *ppd = hfi1_get_pportdata_kobj(kobj);
 	int ret;
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, pport_cc_kobj);
 	struct cc_state *cc_state;
 
 	ret = sizeof(struct opa_congestion_setting_attr_shadow);
@@ -136,27 +134,30 @@ static ssize_t read_cc_setting_bin(struct file *filp, struct kobject *kobj,
 
 	return count;
 }
+static BIN_ATTR_RO(cc_setting_bin, PAGE_SIZE);
 
-static const struct bin_attribute cc_setting_bin_attr = {
-	.attr = {.name = "cc_settings_bin", .mode = 0444},
-	.read = read_cc_setting_bin,
-	.size = PAGE_SIZE,
-};
-
-struct hfi1_port_attr {
-	struct attribute attr;
-	ssize_t	(*show)(struct hfi1_pportdata *, char *);
-	ssize_t	(*store)(struct hfi1_pportdata *, const char *, size_t);
+static struct bin_attribute *port_cc_bin_attributes[] = {
+	&bin_attr_cc_setting_bin,
+	&bin_attr_cc_table_bin,
+	NULL
 };
 
-static ssize_t cc_prescan_show(struct hfi1_pportdata *ppd, char *buf)
+static ssize_t cc_prescan_show(struct ib_device *ibdev, u32 port_num,
+			       struct ib_port_attribute *attr, char *buf)
 {
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct hfi1_pportdata *ppd = &dd->pport[port_num - 1];
+
 	return sysfs_emit(buf, "%s\n", ppd->cc_prescan ? "on" : "off");
 }
 
-static ssize_t cc_prescan_store(struct hfi1_pportdata *ppd, const char *buf,
+static ssize_t cc_prescan_store(struct ib_device *ibdev, u32 port_num,
+				struct ib_port_attribute *attr, const char *buf,
 				size_t count)
 {
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct hfi1_pportdata *ppd = &dd->pport[port_num - 1];
+
 	if (!memcmp(buf, "on", 2))
 		ppd->cc_prescan = true;
 	else if (!memcmp(buf, "off", 3))
@@ -164,60 +165,41 @@ static ssize_t cc_prescan_store(struct hfi1_pportdata *ppd, const char *buf,
 
 	return count;
 }
+static IB_PORT_ATTR_ADMIN_RW(cc_prescan);
 
-static struct hfi1_port_attr cc_prescan_attr =
-		__ATTR(cc_prescan, 0600, cc_prescan_show, cc_prescan_store);
-
-static ssize_t cc_attr_show(struct kobject *kobj, struct attribute *attr,
-			    char *buf)
-{
-	struct hfi1_port_attr *port_attr =
-		container_of(attr, struct hfi1_port_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, pport_cc_kobj);
-
-	return port_attr->show(ppd, buf);
-}
-
-static ssize_t cc_attr_store(struct kobject *kobj, struct attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct hfi1_port_attr *port_attr =
-		container_of(attr, struct hfi1_port_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, pport_cc_kobj);
-
-	return port_attr->store(ppd, buf, count);
-}
-
-static const struct sysfs_ops port_cc_sysfs_ops = {
-	.show = cc_attr_show,
-	.store = cc_attr_store
-};
-
-static struct attribute *port_cc_default_attributes[] = {
-	&cc_prescan_attr.attr,
+static struct attribute *port_cc_attributes[] = {
+	&ib_port_attr_cc_prescan.attr,
 	NULL
 };
 
-static struct kobj_type port_cc_ktype = {
-	.release = port_release,
-	.sysfs_ops = &port_cc_sysfs_ops,
-	.default_attrs = port_cc_default_attributes
+static const struct attribute_group port_cc_group = {
+	.name = "CCMgtA",
+	.attrs = port_cc_attributes,
+	.bin_attrs = port_cc_bin_attributes,
 };
 
 /* Start sc2vl */
-#define HFI1_SC2VL_ATTR(N)				    \
-	static struct hfi1_sc2vl_attr hfi1_sc2vl_attr_##N = { \
-		.attr = { .name = __stringify(N), .mode = 0444 }, \
-		.sc = N \
-	}
-
 struct hfi1_sc2vl_attr {
-	struct attribute attr;
+	struct ib_port_attribute attr;
 	int sc;
 };
 
+static ssize_t sc2vl_attr_show(struct ib_device *ibdev, u32 port_num,
+			       struct ib_port_attribute *attr, char *buf)
+{
+	struct hfi1_sc2vl_attr *sattr =
+		container_of(attr, struct hfi1_sc2vl_attr, attr);
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+
+	return sysfs_emit(buf, "%u\n", *((u8 *)dd->sc2vl + sattr->sc));
+}
+
+#define HFI1_SC2VL_ATTR(N)                                                     \
+	static struct hfi1_sc2vl_attr hfi1_sc2vl_attr_##N = {                  \
+		.attr = __ATTR(N, 0444, sc2vl_attr_show, NULL),                \
+		.sc = N,                                                       \
+	}
+
 HFI1_SC2VL_ATTR(0);
 HFI1_SC2VL_ATTR(1);
 HFI1_SC2VL_ATTR(2);
@@ -251,78 +233,70 @@ HFI1_SC2VL_ATTR(29);
 HFI1_SC2VL_ATTR(30);
 HFI1_SC2VL_ATTR(31);
 
-static struct attribute *sc2vl_default_attributes[] = {
-	&hfi1_sc2vl_attr_0.attr,
-	&hfi1_sc2vl_attr_1.attr,
-	&hfi1_sc2vl_attr_2.attr,
-	&hfi1_sc2vl_attr_3.attr,
-	&hfi1_sc2vl_attr_4.attr,
-	&hfi1_sc2vl_attr_5.attr,
-	&hfi1_sc2vl_attr_6.attr,
-	&hfi1_sc2vl_attr_7.attr,
-	&hfi1_sc2vl_attr_8.attr,
-	&hfi1_sc2vl_attr_9.attr,
-	&hfi1_sc2vl_attr_10.attr,
-	&hfi1_sc2vl_attr_11.attr,
-	&hfi1_sc2vl_attr_12.attr,
-	&hfi1_sc2vl_attr_13.attr,
-	&hfi1_sc2vl_attr_14.attr,
-	&hfi1_sc2vl_attr_15.attr,
-	&hfi1_sc2vl_attr_16.attr,
-	&hfi1_sc2vl_attr_17.attr,
-	&hfi1_sc2vl_attr_18.attr,
-	&hfi1_sc2vl_attr_19.attr,
-	&hfi1_sc2vl_attr_20.attr,
-	&hfi1_sc2vl_attr_21.attr,
-	&hfi1_sc2vl_attr_22.attr,
-	&hfi1_sc2vl_attr_23.attr,
-	&hfi1_sc2vl_attr_24.attr,
-	&hfi1_sc2vl_attr_25.attr,
-	&hfi1_sc2vl_attr_26.attr,
-	&hfi1_sc2vl_attr_27.attr,
-	&hfi1_sc2vl_attr_28.attr,
-	&hfi1_sc2vl_attr_29.attr,
-	&hfi1_sc2vl_attr_30.attr,
-	&hfi1_sc2vl_attr_31.attr,
+static struct attribute *port_sc2vl_attributes[] = {
+	&hfi1_sc2vl_attr_0.attr.attr,
+	&hfi1_sc2vl_attr_1.attr.attr,
+	&hfi1_sc2vl_attr_2.attr.attr,
+	&hfi1_sc2vl_attr_3.attr.attr,
+	&hfi1_sc2vl_attr_4.attr.attr,
+	&hfi1_sc2vl_attr_5.attr.attr,
+	&hfi1_sc2vl_attr_6.attr.attr,
+	&hfi1_sc2vl_attr_7.attr.attr,
+	&hfi1_sc2vl_attr_8.attr.attr,
+	&hfi1_sc2vl_attr_9.attr.attr,
+	&hfi1_sc2vl_attr_10.attr.attr,
+	&hfi1_sc2vl_attr_11.attr.attr,
+	&hfi1_sc2vl_attr_12.attr.attr,
+	&hfi1_sc2vl_attr_13.attr.attr,
+	&hfi1_sc2vl_attr_14.attr.attr,
+	&hfi1_sc2vl_attr_15.attr.attr,
+	&hfi1_sc2vl_attr_16.attr.attr,
+	&hfi1_sc2vl_attr_17.attr.attr,
+	&hfi1_sc2vl_attr_18.attr.attr,
+	&hfi1_sc2vl_attr_19.attr.attr,
+	&hfi1_sc2vl_attr_20.attr.attr,
+	&hfi1_sc2vl_attr_21.attr.attr,
+	&hfi1_sc2vl_attr_22.attr.attr,
+	&hfi1_sc2vl_attr_23.attr.attr,
+	&hfi1_sc2vl_attr_24.attr.attr,
+	&hfi1_sc2vl_attr_25.attr.attr,
+	&hfi1_sc2vl_attr_26.attr.attr,
+	&hfi1_sc2vl_attr_27.attr.attr,
+	&hfi1_sc2vl_attr_28.attr.attr,
+	&hfi1_sc2vl_attr_29.attr.attr,
+	&hfi1_sc2vl_attr_30.attr.attr,
+	&hfi1_sc2vl_attr_31.attr.attr,
 	NULL
 };
 
-static ssize_t sc2vl_attr_show(struct kobject *kobj, struct attribute *attr,
-			       char *buf)
-{
-	struct hfi1_sc2vl_attr *sattr =
-		container_of(attr, struct hfi1_sc2vl_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, sc2vl_kobj);
-	struct hfi1_devdata *dd = ppd->dd;
-
-	return sysfs_emit(buf, "%u\n", *((u8 *)dd->sc2vl + sattr->sc));
-}
-
-static const struct sysfs_ops hfi1_sc2vl_ops = {
-	.show = sc2vl_attr_show,
+static const struct attribute_group port_sc2vl_group = {
+	.name = "sc2vl",
+	.attrs = port_sc2vl_attributes,
 };
-
-static struct kobj_type hfi1_sc2vl_ktype = {
-	.release = port_release,
-	.sysfs_ops = &hfi1_sc2vl_ops,
-	.default_attrs = sc2vl_default_attributes
-};
-
 /* End sc2vl */
 
 /* Start sl2sc */
-#define HFI1_SL2SC_ATTR(N)				    \
-	static struct hfi1_sl2sc_attr hfi1_sl2sc_attr_##N = {	  \
-		.attr = { .name = __stringify(N), .mode = 0444 }, \
-		.sl = N						  \
-	}
-
 struct hfi1_sl2sc_attr {
-	struct attribute attr;
+	struct ib_port_attribute attr;
 	int sl;
 };
 
+static ssize_t sl2sc_attr_show(struct ib_device *ibdev, u32 port_num,
+			       struct ib_port_attribute *attr, char *buf)
+{
+	struct hfi1_sl2sc_attr *sattr =
+		container_of(attr, struct hfi1_sl2sc_attr, attr);
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct hfi1_ibport *ibp = &dd->pport[port_num - 1].ibport_data;
+
+	return sysfs_emit(buf, "%u\n", ibp->sl_to_sc[sattr->sl]);
+}
+
+#define HFI1_SL2SC_ATTR(N)                                                     \
+	static struct hfi1_sl2sc_attr hfi1_sl2sc_attr_##N = {                  \
+		.attr = __ATTR(N, 0444, sl2sc_attr_show, NULL), .sl = N        \
+	}
+
 HFI1_SL2SC_ATTR(0);
 HFI1_SL2SC_ATTR(1);
 HFI1_SL2SC_ATTR(2);
@@ -356,79 +330,72 @@ HFI1_SL2SC_ATTR(29);
 HFI1_SL2SC_ATTR(30);
 HFI1_SL2SC_ATTR(31);
 
-static struct attribute *sl2sc_default_attributes[] = {
-	&hfi1_sl2sc_attr_0.attr,
-	&hfi1_sl2sc_attr_1.attr,
-	&hfi1_sl2sc_attr_2.attr,
-	&hfi1_sl2sc_attr_3.attr,
-	&hfi1_sl2sc_attr_4.attr,
-	&hfi1_sl2sc_attr_5.attr,
-	&hfi1_sl2sc_attr_6.attr,
-	&hfi1_sl2sc_attr_7.attr,
-	&hfi1_sl2sc_attr_8.attr,
-	&hfi1_sl2sc_attr_9.attr,
-	&hfi1_sl2sc_attr_10.attr,
-	&hfi1_sl2sc_attr_11.attr,
-	&hfi1_sl2sc_attr_12.attr,
-	&hfi1_sl2sc_attr_13.attr,
-	&hfi1_sl2sc_attr_14.attr,
-	&hfi1_sl2sc_attr_15.attr,
-	&hfi1_sl2sc_attr_16.attr,
-	&hfi1_sl2sc_attr_17.attr,
-	&hfi1_sl2sc_attr_18.attr,
-	&hfi1_sl2sc_attr_19.attr,
-	&hfi1_sl2sc_attr_20.attr,
-	&hfi1_sl2sc_attr_21.attr,
-	&hfi1_sl2sc_attr_22.attr,
-	&hfi1_sl2sc_attr_23.attr,
-	&hfi1_sl2sc_attr_24.attr,
-	&hfi1_sl2sc_attr_25.attr,
-	&hfi1_sl2sc_attr_26.attr,
-	&hfi1_sl2sc_attr_27.attr,
-	&hfi1_sl2sc_attr_28.attr,
-	&hfi1_sl2sc_attr_29.attr,
-	&hfi1_sl2sc_attr_30.attr,
-	&hfi1_sl2sc_attr_31.attr,
+static struct attribute *port_sl2sc_attributes[] = {
+	&hfi1_sl2sc_attr_0.attr.attr,
+	&hfi1_sl2sc_attr_1.attr.attr,
+	&hfi1_sl2sc_attr_2.attr.attr,
+	&hfi1_sl2sc_attr_3.attr.attr,
+	&hfi1_sl2sc_attr_4.attr.attr,
+	&hfi1_sl2sc_attr_5.attr.attr,
+	&hfi1_sl2sc_attr_6.attr.attr,
+	&hfi1_sl2sc_attr_7.attr.attr,
+	&hfi1_sl2sc_attr_8.attr.attr,
+	&hfi1_sl2sc_attr_9.attr.attr,
+	&hfi1_sl2sc_attr_10.attr.attr,
+	&hfi1_sl2sc_attr_11.attr.attr,
+	&hfi1_sl2sc_attr_12.attr.attr,
+	&hfi1_sl2sc_attr_13.attr.attr,
+	&hfi1_sl2sc_attr_14.attr.attr,
+	&hfi1_sl2sc_attr_15.attr.attr,
+	&hfi1_sl2sc_attr_16.attr.attr,
+	&hfi1_sl2sc_attr_17.attr.attr,
+	&hfi1_sl2sc_attr_18.attr.attr,
+	&hfi1_sl2sc_attr_19.attr.attr,
+	&hfi1_sl2sc_attr_20.attr.attr,
+	&hfi1_sl2sc_attr_21.attr.attr,
+	&hfi1_sl2sc_attr_22.attr.attr,
+	&hfi1_sl2sc_attr_23.attr.attr,
+	&hfi1_sl2sc_attr_24.attr.attr,
+	&hfi1_sl2sc_attr_25.attr.attr,
+	&hfi1_sl2sc_attr_26.attr.attr,
+	&hfi1_sl2sc_attr_27.attr.attr,
+	&hfi1_sl2sc_attr_28.attr.attr,
+	&hfi1_sl2sc_attr_29.attr.attr,
+	&hfi1_sl2sc_attr_30.attr.attr,
+	&hfi1_sl2sc_attr_31.attr.attr,
 	NULL
 };
 
-static ssize_t sl2sc_attr_show(struct kobject *kobj, struct attribute *attr,
-			       char *buf)
-{
-	struct hfi1_sl2sc_attr *sattr =
-		container_of(attr, struct hfi1_sl2sc_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, sl2sc_kobj);
-	struct hfi1_ibport *ibp = &ppd->ibport_data;
-
-	return sysfs_emit(buf, "%u\n", ibp->sl_to_sc[sattr->sl]);
-}
-
-static const struct sysfs_ops hfi1_sl2sc_ops = {
-	.show = sl2sc_attr_show,
-};
-
-static struct kobj_type hfi1_sl2sc_ktype = {
-	.release = port_release,
-	.sysfs_ops = &hfi1_sl2sc_ops,
-	.default_attrs = sl2sc_default_attributes
+static const struct attribute_group port_sl2sc_group = {
+	.name = "sl2sc",
+	.attrs = port_sl2sc_attributes,
 };
 
 /* End sl2sc */
 
 /* Start vl2mtu */
 
-#define HFI1_VL2MTU_ATTR(N) \
-	static struct hfi1_vl2mtu_attr hfi1_vl2mtu_attr_##N = { \
-		.attr = { .name = __stringify(N), .mode = 0444 }, \
-		.vl = N						  \
-	}
-
 struct hfi1_vl2mtu_attr {
-	struct attribute attr;
+	struct ib_port_attribute attr;
 	int vl;
 };
 
+static ssize_t vl2mtu_attr_show(struct ib_device *ibdev, u32 port_num,
+				struct ib_port_attribute *attr, char *buf)
+{
+	struct hfi1_vl2mtu_attr *vlattr =
+		container_of(attr, struct hfi1_vl2mtu_attr, attr);
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+
+	return sysfs_emit(buf, "%u\n", dd->vld[vlattr->vl].mtu);
+}
+
+#define HFI1_VL2MTU_ATTR(N)                                                    \
+	static struct hfi1_vl2mtu_attr hfi1_vl2mtu_attr_##N = {                \
+		.attr = __ATTR(N, 0444, vl2mtu_attr_show, NULL),               \
+		.vl = N,                                                       \
+	}
+
 HFI1_VL2MTU_ATTR(0);
 HFI1_VL2MTU_ATTR(1);
 HFI1_VL2MTU_ATTR(2);
@@ -446,46 +413,29 @@ HFI1_VL2MTU_ATTR(13);
 HFI1_VL2MTU_ATTR(14);
 HFI1_VL2MTU_ATTR(15);
 
-static struct attribute *vl2mtu_default_attributes[] = {
-	&hfi1_vl2mtu_attr_0.attr,
-	&hfi1_vl2mtu_attr_1.attr,
-	&hfi1_vl2mtu_attr_2.attr,
-	&hfi1_vl2mtu_attr_3.attr,
-	&hfi1_vl2mtu_attr_4.attr,
-	&hfi1_vl2mtu_attr_5.attr,
-	&hfi1_vl2mtu_attr_6.attr,
-	&hfi1_vl2mtu_attr_7.attr,
-	&hfi1_vl2mtu_attr_8.attr,
-	&hfi1_vl2mtu_attr_9.attr,
-	&hfi1_vl2mtu_attr_10.attr,
-	&hfi1_vl2mtu_attr_11.attr,
-	&hfi1_vl2mtu_attr_12.attr,
-	&hfi1_vl2mtu_attr_13.attr,
-	&hfi1_vl2mtu_attr_14.attr,
-	&hfi1_vl2mtu_attr_15.attr,
+static struct attribute *port_vl2mtu_attributes[] = {
+	&hfi1_vl2mtu_attr_0.attr.attr,
+	&hfi1_vl2mtu_attr_1.attr.attr,
+	&hfi1_vl2mtu_attr_2.attr.attr,
+	&hfi1_vl2mtu_attr_3.attr.attr,
+	&hfi1_vl2mtu_attr_4.attr.attr,
+	&hfi1_vl2mtu_attr_5.attr.attr,
+	&hfi1_vl2mtu_attr_6.attr.attr,
+	&hfi1_vl2mtu_attr_7.attr.attr,
+	&hfi1_vl2mtu_attr_8.attr.attr,
+	&hfi1_vl2mtu_attr_9.attr.attr,
+	&hfi1_vl2mtu_attr_10.attr.attr,
+	&hfi1_vl2mtu_attr_11.attr.attr,
+	&hfi1_vl2mtu_attr_12.attr.attr,
+	&hfi1_vl2mtu_attr_13.attr.attr,
+	&hfi1_vl2mtu_attr_14.attr.attr,
+	&hfi1_vl2mtu_attr_15.attr.attr,
 	NULL
 };
 
-static ssize_t vl2mtu_attr_show(struct kobject *kobj, struct attribute *attr,
-				char *buf)
-{
-	struct hfi1_vl2mtu_attr *vlattr =
-		container_of(attr, struct hfi1_vl2mtu_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, vl2mtu_kobj);
-	struct hfi1_devdata *dd = ppd->dd;
-
-	return sysfs_emit(buf, "%u\n", dd->vld[vlattr->vl].mtu);
-}
-
-static const struct sysfs_ops hfi1_vl2mtu_ops = {
-	.show = vl2mtu_attr_show,
-};
-
-static struct kobj_type hfi1_vl2mtu_ktype = {
-	.release = port_release,
-	.sysfs_ops = &hfi1_vl2mtu_ops,
-	.default_attrs = vl2mtu_default_attributes
+static const struct attribute_group port_vl2mtu_group = {
+	.name = "vl2mtu",
+	.attrs = port_vl2mtu_attributes,
 };
 
 /* end of per-port file structures and support code */
@@ -649,100 +599,18 @@ const struct attribute_group ib_hfi1_attr_group = {
 	.attrs = hfi1_attributes,
 };
 
+static const struct attribute_group *hfi1_port_groups[] = {
+	&port_cc_group,
+	&port_sc2vl_group,
+	&port_sl2sc_group,
+	&port_vl2mtu_group,
+	NULL,
+};
+
 int hfi1_create_port_files(struct ib_device *ibdev, u32 port_num,
 			   struct kobject *kobj)
 {
-	struct hfi1_pportdata *ppd;
-	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
-	int ret;
-
-	if (!port_num || port_num > dd->num_pports) {
-		dd_dev_err(dd,
-			   "Skipping infiniband class with invalid port %u\n",
-			   port_num);
-		return -ENODEV;
-	}
-	ppd = &dd->pport[port_num - 1];
-
-	ret = kobject_init_and_add(&ppd->sc2vl_kobj, &hfi1_sc2vl_ktype, kobj,
-				   "sc2vl");
-	if (ret) {
-		dd_dev_err(dd,
-			   "Skipping sc2vl sysfs info, (err %d) port %u\n",
-			   ret, port_num);
-		/*
-		 * Based on the documentation for kobject_init_and_add(), the
-		 * caller should call kobject_put even if this call fails.
-		 */
-		goto bail_sc2vl;
-	}
-	kobject_uevent(&ppd->sc2vl_kobj, KOBJ_ADD);
-
-	ret = kobject_init_and_add(&ppd->sl2sc_kobj, &hfi1_sl2sc_ktype, kobj,
-				   "sl2sc");
-	if (ret) {
-		dd_dev_err(dd,
-			   "Skipping sl2sc sysfs info, (err %d) port %u\n",
-			   ret, port_num);
-		goto bail_sl2sc;
-	}
-	kobject_uevent(&ppd->sl2sc_kobj, KOBJ_ADD);
-
-	ret = kobject_init_and_add(&ppd->vl2mtu_kobj, &hfi1_vl2mtu_ktype, kobj,
-				   "vl2mtu");
-	if (ret) {
-		dd_dev_err(dd,
-			   "Skipping vl2mtu sysfs info, (err %d) port %u\n",
-			   ret, port_num);
-		goto bail_vl2mtu;
-	}
-	kobject_uevent(&ppd->vl2mtu_kobj, KOBJ_ADD);
-
-	ret = kobject_init_and_add(&ppd->pport_cc_kobj, &port_cc_ktype,
-				   kobj, "CCMgtA");
-	if (ret) {
-		dd_dev_err(dd,
-			   "Skipping Congestion Control sysfs info, (err %d) port %u\n",
-			   ret, port_num);
-		goto bail_cc;
-	}
-
-	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
-
-	ret = sysfs_create_bin_file(&ppd->pport_cc_kobj, &cc_setting_bin_attr);
-	if (ret) {
-		dd_dev_err(dd,
-			   "Skipping Congestion Control setting sysfs info, (err %d) port %u\n",
-			   ret, port_num);
-		goto bail_cc;
-	}
-
-	ret = sysfs_create_bin_file(&ppd->pport_cc_kobj, &cc_table_bin_attr);
-	if (ret) {
-		dd_dev_err(dd,
-			   "Skipping Congestion Control table sysfs info, (err %d) port %u\n",
-			   ret, port_num);
-		goto bail_cc_entry_bin;
-	}
-
-	dd_dev_info(dd,
-		    "Congestion Control Agent enabled for port %d\n",
-		    port_num);
-
-	return 0;
-
-bail_cc_entry_bin:
-	sysfs_remove_bin_file(&ppd->pport_cc_kobj,
-			      &cc_setting_bin_attr);
-bail_cc:
-	kobject_put(&ppd->pport_cc_kobj);
-bail_vl2mtu:
-	kobject_put(&ppd->vl2mtu_kobj);
-bail_sl2sc:
-	kobject_put(&ppd->sl2sc_kobj);
-bail_sc2vl:
-	kobject_put(&ppd->sc2vl_kobj);
-	return ret;
+	return ib_port_sysfs_create_groups(ibdev, port_num, hfi1_port_groups);
 }
 
 struct sde_attribute {
@@ -868,23 +736,13 @@ int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd)
  */
 void hfi1_verbs_unregister_sysfs(struct hfi1_devdata *dd)
 {
-	struct hfi1_pportdata *ppd;
 	int i;
 
 	/* Unwind operations in hfi1_verbs_register_sysfs() */
 	for (i = 0; i < dd->num_sdma; i++)
 		kobject_put(&dd->per_sdma[i].kobj);
 
-	for (i = 0; i < dd->num_pports; i++) {
-		ppd = &dd->pport[i];
-
-		sysfs_remove_bin_file(&ppd->pport_cc_kobj,
-				      &cc_setting_bin_attr);
-		sysfs_remove_bin_file(&ppd->pport_cc_kobj,
-				      &cc_table_bin_attr);
-		kobject_put(&ppd->pport_cc_kobj);
-		kobject_put(&ppd->vl2mtu_kobj);
-		kobject_put(&ppd->sl2sc_kobj);
-		kobject_put(&ppd->sc2vl_kobj);
-	}
+	for (i = 0; i < dd->num_pports; i++)
+		ib_port_sysfs_remove_groups(&dd->verbs_dev.rdi.ibdev, i + 1,
+					    hfi1_port_groups);
 }
-- 
2.30.2

