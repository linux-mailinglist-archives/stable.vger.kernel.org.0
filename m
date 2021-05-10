Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F2E37887E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhEJLVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237136AbhEJLL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 195C1617ED;
        Mon, 10 May 2021 11:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644849;
        bh=0TbRy66sZ4R1vqsd8auMee9yRY592CCfcWWA3/EZ9Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=au1zegmqDY6/R+uGmeCiTpah6mWM9MPzMBLXYlx3TWBnkry0bEPA8aw6iFGGarYR6
         O7ybNLX75UGpuVtiiWk2HecandnsFPk5+Fnpv4i4QncgidkhYc36iCdb32LHikPXN7
         qSG6ePhuoiZD2mdCrCNgTN4EUblTxz5ikIVGrJ5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 249/384] drm/amdgpu/display: fix memory leak for dimgrey cavefish
Date:   Mon, 10 May 2021 12:20:38 +0200
Message-Id: <20210510102023.094120004@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 42b599732ee1d4ac742760050603fb6046789011 ]

We need to clean up the dcn3 clk_mgr.

Acked-by: Nirmoy Das <nirmoy.das@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
index 995ffbbf64e7..1ee27f2f28f1 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
@@ -217,6 +217,9 @@ void dc_destroy_clk_mgr(struct clk_mgr *clk_mgr_base)
 		if (ASICREV_IS_SIENNA_CICHLID_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
 			dcn3_clk_mgr_destroy(clk_mgr);
 		}
+		if (ASICREV_IS_DIMGREY_CAVEFISH_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
+			dcn3_clk_mgr_destroy(clk_mgr);
+		}
 		break;
 
 	case FAMILY_VGH:
-- 
2.30.2



