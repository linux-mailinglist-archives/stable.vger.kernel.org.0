Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9EA2127DF4
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfLTOaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbfLTOaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118AD2465E;
        Fri, 20 Dec 2019 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852209;
        bh=JVdsZGegTIK6KkrOyFZrOxGq/flHJ3EyKYQfV2YU9lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGBCpisA2yqL4q1HybnC32mp1BAr7fIn2v/fnOog3NdrphYV4Nw948oGPiExti8r1
         h+KDhrFMZxnucStxuFYq/k8Jp5Ip2GnYjQkiAix8iHehRG2VisVQu0ntE1Nr9fkzk3
         o5c5JqOsCr15LcUuKMERiuypz1iBq16b0taHrRMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikola Cornij <nikola.cornij@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 10/52] drm/amd/display: Reset steer fifo before unblanking the stream
Date:   Fri, 20 Dec 2019 09:29:12 -0500
Message-Id: <20191220142954.9500-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

[ Upstream commit 87de6cb2f28153bc74d0a001ca099c29453e145f ]

[why]
During mode transition steer fifo could overflow. Quite often it
recovers by itself, but sometimes it doesn't.

[how]
Add steer fifo reset before unblanking the stream. Also add a short
delay when resetting dig resync fifo to make sure register writes
don't end up back-to-back, in which case the HW might miss the reset
request.

Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn20/dcn20_stream_encoder.c  | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c
index 5ab9d62404981..e95025b1d14d2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c
@@ -492,15 +492,23 @@ void enc2_stream_encoder_dp_unblank(
 				DP_VID_N_MUL, n_multiply);
 	}
 
-	/* set DIG_START to 0x1 to reset FIFO */
+	/* make sure stream is disabled before resetting steer fifo */
+	REG_UPDATE(DP_VID_STREAM_CNTL, DP_VID_STREAM_ENABLE, false);
+	REG_WAIT(DP_VID_STREAM_CNTL, DP_VID_STREAM_STATUS, 0, 10, 5000);
 
+	/* set DIG_START to 0x1 to reset FIFO */
 	REG_UPDATE(DIG_FE_CNTL, DIG_START, 1);
+	udelay(1);
 
 	/* write 0 to take the FIFO out of reset */
 
 	REG_UPDATE(DIG_FE_CNTL, DIG_START, 0);
 
-	/* switch DP encoder to CRTC data */
+	/* switch DP encoder to CRTC data, but reset it the fifo first. It may happen
+	 * that it overflows during mode transition, and sometimes doesn't recover.
+	 */
+	REG_UPDATE(DP_STEER_FIFO, DP_STEER_FIFO_RESET, 1);
+	udelay(10);
 
 	REG_UPDATE(DP_STEER_FIFO, DP_STEER_FIFO_RESET, 0);
 
-- 
2.20.1

