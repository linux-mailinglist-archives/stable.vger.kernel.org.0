Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA02D1C8FC1
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEGOel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgEGO3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB87C20870;
        Thu,  7 May 2020 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861744;
        bh=ouyLlWBbNH0FtRmGq8YsQpE51svtNoNQQcK8Lbax6W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApLcOZ21TZ6IOABX38Bhu7Q+xmbH3E3KyziLom22UbK2uFgfQ7/O9V/oz+/hS3w1R
         /+L2s+sVqPOs9uWoWcwSuf2Ude1R6CTREUSSM8Q/SwDQyUWVRrVTzE7eKqhwGws6x4
         HBC7+ys3TcUW+1t8RRiP8Pebl0zDKrrwckkBIydw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Eric Bernstein <Eric.Bernstein@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 27/35] drm/amd/display: check if REFCLK_CNTL register is present
Date:   Thu,  7 May 2020 10:28:21 -0400
Message-Id: <20200507142830.26239-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 3159d41db3a04330c31ece32f8b29752fc114848 ]

Check before programming the register since it isn't present on
all IPs using this code.

Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Eric Bernstein <Eric.Bernstein@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index e933f6a369f92..083c42e521f5c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2015,7 +2015,8 @@ static void dcn20_fpga_init_hw(struct dc *dc)
 
 	REG_UPDATE(DCHUBBUB_GLOBAL_TIMER_CNTL, DCHUBBUB_GLOBAL_TIMER_REFDIV, 2);
 	REG_UPDATE(DCHUBBUB_GLOBAL_TIMER_CNTL, DCHUBBUB_GLOBAL_TIMER_ENABLE, 1);
-	REG_WRITE(REFCLK_CNTL, 0);
+	if (REG(REFCLK_CNTL))
+		REG_WRITE(REFCLK_CNTL, 0);
 	//
 
 
-- 
2.20.1

