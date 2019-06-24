Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6D0C50694
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfFXJ7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfFXJ7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:59:40 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37B7D208CA;
        Mon, 24 Jun 2019 09:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370379;
        bh=sehTHTNS7DM5sY0apoY8R4ulgNuUsVCxPhR1vEBgBcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Val+++lYx1/ymKl02HF2QvagFShW5U9mKCp1WKqB78Tk6G3ft9tS0HaB/QV/y4PoR
         KQjgcEpuGBaqSFsLQKBYvwdfemYsy0EWbbblXzfn29ujsFbNKopRf6aMUT8egQnQZS
         jiLdcXAEUCe1TTmi0ldB9kBTnSdhdGX/JPVMCO2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <hancock@sedsystems.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/51] hwmon: (pmbus/core) Treat parameters as paged if on multiple pages
Date:   Mon, 24 Jun 2019 17:56:55 +0800
Message-Id: <20190624092310.445377453@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
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
index 924f3ca41c65..cb9064ac4977 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1055,7 +1055,8 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 				      const struct pmbus_driver_info *info,
 				      const char *name,
 				      int index, int page,
-				      const struct pmbus_sensor_attr *attr)
+				      const struct pmbus_sensor_attr *attr,
+				      bool paged)
 {
 	struct pmbus_sensor *base;
 	bool upper = !!(attr->gbit & 0xff00);	/* need to check STATUS_WORD */
@@ -1063,7 +1064,7 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
 
 	if (attr->label) {
 		ret = pmbus_add_label(data, name, index, attr->label,
-				      attr->paged ? page + 1 : 0);
+				      paged ? page + 1 : 0);
 		if (ret)
 			return ret;
 	}
@@ -1096,6 +1097,30 @@ static int pmbus_add_sensor_attrs_one(struct i2c_client *client,
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
@@ -1109,14 +1134,15 @@ static int pmbus_add_sensor_attrs(struct i2c_client *client,
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



