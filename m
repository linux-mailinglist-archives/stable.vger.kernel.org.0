Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B0711C5B7
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfLLF4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:56:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:16608 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfLLF4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 00:56:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 21:56:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,304,1571727600"; 
   d="scan'208";a="216003836"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.155])
  by orsmga006.jf.intel.com with ESMTP; 11 Dec 2019 21:56:43 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        stable@vger.kernel.org, Ramalingam C <ramalingam.c@intel.com>
Subject: [char-misc-next] mei: hdcp: bind only with i915 on the same PCH
Date:   Thu, 12 Dec 2019 10:41:03 +0200
Message-Id: <20191212084103.2893-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mei device and i915 must reside on the same
PCH in order for HDCP to work. Make the component
matching function enforce this requirement.

                   hdcp
                    |
   i915            mei
    |               |
    +----= PCH =----+

Cc: <stable@vger.kernel.org> v5.0+
Cc: Ramalingam C <ramalingam.c@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hdcp/mei_hdcp.c | 33 +++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
index 93027fd96c71..4c596c646ac0 100644
--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -757,11 +757,38 @@ static const struct component_master_ops mei_component_master_ops = {
 	.unbind = mei_component_master_unbind,
 };
 
+/**
+ * mei_hdcp_component_match - compare function for matching mei hdcp.
+ *
+ *    The function checks if the driver is i915, the subcomponent is HDCP
+ *    and the grand parent of hdcp and the parent of i915 are the same
+ *    PCH device.
+ *
+ * @dev: master device
+ * @subcomponent: subcomponent to match (I915_COMPONENT_HDCP)
+ * @data: compare data (mei hdcp device)
+ *
+ * Return:
+ * * 1 - if components match
+ * * 0 - otherwise
+ */
 static int mei_hdcp_component_match(struct device *dev, int subcomponent,
 				    void *data)
 {
-	return !strcmp(dev->driver->name, "i915") &&
-	       subcomponent == I915_COMPONENT_HDCP;
+	struct device *base = data;
+
+	if (strcmp(dev->driver->name, "i915") ||
+	    subcomponent != I915_COMPONENT_HDCP)
+		return 0;
+
+	base = base->parent;
+	if (!base)
+		return 0;
+
+	base = base->parent;
+	dev = dev->parent;
+
+	return (base && dev && dev == base);
 }
 
 static int mei_hdcp_probe(struct mei_cl_device *cldev,
@@ -785,7 +812,7 @@ static int mei_hdcp_probe(struct mei_cl_device *cldev,
 
 	master_match = NULL;
 	component_match_add_typed(&cldev->dev, &master_match,
-				  mei_hdcp_component_match, comp_master);
+				  mei_hdcp_component_match, &cldev->dev);
 	if (IS_ERR_OR_NULL(master_match)) {
 		ret = -ENOMEM;
 		goto err_exit;
-- 
2.21.0

