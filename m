Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EDE41DA30
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 14:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351044AbhI3Mth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 08:49:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:42531 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351053AbhI3Mtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 08:49:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="288832767"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="288832767"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 05:47:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="618108524"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 30 Sep 2021 05:47:52 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org,
        "Regupathy, Rajaram" <rajaram.regupathy@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: typec: tipd: Remove dependency on "connector" child fwnode
Date:   Thu, 30 Sep 2021 15:47:58 +0300
Message-Id: <20210930124758.23233-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is no "connector" child node available on every
platform, so the driver can't fail to probe when it's
missing.

Fixes: 57560ee95cb7 ("usb: typec: tipd: Don't block probing of consumer of "connector" nodes")
Reported-by: "Regupathy, Rajaram" <rajaram.regupathy@intel.com>
Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/tipd/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 93e56291f0cf1..b30efdb9fa9ed 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -628,10 +628,6 @@ static int tps6598x_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
-	fwnode = device_get_named_child_node(&client->dev, "connector");
-	if (!fwnode)
-		return -ENODEV;
-
 	/*
 	 * This fwnode has a "compatible" property, but is never populated as a
 	 * struct device. Instead we simply parse it to read the properties.
@@ -639,7 +635,9 @@ static int tps6598x_probe(struct i2c_client *client)
 	 * with existing DT files, we work around this by deleting any
 	 * fwnode_links to/from this fwnode.
 	 */
-	fw_devlink_purge_absent_suppliers(fwnode);
+	fwnode = device_get_named_child_node(&client->dev, "connector");
+	if (fwnode)
+		fw_devlink_purge_absent_suppliers(fwnode);
 
 	tps->role_sw = fwnode_usb_role_switch_get(fwnode);
 	if (IS_ERR(tps->role_sw)) {
-- 
2.33.0

