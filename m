Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87341594842
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354075AbiHOXnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354324AbiHOXlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E7C2C66D;
        Mon, 15 Aug 2022 13:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F43FB80EAD;
        Mon, 15 Aug 2022 20:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85049C433C1;
        Mon, 15 Aug 2022 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594363;
        bh=d/52b45doYg9s/2ntpneHgZYLVevpz6UYW9ck9AIykk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm2mPEot3N7ZPij+qQfbRZbFFRwTOI12KpD6iup/Zlxqwy4lPrp9LqtfKLJjg6025
         ZoxhzBqSB3IpFesL1ttqDV7AQj6RLBNIguifI6t7by2CgNomZsTp1lxUjZplFZpUYT
         L71fcHxO6FSrm81nostQ7H94dcUfRG6Wtl5835Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0422/1157] drm/vc4: hdmi: Force modeset when bpc or format changes
Date:   Mon, 15 Aug 2022 19:56:18 +0200
Message-Id: <20220815180456.543086316@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit c94cd0620a922156c9ff9af9c3301b174b287677 ]

Whenever the maximum BPC is changed, vc4_hdmi_encoder_compute_config()
might pick up a different BPC or format depending on the display
capabilities.

That change will have a number of side effects, including the clock
rates and whether the scrambling is enabled.

However, only drm_crtc_state.connectors_changed will be set to true,
since that properly only affects the connector.

This means that while drm_atomic_crtc_needs_modeset() will return true,
and thus drm_atomic_helper_commit_modeset_enables() will call our
encoder atomic_enable() hook, mode_changed will be false.

So crtc_set_mode() will not call our encoder .atomic_mode_set() hook. We
use this hook in vc4 to set the vc4_hdmi_connector_state.output_bpc (and
output_format), and will then reuse the value in .atomic_enable() to select
whether or not scrambling should be enabled.

However, since our clock rate is pre-computed during .atomic_check(), we
end up with the clocks properly configured, but the scrambling disabled,
leading to a blank screen.

Let's set mode_changed to true in our HDMI driver to force the update of
output_bpc, and thus prevent the issue entirely.

Fixes: ba8c0faebbb0 ("drm/vc4: hdmi: Enable 10/12 bpc output")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Link: https://lore.kernel.org/r/20220613144800.326124-32-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 674bd29a7cf2..3829e13c8627 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1620,9 +1620,14 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 					 struct drm_crtc_state *crtc_state,
 					 struct drm_connector_state *conn_state)
 {
+	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
+	struct drm_connector *connector = &vc4_hdmi->connector;
+	struct drm_connector_state *old_conn_state =
+		drm_atomic_get_old_connector_state(conn_state->state, connector);
+	struct vc4_hdmi_connector_state *old_vc4_state =
+		conn_state_to_vc4_hdmi_conn_state(old_conn_state);
 	struct vc4_hdmi_connector_state *vc4_state = conn_state_to_vc4_hdmi_conn_state(conn_state);
 	struct drm_display_mode *mode = &crtc_state->adjusted_mode;
-	struct vc4_hdmi *vc4_hdmi = encoder_to_vc4_hdmi(encoder);
 	unsigned long long tmds_char_rate = mode->clock * 1000;
 	unsigned long long tmds_bit_rate;
 	int ret;
@@ -1651,6 +1656,11 @@ static int vc4_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
 	if (ret)
 		return ret;
 
+	/* vc4_hdmi_encoder_compute_config may have changed output_bpc and/or output_format */
+	if (vc4_state->output_bpc != old_vc4_state->output_bpc ||
+	    vc4_state->output_format != old_vc4_state->output_format)
+		crtc_state->mode_changed = true;
+
 	return 0;
 }
 
-- 
2.35.1



