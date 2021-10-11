Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59844428FC4
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbhJKOA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236510AbhJKN7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3BB060EDF;
        Mon, 11 Oct 2021 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960556;
        bh=vSx7KG/TO6aBvUL+kSOq3AuoxXgFnfFQrxhH33luaeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDRYYy20tZANBnprS3IyGGZdHGq3FB0Lv7i8kgSYTeMF709jm2ReFneoWNdyor9Nq
         00a8DedhZUb/2G445Q/tFCMJJ95AGxbKnGbXoipGGzumXNosyv0suCAeoPD6gq2lFH
         iyFj4Hf7NjW+4uszGuBH+87inmu/xbk1N2IJBglo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <charlene.liu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Zhan Liu <Zhan.Liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 010/151] drm/amd/display: Fix B0 USB-C DP Alt mode
Date:   Mon, 11 Oct 2021 15:44:42 +0200
Message-Id: <20211011134518.179090536@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu, Zhan <Zhan.Liu@amd.com>

commit 45d65c0f09aaa6cdd21fe0743f317d4bbdfd1466 upstream.

[Why]
Starting from B0, along with RDPCSTX, RDPCSPIPE registers are also used.

[How]
Make sure RDPCSPIPE registers are programmed correctly.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Zhan Liu <Zhan.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit bdd1a21b52557ea8f61d0a5dc2f77151b576eb70)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.h     |    1 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c |   33 +++++++++-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h |   11 +++
 drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_4_2_0_offset.h |   27 ++++++++
 4 files changed, 70 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_link_encoder.h
@@ -118,6 +118,7 @@ struct dcn10_link_enc_registers {
 	uint32_t RDPCSTX_PHY_CNTL4;
 	uint32_t RDPCSTX_PHY_CNTL5;
 	uint32_t RDPCSTX_PHY_CNTL6;
+	uint32_t RDPCSPIPE_PHY_CNTL6;
 	uint32_t RDPCSTX_PHY_CNTL7;
 	uint32_t RDPCSTX_PHY_CNTL8;
 	uint32_t RDPCSTX_PHY_CNTL9;
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
@@ -37,6 +37,7 @@
 
 #include "link_enc_cfg.h"
 #include "dc_dmub_srv.h"
+#include "dal_asic_id.h"
 
 #define CTX \
 	enc10->base.ctx
@@ -215,7 +216,7 @@ static const struct link_encoder_funcs d
 	.fec_is_active = enc2_fec_is_active,
 	.get_dig_frontend = dcn10_get_dig_frontend,
 	.get_dig_mode = dcn10_get_dig_mode,
-	.is_in_alt_mode = dcn20_link_encoder_is_in_alt_mode,
+	.is_in_alt_mode = dcn31_link_encoder_is_in_alt_mode,
 	.get_max_link_cap = dcn20_link_encoder_get_max_link_cap,
 	.set_dio_phy_mux = dcn31_link_encoder_set_dio_phy_mux,
 };
@@ -404,3 +405,33 @@ void dcn31_link_encoder_disable_output(
 	}
 }
 
+bool dcn31_link_encoder_is_in_alt_mode(struct link_encoder *enc)
+{
+	struct dcn10_link_encoder *enc10 = TO_DCN10_LINK_ENC(enc);
+	uint32_t dp_alt_mode_disable;
+	bool is_usb_c_alt_mode = false;
+
+	if (enc->features.flags.bits.DP_IS_USB_C) {
+		if (enc->ctx->asic_id.hw_internal_rev != YELLOW_CARP_B0) {
+			// [Note] no need to check hw_internal_rev once phy mux selection is ready
+			REG_GET(RDPCSTX_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE, &dp_alt_mode_disable);
+		} else {
+		/*
+		 * B0 phys use a new set of registers to check whether alt mode is disabled.
+		 * if value == 1 alt mode is disabled, otherwise it is enabled.
+		 */
+			if ((enc10->base.transmitter == TRANSMITTER_UNIPHY_A)
+					|| (enc10->base.transmitter == TRANSMITTER_UNIPHY_B)
+					|| (enc10->base.transmitter == TRANSMITTER_UNIPHY_E)) {
+				REG_GET(RDPCSTX_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE, &dp_alt_mode_disable);
+			} else {
+			// [Note] need to change TRANSMITTER_UNIPHY_C/D to F/G once phy mux selection is ready
+				REG_GET(RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE, &dp_alt_mode_disable);
+			}
+		}
+
+		is_usb_c_alt_mode = (dp_alt_mode_disable == 0);
+	}
+
+	return is_usb_c_alt_mode;
+}
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h
@@ -69,6 +69,7 @@
 	SRI(RDPCSTX_PHY_CNTL4, RDPCSTX, id), \
 	SRI(RDPCSTX_PHY_CNTL5, RDPCSTX, id), \
 	SRI(RDPCSTX_PHY_CNTL6, RDPCSTX, id), \
