Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A01131330F0
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgAGU4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgAGU4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C59220880;
        Tue,  7 Jan 2020 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430577;
        bh=ly/rn/Ukf4dQDBwDwrobZPKBf4kNn7H0xXc1rCJuA/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mo/JgtDWwNDE6AVO65cTeAc8k78dVXi/T0edcMAv7/v41KTxf4FsKr12q8wgULZaX
         JfJGn4/cisE0T1VUGM87KpcAJaPgCBBYayQFgSwrY+Vi09nr7KYVF3VIyac2lIhvoJ
         s6tNwb++5eJ7wqB3cgWop0+VzfuOOwbC5/xXFXgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikola Cornij <nikola.cornij@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/191] drm/amd/display: Reset steer fifo before unblanking the stream
Date:   Tue,  7 Jan 2020 21:52:10 +0100
Message-Id: <20200107205333.560146630@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5ab9d6240498..e95025b1d14d 100644
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



