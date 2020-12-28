Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08FB2E4220
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437201AbgL1ODo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437160AbgL1ODn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934B020791;
        Mon, 28 Dec 2020 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164183;
        bh=olZj1KjHhUKMN6RTBuDdrUGOGUDZ914utUyJaUpZVhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRA1AFdCqzuR3Z7R5wDX+XeczaNHLbyab7RsmqJ0zHuGgB6ErvsHWmayL6JcKkbnX
         Fraj+ITOQpXxfoBS9tI67LZpWDLoNW3YWxUIFz2idfpj3pqWB/fayX/ZtQ6rSG/PcK
         jsa9PxECuxFtRdnjqfgpKFjTMkQyyfo6+eDGmlnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <abhinavk@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/717] drm/msm/dp: do not notify audio subsystem if sink doesnt support audio
Date:   Mon, 28 Dec 2020 13:41:29 +0100
Message-Id: <20201228125025.336303531@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhinav Kumar <abhinavk@codeaurora.org>

[ Upstream commit e8c765811b1064c200829eacf237ac8c25e79cd0 ]

For sinks that do not support audio, there is no need to notify
audio subsystem of the connection event.

This will make sure that audio routes only to the primary display
when connected to such sinks.

changes in v2:
  - Added fixes tag
  - Removed nested if condition and removed usage of global pointer

Fixes: d13e36d7d222 ("drm/msm/dp: add audio support for Display Port on MSM")
Signed-off-by: Abhinav Kumar <abhinavk@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 8703c63d85c87..fe0279542a1c2 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -563,7 +563,14 @@ static int dp_connect_pending_timeout(struct dp_display_private *dp, u32 data)
 static void dp_display_handle_plugged_change(struct msm_dp *dp_display,
 		bool plugged)
 {
-	if (dp_display->plugged_cb && dp_display->codec_dev)
+	struct dp_display_private *dp;
+
+	dp = container_of(dp_display,
+			struct dp_display_private, dp_display);
+
+	/* notify audio subsystem only if sink supports audio */
+	if (dp_display->plugged_cb && dp_display->codec_dev &&
+			dp->audio_supported)
 		dp_display->plugged_cb(dp_display->codec_dev, plugged);
 }
 
-- 
2.27.0



