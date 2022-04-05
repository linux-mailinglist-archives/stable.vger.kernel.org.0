Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADB44F3484
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245681AbiDEJMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244793AbiDEIwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400D11EAF6;
        Tue,  5 Apr 2022 01:44:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5FE5B81BC5;
        Tue,  5 Apr 2022 08:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D180C385A1;
        Tue,  5 Apr 2022 08:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148243;
        bh=5a4w0X02E9XeqceD8KGfG2dRL/J743LjSjuw3PThuj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjZCyML79APX6pjzoGZ+PZHut//OIGB5SiwGq1wHOh2uBaiVoi/pAzQdYc6ItQxHt
         +HrB6x4RhtB9OXjm3U2KHT6zXv/l/dNpBqPCCbl4NLWOhbo6wtYTCD+QQQNPbMiTF2
         mK9t8pNTcwJXsR+l0dSkpopZSE6MkhRXmAwiX1GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0286/1017] media: imx: imx8mq-mipi-csi2: remove wrong irq config write operation
Date:   Tue,  5 Apr 2022 09:19:59 +0200
Message-Id: <20220405070402.760885065@linuxfoundation.org>
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

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit 59c2b6d51803ad6b7af28f2a60a843b24374e692 ]

The place where this register writel() that masks one interrupt is placed
does not guarantee that the device is powered so that's not allowed.
Moreover imx8mq_mipi_csi_start_stream() masks the interrupt anyway so the
write is not even needed. Remove it as this is a mistake that slipped in
with the driver.

Fixes: f33fd8d77dd0 ("media: imx: add a driver for i.MX8MQ mipi csi rx phy and controller")
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx8mq-mipi-csi2.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/imx/imx8mq-mipi-csi2.c b/drivers/staging/media/imx/imx8mq-mipi-csi2.c
index 7adbdd14daa9..8f3cc138c52c 100644
--- a/drivers/staging/media/imx/imx8mq-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx8mq-mipi-csi2.c
@@ -398,9 +398,6 @@ static int imx8mq_mipi_csi_s_stream(struct v4l2_subdev *sd, int enable)
 	struct csi_state *state = mipi_sd_to_csi2_state(sd);
 	int ret = 0;
 
-	imx8mq_mipi_csi_write(state, CSI2RX_IRQ_MASK,
-			      CSI2RX_IRQ_MASK_ULPS_STATUS_CHANGE);
-
 	if (enable) {
 		ret = pm_runtime_resume_and_get(state->dev);
 		if (ret < 0)
-- 
2.34.1



