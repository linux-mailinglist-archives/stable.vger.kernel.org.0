Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0124C1D8307
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbgERSBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732394AbgERSBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BB83207C4;
        Mon, 18 May 2020 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824881;
        bh=AeGgUuPFvqd5SZ4TZYIXGV98hXVWJhC1s1Z7n1opW2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP751E7U1gnRxCrYJwHqgNpR1l9CncH6+ZK/TcAWgRec4jq0qccFDAiXbt25jvdp8
         wLdgO8+q82eJuJCA/T0vLEbUVwrueAIcyVrOCgHu6iSe1T+zW9wgTsBSQYmLbIDxfa
         ZMolcCphE42xtce9kHH8XAp1A56ajSSwKTOVJlE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 007/194] drm/i915/display: Load DP_TP_CTL/STATUS offset before use it
Date:   Mon, 18 May 2020 19:34:57 +0200
Message-Id: <20200518173532.216622751@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 12399028751b887bdc2515f1a1e2c81b4fd74085 ]

Right now dp.regs.dp_tp_ctl/status are only set during the encoder
pre_enable() hook, what is causing all reads and writes to those
registers to go to offset 0x0 before pre_enable() is executed.

So if i915 takes the BIOS state and don't do a modeset any following
link retraing will fail.

In the case that i915 needs to do a modeset, the DDI disable sequence
will write to a wrong register not disabling DP 'Transport Enable' in
DP_TP_CTL, making a HDMI modeset in the same port/transcoder to
not light up the monitor.

So here for GENs older than 12, that have those registers fixed at
port offset range it is loading at encoder/port init while for GEN12
it will keep setting it at encoder pre_enable() and during HW state
readout.

Fixes: 4444df6e205b ("drm/i915/tgl: move DP_TP_* to transcoder")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200414230442.262092-1-jose.souza@intel.com
(cherry picked from commit edcb9028d66b44d74ba4f8b9daa379b004dc1f85)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 14 +++++++++++---
 drivers/gpu/drm/i915/display/intel_dp.c  |  5 ++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 2fe594952748d..d3c58026d55e6 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3545,9 +3545,6 @@ static void hsw_ddi_pre_enable_dp(struct intel_encoder *encoder,
 	intel_dp_set_link_params(intel_dp, crtc_state->port_clock,
 				 crtc_state->lane_count, is_mst);
 
-	intel_dp->regs.dp_tp_ctl = DP_TP_CTL(port);
-	intel_dp->regs.dp_tp_status = DP_TP_STATUS(port);
-
 	intel_edp_panel_on(intel_dp);
 
 	intel_ddi_clk_select(encoder, crtc_state);
@@ -4269,12 +4266,18 @@ void intel_ddi_get_config(struct intel_encoder *encoder,
 	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
 	struct intel_crtc *intel_crtc = to_intel_crtc(pipe_config->uapi.crtc);
 	enum transcoder cpu_transcoder = pipe_config->cpu_transcoder;
+	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 	u32 temp, flags = 0;
 
 	/* XXX: DSI transcoder paranoia */
 	if (WARN_ON(transcoder_is_dsi(cpu_transcoder)))
 		return;
 
+	if (INTEL_GEN(dev_priv) >= 12) {
+		intel_dp->regs.dp_tp_ctl = TGL_DP_TP_CTL(cpu_transcoder);
+		intel_dp->regs.dp_tp_status = TGL_DP_TP_STATUS(cpu_transcoder);
+	}
+
 	intel_dsc_get_config(encoder, pipe_config);
 
 	temp = I915_READ(TRANS_DDI_FUNC_CTL(cpu_transcoder));
@@ -4492,6 +4495,7 @@ static const struct drm_encoder_funcs intel_ddi_funcs = {
 static struct intel_connector *
 intel_ddi_init_dp_connector(struct intel_digital_port *intel_dig_port)
 {
+	struct drm_i915_private *dev_priv = to_i915(intel_dig_port->base.base.dev);
 	struct intel_connector *connector;
 	enum port port = intel_dig_port->base.port;
 
@@ -4502,6 +4506,10 @@ intel_ddi_init_dp_connector(struct intel_digital_port *intel_dig_port)
 	intel_dig_port->dp.output_reg = DDI_BUF_CTL(port);
 	intel_dig_port->dp.prepare_link_retrain =
 		intel_ddi_prepare_link_retrain;
+	if (INTEL_GEN(dev_priv) < 12) {
+		intel_dig_port->dp.regs.dp_tp_ctl = DP_TP_CTL(port);
+		intel_dig_port->dp.regs.dp_tp_status = DP_TP_STATUS(port);
+	}
 
 	if (!intel_dp_init_connector(intel_dig_port, connector)) {
 		kfree(connector);
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index c7424e2a04a35..fa3a9e9e0b290 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2492,9 +2492,6 @@ static void intel_dp_prepare(struct intel_encoder *encoder,
 				 intel_crtc_has_type(pipe_config,
 						     INTEL_OUTPUT_DP_MST));
 
-	intel_dp->regs.dp_tp_ctl = DP_TP_CTL(port);
-	intel_dp->regs.dp_tp_status = DP_TP_STATUS(port);
-
 	/*
 	 * There are four kinds of DP registers:
 	 *
@@ -7616,6 +7613,8 @@ bool intel_dp_init(struct drm_i915_private *dev_priv,
 
 	intel_dig_port->dp.output_reg = output_reg;
 	intel_dig_port->max_lanes = 4;
+	intel_dig_port->dp.regs.dp_tp_ctl = DP_TP_CTL(port);
+	intel_dig_port->dp.regs.dp_tp_status = DP_TP_STATUS(port);
 
 	intel_encoder->type = INTEL_OUTPUT_DP;
 	intel_encoder->power_domain = intel_port_to_power_domain(port);
-- 
2.20.1



