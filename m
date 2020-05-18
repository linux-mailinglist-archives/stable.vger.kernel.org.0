Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7141D874C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgERRjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgERRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE29B20873;
        Mon, 18 May 2020 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823558;
        bh=Q5vjR3A42sT572+2XiUaWuDAb7OcxXQ3NdwNQGDIreo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2s6iiiQb3NHneSU1kZx44uq89LRh3eWudcqH+Ti61iU+Pjdix/8TL7GWgUNiY9nS
         cwb19xlBKraIDG8mrm+wSbeSIqYwGx3osmdkxqeyfHzuyeZtFeNakkB4xOJ4QvLgP0
         UdL1AhIDiVFM92T0MRuqH26k/AKDU+FmAeLKkVRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 30/86] ptp: create "pins" together with the rest of attributes
Date:   Mon, 18 May 2020 19:36:01 +0200
Message-Id: <20200518173456.604969976@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 85a66e55019583da1e0f18706b7a8281c9f6de5b upstream.

Let's switch to using device_create_with_groups(), which will allow us to
create "pins" attribute group together with the rest of ptp device
attributes, and before userspace gets notified about ptp device creation.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_clock.c   |   20 +++++++++++---------
 drivers/ptp/ptp_private.h |    7 ++++---
 drivers/ptp/ptp_sysfs.c   |   39 +++++++++------------------------------
 3 files changed, 24 insertions(+), 42 deletions(-)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -214,16 +214,17 @@ struct ptp_clock *ptp_clock_register(str
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
@@ -251,10 +252,10 @@ no_clock:
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
@@ -272,8 +273,9 @@ int ptp_clock_unregister(struct ptp_cloc
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


