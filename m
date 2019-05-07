Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69DD1590E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfEGFdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfEGFdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8B2206A3;
        Tue,  7 May 2019 05:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207202;
        bh=ELeThrmNFHcLWssUk4KzYslzDNaYvFVj1cK3oWt+ibU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuaY+Jucz6170Lb6ZSeSXRfhDC+dgBKPz0DrS+5AxvkeCLQNvZu3X8Tt6Cm9b711C
         uwt04DAUqICRZ9D8o3Bn/9uR3Zl0OFngNsKisanInliEgs/oWawH7vbHLlh96sMM7W
         jh4uLfr3EzNnM17o3p/jIAMickrHbiQmYgZ0WCp0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <martin.leung@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 23/99] drm/amd/display: extending AUX SW Timeout
Date:   Tue,  7 May 2019 01:31:17 -0400
Message-Id: <20190507053235.29900-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <martin.leung@amd.com>

[ Upstream commit f4bbebf8e7eb4d294b040ab2d2ba71e70e69b930 ]

[Why]
AUX takes longer to reply when using active DP-DVI dongle on some asics
resulting in up to 2000+ us edid read (timeout).

[How]
1. Adjust AUX poll to match spec
2. Extend the SW timeout. This does not affect normal
operation since we exit the loop as soon as AUX acks.

Signed-off-by: Martin Leung <martin.leung@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c | 9 ++++++---
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h | 6 +++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
index aaeb7faac0c4..e0fff5744b5f 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.c
@@ -189,6 +189,12 @@ static void submit_channel_request(
 				1,
 				0);
 	}
+
+	REG_UPDATE(AUX_INTERRUPT_CONTROL, AUX_SW_DONE_ACK, 1);
+
+	REG_WAIT(AUX_SW_STATUS, AUX_SW_DONE, 0,
+				10, aux110->timeout_period/10);
+
 	/* set the delay and the number of bytes to write */
 
 	/* The length include
@@ -241,9 +247,6 @@ static void submit_channel_request(
 		}
 	}
 
-	REG_UPDATE(AUX_INTERRUPT_CONTROL, AUX_SW_DONE_ACK, 1);
-	REG_WAIT(AUX_SW_STATUS, AUX_SW_DONE, 0,
-				10, aux110->timeout_period/10);
 	REG_UPDATE(AUX_SW_CONTROL, AUX_SW_GO, 1);
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h
index f7caab85dc80..2c6f50b4245a 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_aux.h
@@ -69,11 +69,11 @@ enum {	/* This is the timeout as defined in DP 1.2a,
 	 * at most within ~240usec. That means,
 	 * increasing this timeout will not affect normal operation,
 	 * and we'll timeout after
-	 * SW_AUX_TIMEOUT_PERIOD_MULTIPLIER * AUX_TIMEOUT_PERIOD = 1600usec.
+	 * SW_AUX_TIMEOUT_PERIOD_MULTIPLIER * AUX_TIMEOUT_PERIOD = 2400usec.
 	 * This timeout is especially important for
-	 * resume from S3 and CTS.
+	 * converters, resume from S3, and CTS.
 	 */
-	SW_AUX_TIMEOUT_PERIOD_MULTIPLIER = 4
+	SW_AUX_TIMEOUT_PERIOD_MULTIPLIER = 6
 };
 struct aux_engine_dce110 {
 	struct aux_engine base;
-- 
2.20.1

