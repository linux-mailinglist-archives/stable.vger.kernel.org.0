Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41C1CD541
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbfJFReP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbfJFReP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:34:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC92F2080F;
        Sun,  6 Oct 2019 17:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383254;
        bh=hzSleYMWTRtUF8dgUsifvE5JwF7V349DimY1uSYzY1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IoG70fQkahvoGDVefN6RuaihoF9IgoA87RZowBbf6UfpI+Q46jSRK+StbSBW1Ik7
         2qFMXXkCHsZ5ItnNJug8lCxyiYinXN3EW2eVAfqshBBWIVlR/YSvwA1rcs+21VsVGf
         0mQgpiLaVH6d5vK5K51Ucn+XaduTJFEg86fbQ47k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 035/137] drm/rockchip: Check for fast link training before enabling psr
Date:   Sun,  6 Oct 2019 19:20:19 +0200
Message-Id: <20191006171212.048527159@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

[ Upstream commit ad309284a52be47c8b3126c9376358bf381861bc ]

Once we start shutting off the link during PSR, we're going to want fast
training to work. If the display doesn't support fast training, don't
enable psr.

Changes in v2:
- None
Changes in v3:
- None
Changes in v4:
- None
Changes in v5:
- None

Link to v1: https://patchwork.freedesktop.org/patch/msgid/20190228210939.83386-3-sean@poorly.run
Link to v2: https://patchwork.freedesktop.org/patch/msgid/20190326204509.96515-2-sean@poorly.run
Link to v3: https://patchwork.freedesktop.org/patch/msgid/20190502194956.218441-9-sean@poorly.run
Link to v4: https://patchwork.freedesktop.org/patch/msgid/20190508160920.144739-8-sean@poorly.run

Cc: Zain Wang <wzz@rock-chips.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190611160844.257498-8-sean@poorly.run
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 3666c308c34a6..53676b5fec684 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1036,16 +1036,17 @@ static int analogix_dp_commit(struct analogix_dp_device *dp)
 	if (ret)
 		return ret;
 
+	/* Check whether panel supports fast training */
+	ret = analogix_dp_fast_link_train_detection(dp);
+	if (ret)
+		dp->psr_enable = false;
+
 	if (dp->psr_enable) {
 		ret = analogix_dp_enable_sink_psr(dp);
 		if (ret)
 			return ret;
 	}
 
-	/* Check whether panel supports fast training */
-	ret =  analogix_dp_fast_link_train_detection(dp);
-	if (ret)
-		dp->psr_enable = false;
 
 	return ret;
 }
-- 
2.20.1



