Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1702217BD89
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCFNEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:04:07 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:54088 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgCFNEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 08:04:06 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 026D45a2076542;
        Fri, 6 Mar 2020 07:04:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583499846;
        bh=YGPGIjMx8NpAqoWqRIFkR0DHWMSpJffHZWteABIBptA=;
        h=From:To:CC:Subject:Date;
        b=zDRTKQ6V1wuFj+2ihF5TjttoKFCukldb45qddFXQctpFOblg/vCf6CWpf9yqOtWI8
         h/Bbd1VDq9byySPBVzCLdSWx9sJ+Fnki177o9d0WBnwJmniyv0tp1KdOGqszUSVAJO
         gn3pSCF0RTtToHGx1jbCjlTBQDaxH/w6HgDNbWfA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 026D454T105721
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 6 Mar 2020 07:04:05 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Mar
 2020 07:04:05 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Mar 2020 07:04:05 -0600
Received: from uda0869644b.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 026D45Ne066327;
        Fri, 6 Mar 2020 07:04:05 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Benoit Parrot <bparrot@ti.com>, <stable@vger.kernel.org>
Subject: [Patch v2] media: ti-vpe: cal: fix a kernel oops when unloading module
Date:   Fri, 6 Mar 2020 07:08:39 -0600
Message-ID: <20200306130839.1209-1-bparrot@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After the switch to use v4l2_async_notifier_add_subdev() and
v4l2_async_notifier_cleanup(), unloading the ti_cal module would casue a
kernel oops.

This was root cause to the fact that v4l2_async_notifier_cleanup() tries
to kfree the asd pointer passed into v4l2_async_notifier_add_subdev().

In our case the asd reference was from a statically allocated struct.
So in effect v4l2_async_notifier_cleanup() was trying to free a pointer
that was not kalloc.

So here we switch to using a kzalloc struct instead of a static one.
To acheive this we re-order some of the calls to prevent asd allocation
from leaking.

Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")

Cc: stable@vger.kernel.org
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
Changes since v1:
- fix asd allocation leak

 drivers/media/platform/ti-vpe/cal.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 6d4cbb8782ed..6c8f3702eac0 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -372,8 +372,6 @@ struct cal_ctx {
 	struct v4l2_subdev	*sensor;
 	struct v4l2_fwnode_endpoint	endpoint;
 
-	struct v4l2_async_subdev asd;
-
 	struct v4l2_fh		fh;
 	struct cal_dev		*dev;
 	struct cc_data		*cc;
@@ -2032,7 +2030,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 
 	parent = pdev->dev.of_node;
 
-	asd = &ctx->asd;
 	endpoint = &ctx->endpoint;
 
 	ep_node = NULL;
@@ -2079,8 +2076,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		ctx_dbg(3, ctx, "can't get remote parent\n");
 		goto cleanup_exit;
 	}
-	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode = of_fwnode_handle(sensor_node);
 
 	v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), endpoint);
 
@@ -2110,9 +2105,17 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 
 	v4l2_async_notifier_init(&ctx->notifier);
 
+	asd = kzalloc(sizeof(*asd), GFP_KERNEL);
+	if (!asd)
+		goto cleanup_exit;
+
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	asd->match.fwnode = of_fwnode_handle(sensor_node);
+
 	ret = v4l2_async_notifier_add_subdev(&ctx->notifier, asd);
 	if (ret) {
 		ctx_err(ctx, "Error adding asd\n");
+		kfree(asd);
 		goto cleanup_exit;
 	}
 
-- 
2.17.1

