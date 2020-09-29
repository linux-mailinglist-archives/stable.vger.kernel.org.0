Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978B027C769
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgI2Lxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731017AbgI2Lqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 684FC208B8;
        Tue, 29 Sep 2020 11:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379984;
        bh=iCMmlg68NCVnUTDoPJQ2F3o7x/tEUQScwr2ioQlr60U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iw2NPOyecVUrzDHQHuxOn2jd2J9jzm4fqHgi6eSm1uK9pDdgEvGrA7GYvD6cTHRwU
         jPtR0exH1lgS3ACvPLSn6Dm5LV0cQjSEBPI++8QOkMSDn8yiLbO7u7N9Yt6R2Awp2Q
         6jxHLUAEaCpsRsCpI9grZ9ItGa9tAeA6SMV7UO78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 16/99] drm/amd/display: Dont log hdcp module warnings in dmesg
Date:   Tue, 29 Sep 2020 13:00:59 +0200
Message-Id: <20200929105930.511055931@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



