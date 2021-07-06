Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3147A3BD4B7
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbhGFMRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235893AbhGFLac (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B124161DF2;
        Tue,  6 Jul 2021 11:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570530;
        bh=0I6sraG7t8CfgmD4CJhp+GC2kCQuB1+mEYLSPFGqnhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxUit1XTti+l9VJm4q02FtuWggqPxswj/MCBzj08Oz8S0J1F3D9l8xwVa4YKyLgDW
         ih/mOz2QJbK5WkazB9cnxHxDD3X9s+uDbBPJQllrxAFecwJegl3OMhg10/VktoLmHA
         gJ8H5wy/MbQW4+bsBh5oPE941kWz/bbf9fNaHXv+LPHM/yBS+Mal07QOXoZMKsuLA7
         miJ0xkDGChuDUL9cbi/BSwbE+2/n32nJTd18lu6Z6qroIZkWnvJ2eqg0fvkMZNg5vo
         e0QhzjL0CyZxO16cykrkrOP5dIdBP4r8+VJV3Os0x+e+6Q+BIhUtA3KaB0Kh7bAdMx
         vWrNyZ3WRtjdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Syu <Brandon.Syu@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 005/137] drm/amd/display: fix HDCP reset sequence on reinitialize
Date:   Tue,  6 Jul 2021 07:19:51 -0400
Message-Id: <20210706112203.2062605-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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

