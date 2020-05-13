Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2E1D0E2D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgEMJyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388102AbgEMJye (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 184DB23127;
        Wed, 13 May 2020 09:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363673;
        bh=+HEWT40WAKTvJiede5y7TrPjk/GLzquagjTyr1OHuQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEvRgAZAWxCV83MTahJdfp2ZivnchdyzvSH+5FJuQld+0z4tRAlargaUyp5xtunoN
         ZWA8OgOeic+2BT8kkhvzSTiqoEoG7DGe9QDZV/4TAULn2Cm+poqurjamvH9gWHec+0
         86u7X6Gdm1Jri4+6Ab+iLFYq1oUT+revcM7ZWS3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Kolesa <daniel@octaforge.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.6 080/118] drm/amd/display: work around fp code being emitted outside of DC_FP_START/END
Date:   Wed, 13 May 2020 11:44:59 +0200
Message-Id: <20200513094424.537172681@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Kolesa <daniel@octaforge.org>

commit 59dfb0c64d3853d20dc84f4561f28d4f5a2ddc7d upstream.

The dcn20_validate_bandwidth function would have code touching the
incorrect registers emitted outside of the boundaries of the
DC_FP_START/END macros, at least on ppc64le. Work around the
problem by wrapping the whole function instead.

Signed-off-by: Daniel Kolesa <daniel@octaforge.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.6.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |   31 +++++++++++++-----
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3034,25 +3034,32 @@ validate_out:
 	return out;
 }
 
-
-bool dcn20_validate_bandwidth(struct dc *dc, struct dc_state *context,
-		bool fast_validate)
+/*
+ * This must be noinline to ensure anything that deals with FP registers
+ * is contained within this call; previously our compiling with hard-float
+ * would result in fp instructions being emitted outside of the boundaries
+ * of the DC_FP_START/END macros, which makes sense as the compiler has no
+ * idea about what is wrapped and what is not
+ *
+ * This is largely just a workaround to avoid breakage introduced with 5.6,
+ * ideally all fp-using code should be moved into its own file, only that
+ * should be compiled with hard-float, and all code exported from there
+ * should be strictly wrapped with DC_FP_START/END
+ */
+static noinline bool dcn20_validate_bandwidth_fp(struct dc *dc,
+		struct dc_state *context, bool fast_validate)
 {
 	bool voltage_supported = false;
 	bool full_pstate_supported = false;
 	bool dummy_pstate_supported = false;
 	double p_state_latency_us;
 
-	DC_FP_START();
 	p_state_latency_us = context->bw_ctx.dml.soc.dram_clock_change_latency_us;
 	context->bw_ctx.dml.soc.disable_dram_clock_change_vactive_support =
 		dc->debug.disable_dram_clock_change_vactive_support;
 
 	if (fast_validate) {
-		voltage_supported = dcn20_validate_bandwidth_internal(dc, context, true);
-
-		DC_FP_END();
-		return voltage_supported;
+		return dcn20_validate_bandwidth_internal(dc, context, true);
 	}
 
 	// Best case, we support full UCLK switch latency
@@ -3081,7 +3088,15 @@ bool dcn20_validate_bandwidth(struct dc
 
 restore_dml_state:
 	context->bw_ctx.dml.soc.dram_clock_change_latency_us = p_state_latency_us;
+	return voltage_supported;
+}
 
+bool dcn20_validate_bandwidth(struct dc *dc, struct dc_state *context,
+		bool fast_validate)
+{
+	bool voltage_supported = false;
+	DC_FP_START();
+	voltage_supported = dcn20_validate_bandwidth_fp(dc, context, fast_validate);
 	DC_FP_END();
 	return voltage_supported;
 }


