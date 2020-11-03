Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750F2A56F2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbgKCVcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732109AbgKCU5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EC5B22226;
        Tue,  3 Nov 2020 20:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437037;
        bh=L8ZuELjMeM0ZMowK9r/ZBhw2Y6O/DsmCbS5s3XpXKqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P77tFukUqfiM3BbaPco3gVz7noKCPn5rSfX/8oio/EvhqYhpRP8DrLnMHjUhZ5/HM
         fpyBbViwsH1ildTDGzr4ksfPpxH13ZtSiJnAZRH67MBhjoW84M/4l32aXa8HYjljPY
         syBilEiI8m1I7K1e/tsfqLFJnq0hLsr1t1/KZnKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>, Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/214] drm/amd/display: HDMI remote sink need mode validation for Linux
Date:   Tue,  3 Nov 2020 21:35:19 +0100
Message-Id: <20201103203257.058919226@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 95d620adb48f7728e67d82f56f756e8d451cf8d2 ]

[Why]
Currently mode validation is bypassed if remote sink exists. That
leads to mode set issue when a BW bottle neck exists in the link path,
e.g., a DP-to-HDMI converter that only supports HDMI 1.4.

Any invalid mode passed to Linux user space will cause the modeset
failure due to limitation of Linux user space implementation.

[How]
Mode validation is skipped only if in edid override. For real remote
sink, clock limit check should be done for HDMI remote sink.

Have HDMI related remote sink going through mode validation to
elimiate modes which pixel clock exceeds BW limitation.

Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 3efee7b3378a3..47cefc05fd3f5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2268,7 +2268,7 @@ enum dc_status dc_link_validate_mode_timing(
 	/* A hack to avoid failing any modes for EDID override feature on
 	 * topology change such as lower quality cable for DP or different dongle
 	 */
-	if (link->remote_sinks[0])
+	if (link->remote_sinks[0] && link->remote_sinks[0]->sink_signal == SIGNAL_TYPE_VIRTUAL)
 		return DC_OK;
 
 	/* Passive Dongle */
-- 
2.27.0



