Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502983A9F4F
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbhFPPhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234697AbhFPPgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8CC26100B;
        Wed, 16 Jun 2021 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857682;
        bh=f80SMjVXuFIG2vJ6MBNISobFfAFhDGaZoem9OetOAbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXJLF4TikciCmyGStcFvvEK/eYgus/8nKaXEnU83KIwrC8EL1G6GO/19mrEZJoi/e
         gJ9FKvPqtnK38CH/7zf9I/9292Fsk7Tp+ZxcbZlv9u6fIEE2OXj73j+fCu/QMVrIZP
         tfBiKeJvxGWnLFLSrG7O3qbkwRt5pt1m/meU/IKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bindu Ramamurthy <bindu.r@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/28] drm/amd/display: Allow bandwidth validation for 0 streams.
Date:   Wed, 16 Jun 2021 17:33:34 +0200
Message-Id: <20210616152834.889132188@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bindu Ramamurthy <bindu.r@amd.com>

[ Upstream commit ba8e59773ae59818695d1e20b8939282da80ec8c ]

[Why]
Bandwidth calculations are triggered for non zero streams, and
in case of 0 streams, these calculations were skipped with
pstate status not being updated.

[How]
As the pstate status is applicable for non zero streams, check
added for allowing 0 streams inline with dcn internal bandwidth
validations.

Signed-off-by: Bindu Ramamurthy <bindu.r@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 08062de3fbeb..2b1175bb2dae 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2917,7 +2917,7 @@ bool dcn20_validate_bandwidth(struct dc *dc, struct dc_state *context,
 	voltage_supported = dcn20_validate_bandwidth_internal(dc, context, false);
 	dummy_pstate_supported = context->bw_ctx.bw.dcn.clk.p_state_change_support;
 
-	if (voltage_supported && dummy_pstate_supported) {
+	if (voltage_supported && (dummy_pstate_supported || !(context->stream_count))) {
 		context->bw_ctx.bw.dcn.clk.p_state_change_support = false;
 		goto restore_dml_state;
 	}
-- 
2.30.2



