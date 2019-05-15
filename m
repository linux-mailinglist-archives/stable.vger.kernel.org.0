Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B021F02D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfEOL2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732423AbfEOL2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:28:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7AA5206BF;
        Wed, 15 May 2019 11:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919720;
        bh=yp94k15qVYX917pnAhp4n7gKvHuaedyl+IKE7TfqXws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrHVYYeoUbxzh5qjZ4f7D8JfhG6cILh4DslRzfK4Z2+ii9pE+naYT7yTlNuJe16z1
         mnPPsnjC5F7OlyZLWVxSvPUHyeLKNopM0dEhyQEqYmRl36Xl/HZf1p6ixV7KMAToGf
         qcRE9bNsq0PTIeXwIjEwwDjflCzRTvPZohY3SCqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Leung <martin.leung@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 031/137] drm/amd/display: extending AUX SW Timeout
Date:   Wed, 15 May 2019 12:55:12 +0200
Message-Id: <20190515090655.568098205@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index aaeb7faac0c43..e0fff5744b5f6 100644
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
index f7caab85dc801..2c6f50b4245a4 100644
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



