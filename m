Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9526148F1
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiKALbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiKALa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:30:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F546568;
        Tue,  1 Nov 2022 04:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A30DEB81CC1;
        Tue,  1 Nov 2022 11:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5269EC433C1;
        Tue,  1 Nov 2022 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302165;
        bh=/fc3IxWnlL9ryUX+Xrm9lW41E1+fW8R8qfEU7/6uRn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcSZq6dSXHqatwBFbCe6NUIYSuetreI0jsxcuUJqd2E04S8Dq+iHWcVwZJcv/hAqo
         WnnkY2ZYbAi0Ms0wQG4MsEQojIwN93cAiDjf55JbL7zml7nP88GoMJX3APcYh89Mzk
         /wTmVNwMxJiZlFLyy9O6rHXo8mrK40Kx8GpVcy+xom6rMvKXZ2nwS28GWnXpdDnHft
         GW2SLvg5629E5XpY2wIECQwFr73dxYxy/rEQddJSYzjCYtgSypF5ER53K6j/4orkiC
         X6hfWfZm6soJhbr+oMx9yx5XQd+o0wtMKRo30/zePVNGZ4XAy+Z4pij7aP6a3lqhpz
         D6tPJCPorq68g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 03/19] media: rkisp1: Use correct macro for gradient registers
Date:   Tue,  1 Nov 2022 07:29:03 -0400
Message-Id: <20221101112919.799868-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 4c3501f13e8e60f6e7e7308c77ac4404e1007c18 ]

The rkisp1_lsc_config() function incorrectly uses the
RKISP1_CIF_ISP_LSC_SECT_SIZE() macro for the gradient registers. Replace
it with the correct macro, and rename it from
RKISP1_CIF_ISP_LSC_GRAD_SIZE() to RKISP1_CIF_ISP_LSC_SECT_GRAD() as the
corresponding registers store the gradients for each sector, not a size.
This doesn't cause any functional change as the two macros are defined
identically (the size and gradient registers store fields in the same
number of bits at the same positions).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-params.c | 4 ++--
 drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
index 8461e88c1288..e0e7d0b4ea04 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -275,7 +275,7 @@ static void rkisp1_lsc_config(struct rkisp1_params *params,
 			     RKISP1_CIF_ISP_LSC_XSIZE_01 + i * 4);
 
 		/* program x grad tables */
-		data = RKISP1_CIF_ISP_LSC_SECT_SIZE(arg->x_grad_tbl[i * 2],
+		data = RKISP1_CIF_ISP_LSC_SECT_GRAD(arg->x_grad_tbl[i * 2],
 						    arg->x_grad_tbl[i * 2 + 1]);
 		rkisp1_write(params->rkisp1, data,
 			     RKISP1_CIF_ISP_LSC_XGRAD_01 + i * 4);
@@ -287,7 +287,7 @@ static void rkisp1_lsc_config(struct rkisp1_params *params,
 			     RKISP1_CIF_ISP_LSC_YSIZE_01 + i * 4);
 
 		/* program y grad tables */
-		data = RKISP1_CIF_ISP_LSC_SECT_SIZE(arg->y_grad_tbl[i * 2],
+		data = RKISP1_CIF_ISP_LSC_SECT_GRAD(arg->y_grad_tbl[i * 2],
 						    arg->y_grad_tbl[i * 2 + 1]);
 		rkisp1_write(params->rkisp1, data,
 			     RKISP1_CIF_ISP_LSC_YGRAD_01 + i * 4);
diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h b/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h
index fa33080f51db..f584ccfe0286 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h
@@ -480,7 +480,7 @@
 	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 12))
 #define RKISP1_CIF_ISP_LSC_SECT_SIZE(v0, v1)      \
 	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 16))
-#define RKISP1_CIF_ISP_LSC_GRAD_SIZE(v0, v1)      \
+#define RKISP1_CIF_ISP_LSC_SECT_GRAD(v0, v1)      \
 	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 16))
 
 /* LSC: ISP_LSC_TABLE_SEL */
-- 
2.35.1

