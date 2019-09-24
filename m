Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5B4BCCD4
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404266AbfIXQmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404209AbfIXQmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C94C20872;
        Tue, 24 Sep 2019 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343340;
        bh=bnDghddhGNrXYMm7y7i94nht+NXgCpKvXxgaNq7ZRAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqdldz9+S4Pkp0DRASjh+0urs3aARz9VTXdxf0nD2jAToPy61XZ8L5EVzDPu9wXtJ
         cYefdpZcQxONHXFYxwTy1est8tDTEBkc4QCghPnAPnxfwh5DyMd8ZpcEyY4pWB0h6m
         VdkgVfKCnt/YNmWyRjAQ3/knHD4tbsCON8tjK0sM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikola Cornij <nikola.cornij@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Chris Park <Chris.Park@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 11/87] drm/amd/display: Clear FEC_READY shadow register if DPCD write fails
Date:   Tue, 24 Sep 2019 12:40:27 -0400
Message-Id: <20190924164144.25591-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit d68a74541735e030dea56f72746cd26d19986f41 ]

[why]
As a fail-safe, in case 'set FEC_READY' DPCD write fails, a HW shadow
register should be cleared and the internal FEC stat should be set to
'not ready'. This is to make sure HW settings will be consistent with
FEC_READY state on the RX.

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Chris Park <Chris.Park@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 2c7aaed907b91..0bf85a7a2cd31 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3033,6 +3033,8 @@ void dp_set_fec_ready(struct dc_link *link, bool ready)
 				link_enc->funcs->fec_set_ready(link_enc, true);
 				link->fec_state = dc_link_fec_ready;
 			} else {
+				link->link_enc->funcs->fec_set_ready(link->link_enc, false);
+				link->fec_state = dc_link_fec_not_ready;
 				dm_error("dpcd write failed to set fec_ready");
 			}
 		} else if (link->fec_state == dc_link_fec_ready && !ready) {
-- 
2.20.1

