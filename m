Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F63D12C80C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbfL2RuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731524AbfL2RuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8CE24656;
        Sun, 29 Dec 2019 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641821;
        bh=93LNHI38Gs19WsUFFgk3wWmM/PpjaHwbpf0hKGhQr+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkp9sRR7tg7g7JI8aSvwkvc2TSx6J5dgJgfsWZJHgJ42rtIE7DJoAGRN9ykSzyJCg
         QDBXldI11s/Q0DGGxssEFqeaoTpzCtdtCc9HlV3qNN79vVLONBnMESDzmqht0pfish
         thbFvrnyfn1Wqmgc3oiTauyRDB445hVVarP1avJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/434] pinctrl: qcom: sc7180: Add missing tile info in SDC_QDSD_PINGROUP/UFS_RESET
Date:   Sun, 29 Dec 2019 18:24:37 +0100
Message-Id: <20191229172716.732458305@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit 81898a44f288607cb3b11a42aed6efb646891c19 ]

The SDC_QDSD_PINGROUP/UFS_RESET macros are missing the .tile info needed to
calculate the right register offsets. Adding them here and also
adjusting the offsets accordingly.

Fixes: f2ae04c45b1a ("pinctrl: qcom: Add SC7180 pinctrl driver")

Reported-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Link: https://lore.kernel.org/r/20191021141507.24066-1-rnayak@codeaurora.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc7180.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc7180.c b/drivers/pinctrl/qcom/pinctrl-sc7180.c
index 6399c8a2bc22..d6cfad7417b1 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc7180.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7180.c
@@ -77,6 +77,7 @@ enum {
 		.intr_cfg_reg = 0,			\
 		.intr_status_reg = 0,			\
 		.intr_target_reg = 0,			\
+		.tile = SOUTH,				\
 		.mux_bit = -1,				\
 		.pull_bit = pull,			\
 		.drv_bit = drv,				\
@@ -102,6 +103,7 @@ enum {
 		.intr_cfg_reg = 0,			\
 		.intr_status_reg = 0,			\
 		.intr_target_reg = 0,			\
+		.tile = SOUTH,				\
 		.mux_bit = -1,				\
 		.pull_bit = 3,				\
 		.drv_bit = 0,				\
@@ -1087,14 +1089,14 @@ static const struct msm_pingroup sc7180_groups[] = {
 	[116] = PINGROUP(116, WEST, qup04, qup04, _, _, _, _, _, _, _),
 	[117] = PINGROUP(117, WEST, dp_hot, _, _, _, _, _, _, _, _),
 	[118] = PINGROUP(118, WEST, _, _, _, _, _, _, _, _, _),
-	[119] = UFS_RESET(ufs_reset, 0x97f000),
-	[120] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x97a000, 15, 0),
-	[121] = SDC_QDSD_PINGROUP(sdc1_clk, 0x97a000, 13, 6),
-	[122] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x97a000, 11, 3),
-	[123] = SDC_QDSD_PINGROUP(sdc1_data, 0x97a000, 9, 0),
-	[124] = SDC_QDSD_PINGROUP(sdc2_clk, 0x97b000, 14, 6),
-	[125] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x97b000, 11, 3),
-	[126] = SDC_QDSD_PINGROUP(sdc2_data, 0x97b000, 9, 0),
+	[119] = UFS_RESET(ufs_reset, 0x7f000),
+	[120] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x7a000, 15, 0),
+	[121] = SDC_QDSD_PINGROUP(sdc1_clk, 0x7a000, 13, 6),
+	[122] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x7a000, 11, 3),
+	[123] = SDC_QDSD_PINGROUP(sdc1_data, 0x7a000, 9, 0),
+	[124] = SDC_QDSD_PINGROUP(sdc2_clk, 0x7b000, 14, 6),
+	[125] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x7b000, 11, 3),
+	[126] = SDC_QDSD_PINGROUP(sdc2_data, 0x7b000, 9, 0),
 };
 
 static const struct msm_pinctrl_soc_data sc7180_pinctrl = {
-- 
2.20.1



