Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8543177D48
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgCCRWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:22:12 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35948 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbgCCRWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 12:22:12 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 023HMBTi113154;
        Tue, 3 Mar 2020 11:22:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583256131;
        bh=SBRUU+j3XyFM6R2K8Qs7x9a1C38P7C+RT5tCbBFb0hI=;
        h=From:To:CC:Subject:Date;
        b=v7cg1KPn7IPdLZAVsY8/27/RR2l/nN/JHJRMrmyrf+EvYnjV8LHzuUAqDypAq5NQ+
         U5M37Me3JuTQ+RqasRWnfiGIJJei/PY1n0I2SrZIT19bIbPQ0afRfGFO3Apd6e4KN/
         oLSJ87u3nPajtUs3837qNK5DNjfYtJDlXqpYWiGs=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 023HMBKj077381
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Mar 2020 11:22:11 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 3 Mar
 2020 11:22:10 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 3 Mar 2020 11:22:10 -0600
Received: from uda0869644b.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 023HMAq0014433;
        Tue, 3 Mar 2020 11:22:10 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
CC:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>,
        <stable@vger.kernel.org>
Subject: [Patch] media: ti-vpe: cal: fix a kernel oops when unloading module
Date:   Tue, 3 Mar 2020 11:26:29 -0600
Message-ID: <20200303172629.21339-1-bparrot@ti.com>
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

Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")

Cc: stable@vger.kernel.org
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/cal.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 6d4cbb8782ed..18fe2cb9dd17 100644
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
@@ -2040,6 +2037,10 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	sensor_node = NULL;
 	ret = -EINVAL;
 
+	asd = kzalloc(sizeof(*asd), GFP_KERNEL);
+	if (!asd)
+		goto cleanup_exit;
+
 	ctx_dbg(3, ctx, "Scanning Port node for csi2 port: %d\n", inst);
 	for (index = 0; index < CAL_NUM_CSI2_PORTS; index++) {
 		port = of_get_next_port(parent, port);
-- 
2.17.1

