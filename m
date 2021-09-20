Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7F641239E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbhITS0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378263AbhITSYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2291A61A86;
        Mon, 20 Sep 2021 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158684;
        bh=3qHHijCYxJm+P+XXOkVa9sKBdREAC2QdlWEg93aqQQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBjgPlKME93p7XsgDbsSTY3AsuH3iQBhaODJ03yFR8Hm0f7pX2nLsQvEPHKcLzWu6
         wW9gqe4LPM1K/Dh+K5TQ4nBvENihouUBZKVwrFC8aa1AE5HnBJhjbxeU30I3f0dJmp
         kcnQa0n40vIe1wd0w3/w2gx2YdE69qESiUriYmsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Robert Foss <robert.foss@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Anibal Limon <anibal.limon@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 001/122] drm/bridge: lt9611: Fix handling of 4k panels
Date:   Mon, 20 Sep 2021 18:42:53 +0200
Message-Id: <20210920163915.808718406@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

commit d1a97648ae028a44536927c87837c45ada7141c9 upstream.

4k requires two dsi pipes, so don't report MODE_OK when only a
single pipe is configured. But rather report MODE_PANEL to
signal that requirements of the panel are not being met.

Reported-by: Peter Collingbourne <pcc@google.com>
Suggested-by: Peter Collingbourne <pcc@google.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Tested-by: Anibal Limon <anibal.limon@linaro.org>
Tested-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201217140933.1133969-1-robert.foss@linaro.org
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -867,8 +867,14 @@ static enum drm_mode_status lt9611_bridg
 						     const struct drm_display_mode *mode)
 {
 	struct lt9611_mode *lt9611_mode = lt9611_find_mode(mode);
+	struct lt9611 *lt9611 = bridge_to_lt9611(bridge);
 
-	return lt9611_mode ? MODE_OK : MODE_BAD;
+	if (!lt9611_mode)
+		return MODE_BAD;
+	else if (lt9611_mode->intfs > 1 && !lt9611->dsi1)
+		return MODE_PANEL;
+	else
+		return MODE_OK;
 }
 
 static void lt9611_bridge_pre_enable(struct drm_bridge *bridge)


