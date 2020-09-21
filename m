Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616C427286D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgIUOnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgIUOkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5DF3221EC;
        Mon, 21 Sep 2020 14:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699248;
        bh=iCMmlg68NCVnUTDoPJQ2F3o7x/tEUQScwr2ioQlr60U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lnBbpQmhPKQJv1ktrw2p5aX3nc0anvr2XsSZECUs0PasrlZa05IXVtHQIXd1wWqD
         s6Mp9WYKCS7JanSCzGSsrZXgsaoO30UcTIYMhYwauE+IneT/imEV5qoXBEBe7Z8kFS
         2+Og412dlryBcE9Gwtax3VP8RS8iyW27fJpsIJQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 16/20] drm/amd/display: Don't log hdcp module warnings in dmesg
Date:   Mon, 21 Sep 2020 10:40:23 -0400
Message-Id: <20200921144027.2135390-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

[ Upstream commit 875d369d8f75275d30e59421602d9366426abff7 ]

[Why]
DTM topology updates happens by default now. This results in DTM
warnings when hdcp is not even being enabled. This spams the dmesg
and doesn't effect normal display functionality so it is better to log it
using DRM_DEBUG_KMS()

[How]
Change the DRM_WARN() to DRM_DEBUG_KMS()

Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_log.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_log.h b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_log.h
index d3192b9d0c3d8..47f8ee2832ff0 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_log.h
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_log.h
@@ -27,7 +27,7 @@
 #define MOD_HDCP_LOG_H_
 
 #ifdef CONFIG_DRM_AMD_DC_HDCP
-#define HDCP_LOG_ERR(hdcp, ...) DRM_WARN(__VA_ARGS__)
+#define HDCP_LOG_ERR(hdcp, ...) DRM_DEBUG_KMS(__VA_ARGS__)
 #define HDCP_LOG_VER(hdcp, ...) DRM_DEBUG_KMS(__VA_ARGS__)
 #define HDCP_LOG_FSM(hdcp, ...) DRM_DEBUG_KMS(__VA_ARGS__)
 #define HDCP_LOG_TOP(hdcp, ...) pr_debug("[HDCP_TOP]:"__VA_ARGS__)
-- 
2.25.1

