Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9D45138A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348393AbhKOTwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343634AbhKOTVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 023F4635C5;
        Mon, 15 Nov 2021 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001807;
        bh=RT4c1amvKbIveG1AjmPg6G5GHIIEYCHdQS57BgVmXgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsul6lSnggybkYcfiDkziRcDtEcyU1LHYFr7onPZHpVyxruqqhrdmvEC6K/zfGj5B
         ZncCnTaZ2AIZt3ZZwMoMJt4Ux5JqewcUjFzDR09OL06IeQBHqTesZSh3biOAVLTGhg
         BO0caHDMHUjaQrvZ70iF5/0Ng+YJZN5TKfY7H2oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/917] drm/bridge: it66121: Wait for next bridge to be probed
Date:   Mon, 15 Nov 2021 17:57:03 +0100
Message-Id: <20211115165439.882262591@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 8b03e3fc79189b17d31a82f5e175698802a11e87 ]

If run before the next bridge is initialized, of_drm_find_bridge() will
give us a NULL pointer.

If that's the case, return -EPROBE_DEFER; we may have more luck next
time.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Fixes: 988156dc2fc9 ("drm: bridge: add it66121 driver")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210827163956.27517-2-paul@crapouillou.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index b130d01147c6c..9dc41a7b91362 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -924,6 +924,9 @@ static int it66121_probe(struct i2c_client *client,
 	ctx->next_bridge = of_drm_find_bridge(ep);
 	of_node_put(ep);
 
+	if (!ctx->next_bridge)
+		return -EPROBE_DEFER;
+
 	i2c_set_clientdata(client, ctx);
 	mutex_init(&ctx->lock);
 
-- 
2.33.0



