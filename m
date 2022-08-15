Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF685938B6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiHOSwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244328AbiHOSu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C398F4504B;
        Mon, 15 Aug 2022 11:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA6EB81081;
        Mon, 15 Aug 2022 18:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2EEC433D6;
        Mon, 15 Aug 2022 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588136;
        bh=mZW8ED33u+A2FgscfFPXlX5JDkvNzIjQrACfOxCP7HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kc0O2hDRPRuVoHJiW+ZWKyQW+GDP7MJMi0wacoo7UALdDtmjt3i0b6rH2w3PGd/Qn
         nuaGbPHdewF/b/VMHSm0Qt+1+APnSaGlYicp9Lvgy5pfFT4aqYcit9nmsLYGHGdigC
         2oWYJM6U8US+lMsgxekVgoTVFCSoYWCuCd8OGX3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/779] drm/vc4: hdmi: Reset HDMI MISC_CONTROL register
Date:   Mon, 15 Aug 2022 19:59:11 +0200
Message-Id: <20220815180350.417995874@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 35dc00c12a72700a9c4592afee7d136ecb280cbd ]

The HDMI block can repeat pixels for double clocked modes,
and the firmware is now configuring the block to do this as
the PV is doing it incorrectly when at 2pixels/clock.
If the kernel doesn't reset it then we end up with strange
modes.

Reset MISC_CONTROL.

Fixes: 8323989140f3 ("drm/vc4: hdmi: Support the BCM2711 HDMI controllers")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-22-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c      | 8 ++++++++
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 879245808e26..e16fece541da 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -79,6 +79,9 @@
 #define VC5_HDMI_VERTB_VSPO_SHIFT		16
 #define VC5_HDMI_VERTB_VSPO_MASK		VC4_MASK(29, 16)
 
+#define VC5_HDMI_MISC_CONTROL_PIXEL_REP_SHIFT	0
+#define VC5_HDMI_MISC_CONTROL_PIXEL_REP_MASK	VC4_MASK(3, 0)
+
 #define VC5_HDMI_SCRAMBLER_CTL_ENABLE		BIT(0)
 
 #define VC5_HDMI_DEEP_COLOR_CONFIG_1_INIT_PACK_PHASE_SHIFT	8
@@ -849,6 +852,11 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 	reg |= gcp_en ? VC5_HDMI_GCP_CONFIG_GCP_ENABLE : 0;
 	HDMI_WRITE(HDMI_GCP_CONFIG, reg);
 
+	reg = HDMI_READ(HDMI_MISC_CONTROL);
+	reg &= ~VC5_HDMI_MISC_CONTROL_PIXEL_REP_MASK;
+	reg |= VC4_SET_FIELD(0, VC5_HDMI_MISC_CONTROL_PIXEL_REP);
+	HDMI_WRITE(HDMI_MISC_CONTROL, reg);
+
 	HDMI_WRITE(HDMI_CLOCK_STOP, 0);
 }
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi_regs.h b/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
index 19d2fdc446bc..f126fa425a1d 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi_regs.h
@@ -123,6 +123,7 @@ enum vc4_hdmi_field {
 	HDMI_VERTB0,
 	HDMI_VERTB1,
 	HDMI_VID_CTL,
+	HDMI_MISC_CONTROL,
 };
 
 struct vc4_hdmi_register {
@@ -233,6 +234,7 @@ static const struct vc4_hdmi_register __maybe_unused vc5_hdmi_hdmi0_fields[] = {
 	VC4_HDMI_REG(HDMI_VERTB0, 0x0f0),
 	VC4_HDMI_REG(HDMI_VERTA1, 0x0f4),
 	VC4_HDMI_REG(HDMI_VERTB1, 0x0f8),
+	VC4_HDMI_REG(HDMI_MISC_CONTROL, 0x100),
 	VC4_HDMI_REG(HDMI_MAI_CHANNEL_MAP, 0x09c),
 	VC4_HDMI_REG(HDMI_MAI_CONFIG, 0x0a0),
 	VC4_HDMI_REG(HDMI_DEEP_COLOR_CONFIG_1, 0x170),
@@ -313,6 +315,7 @@ static const struct vc4_hdmi_register __maybe_unused vc5_hdmi_hdmi1_fields[] = {
 	VC4_HDMI_REG(HDMI_VERTB0, 0x0f0),
 	VC4_HDMI_REG(HDMI_VERTA1, 0x0f4),
 	VC4_HDMI_REG(HDMI_VERTB1, 0x0f8),
+	VC4_HDMI_REG(HDMI_MISC_CONTROL, 0x100),
 	VC4_HDMI_REG(HDMI_MAI_CHANNEL_MAP, 0x09c),
 	VC4_HDMI_REG(HDMI_MAI_CONFIG, 0x0a0),
 	VC4_HDMI_REG(HDMI_DEEP_COLOR_CONFIG_1, 0x170),
-- 
2.35.1



