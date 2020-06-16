Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46B11FB951
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgFPPue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbgFPPud (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4368C214DB;
        Tue, 16 Jun 2020 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322632;
        bh=DKyteoJXwF6d2+gaakt8YvFgsdfoCeEc/SzAqfCFfMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAVMXGqWeo7DusYlNGtXxGkpImPrvbfSTMvklP8PhpABCGAx5XSzUnfI2aU/zI25g
         1EkSnLIaE8s696R4ljbqa/ldmtHtWvMzgMtoD2QFr4tA0SIRE3Q4sqYAe1l5AksnyW
         rU76mBdwjd/5cG+J/RJmYs1CWq24b6MLV4KlJoPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joseph Gravenor <joseph.gravenor@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 044/161] drm/amd/display: remove invalid dc_is_hw_initialized function
Date:   Tue, 16 Jun 2020 17:33:54 +0200
Message-Id: <20200616153108.470101996@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Gravenor <joseph.gravenor@amd.com>

[ Upstream commit e2d533eceb1feb0b8b965c3ff11184921532a28e ]

[why/how]
We found out that the register we read actually gets reset by SMU
after we loose power, meaning this always returns true

Signed-off-by: Joseph Gravenor <joseph.gravenor@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 6 ------
 drivers/gpu/drm/amd/display/dc/dc.h      | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 32a07665863f..48e4eb5a37dd 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1362,12 +1362,6 @@ bool dc_commit_state(struct dc *dc, struct dc_state *context)
 	return (result == DC_OK);
 }
 
-bool dc_is_hw_initialized(struct dc *dc)
-{
-	struct dc_bios *dcb = dc->ctx->dc_bios;
-	return dcb->funcs->is_accelerated_mode(dcb);
-}
-
 bool dc_post_update_surfaces_to_stream(struct dc *dc)
 {
 	int i;
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 8ff25b5dd2f6..e8d126890d7e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1075,7 +1075,6 @@ unsigned int dc_get_current_backlight_pwm(struct dc *dc);
 unsigned int dc_get_target_backlight_pwm(struct dc *dc);
 
 bool dc_is_dmcu_initialized(struct dc *dc);
-bool dc_is_hw_initialized(struct dc *dc);
 
 enum dc_status dc_set_clock(struct dc *dc, enum dc_clock_type clock_type, uint32_t clk_khz, uint32_t stepping);
 void dc_get_clock(struct dc *dc, enum dc_clock_type clock_type, struct dc_clock_config *clock_cfg);
-- 
2.25.1



