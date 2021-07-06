Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85FD3BCB7A
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhGFLQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231882AbhGFLQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 428EF61C22;
        Tue,  6 Jul 2021 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570057;
        bh=h50X7yqGEaTpjIyoJe/7TnUg0U13htKsKuz+qBmIFpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON95brRS3O4EAnbRMCfYK5Vl/SAy7HpLGPyMjd6LIIeg2pAjXsNI/bpFlV1+pNlNb
         OfeS2yT3MjDFVu0IPLWWad1h24J8f1sFU9oSHLymYp3OsK6G12KcqphK54Tjt7v+eJ
         p4bEoWyc4Dg30Sz1sO1TXgvtVUI1C4jJTDVgMc0NggmRqnlrB56XLR0nba6H9upEcb
         xTk8lCyEL0rj+UrbLifZSIL2vK8K3mdWGywF065wKvpviqtaqacoSN9iAGqvW+L7+A
         vRW68YxYljlSfU5J4uEpClhc+X/Qwh1SH+aJAkr9ny7KuagVf8xDqVcP7AAzUz5mU0
         iNCh8MjC8TfjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Syu <Brandon.Syu@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 005/189] drm/amd/display: fix HDCP reset sequence on reinitialize
Date:   Tue,  6 Jul 2021 07:11:05 -0400
Message-Id: <20210706111409.2058071-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Syu <Brandon.Syu@amd.com>

[ Upstream commit 99c248c41c2199bd34232ce8e729d18c4b343b64 ]

[why]
When setup is called after hdcp has already setup,
it would cause to disable HDCP flow won’t execute.

[how]
Don't clean up hdcp content to be 0.

Signed-off-by: Brandon Syu <Brandon.Syu@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Wayne Lin <waynelin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
index 68a6481d7f8f..b963226e8af4 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
@@ -260,7 +260,6 @@ enum mod_hdcp_status mod_hdcp_setup(struct mod_hdcp *hdcp,
 	struct mod_hdcp_output output;
 	enum mod_hdcp_status status = MOD_HDCP_STATUS_SUCCESS;
 
-	memset(hdcp, 0, sizeof(struct mod_hdcp));
 	memset(&output, 0, sizeof(output));
 	hdcp->config = *config;
 	HDCP_TOP_INTERFACE_TRACE(hdcp);
-- 
2.30.2

