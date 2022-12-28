Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EB9658383
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiL1Qs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiL1Qr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E941EAC1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5E4B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6978AC433D2;
        Wed, 28 Dec 2022 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245799;
        bh=STWR08XNfDHGIgwVqoMjIcCEx47HDiY/pzVuziTSxrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rF/7mt+vimmq+qCtV5joNh969fdT4ewWa316R+38IPHB0YZ4+2VvELEJr6CBUTXVp
         ppIpIXvwDUhvFD9CCbBasr6oNMMQn2Qa4n+mIWRn6Y7Y4CD3DHdgUK547Xt6oVjc2V
         vskrBjuXN9Fy/fcMx09tmYpsM9gd/SL5YGbPSIdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0924/1146] mailbox: mpfs: read the system controllers status
Date:   Wed, 28 Dec 2022 15:41:03 +0100
Message-Id: <20221228144355.369333270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit ab47d0bfdf88faac0eb02749e5bfaa306e004300 ]

Some services explicitly return an error code in their response, but
others rely on the system controller to set a status in its status
register. The meaning of the bits varies based on what service is
requested, so pass it back up to the driver that requested the service
in the first place. The field in the message struct already existed, but
was unused until now.

If the system controller is busy, in which case we should never actually
be in the interrupt handler, or if the service fails the mailbox itself
should not be read. Callers should check the status before operating on
the response.

There's an existing, but unused, #define for the mailbox mask - but it
was incorrect. It was doing a GENMASK_ULL(32, 16) which should've just
been a GENMASK(31, 16), so fix that up and start using it.

Fixes: 83d7b1560810 ("mbox: add polarfire soc system controller mailbox")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index cfacb3f320a6..853901acaeec 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -2,7 +2,7 @@
 /*
  * Microchip PolarFire SoC (MPFS) system controller/mailbox controller driver
  *
- * Copyright (c) 2020 Microchip Corporation. All rights reserved.
+ * Copyright (c) 2020-2022 Microchip Corporation. All rights reserved.
  *
  * Author: Conor Dooley <conor.dooley@microchip.com>
  *
@@ -56,7 +56,7 @@
 #define SCB_STATUS_NOTIFY_MASK BIT(SCB_STATUS_NOTIFY)
 
 #define SCB_STATUS_POS (16)
-#define SCB_STATUS_MASK GENMASK_ULL(SCB_STATUS_POS + SCB_MASK_WIDTH, SCB_STATUS_POS)
+#define SCB_STATUS_MASK GENMASK(SCB_STATUS_POS + SCB_MASK_WIDTH - 1, SCB_STATUS_POS)
 
 struct mpfs_mbox {
 	struct mbox_controller controller;
@@ -130,13 +130,38 @@ static void mpfs_mbox_rx_data(struct mbox_chan *chan)
 	struct mpfs_mbox *mbox = (struct mpfs_mbox *)chan->con_priv;
 	struct mpfs_mss_response *response = mbox->response;
 	u16 num_words = ALIGN((response->resp_size), (4)) / 4U;
-	u32 i;
+	u32 i, status;
 
 	if (!response->resp_msg) {
 		dev_err(mbox->dev, "failed to assign memory for response %d\n", -ENOMEM);
 		return;
 	}
 
+	/*
+	 * The status is stored in bits 31:16 of the SERVICES_SR register.
+	 * It is only valid when BUSY == 0.
+	 * We should *never* get an interrupt while the controller is
+	 * still in the busy state. If we do, something has gone badly
+	 * wrong & the content of the mailbox would not be valid.
+	 */
+	if (mpfs_mbox_busy(mbox)) {
+		dev_err(mbox->dev, "got an interrupt but system controller is busy\n");
+		response->resp_status = 0xDEAD;
+		return;
+	}
+
+	status = readl_relaxed(mbox->ctrl_base + SERVICES_SR_OFFSET);
+
+	/*
+	 * If the status of the individual servers is non-zero, the service has
+	 * failed. The contents of the mailbox at this point are not be valid,
+	 * so don't bother reading them. Set the status so that the driver
+	 * implementing the service can handle the result.
+	 */
+	response->resp_status = (status & SCB_STATUS_MASK) >> SCB_STATUS_POS;
+	if (response->resp_status)
+		return;
+
 	if (!mpfs_mbox_busy(mbox)) {
 		for (i = 0; i < num_words; i++) {
 			response->resp_msg[i] =
-- 
2.35.1



