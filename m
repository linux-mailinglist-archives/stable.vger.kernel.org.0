Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA04B1F3068
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgFIA6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgFHXIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7FD920890;
        Mon,  8 Jun 2020 23:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657723;
        bh=7IiQDXdq9Z5dE9WWdDCDCvrJ4FHOUElT9vMdc58iVhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4Lj95ghCpXTJQqlfuuZHf7dryN6Fo+aQ3BoWQTVM5Dv+ueDnAckKCN1EMlR2uG8l
         ulVrJsFgu0Y8+gbMSc6EpvyVRuK9wPJ0prj3LJuWjl47SedX5yKLQxaRTyzBg0naWU
         ZN/wFuOgq+YxXqA+5pd5RskMRDXnb86qP5eAxNto=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dale Zhao <dale.zhao@amd.com>, Sung Lee <sung.lee@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 116/274] drm/amd/display: Correct updating logic of dcn21's pipe VM flags
Date:   Mon,  8 Jun 2020 19:03:29 -0400
Message-Id: <20200608230607.3361041-116-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dale Zhao <dale.zhao@amd.com>

[ Upstream commit 2a28fe92220a116735ef45939b7edcfee83cc6b0 ]

[Why]:
Renoir's pipe VM flags are not correctly updated if pipe strategy has
changed during some scenarios. It will result in watermarks mistakenly
calculation, thus underflow and garbage appear.

[How]:
Correctly update pipe VM flags to pipes which have been populated.

Signed-off-by: Dale Zhao <dale.zhao@amd.com>
Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index a721bb401ef0..6d1736cf5c12 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1694,12 +1694,8 @@ static int dcn21_populate_dml_pipes_from_context(
 {
 	uint32_t pipe_cnt = dcn20_populate_dml_pipes_from_context(dc, context, pipes);
 	int i;
-	struct resource_context *res_ctx = &context->res_ctx;
 
-	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-
-		if (!res_ctx->pipe_ctx[i].stream)
-			continue;
+	for (i = 0; i < pipe_cnt; i++) {
 
 		pipes[i].pipe.src.hostvm = 1;
 		pipes[i].pipe.src.gpuvm = 1;
-- 
2.25.1

