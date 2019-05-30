Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F272F4A5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfE3EkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbfE3DMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:35 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D5A23DE3;
        Thu, 30 May 2019 03:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185955;
        bh=BozWObVCFZUojhexPYO13Npvr6qSsLfQWmqS7IskZjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeqMRbeeV2gO2v6vv9sRSUyy5iq/g+aAJFWmUL4saQoVdWWPoMcZ3rAKn1duYoR9t
         lhAyXo4IlUaoXVNJt0Cx+JM0pRDlVrnoH6v48L8egAzg37HwHXM8jEThtZ4Ozv98Wj
         TI/sFfpNO5RU5GN0fz5J874a5OQlFMnrbgRbgnFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 335/405] media: v4l2-fwnode: The first default data lane is 0 on C-PHY
Date:   Wed, 29 May 2019 20:05:33 -0700
Message-Id: <20190530030557.660144630@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fff35d45e16fae125c6000cb87e254cb634ac7fb ]

C-PHY has no clock lanes. Therefore the first data lane is 0 by default.

Fixes: edc6d56c2e7e ("media: v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints")

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 20571846e6367..7495f83231479 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -225,6 +225,10 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	if (bus_type == V4L2_MBUS_CSI2_DPHY ||
 	    bus_type == V4L2_MBUS_CSI2_CPHY || lanes_used ||
 	    have_clk_lane || (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
+		/* Only D-PHY has a clock lane. */
+		unsigned int dfl_data_lane_index =
+			bus_type == V4L2_MBUS_CSI2_DPHY;
+
 		bus->flags = flags;
 		if (bus_type == V4L2_MBUS_UNKNOWN)
 			vep->bus_type = V4L2_MBUS_CSI2_DPHY;
@@ -233,7 +237,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		if (use_default_lane_mapping) {
 			bus->clock_lane = 0;
 			for (i = 0; i < num_data_lanes; i++)
-				bus->data_lanes[i] = 1 + i;
+				bus->data_lanes[i] = dfl_data_lane_index + i;
 		} else {
 			bus->clock_lane = clock_lane;
 			for (i = 0; i < num_data_lanes; i++)
-- 
2.20.1



