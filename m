Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8C4F2CEA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbiDEJMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244788AbiDEIwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BDD1A382;
        Tue,  5 Apr 2022 01:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B52B81A32;
        Tue,  5 Apr 2022 08:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3075FC385A0;
        Tue,  5 Apr 2022 08:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148235;
        bh=DxHVQy1Fc+e0le2fwHX1vbuTw7y/q9K+F6271ZOTKMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWJZURdc1fL9wPImEJcnXfrtzXDnamN6/e6kDru9OrY8GIYsU70CQXwcvadS/VCbY
         5N+1FGbxAaAV1ywxXVZ+rbK4G/TuSPaeYjwWW6rp8aZ1uWXo684JrnLSd7qFzktbor
         yoNWZRJD/sFTAHGLv8lMggZQle0dpZgzBz2VMfSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0283/1017] media: staging: media: imx: imx7-mipi-csis: Make subdev name unique
Date:   Tue,  5 Apr 2022 09:19:56 +0200
Message-Id: <20220405070402.669618359@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 5be7f8c91d25089be847a71b336c13b5bb0db772 ]

When multiple CSIS instances are present in a single graph, they are
currently all named "imx7-mipi-csis.0", which breaks the entity name
uniqueness requirement. Fix it by using the device name to create the
subdev name.

Fixes: 7807063b862b ("media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com> # On i.MX8MP
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 2b73fa55c938..9ea723bb5f20 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -32,7 +32,6 @@
 #include <media/v4l2-subdev.h>
 
 #define CSIS_DRIVER_NAME			"imx7-mipi-csis"
-#define CSIS_SUBDEV_NAME			CSIS_DRIVER_NAME
 
 #define CSIS_PAD_SINK				0
 #define CSIS_PAD_SOURCE				1
@@ -311,7 +310,6 @@ struct csi_state {
 	struct reset_control *mrst;
 	struct regulator *mipi_phy_regulator;
 	const struct mipi_csis_info *info;
-	u8 index;
 
 	struct v4l2_subdev sd;
 	struct media_pad pads[CSIS_PADS_NUM];
@@ -1303,8 +1301,8 @@ static int mipi_csis_subdev_init(struct csi_state *state)
 
 	v4l2_subdev_init(sd, &mipi_csis_subdev_ops);
 	sd->owner = THIS_MODULE;
-	snprintf(sd->name, sizeof(sd->name), "%s.%d",
-		 CSIS_SUBDEV_NAME, state->index);
+	snprintf(sd->name, sizeof(sd->name), "csis-%s",
+		 dev_name(state->dev));
 
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	sd->ctrl_handler = NULL;
-- 
2.34.1



