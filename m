Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBD96AEB5B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjCGRnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjCGRnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:43:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD4B9CFC4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466A1614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAE5C433A4;
        Tue,  7 Mar 2023 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210696;
        bh=6mzyJYt0huHbzupLMh2jwopCQuyIADj9KoOIqpEDMd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzdCzwBzl8It1otaEEMVNJhvcVoixOablwN8SZY5AH9KItnCN3BryxGdHchmnf0xn
         9vcLaVoY1yqatiOdxBOmnsgraQdhcaVbhCIFIaWxud6+JWQHm1zOujZrfTHL9cro7p
         Qim5ndfJtp62tTT3Teh0ADYtsrJamtkPFPuE80fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0594/1001] media: i2c: tc358746: fix possible endianness issue
Date:   Tue,  7 Mar 2023 17:56:06 +0100
Message-Id: <20230307170047.290298207@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 5ad2e46030ad97de7fdbdaf63bb1af45c7caf3dd ]

Using the u64 v4l2_dbg_register.val directly can lead to unexpected
results depending on machine endianness. Fix this by using a local
variable which is assigned afterwards. Since tc358746_read() will init
the val variable to 0 we can assing it without checking the return value
first.

Addresses-Coverity-ID: 1527256 ("Integer handling issues")

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Fixes: 80a21da36051 ("media: tc358746: add Toshiba TC358746 Parallel to CSI-2 bridge driver")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358746.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358746.c b/drivers/media/i2c/tc358746.c
index c5a0df300a06d..4063754a67320 100644
--- a/drivers/media/i2c/tc358746.c
+++ b/drivers/media/i2c/tc358746.c
@@ -988,6 +988,7 @@ static int __maybe_unused
 tc358746_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
 	struct tc358746 *tc358746 = to_tc358746(sd);
+	u32 val;
 	int err;
 
 	/* 32-bit registers starting from CLW_DPHYCONTTX */
@@ -996,7 +997,8 @@ tc358746_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 	if (!pm_runtime_get_if_in_use(sd->dev))
 		return 0;
 
-	err = tc358746_read(tc358746, reg->reg, (u32 *)&reg->val);
+	err = tc358746_read(tc358746, reg->reg, &val);
+	reg->val = val;
 
 	pm_runtime_mark_last_busy(sd->dev);
 	pm_runtime_put_sync_autosuspend(sd->dev);
-- 
2.39.2



