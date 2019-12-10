Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA2C11968F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfLJV1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbfLJVZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE74F206D5;
        Tue, 10 Dec 2019 21:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013119;
        bh=SNku1A80aBY1NpeoUIxNgyT9QiMOSAAxcUYbnDY+Zp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ5qewbLBX5n0akdskl9TScv/rKJeYL4iX40J0jI/zlaZGHI3CB1+OR9TIJyiarmF
         oPxRSBkRgHDoGJX8tv+tmiyfM4ltAgaoyMmC/L3+viUHlYgeLNqVqbnwEh+jVzuWym
         hRwMBToM1xGQBw4+cyX2d5OOHUNcR4Oag/xUpBaE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Zhou <Jing.Zhou@amd.com>, Wenjing Liu <Wenjing.Liu@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 006/292] drm/amd/display: verify stream link before link test
Date:   Tue, 10 Dec 2019 16:20:25 -0500
Message-Id: <20191210212511.11392-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Zhou <Jing.Zhou@amd.com>

[ Upstream commit b131932215c993ea5adf8192d1de2e8d6b23048d ]

[Why]
DP1.2 LL CTS test failure.

[How]
The failure is caused by not verify stream link is equal
to link, only check stream and link is not null.

Signed-off-by: Jing Zhou <Jing.Zhou@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
index a9135764e5806..767de9d6b07a7 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
@@ -312,7 +312,8 @@ void dp_retrain_link_dp_test(struct dc_link *link,
 		if (pipes[i].stream != NULL &&
 			!pipes[i].top_pipe &&
 			pipes[i].stream->link != NULL &&
-			pipes[i].stream_res.stream_enc != NULL) {
+			pipes[i].stream_res.stream_enc != NULL &&
+			pipes[i].stream->link == link) {
 			udelay(100);
 
 			pipes[i].stream_res.stream_enc->funcs->dp_blank(
-- 
2.20.1

