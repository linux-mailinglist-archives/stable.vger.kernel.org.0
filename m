Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F27657CB0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiL1PfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiL1PfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAFB164AE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 833AEB81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC35C433D2;
        Wed, 28 Dec 2022 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241703;
        bh=O2UZt/D8iRl4mCvJNm26WOqTGnZ0ZCFMgQY6QpAQZPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tcJydUVC+TPLKipsRWhNC1KJdczueBueKrIKJUmgXZgxcBmI9Mu4XV/oKTZXkMLJ
         w1/YeENhD6IqxjyzJM8gzkLkaobFrfXmjnHw36KNo6I3Y5H54bz++nmS3Db1Gqmo4Q
         rs19rDXJ3W1JxrUkkueGO65AmmjD3/9+dNg0mWSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0267/1146] drm: lcdif: change burst size to 256B
Date:   Wed, 28 Dec 2022 15:30:06 +0100
Message-Id: <20221228144337.386885082@linuxfoundation.org>
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 2215cb3be5c28a1fd43036550c00c2371aeeba95 ]

If a axi bus master with a higher priority do a lot of memory access
FIFO underruns can be inspected. Increase the burst size to 256B to
avoid such underruns and to improve the memory access efficiency.

Fixes: 9db35bb349a0 ("drm: lcdif: Add support for i.MX8MP LCDIF variant")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101164615.778299-1-m.felsch@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/lcdif_kms.c  | 14 ++++++++++++--
 drivers/gpu/drm/mxsfb/lcdif_regs.h |  4 ++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mxsfb/lcdif_kms.c b/drivers/gpu/drm/mxsfb/lcdif_kms.c
index 9f212e29059b..d594938a6c8d 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_kms.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_kms.c
@@ -148,8 +148,18 @@ static void lcdif_set_mode(struct lcdif_drm_private *lcdif, u32 bus_flags)
 	       CTRLDESCL0_1_WIDTH(m->hdisplay),
 	       lcdif->base + LCDC_V8_CTRLDESCL0_1);
 
-	writel(CTRLDESCL0_3_PITCH(lcdif->crtc.primary->state->fb->pitches[0]),
-	       lcdif->base + LCDC_V8_CTRLDESCL0_3);
+	/*
+	 * Undocumented P_SIZE and T_SIZE register but those written in the
+	 * downstream kernel those registers control the AXI burst size. As of
+	 * now there are two known values:
+	 *  1 - 128Byte
+	 *  2 - 256Byte
+	 * Downstream set it to 256B burst size to improve the memory
+	 * efficiency so set it here too.
+	 */
+	ctrl = CTRLDESCL0_3_P_SIZE(2) | CTRLDESCL0_3_T_SIZE(2) |
+	       CTRLDESCL0_3_PITCH(lcdif->crtc.primary->state->fb->pitches[0]);
+	writel(ctrl, lcdif->base + LCDC_V8_CTRLDESCL0_3);
 }
 
 static void lcdif_enable_controller(struct lcdif_drm_private *lcdif)
diff --git a/drivers/gpu/drm/mxsfb/lcdif_regs.h b/drivers/gpu/drm/mxsfb/lcdif_regs.h
index c70220651e3a..8e8bef175bf2 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_regs.h
+++ b/drivers/gpu/drm/mxsfb/lcdif_regs.h
@@ -190,6 +190,10 @@
 #define CTRLDESCL0_1_WIDTH(n)		((n) & 0xffff)
 #define CTRLDESCL0_1_WIDTH_MASK		GENMASK(15, 0)
 
+#define CTRLDESCL0_3_P_SIZE(n)		(((n) << 20) & CTRLDESCL0_3_P_SIZE_MASK)
+#define CTRLDESCL0_3_P_SIZE_MASK	GENMASK(22, 20)
+#define CTRLDESCL0_3_T_SIZE(n)		(((n) << 16) & CTRLDESCL0_3_T_SIZE_MASK)
+#define CTRLDESCL0_3_T_SIZE_MASK	GENMASK(17, 16)
 #define CTRLDESCL0_3_PITCH(n)		((n) & 0xffff)
 #define CTRLDESCL0_3_PITCH_MASK		GENMASK(15, 0)
 
-- 
2.35.1



