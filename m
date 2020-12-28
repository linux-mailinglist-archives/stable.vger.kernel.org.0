Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EAA2E3C9E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437483AbgL1OEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437476AbgL1OEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E63120715;
        Mon, 28 Dec 2020 14:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164273;
        bh=28XR6IU3/toudgJLvlMgbXSYNFv/xV0vBVnS+6rUYzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eg4sWf7j21GPQbweDSiwng6eqssMf8V7Mdc4XZfdssq4QCGMGkFwYCFNORjfS5zhc
         MYBwyTegxaywddnUE24hrnFFbCH6gTmG1exJ1+UU0b11yJNTdyjhvmZnvfm1lnFVrU
         nfo79M3T1VRIBdU9P1jFS9e1ePDc9Oh2c8o1GzCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/717] media: v4l2-fwnode: Return -EINVAL for invalid bus-type
Date:   Mon, 28 Dec 2020 13:42:01 +0100
Message-Id: <20201228125026.849035356@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 69baf338fc16a4d55c78da8874ce3f06feb38c78 ]

Return -EINVAL if invalid bus-type is detected while parsing endpoints.

Fixes: 26c1126c9b56 ("media: v4l: fwnode: Use media bus type for bus parser selection")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 6 +++++-
 include/media/v4l2-mediabus.h         | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d7bbe33840cb4..dfc53d11053fc 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -93,7 +93,7 @@ v4l2_fwnode_bus_type_to_mbus(enum v4l2_fwnode_bus_type type)
 	const struct v4l2_fwnode_bus_conv *conv =
 		get_v4l2_fwnode_bus_conv_by_fwnode_bus(type);
 
-	return conv ? conv->mbus_type : V4L2_MBUS_UNKNOWN;
+	return conv ? conv->mbus_type : V4L2_MBUS_INVALID;
 }
 
 static const char *
@@ -436,6 +436,10 @@ static int __v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
 		 v4l2_fwnode_mbus_type_to_string(vep->bus_type),
 		 vep->bus_type);
 	mbus_type = v4l2_fwnode_bus_type_to_mbus(bus_type);
+	if (mbus_type == V4L2_MBUS_INVALID) {
+		pr_debug("unsupported bus type %u\n", bus_type);
+		return -EINVAL;
+	}
 
 	if (vep->bus_type != V4L2_MBUS_UNKNOWN) {
 		if (mbus_type != V4L2_MBUS_UNKNOWN &&
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 59b1de1971142..c20e2dc6d4320 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -103,6 +103,7 @@
  * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
  * @V4L2_MBUS_CSI2_DPHY: MIPI CSI-2 serial interface, with D-PHY
  * @V4L2_MBUS_CSI2_CPHY: MIPI CSI-2 serial interface, with C-PHY
+ * @V4L2_MBUS_INVALID:	invalid bus type (keep as last)
  */
 enum v4l2_mbus_type {
 	V4L2_MBUS_UNKNOWN,
@@ -112,6 +113,7 @@ enum v4l2_mbus_type {
 	V4L2_MBUS_CCP2,
 	V4L2_MBUS_CSI2_DPHY,
 	V4L2_MBUS_CSI2_CPHY,
+	V4L2_MBUS_INVALID,
 };
 
 /**
-- 
2.27.0



