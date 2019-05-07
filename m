Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9F15C02
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfEGFgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfEGFgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:36:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D3D20989;
        Tue,  7 May 2019 05:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207396;
        bh=vZ7fddoN+6y18PR0+sMC9+VC7G8zQx2whTfDrhw4ZHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVelqyRnJJGRfVddOkWoohK3WxdPRTWt/nL+byB28+pPb13PddhCOe51dhakmwTSh
         v2lfExPnblu7kiOuJB6ZQngo1TZ/5ah1RZeDBCZ/CaB3qfgg6Hc5ggNE/uAZ0Zc3Bs
         mD1OnCJk78RrF+MvHnalEzGVxSifho8v0rWaTOMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <martin.leung@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 20/81] drm/amd/display: extending AUX SW Timeout
Date:   Tue,  7 May 2019 01:34:51 -0400
Message-Id: <20190507053554.30848-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
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
index 3f5b2e6f7553..df936edac5c7 100644
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

