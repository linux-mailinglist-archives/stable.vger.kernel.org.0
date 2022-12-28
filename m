Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49F6657C35
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiL1PaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiL1PaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:30:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF32515831
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:30:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F1FCB8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A4C433EF;
        Wed, 28 Dec 2022 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241400;
        bh=qmVET0cJx3ScaVnuwOtD91ze65MEzrFc/OULRL/uRNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhZGlGW/eGYyanfEZUBjZGT1Vsgs55egV2CuhDX6FhvNg/ubq/Org5iKjPC/FTml6
         GA3M/rVMmT8id8b2HeLPOTP3SqsnLBJCyRNNbnpJ0TTJyTjEQ/zc3m9cZ8JFbvZjL/
         jnTuOO8Kc2PGzSbE9se8krKeJFdQt8MMnSitfPCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0242/1146] media: i2c: ov5648: Free V4L2 fwnode data on unbind
Date:   Wed, 28 Dec 2022 15:29:41 +0100
Message-Id: <20221228144336.708905059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit c95770e4fc172696dcb1450893cda7d6324d96fc ]

The V4L2 fwnode data structure doesn't get freed on unbind, which leads to
a memleak.

Fixes: e43ccb0a045f ("media: i2c: Add support for the OV5648 image sensor")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5648.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov5648.c b/drivers/media/i2c/ov5648.c
index 84604ea7bdf9..17465fcf28e3 100644
--- a/drivers/media/i2c/ov5648.c
+++ b/drivers/media/i2c/ov5648.c
@@ -2597,6 +2597,7 @@ static void ov5648_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 	mutex_destroy(&sensor->mutex);
 	media_entity_cleanup(&subdev->entity);
+	v4l2_fwnode_endpoint_free(&sensor->endpoint);
 }
 
 static const struct dev_pm_ops ov5648_pm_ops = {
-- 
2.35.1



