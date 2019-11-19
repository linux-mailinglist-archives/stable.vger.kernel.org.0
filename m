Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D65101788
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbfKSFmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730665AbfKSFmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C6F3218BA;
        Tue, 19 Nov 2019 05:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142162;
        bh=RRoVybARuoCg+kCC3+TjStz3qLWGD7rDOiQeSGC0dmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Mc8EUXYwwItXCBz4DLR/kpyA5aJJQgRPme/JFwwHibMTZuICIwTb26ZO1DNu9+At
         TG6YhcDJX/N2OvNedktu+Yzu5sDkMJqzEx319X26avCM9190e1vvBiwmvxPlo5KKCh
         lw6aMOYtoMxH/ZXCmQuKo4Dn8QtWLeSfvHl8rv5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Denis Osterland <Denis.Osterland@diehl.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 411/422] rtc: isl1208: avoid possible sysfs race
Date:   Tue, 19 Nov 2019 06:20:08 +0100
Message-Id: <20191119051425.824143266@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 1b4c794fda583edabe864ac466e9cd43c707be80 ]

Use rtc_add_group to add the common sysfs group to avoid a possible race
condition.

[Denis.Osterland@diehl.com: use to_i2c_client(dev->parent)]
Signed-off-by: Denis Osterland <Denis.Osterland@diehl.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

The move of atrim, dtrim usr sysfs properties from i2c device
to rtc device require to access them via dev->parent.
This patch also aligns timestamp0.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-isl1208.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index ea18a8f4bce06..033f65aef5788 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -518,7 +518,7 @@ static ssize_t timestamp0_store(struct device *dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
-	struct i2c_client *client = dev_get_drvdata(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	int sr;
 
 	sr = isl1208_i2c_get_sr(client);
@@ -540,7 +540,7 @@ static ssize_t timestamp0_store(struct device *dev,
 static ssize_t timestamp0_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = dev_get_drvdata(dev);
+	struct i2c_client *client = to_i2c_client(dev->parent);
 	u8 regs[ISL1219_EVT_SECTION_LEN] = { 0, };
 	struct rtc_time tm;
 	int sr;
@@ -650,7 +650,7 @@ static ssize_t
 isl1208_sysfs_show_atrim(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	int atr = isl1208_i2c_get_atr(to_i2c_client(dev));
+	int atr = isl1208_i2c_get_atr(to_i2c_client(dev->parent));
 	if (atr < 0)
 		return atr;
 
@@ -663,7 +663,7 @@ static ssize_t
 isl1208_sysfs_show_dtrim(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	int dtr = isl1208_i2c_get_dtr(to_i2c_client(dev));
+	int dtr = isl1208_i2c_get_dtr(to_i2c_client(dev->parent));
 	if (dtr < 0)
 		return dtr;
 
@@ -676,7 +676,7 @@ static ssize_t
 isl1208_sysfs_show_usr(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
-	int usr = isl1208_i2c_get_usr(to_i2c_client(dev));
+	int usr = isl1208_i2c_get_usr(to_i2c_client(dev->parent));
 	if (usr < 0)
 		return usr;
 
@@ -701,7 +701,10 @@ isl1208_sysfs_store_usr(struct device *dev,
 	if (usr < 0 || usr > 0xffff)
 		return -EINVAL;
 
-	return isl1208_i2c_set_usr(to_i2c_client(dev), usr) ? -EIO : count;
+	if (isl1208_i2c_set_usr(to_i2c_client(dev->parent), usr))
+		return -EIO;
+
+	return count;
 }
 
 static DEVICE_ATTR(usr, S_IRUGO | S_IWUSR, isl1208_sysfs_show_usr,
@@ -765,7 +768,6 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	rtc->ops = &isl1208_rtc_ops;
 
 	i2c_set_clientdata(client, rtc);
-	dev_set_drvdata(&rtc->dev, client);
 
 	rc = isl1208_i2c_get_sr(client);
 	if (rc < 0) {
@@ -804,7 +806,7 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		evdet_irq = of_irq_get_byname(np, "evdet");
 	}
 
-	rc = sysfs_create_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
+	rc = rtc_add_group(rtc, &isl1208_rtc_sysfs_files);
 	if (rc)
 		return rc;
 
@@ -821,14 +823,6 @@ isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return rtc_register_device(rtc);
 }
 
-static int
-isl1208_remove(struct i2c_client *client)
-{
-	sysfs_remove_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
-
-	return 0;
-}
-
 static const struct i2c_device_id isl1208_id[] = {
 	{ "isl1208", TYPE_ISL1208 },
 	{ "isl1218", TYPE_ISL1218 },
@@ -851,7 +845,6 @@ static struct i2c_driver isl1208_driver = {
 		.of_match_table = of_match_ptr(isl1208_of_match),
 	},
 	.probe = isl1208_probe,
-	.remove = isl1208_remove,
 	.id_table = isl1208_id,
 };
 
-- 
2.20.1



