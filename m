Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9527938376B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343739AbhEQPnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244798AbhEQPlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48DF461D11;
        Mon, 17 May 2021 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262520;
        bh=GBwKL7ITMQsSdUmtVfW08aHGYf/Z0AEJCVTg6Jg6d1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUOJDH0hTO2rcdL/cfZ8ftVSgsPuTlc+coYZQaP559SBaTDzoxZdmphPnnTfb/XEi
         CmEpM1ODHG+CbQuRA1WPsYVXcukOBmXTDYt1dlcZsA24cW5d76vehRZTXVcjFSbtYl
         oBJYzTDIOkqawJkNk15RJBpXyOr7ed9LQBiBKJ3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Kuogee Hsieh <khsieh@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.11 312/329] drm/msm/dp: check sink_count before update is_connected status
Date:   Mon, 17 May 2021 16:03:43 +0200
Message-Id: <20210517140312.643931968@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

commit d9aa6571b28ba0022de1e48801ff03a1854c7ef2 upstream.

Link status is different from display connected status in the case
of something like an Apple dongle where the type-c plug can be
connected, and therefore the link is connected, but no sink is
connected until an HDMI cable is plugged into the dongle.
The sink_count of DPCD of dongle will increase to 1 once an HDMI
cable is plugged into the dongle so that display connected status
will become true. This checking also apply at pm_resume.

Changes in v4:
-- none

Fixes: 94e58e2d06e3 ("drm/msm/dp: reset dp controller only at boot up and pm_resume")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Link: https://lore.kernel.org/r/1619048258-8717-2-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -595,10 +595,8 @@ static int dp_connect_pending_timeout(st
 	mutex_lock(&dp->event_mutex);
 
 	state = dp->hpd_state;
-	if (state == ST_CONNECT_PENDING) {
-		dp_display_enable(dp, 0);
+	if (state == ST_CONNECT_PENDING)
 		dp->hpd_state = ST_CONNECTED;
-	}
 
 	mutex_unlock(&dp->event_mutex);
 
@@ -677,10 +675,8 @@ static int dp_disconnect_pending_timeout
 	mutex_lock(&dp->event_mutex);
 
 	state =  dp->hpd_state;
-	if (state == ST_DISCONNECT_PENDING) {
-		dp_display_disable(dp, 0);
+	if (state == ST_DISCONNECT_PENDING)
 		dp->hpd_state = ST_DISCONNECTED;
-	}
 
 	mutex_unlock(&dp->event_mutex);
 
@@ -1272,7 +1268,12 @@ static int dp_pm_resume(struct device *d
 
 	status = dp_catalog_link_is_connected(dp->catalog);
 
-	if (status)
+	/*
+	 * can not declared display is connected unless
+	 * HDMI cable is plugged in and sink_count of
+	 * dongle become 1
+	 */
+	if (status && dp->link->sink_count)
 		dp->dp_display.is_connected = true;
 	else
 		dp->dp_display.is_connected = false;


