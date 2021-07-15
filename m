Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A003CA9F6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhGOTLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242464AbhGOTIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DEC7613F8;
        Thu, 15 Jul 2021 19:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375864;
        bh=h50X7yqGEaTpjIyoJe/7TnUg0U13htKsKuz+qBmIFpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9UrtYH9tKe1IjjcrIlY5BeCg2MIFVVVwbtD2fcPwIpUjOGVAciflfZW5HFAtWUww
         HjnMYDeBvfztA1URPHcy8n303Pza2m6Es3cd7POJAq6w1snmc9WsrvZw+Hc0X2V/wx
         ssE1Ue3vja05zFPiJWwHKc+bMugQUvAePDZneDig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Syu <Brandon.Syu@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Wayne Lin <waynelin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 004/266] drm/amd/display: fix HDCP reset sequence on reinitialize
Date:   Thu, 15 Jul 2021 20:35:59 +0200
Message-Id: <20210715182614.688433527@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