+	SRI(RDPCSPIPE_PHY_CNTL6, RDPCSPIPE, id), \
 	SRI(RDPCSTX_PHY_CNTL7, RDPCSTX, id), \
 	SRI(RDPCSTX_PHY_CNTL8, RDPCSTX, id), \
 	SRI(RDPCSTX_PHY_CNTL9, RDPCSTX, id), \
@@ -115,7 +116,9 @@
 	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL6, RDPCS_PHY_DP_TX2_MPLL_EN, mask_sh),\
 	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL6, RDPCS_PHY_DP_TX3_MPLL_EN, mask_sh),\
 	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL6, RDPCS_PHY_DPALT_DP4, mask_sh),\
-	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE, mask_sh),\
+	LE_SF(RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DP4, mask_sh),\
+	LE_SF(RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE, mask_sh),\
+	LE_SF(RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE_ACK, mask_sh),\
 	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL7, RDPCS_PHY_DP_MPLLB_FRACN_QUOT, mask_sh),\
 	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL7, RDPCS_PHY_DP_MPLLB_FRACN_DEN, mask_sh),\
 	LE_SF(RDPCSTX0_RDPCSTX_PHY_CNTL8, RDPCS_PHY_DP_MPLLB_SSC_PEAK, mask_sh),\
@@ -243,4 +246,10 @@ void dcn31_link_encoder_disable_output(
 	struct link_encoder *enc,
 	enum signal_type signal);
 
+/*
+ * Check whether USB-C DP Alt mode is disabled
+ */
+bool dcn31_link_encoder_is_in_alt_mode(
+	struct link_encoder *enc);
+
 #endif /* __DC_LINK_ENCODER__DCN31_H__ */
--- a/drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_4_2_0_offset.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/dpcs/dpcs_4_2_0_offset.h
@@ -11932,5 +11932,32 @@
 #define ixDPCSSYS_CR4_RAWLANEX_DIG_PCS_XF_RX_OVRD_OUT_2                                                0xe0c7
 #define ixDPCSSYS_CR4_RAWLANEX_DIG_PCS_XF_TX_OVRD_IN_2                                                 0xe0c8
 
+//RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6
+#define RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DP4__SHIFT                                            0x10
+#define RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE__SHIFT                                        0x11
+#define RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE_ACK__SHIFT                                    0x12
+#define RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DP4_MASK                                              0x00010000L
+#define RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE_MASK                                          0x00020000L
+#define RDPCSPIPE0_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE_ACK_MASK                                      0x00040000L
+
+//RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6
+#define RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DP4__SHIFT                                            0x10
+#define RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE__SHIFT                                        0x11
+#define RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE_ACK__SHIFT                                    0x12
+#define RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DP4_MASK                                              0x00010000L
+#define RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE_MASK                                          0x00020000L
+#define RDPCSPIPE1_RDPCSPIPE_PHY_CNTL6__RDPCS_PHY_DPALT_DISABLE_ACK_MASK                                      0x00040000L
+
+//[Note] Hack. RDPCSPIPE only has 2 instances.
+#define regRDPCSPIPE0_RDPCSPIPE_PHY_CNTL6                                                              0x2d73
+#define regRDPCSPIPE0_RDPCSPIPE_PHY_CNTL6_BASE_IDX                                                     2
+#define regRDPCSPIPE1_RDPCSPIPE_PHY_CNTL6                                                              0x2e4b
+#define regRDPCSPIPE1_RDPCSPIPE_PHY_CNTL6_BASE_IDX                                                     2
+#define regRDPCSPIPE2_RDPCSPIPE_PHY_CNTL6                                                              0x2d73
+#define regRDPCSPIPE2_RDPCSPIPE_PHY_CNTL6_BASE_IDX                                                     2
+#define regRDPCSPIPE3_RDPCSPIPE_PHY_CNTL6                                                              0x2e4b
+#define regRDPCSPIPE3_RDPCSPIPE_PHY_CNTL6_BASE_IDX                                                     2
+#define regRDPCSPIPE4_RDPCSPIPE_PHY_CNTL6                                                              0x2d73
+#define regRDPCSPIPE4_RDPCSPIPE_PHY_CNTL6_BASE_IDX                                                     2
 
 #endif


