Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EFC3AA007
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhFPPof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235468AbhFPPmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6526D613F0;
        Wed, 16 Jun 2021 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857865;
        bh=TphpqG65VcUpX5OfHGY506kWnLKwdbUh7j08C20Yb7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tH3GulakB3sC2gdXAGfM4stA54JWYPiyCZ3jAeZt6HLH5pUzYo/H1RG6FBYqFXKtP
         MDW3GXfkFIOi4PLeVzZAGAVCy7isu1CcFoThRzPh/yevo4MivmgXsDlgZERRBpS1rk
         Mt4HZ/KiBUoKCnUjtvqdfiXhLt/6J8fov/ItRLQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bindu Ramamurthy <bindu.r@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 40/48] drm/amd/display: Allow bandwidth validation for 0 streams.
Date:   Wed, 16 Jun 2021 17:33:50 +0200
Message-Id: <20210616152837.910135347@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
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
index bfbc23b76cd5..3e3c898848bd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3231,7 +3231,7 @@ static noinline bool dcn20_validate_bandwidth_fp(struct dc *dc,
 	voltage_supported = dcn20_validate_bandwidth_internal(dc, context, false);
 	dummy_pstate_supported = context->bw_ctx.bw.dcn.clk.p_state_change_support;
 
-	if (voltage_supported && dummy_pstate_supported) {
+	if (voltage_supported && (dummy_pstate_supported || !(context->stream_count))) {
 		context->bw_ctx.bw.dcn.clk.p_state_change_support = false;
 		goto restore_dml_state;
 	}
-- 
2.30.2



