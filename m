Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5542E3BCEC5
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhGFL1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234494AbhGFLYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 874F061CEF;
        Tue,  6 Jul 2021 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570314;
        bh=0I6sraG7t8CfgmD4CJhp+GC2kCQuB1+mEYLSPFGqnhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwhr8ai6xUZSz3qGl7wKDfrrBRluCJZbE/Ar4cBba6bhLbeYfMo2wZUupxdl5wDUQ
         L8I2z9CSRNaUWfgtp7FM4euxUeK2u79QJ24gtUmGAJ4HnjJcwG/hUW/LhYCn+qF3Fa
         Ju32vVEkJTgrOcecYT3qlBO8DCoT1e0thD+uh0whX1ub6BCSfAn0Um8QIlAvTT5nCg
         8kZNoOmnyPUXmcjUdYWVumDgUQJJxjpCSknf5Kl6Fn6UPOJJ630SnZz6GcpYd3wR2O
         icP7gAIkWNZQSOMVcMHeZGKkPLUZac/Cto0JMZKCfyiLlPRyP4+5HpR4T8wONZYt4I
         sr2bAYIEDPcnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Syu <Brandon.Syu@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 005/160] drm/amd/display: fix HDCP reset sequence on reinitialize
Date:   Tue,  6 Jul 2021 07:15:51 -0400
Message-Id: <20210706111827.2060499-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 20e554e771d1..fa8aeec304ef 100644
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

