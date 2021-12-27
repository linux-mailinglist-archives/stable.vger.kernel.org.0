Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1648002A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbhL0PnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42980 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbhL0PlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7599FB81063;
        Mon, 27 Dec 2021 15:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA4DC36AE7;
        Mon, 27 Dec 2021 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619682;
        bh=k9qRjT4PPLjvZidYW2Nk0Nwn+tBZVx/kfsgZzH8mgQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RENgXMqzC6nn9at+f/LoAKtBvU6K8mX5CbV9DsEEw4qVTdRAnW1gb0EKCaydBqVaA
         vkWKzWl9+Kp183yskA/zRODySh/U/mHVLj5IAet+C2SZ2dRhCCToJnQZS6Fy57NlFm
         LUhlWNjsMPsh1uB929nH0OIJIw6BBRubXinflCFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/128] drm/mediatek: hdmi: Perform NULL pointer check for mtk_hdmi_conf
Date:   Mon, 27 Dec 2021 16:29:50 +0100
Message-Id: <20211227151332.033041957@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 3b8e19a0aa3933a785be9f1541afd8d398c4ec69 ]

In commit 41ca9caaae0b
("drm/mediatek: hdmi: Add check for CEA modes only") a check
for CEA modes was added to function mtk_hdmi_bridge_mode_valid()
in order to address possible issues on MT8167;
moreover, with commit c91026a938c2
("drm/mediatek: hdmi: Add optional limit on maximal HDMI mode clock")
another similar check was introduced.

Unfortunately though, at the time of writing, MT8173 does not provide
any mtk_hdmi_conf structure and this is crashing the kernel with NULL
pointer upon entering mtk_hdmi_bridge_mode_valid(), which happens as
soon as a HDMI cable gets plugged in.

To fix this regression, add a NULL pointer check for hdmi->conf in the
said function, restoring HDMI functionality and avoiding NULL pointer
kernel panics.

Fixes: 41ca9caaae0b ("drm/mediatek: hdmi: Add check for CEA modes only")
Fixes: c91026a938c2 ("drm/mediatek: hdmi: Add optional limit on maximal HDMI mode clock")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 5838c44cbf6f0..3196189429bcf 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1224,12 +1224,14 @@ static int mtk_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
 			return MODE_BAD;
 	}
 
-	if (hdmi->conf->cea_modes_only && !drm_match_cea_mode(mode))
-		return MODE_BAD;
+	if (hdmi->conf) {
+		if (hdmi->conf->cea_modes_only && !drm_match_cea_mode(mode))
+			return MODE_BAD;
 
-	if (hdmi->conf->max_mode_clock &&
-	    mode->clock > hdmi->conf->max_mode_clock)
-		return MODE_CLOCK_HIGH;
+		if (hdmi->conf->max_mode_clock &&
+		    mode->clock > hdmi->conf->max_mode_clock)
+			return MODE_CLOCK_HIGH;
+	}
 
 	if (mode->clock < 27000)
 		return MODE_CLOCK_LOW;
-- 
2.34.1



