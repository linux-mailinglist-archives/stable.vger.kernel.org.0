Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429B114E28A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgA3Sw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730428AbgA3Smi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:42:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41E12082E;
        Thu, 30 Jan 2020 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409758;
        bh=ybi2agjHtsH6PwtVn5gxm6bDkgl8N3lWVMdY04N68ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzKoBIsAc2q503em5oHJGsDWymoyxMHhudFprCmETv0cNII6o4kPoeKF+caGNPOBR
         jJGDpmjvfU8FMBIrHA+JU5fZ88shCOVN5/4K29Qk0cPZntyTaKKCuL+zL7JLEXP37c
         gdQ6MVw/N06ifKtlypFrDZYqe4Dq5hZyWNCerNLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ramalingam C <ramalingam.c@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.4 022/110] mei: hdcp: bind only with i915 on the same PCH
Date:   Thu, 30 Jan 2020 19:37:58 +0100
Message-Id: <20200130183617.618805174@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

commit 1e8d19d9b0dfcf11b61bac627203a290577e807a upstream.

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
 drivers/misc/mei/hdcp/mei_hdcp.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -758,11 +758,38 @@ static const struct component_master_ops
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
@@ -786,7 +813,7 @@ static int mei_hdcp_probe(struct mei_cl_
 
 	master_match = NULL;
 	component_match_add_typed(&cldev->dev, &master_match,
-				  mei_hdcp_component_match, comp_master);
+				  mei_hdcp_component_match, &cldev->dev);
 	if (IS_ERR_OR_NULL(master_match)) {
 		ret = -ENOMEM;
 		goto err_exit;


