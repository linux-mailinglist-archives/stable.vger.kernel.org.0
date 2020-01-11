Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85313137BD5
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 07:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgAKGQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 01:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgAKGQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 01:16:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C1D2072E;
        Sat, 11 Jan 2020 06:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578723382;
        bh=xuIt3pI9UIJTtODfYx1SXNJ89/uHyqpJYVWiOpmlbag=;
        h=Subject:To:From:Date:From;
        b=c8juVxPDeXU4aeTtzk9jqzc8J3DSMNJhNLCew8W7FOLClkWrlFzYTdjws5Pz+vwro
         VF/C2BY9U80wKa/VfTdyNlxtR/Ij0c9jktH0NTPA4t+1o4QZKupI8fmI+T/zFeBik4
         GOnA4eK5sj8GjZP4WGSoX7XoZ9GpKQczUO5q6EGs=
Subject: patch "mei: hdcp: bind only with i915 on the same PCH" added to char-misc-next
To:     tomas.winkler@intel.com, alexander.usyskin@intel.com,
        gregkh@linuxfoundation.org, ramalingam.c@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 11 Jan 2020 07:16:17 +0100
Message-ID: <157872337720848@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


