Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAEF136CFF
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 13:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgAJMYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 07:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgAJMYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 07:24:48 -0500
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9122B2077C;
        Fri, 10 Jan 2020 12:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578659088;
        bh=J80SX+o3Kk5A8sv90BkrBdVmpHZwYIHnUOkGnfV3Bwg=;
        h=Subject:To:From:Date:From;
        b=MJ54FqNlbJWFHMQEr5uYQi5/AFGJ0jpbLz3hYWGau3rBgYLxbCAijqcdQuBIsf/Vo
         XfGYCrGm5m+XIb9JAZMDNNzXEV0Gl2a1RpvPDNT5w2QKy03vRAuHHyOgYO/uRqDEn7
         WUfK1pA47q/BjcKB0P1syjTsOUm89KJ5mbMKWTiU=
Subject: patch "mei: hdcp: bind only with i915 on the same PCH" added to char-misc-testing
To:     tomas.winkler@intel.com, alexander.usyskin@intel.com,
        gregkh@linuxfoundation.org, ramalingam.c@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jan 2020 13:20:53 +0100
Message-ID: <157865885369236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: hdcp: bind only with i915 on the same PCH

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1e8d19d9b0dfcf11b61bac627203a290577e807a Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Thu, 12 Dec 2019 10:41:03 +0200
Subject: mei: hdcp: bind only with i915 on the same PCH

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
Link: https://lore.kernel.org/r/20191212084103.2893-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.24.1


