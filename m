Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FFA24D344
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 12:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgHUKyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 06:54:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:31401 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbgHUKyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 06:54:00 -0400
IronPort-SDR: Ie/8+Tswi6Rkljkvv5TD9WptbUI+Xf4DJv46I+JUvfQ2JOkzKOnT6EW470dnEiqvygfWl1y70/
 MZT276Ww3Ygw==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="155494756"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="155494756"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 03:53:44 -0700
IronPort-SDR: j+94MbSUQj15whe7im+QKZO8y7kzyfjS56Yuc9gPfReD1SP7JjhGcSRoaiXzUNaaUJEqY6bjj8
 izfp95Pyzz1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="401438755"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 21 Aug 2020 03:53:42 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] device property: Fix the secondary firmware node handling in set_primary_fwnode()
Date:   Fri, 21 Aug 2020 13:53:42 +0300
Message-Id: <20200821105342.32368-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the primary firmware node pointer is removed from a
device (set to NULL) the secondary firmware node pointer,
when it exists, is made the primary node for the device.
However, the secondary firmware node pointer of the original
primary firmware node is never cleared (set to NULL).

To avoid situation where the secondary firmware node pointer
is pointing to a non-existing object, clearing it properly
when the primary node is removed from a device in
set_primary_fwnode().

Fixes: 97badf873ab6 ("device property: Make it possible to use secondary firmware nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/base/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ac1046a382bc0..f6f620aa94086 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4264,9 +4264,9 @@ static inline bool fwnode_is_primary(struct fwnode_handle *fwnode)
  */
 void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
 {
-	if (fwnode) {
-		struct fwnode_handle *fn = dev->fwnode;
+	struct fwnode_handle *fn = dev->fwnode;
 
+	if (fwnode) {
 		if (fwnode_is_primary(fn))
 			fn = fn->secondary;
 
@@ -4276,8 +4276,12 @@ void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
 		}
 		dev->fwnode = fwnode;
 	} else {
-		dev->fwnode = fwnode_is_primary(dev->fwnode) ?
-			dev->fwnode->secondary : NULL;
+		if (fwnode_is_primary(fn)) {
+			dev->fwnode = fn->secondary;
+			fn->secondary = NULL;
+		} else {
+			dev->fwnode = NULL;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(set_primary_fwnode);
-- 
2.28.0

