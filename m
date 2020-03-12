Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D591834ED
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 16:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgCLP0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 11:26:43 -0400
Received: from www.linuxtv.org ([130.149.80.248]:55336 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgCLP0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 11:26:42 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jCPhP-00C8l5-0Q; Thu, 12 Mar 2020 15:24:39 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 12 Mar 2020 15:25:55 +0000
Subject: [git:media_tree/master] media: ti-vpe: cal: fix a kernel oops when unloading module
To:     linuxtv-commits@linuxtv.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Benoit Parrot <bparrot@ti.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jCPhP-00C8l5-0Q@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ti-vpe: cal: fix a kernel oops when unloading module
Author:  Benoit Parrot <bparrot@ti.com>
Date:    Fri Mar 6 14:08:39 2020 +0100

After the switch to use v4l2_async_notifier_add_subdev() and
v4l2_async_notifier_cleanup(), unloading the ti_cal module would cause a
kernel oops.

This was root cause to the fact that v4l2_async_notifier_cleanup() tries
to kfree the asd pointer passed into v4l2_async_notifier_add_subdev().

In our case the asd reference was from a statically allocated struct.
So in effect v4l2_async_notifier_cleanup() was trying to free a pointer
that was not kalloc.

So here we switch to using a kzalloc struct instead of a static one.
To achieve this we re-order some of the calls to prevent asd allocation
from leaking.

Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
Cc: stable@vger.kernel.org
Signed-off-by: Benoit Parrot <bparrot@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/ti-vpe/cal.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

---

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
 
