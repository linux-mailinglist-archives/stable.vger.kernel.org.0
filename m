Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74246942
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfFNUbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbfFNUa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:59 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28D7B21848;
        Fri, 14 Jun 2019 20:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544258;
        bh=4O0JKj5fBcg87NwHkyaqFLa7IWZd6uZjlE5yc9zzJqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmWpnp7DFDptPSVVhs4A98DPvD3KMEd2iO/Ykf316vL22wthxnUJv0MYHTrdPMO/k
         L3wiD5nLsZ6vgjH37uqhT92GtVxgPj2ix/RiWE9bD2BKtQM9YyHmCo4n4CEpLbWg9H
         SkO8DGTxuAaVsFH1rh01UdHW7zUyNOOwMiwg6bq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/10] hwmon: (pmbus/core) Treat parameters as paged if on multiple pages
Date:   Fri, 14 Jun 2019 16:30:46 -0400
Message-Id: <20190614203046.28077-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203046.28077-1-sashal@kernel.org>
References: <20190614203046.28077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>

[ Upstream commit 4a60570dce658e3f8885bbcf852430b99f65aca5 ]

Some chips have attributes which exist on more than one page but the
attribute is not presently marked as paged. This causes the attributes
to be generated with the same label, which makes it impossible for
userspace to tell them apart.

Marking all such attributes as paged would result in the page suffix
being added regardless of whether they were present on more than one
page or not, which might break existing setups. Therefore, we add a
second check which treats the attribute as paged, even if not marked as
such, if it is present on multiple pages.

Fixes: b4ce237b7f7d ("hwmon: (pmbus) Introduce infrastructure to detect sensors and limit registers")
Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 34 ++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index c00bad02761a..0d75bc7b5065 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1028,14 +1028,15 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 				      const struct pmbus_driver_info *info,
 				      const char *name,
 				      int index, int page,
-				      const struct pmbus_sensor_attr *attr)
+				      const struct pmbus_sensor_attr *attr,
+				      bool paged)
 {
 	struct pmbus_sensor *base;
 	int ret;
 
 	if (attr->label) {
 		ret = pmbus_add_label(data, name, index, attr->label,
-				      attr->paged ? page + 1 : 0);
+				      paged ? page + 1 : 0);
 		if (ret)
 			return ret;
 	}
@@ -1067,6 +1068,30 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 	return 0;
 }
 
+static bool pmbus_sensor_is_paged(const struct pmbus_driver_info *info,
+				  const struct pmbus_sensor_attr *attr)
+{
+	int p;
+
+	if (attr->paged)
+		return true;
+
+	/*
+	 * Some attributes may be present on more than one page despite
+	 * not being marked with the paged attribute. If that is the case,
+	 * then treat the sensor as being paged and add the page suffix to the
+	 * attribute name.
+	 * We don't just add the paged attribute to all such attributes, in
+	 * order to maintain the un-suffixed labels in the case where the
+	 * attribute is only on page 0.
+	 */
+	for (p = 1; p < info->pages; p++) {
+		if (info->func[p] & attr->func)
+			return true;
+	}
+	return false;
+}
+
 static int pmbus_add_sensor_attrs(struct i2c_client *client,
 				  struct pmbus_data *data,
 				  const char *name,
@@ -1080,14 +1105,15 @@ static int pmbus_add_sensor_attrs(struct i2c_client *client,
 	index = 1;
 	for (i = 0; i < nattrs; i++) {
 		int page, pages;
+		bool paged = pmbus_sensor_is_paged(info, attrs);
 
-		pages = attrs->paged ? info->pages : 1;
+		pages = paged ? info->pages : 1;
 		for (page = 0; page < pages; page++) {
 			if (!(info->func[page] & attrs->func))
 				continue;
 			ret = pmbus_add_sensor_attrs_one(client, data, info,
 							 name, index, page,
-							 attrs);
+							 attrs, paged);
 			if (ret)
 				return ret;
 			index++;
-- 
2.20.1

