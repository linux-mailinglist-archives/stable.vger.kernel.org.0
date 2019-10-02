Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDDDC91BE
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfJBTLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35614 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729215AbfJBTIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:12 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00035n-4r; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003dT-BC; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Robert Hancock" <hancock@sedsystems.ca>,
        "Guenter Roeck" <linux@roeck-us.net>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.873035239@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 45/87] hwmon: (pmbus/core) Treat parameters as paged
 if on multiple pages
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <hancock@sedsystems.ca>

commit 4a60570dce658e3f8885bbcf852430b99f65aca5 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/pmbus/pmbus_core.c | 34 ++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -987,14 +987,15 @@ static int pmbus_add_sensor_attrs_one(st
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
@@ -1026,6 +1027,30 @@ static int pmbus_add_sensor_attrs_one(st
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
@@ -1039,14 +1064,15 @@ static int pmbus_add_sensor_attrs(struct
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

