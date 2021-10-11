Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7074C428FD7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbhJKOBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235542AbhJKN7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DE060EFE;
        Mon, 11 Oct 2021 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960585;
        bh=HwKprU92ORmK6ByOOK1Mtexp9Zc6L+J7ZSkS/7jDKbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sqiz/8IxyIb0WkiLOCIfZgIgFbE5iLUyR4xRdbxnRZliih51weEIEurS2rLM603XQ
         aO3IxyvvezCzWcLChNzAU+AxJiD7/XX5aXU+1KknFobeSYFxrX7ONd30SmE+soYi7F
         SSnGyxvpqCwigYyTyiT5LThkG/3/6lJlxrieynpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <Charlene.Liu@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Hansen <Hansen.Dsouza@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 016/151] drm/amd/display: Fix detection of 4 lane for DPALT
Date:   Mon, 11 Oct 2021 15:44:48 +0200
Message-Id: <20211011134518.379826581@linuxfoundation.org>
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

From: Hansen <Hansen.Dsouza@amd.com>

commit 5a1fef027846e7635b9d320b2cc0b416fd11a3be upstream.

[Why]
DPALT detection for B0 PHY has its own set of RDPCSPIPE registers

[How]
Use RDPCSPIPE registers to detect if DPALT lane is 4 lane

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Hansen <Hansen.Dsouza@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c |   33 +++++++++-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h |    3 
 2 files changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
@@ -63,6 +63,10 @@
 #define AUX_REG_WRITE(reg_name, val) \
 			dm_write_reg(CTX, AUX_REG(reg_name), val)
 
+#ifndef MIN
+#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
+
 void dcn31_link_encoder_set_dio_phy_mux(
 	struct link_encoder *enc,
 	enum encoder_type_select sel,
@@ -217,7 +221,7 @@ static const struct link_encoder_funcs d
 	.get_dig_frontend = dcn10_get_dig_frontend,
 	.get_dig_mode = dcn10_get_dig_mode,
 	.is_in_alt_mode = dcn31_link_encoder_is_in_alt_mode,
-	.get_max_link_cap = dcn20_link_encoder_get_max_link_cap,
+	.get_max_link_cap = dcn31_link_encoder_get_max_link_cap,
 	.set_dio_phy_mux = dcn31_link_encoder_set_dio_phy_mux,
 };
 
@@ -435,3 +439,30 @@ bool dcn31_link_encoder_is_in_alt_mode(s
 
 	return is_usb_c_alt_mode;
 }
+
+void dcn31_link_encoder_get_max_link_cap(struct link_encoder *enc,
+										 struct dc_link_settings *link_settings)
+{
+	struct dcn10_link_encoder *enc10 = TO_DCN10_LINK_ENC(enc);
+	uint32_t is_in_usb_c_dp4_mode = 0;
+
+	dcn10_link_encoder_get_max_link_cap(enc, link_settings);
+
+	/* in usb c dp2 mode, max lane count is 2 */
+	if (enc->funcs->is_in_alt_mode && enc->funcs->is_in_alt_mode(enc)) {
+		if (enc->ctx->asic_id.hw_internal_rev != YELLOW_CARP_B0) {
+			// [Note] no need to check hw_internal_rev once phy mux selection is ready
+			REG_GET(RDPCSTX_PHY_CNTL6, RDPCS_PHY_DPALT_DP4, &is_in_usb_c_dp4_mode);
+		} else {
+			if ((enc10->base.transmitter == TRANSMITTER_UNIPHY_A)
+					|| (enc10->base.transmitter == TRANSMITTER_UNIPHY_B)
+					|| (enc10->base.transmitter == TRANSMITTER_UNIPHY_E)) {
+				REG_GET(RDPCSTX_PHY_CNTL6, RDPCS_PHY_DPALT_DP4, &is_in_usb_c_dp4_mode);
+			} else {
+				REG_GET(RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DP4, &is_in_usb_c_dp4_mode);
+			}
+		}
+		if (!is_in_usb_c_dp4_mode)
+			link_settings->lane_count = MIN(LANE_COUNT_TWO, link_settings->lane_count);
+	}
+}
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.h
@@ -252,4 +252,7 @@ void dcn31_link_encoder_disable_output(
 bool dcn31_link_encoder_is_in_alt_mode(
 	struct link_encoder *enc);
 
+void dcn31_link_encoder_get_max_link_cap(struct link_encoder *enc,
+	struct dc_link_settings *link_settings);
+
 #endif /* __DC_LINK_ENCODER__DCN31_H__ */


