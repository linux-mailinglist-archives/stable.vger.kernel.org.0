Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4096254B
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbfGHPPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732314AbfGHPPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF23216F4;
        Mon,  8 Jul 2019 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598920;
        bh=VdeoSkUQVyzlg01CMf1lQWjgV+CndOIEMUt54TeKw7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvwPqQndhbTGecFpqP6MBg4ATuk5HFpXTEMQfCFGt2NBltMkI61alGEKRBBrIsSQq
         FlnsKKnm1l7ob7JQYDsOZ19DDPVauVh1YjcaLb252ScevBpB6smpb7Eg8mTPhbj/vf
         SpvE9NW0hoXu/yAJuX9hDy8Bd8HZG4tTYmsZ0QWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancock@sedsystems.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/73] hwmon: (pmbus/core) Treat parameters as paged if on multiple pages
Date:   Mon,  8 Jul 2019 17:12:28 +0200
Message-Id: <20190708150520.579047707@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



