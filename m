Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3413EACF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406665AbgAPRq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406659AbgAPRqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:46:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAEE0246D9;
        Thu, 16 Jan 2020 17:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196783;
        bh=TlY7+H+pFZQjyCcJQCbjvS+Mb5wwpsI2xEG8bwG2vNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klPjZohtPJlkbl4UlxBbtHSv18XCf+KW0cL4FoGxp5tvuIC2xOWrx05m2so2d3+4J
         LvqhhsGnSwStO3FbLv9vRgpe/7zSwUkEHZIm1HhIehSI5UIgfxyZOArexnO8DIzmjc
         8I95IpnTmT7LwTWcg87a1EW/FrqiMN3VrZGfbG5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Hai Li <hali@codeaurora.org>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <sean@poorly.run>, Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 148/174] drm/msm/dsi: Implement reset correctly
Date:   Thu, 16 Jan 2020 12:42:25 -0500
Message-Id: <20200116174251.24326-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit 78e31c42261779a01bc73472d0f65f15378e9de3 ]

On msm8998, vblank timeouts are observed because the DSI controller is not
reset properly, which ends up stalling the MDP.  This is because the reset
logic is not correct per the hardware documentation.

The documentation states that after asserting reset, software should wait
some time (no indication of how long), or poll the status register until it
returns 0 before deasserting reset.

wmb() is insufficient for this purpose since it just ensures ordering, not
timing between writes.  Since asserting and deasserting reset occurs on the
same register, ordering is already guaranteed by the architecture, making
the wmb extraneous.

Since we would define a timeout for polling the status register to avoid a
possible infinite loop, lets just use a static delay of 20 ms, since 16.666
ms is the time available to process one frame at 60 fps.

Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
Cc: Hai Li <hali@codeaurora.org>
Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Reviewed-by: Sean Paul <sean@poorly.run>
[seanpaul renamed RESET_DELAY to DSI_RESET_TOGGLE_DELAY_MS]
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191011133939.16551-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 4c49868efcda..12ddbbb53107 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -30,6 +30,8 @@
 #include "dsi.xml.h"
 #include "dsi_cfg.h"
 
+#define DSI_RESET_TOGGLE_DELAY_MS 20
+
 static int dsi_get_version(const void __iomem *base, u32 *major, u32 *minor)
 {
 	u32 ver;
@@ -764,7 +766,7 @@ static void dsi_sw_reset(struct msm_dsi_host *msm_host)
 	wmb(); /* clocks need to be enabled before reset */
 
 	dsi_write(msm_host, REG_DSI_RESET, 1);
-	wmb(); /* make sure reset happen */
+	msleep(DSI_RESET_TOGGLE_DELAY_MS); /* make sure reset happen */
 	dsi_write(msm_host, REG_DSI_RESET, 0);
 }
 
@@ -1111,7 +1113,7 @@ static void dsi_sw_reset_restore(struct msm_dsi_host *msm_host)
 
 	/* dsi controller can only be reset while clocks are running */
 	dsi_write(msm_host, REG_DSI_RESET, 1);
-	wmb();	/* make sure reset happen */
+	msleep(DSI_RESET_TOGGLE_DELAY_MS); /* make sure reset happen */
 	dsi_write(msm_host, REG_DSI_RESET, 0);
 	wmb();	/* controller out of reset */
 	dsi_write(msm_host, REG_DSI_CTRL, data0);
-- 
2.20.1

