Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32CA621542
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiKHOJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbiKHOJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1D6BE16
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AD10B81B00
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D4CC433D6;
        Tue,  8 Nov 2022 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916577;
        bh=kNqyiJI7Rs2LTo1YyIMA/RyKkfRLMdJnZXJhuP7IY1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivyuMhNsjUNEUE1U8Dh+jnl8dHD3C+QbfARDRvFrjI0VXCDBZOjGtWKqXPz0gM5Wf
         nit72yU0zLJ548LbMJfWFaGN7qQF2/PIWKqT8kKxel9CIXGnpbuhBwlqfgNm4AR6L+
         4GUE3DBVtSkNsp7VQMMCODNXIHe/sFMpZOd7h0Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 067/197] media: rkisp1: Use correct macro for gradient registers
Date:   Tue,  8 Nov 2022 14:38:25 +0100
Message-Id: <20221108133357.893325738@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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
index 32485f7c79d5..02ac3043badd 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -343,7 +343,7 @@ static void rkisp1_lsc_config(struct rkisp1_params *params,
 			     RKISP1_CIF_ISP_LSC_XSIZE_01 + i * 4, data);
 
 		/* program x grad tables */
-		data = RKISP1_CIF_ISP_LSC_SECT_SIZE(arg->x_grad_tbl[i * 2],
+		data = RKISP1_CIF_ISP_LSC_SECT_GRAD(arg->x_grad_tbl[i * 2],
 						    arg->x_grad_tbl[i * 2 + 1]);
 		rkisp1_write(params->rkisp1,
 			     RKISP1_CIF_ISP_LSC_XGRAD_01 + i * 4, data);
@@ -355,7 +355,7 @@ static void rkisp1_lsc_config(struct rkisp1_params *params,
 			     RKISP1_CIF_ISP_LSC_YSIZE_01 + i * 4, data);
 
 		/* program y grad tables */
-		data = RKISP1_CIF_ISP_LSC_SECT_SIZE(arg->y_grad_tbl[i * 2],
+		data = RKISP1_CIF_ISP_LSC_SECT_GRAD(arg->y_grad_tbl[i * 2],
 						    arg->y_grad_tbl[i * 2 + 1]);
 		rkisp1_write(params->rkisp1,
 			     RKISP1_CIF_ISP_LSC_YGRAD_01 + i * 4, data);
diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h b/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h
index dd3e6c38be67..025491f8793f 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-regs.h
@@ -576,7 +576,7 @@
 	(((v0) & 0x1FFF) | (((v1) & 0x1FFF) << 13))
 #define RKISP1_CIF_ISP_LSC_SECT_SIZE(v0, v1)      \
 	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 16))
-#define RKISP1_CIF_ISP_LSC_GRAD_SIZE(v0, v1)      \
+#define RKISP1_CIF_ISP_LSC_SECT_GRAD(v0, v1)      \
 	(((v0) & 0xFFF) | (((v1) & 0xFFF) << 16))
 
 /* LSC: ISP_LSC_TABLE_SEL */
-- 
2.35.1



