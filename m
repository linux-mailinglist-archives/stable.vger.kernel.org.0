Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6B84513A4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348563AbhKOTyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343705AbhKOTVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B3EF635CF;
        Mon, 15 Nov 2021 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001891;
        bh=jZ5j3IIeFKevyECZ9SdkAnJzRNLg/HOwH9NDQyH5Cfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rg0uUOnTo4zZvulstEpQDG0MykcNn5Ubb3Hk/V3bwRmeGtg2+P6xWdT8k8/MpsM5k
         vsKbQ+hymijxGYv0dSR8wDzOxxu4rex5C2AS9ZfVUP88SqPxyJIR4Ny8VUsWeqJZgS
         UfwTA9p44/0tEzpiwZS1UBqmq/DA9CIARTDsXoLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/917] drm: bridge: it66121: Fix return value it66121_probe
Date:   Mon, 15 Nov 2021 17:57:18 +0100
Message-Id: <20211115165440.379690957@linuxfoundation.org>
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

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit f3bc07eba481942a246926c5b934199e7ccd567b ]

Currently it66121_probe returns -EPROBE_DEFER if the there is no remote
endpoint found in the device tree which doesn't seem helpful, since this
is not going to change later and it is never checked if the next bridge
has been initialized yet. It will fail in that case later while doing
drm_bridge_attach for the next bridge in it66121_bridge_attach.

Since the bindings documentation for it66121 bridge driver states
there has to be a remote endpoint defined, its safe to return -EINVAL
in that case.
This additonally adds a check, if the remote endpoint is enabled and
returns -EPROBE_DEFER, if the remote bridge hasn't been initialized
(yet).

Fixes: 988156dc2fc9 ("drm: bridge: add it66121 driver")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210918140420.231346-1-knaerzche@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it66121.c b/drivers/gpu/drm/bridge/ite-it66121.c
index 9dc41a7b91362..06b59b422c696 100644
--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -918,11 +918,23 @@ static int it66121_probe(struct i2c_client *client,
 		return -EINVAL;
 
 	ep = of_graph_get_remote_node(dev->of_node, 1, -1);
-	if (!ep)
-		return -EPROBE_DEFER;
+	if (!ep) {
+		dev_err(ctx->dev, "The endpoint is unconnected\n");
+		return -EINVAL;
+	}
+
+	if (!of_device_is_available(ep)) {
+		of_node_put(ep);
+		dev_err(ctx->dev, "The remote device is disabled\n");
+		return -ENODEV;
+	}
 
 	ctx->next_bridge = of_drm_find_bridge(ep);
 	of_node_put(ep);
+	if (!ctx->next_bridge) {
+		dev_dbg(ctx->dev, "Next bridge not found, deferring probe\n");
+		return -EPROBE_DEFER;
+	}
 
 	if (!ctx->next_bridge)
 		return -EPROBE_DEFER;
-- 
2.33.0



