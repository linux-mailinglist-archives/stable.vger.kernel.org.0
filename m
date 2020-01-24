Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F024148351
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404801AbgAXLfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404631AbgAXLfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:35:10 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1890B222D9;
        Fri, 24 Jan 2020 11:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865709;
        bh=WuRajSslgg9FwxSUgUQ7vxI+yxTOYwbR9hLen+p2fYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuAPmxxGeFuwFXIyR2BvZ4Wo86aNsfciFHaDkULI1NMJ93YZKCVjhiu/8L0pIcWi/
         gSPPPaUl7bUFB72iPgOk1Ys9Wo/box845l3xIVMqrkjTmDtfWrmbehVDXQn5nLU6dL
         /bVIYFePhkM9JAsMhP/OjM1SooIxHviXOEmFjTY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hai Li <hali@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Sean Paul <sean@poorly.run>, Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 604/639] drm/msm/dsi: Implement reset correctly
Date:   Fri, 24 Jan 2020 10:32:54 +0100
Message-Id: <20200124093205.109249543@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cc4ea5502d6c3..3b78bca0bb4d4 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -34,6 +34,8 @@
 #include "dsi_cfg.h"
 #include "msm_kms.h"
 
+#define DSI_RESET_TOGGLE_DELAY_MS 20
+
 static int dsi_get_version(const void __iomem *base, u32 *major, u32 *minor)
 {
 	u32 ver;
@@ -994,7 +996,7 @@ static void dsi_sw_reset(struct msm_dsi_host *msm_host)
 	wmb(); /* clocks need to be enabled before reset */
 
 	dsi_write(msm_host, REG_DSI_RESET, 1);
-	wmb(); /* make sure reset happen */
+	msleep(DSI_RESET_TOGGLE_DELAY_MS); /* make sure reset happen */
 	dsi_write(msm_host, REG_DSI_RESET, 0);
 }
 
@@ -1402,7 +1404,7 @@ static void dsi_sw_reset_restore(struct msm_dsi_host *msm_host)
 
 	/* dsi controller can only be reset while clocks are running */
 	dsi_write(msm_host, REG_DSI_RESET, 1);
-	wmb();	/* make sure reset happen */
+	msleep(DSI_RESET_TOGGLE_DELAY_MS); /* make sure reset happen */
 	dsi_write(msm_host, REG_DSI_RESET, 0);
 	wmb();	/* controller out of reset */
 	dsi_write(msm_host, REG_DSI_CTRL, data0);
-- 
2.20.1



