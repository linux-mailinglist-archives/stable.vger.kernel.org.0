Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8724C657F6A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiL1QEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiL1QEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2349819028
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2BA960D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C5FC433EF;
        Wed, 28 Dec 2022 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243475;
        bh=oG8p6uHzd9jeLxIpvjJPqGMurUe78KnMd7qmPO7t9wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmfaKZ/WwiaW6CUBDngGfb+XW3U1OyhnWZN77dmc/8Zra+78aX+20izFj9hXi/Ldt
         oVn0QhYRTFYGYtusNEytnKx+K0Iij4KcQ0T5hJuFv1ccU5qeb13IyUtRBZF/3puprQ
         4wQEO98VpchEhnSTWGvpMlOQmCG+R5qrf2K6liS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0533/1073] can: tcan4x5x: Fix use of register error status mask
Date:   Wed, 28 Dec 2022 15:35:21 +0100
Message-Id: <20221228144342.530045124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 67727a17a6b375d68fe569b77e6516b034b834c0 ]

TCAN4X5X_ERROR_STATUS is not a status register that needs clearing
during interrupt handling. Instead this is a masking register that masks
error interrupts. Writing TCAN4X5X_CLEAR_ALL_INT to this register
effectively masks everything.

Rename the register and mask all error interrupts only once by writing
to the register in tcan4x5x_init.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-10-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x-core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index a77f4d4f6299..2342aa011647 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -10,7 +10,7 @@
 #define TCAN4X5X_DEV_ID1 0x04
 #define TCAN4X5X_REV 0x08
 #define TCAN4X5X_STATUS 0x0C
-#define TCAN4X5X_ERROR_STATUS 0x10
+#define TCAN4X5X_ERROR_STATUS_MASK 0x10
 #define TCAN4X5X_CONTROL 0x14
 
 #define TCAN4X5X_CONFIG 0x800
@@ -204,12 +204,7 @@ static int tcan4x5x_clear_interrupts(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
-				      TCAN4X5X_CLEAR_ALL_INT);
-	if (ret)
-		return ret;
-
-	return tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_ERROR_STATUS,
+	return tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_INT_FLAGS,
 				       TCAN4X5X_CLEAR_ALL_INT);
 }
 
@@ -229,6 +224,11 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
+	ret = tcan4x5x_write_tcan_reg(cdev, TCAN4X5X_ERROR_STATUS_MASK,
+				      TCAN4X5X_CLEAR_ALL_INT);
+	if (ret)
+		return ret;
+
 	ret = regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				 TCAN4X5X_MODE_SEL_MASK, TCAN4X5X_MODE_NORMAL);
 	if (ret)
-- 
2.35.1



