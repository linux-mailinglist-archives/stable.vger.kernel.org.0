Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260DB1B67B3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgDWXJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50916 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728661AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004zB-MM; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvi-00E72y-Ft; Fri, 24 Apr 2020 00:06:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date:   Fri, 24 Apr 2020 00:07:39 +0100
Message-ID: <lsq.1587683028.913989582@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 232/245] ptp: create "pins" together with the rest of
 attributes
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 85a66e55019583da1e0f18706b7a8281c9f6de5b upstream.

Let's switch to using device_create_with_groups(), which will allow us to
create "pins" attribute group together with the rest of ptp device
attributes, and before userspace gets notified about ptp device creation.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ptp/ptp_clock.c   | 20 +++++++++++---------
 drivers/ptp/ptp_private.h |  7 ++++---
 drivers/ptp/ptp_sysfs.c   | 39 +++++++++------------------------------
 3 files changed, 24 insertions(+), 42 deletions(-)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -210,16 +210,17 @@ struct ptp_clock *ptp_clock_register(str
 	mutex_init(&ptp->pincfg_mux);
 	init_waitqueue_head(&ptp->tsev_wq);
 
+	err = ptp_populate_pin_groups(ptp);
+	if (err)
+		goto no_pin_groups;
+
 	/* Create a new device in our class. */
-	ptp->dev = device_create(ptp_class, parent, ptp->devid, ptp,
-				 "ptp%d", ptp->index);
+	ptp->dev = device_create_with_groups(ptp_class, parent, ptp->devid,
+					     ptp, ptp->pin_attr_groups,
+					     "ptp%d", ptp->index);
 	if (IS_ERR(ptp->dev))
 		goto no_device;
 
-	err = ptp_populate_sysfs(ptp);
-	if (err)
-		goto no_sysfs;
-
 	/* Register a new PPS source. */
 	if (info->pps) {
 		struct pps_source_info pps;
@@ -247,10 +248,10 @@ no_clock:
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 no_pps:
-	ptp_cleanup_sysfs(ptp);
-no_sysfs:
 	device_destroy(ptp_class, ptp->devid);
 no_device:
+	ptp_cleanup_pin_groups(ptp);
+no_pin_groups:
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 no_slot:
@@ -268,8 +269,9 @@ int ptp_clock_unregister(struct ptp_cloc
 	/* Release the clock's resources. */
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
-	ptp_cleanup_sysfs(ptp);
+
 	device_destroy(ptp_class, ptp->devid);
+	ptp_cleanup_pin_groups(ptp);
 
 	posix_clock_unregister(&ptp->clock);
 	return 0;
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -54,6 +54,8 @@ struct ptp_clock {
 	struct device_attribute *pin_dev_attr;
 	struct attribute **pin_attr;
 	struct attribute_group pin_attr_group;
+	/* 1st entry is a pointer to the real group, 2nd is NULL terminator */
+	const struct attribute_group *pin_attr_groups[2];
 };
 
 /*
@@ -94,8 +96,7 @@ uint ptp_poll(struct posix_clock *pc,
 
 extern const struct attribute_group *ptp_groups[];
 
-int ptp_cleanup_sysfs(struct ptp_clock *ptp);
-
-int ptp_populate_sysfs(struct ptp_clock *ptp);
+int ptp_populate_pin_groups(struct ptp_clock *ptp);
+void ptp_cleanup_pin_groups(struct ptp_clock *ptp);
 
 #endif
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -268,25 +268,14 @@ static ssize_t ptp_pin_store(struct devi
 	return count;
 }
 
-int ptp_cleanup_sysfs(struct ptp_clock *ptp)
+int ptp_populate_pin_groups(struct ptp_clock *ptp)
 {
-	struct device *dev = ptp->dev;
-	struct ptp_clock_info *info = ptp->info;
-
-	if (info->n_pins) {
-		sysfs_remove_group(&dev->kobj, &ptp->pin_attr_group);
-		kfree(ptp->pin_attr);
-		kfree(ptp->pin_dev_attr);
-	}
-	return 0;
-}
-
-static int ptp_populate_pins(struct ptp_clock *ptp)
-{
-	struct device *dev = ptp->dev;
 	struct ptp_clock_info *info = ptp->info;
 	int err = -ENOMEM, i, n_pins = info->n_pins;
 
+	if (!n_pins)
+		return 0;
+
 	ptp->pin_dev_attr = kzalloc(n_pins * sizeof(*ptp->pin_dev_attr),
 				    GFP_KERNEL);
 	if (!ptp->pin_dev_attr)
@@ -310,28 +299,18 @@ static int ptp_populate_pins(struct ptp_
 	ptp->pin_attr_group.name = "pins";
 	ptp->pin_attr_group.attrs = ptp->pin_attr;
 
-	err = sysfs_create_group(&dev->kobj, &ptp->pin_attr_group);
-	if (err)
-		goto no_group;
+	ptp->pin_attr_groups[0] = &ptp->pin_attr_group;
+
 	return 0;
 
-no_group:
-	kfree(ptp->pin_attr);
 no_pin_attr:
 	kfree(ptp->pin_dev_attr);
 no_dev_attr:
 	return err;
 }
 
-int ptp_populate_sysfs(struct ptp_clock *ptp)
+void ptp_cleanup_pin_groups(struct ptp_clock *ptp)
 {
-	struct ptp_clock_info *info = ptp->info;
-	int err;
-
-	if (info->n_pins) {
-		err = ptp_populate_pins(ptp);
-		if (err)
-			return err;
-	}
-	return 0;
+	kfree(ptp->pin_attr);
+	kfree(ptp->pin_dev_attr);
 }

