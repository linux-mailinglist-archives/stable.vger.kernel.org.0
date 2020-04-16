Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237B11AC7AD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgDPO6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392517AbgDPNz1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88B12076D;
        Thu, 16 Apr 2020 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045327;
        bh=4gadm28wxegsVG+5goEWoRjI0J2a1ktHlwEXTFjGKEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhUKCaEGo56iHo6z21v5RvOVLKv7epZEMcXqvDbf58Q+SIeMMacs1FogLkMFuHTBZ
         k1DCejnsqwbvVvVwihVQYLw/irUm3wrbaaUKKRiiSrj2I2UzQDJrB1B+jRn0YWmJr0
         s8r10EI8NXl1QkHtRxOL5JH91B3GqhiwKZ5Jb4Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.6 088/254] media: ti-vpe: cal: fix a kernel oops when unloading module
Date:   Thu, 16 Apr 2020 15:22:57 +0200
Message-Id: <20200416131336.928553484@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

commit 80264809ea0a3fd2ee8251f31a9eb85d2c3fc77e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/ti-vpe/cal.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

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
@@ -2032,7 +2030,6 @@ static int of_cal_create_instance(struct
 
 	parent = pdev->dev.of_node;
 
-	asd = &ctx->asd;
 	endpoint = &ctx->endpoint;
 
 	ep_node = NULL;
@@ -2079,8 +2076,6 @@ static int of_cal_create_instance(struct
 		ctx_dbg(3, ctx, "can't get remote parent\n");
 		goto cleanup_exit;
 	}
-	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode = of_fwnode_handle(sensor_node);
 
 	v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), endpoint);
 
@@ -2110,9 +2105,17 @@ static int of_cal_create_instance(struct
 
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
 


