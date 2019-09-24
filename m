Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4BEBCE1D
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410193AbfIXQtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbfIXQtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D6621D6C;
        Tue, 24 Sep 2019 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343739;
        bh=qqZxm8KNU3bkkqJKEYWUqs8sTqIDkTaNn9u3huRE85Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzzkdU3lj5Cg/oeGtyJelqOEtBkGmZ0JErFKFyqyTvbPePWiYw2YUFJ9f34WtdS1N
         jvXFeA5G9AYKVmA9Dk2V41rqbbKnV5VCSrzexJs6zEf7T/MTky/UGaiI9tnzI5kTNO
         LjW9z8ru++WkJzzRcHfMB4P9hqC1G3DiZpumwVyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 07/50] drm/panel: check failure cases in the probe func
Date:   Tue, 24 Sep 2019 12:48:04 -0400
Message-Id: <20190924164847.27780-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit afd6d4f5a52c16e1483328ac074abb1cde92c29f ]

The following function calls may fail and return NULL, so the null check
is added.
of_graph_get_next_endpoint
of_graph_get_remote_port_parent
of_graph_get_remote_port

Update: Thanks to Sam Ravnborg, for suggession on the use of goto to avoid
leaking endpoint.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190724195534.9303-1-navid.emamdoost@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c   | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index 2c9c9722734f5..9a2cb8aeab3a4 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -400,7 +400,13 @@ static int rpi_touchscreen_probe(struct i2c_client *i2c,
 
 	/* Look up the DSI host.  It needs to probe before we do. */
 	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
+	if (!endpoint)
+		return -ENODEV;
+
 	dsi_host_node = of_graph_get_remote_port_parent(endpoint);
+	if (!dsi_host_node)
+		goto error;
+
 	host = of_find_mipi_dsi_host_by_node(dsi_host_node);
 	of_node_put(dsi_host_node);
 	if (!host) {
@@ -409,6 +415,9 @@ static int rpi_touchscreen_probe(struct i2c_client *i2c,
 	}
 
 	info.node = of_graph_get_remote_port(endpoint);
+	if (!info.node)
+		goto error;
+
 	of_node_put(endpoint);
 
 	ts->dsi = mipi_dsi_device_register_full(host, &info);
@@ -429,6 +438,10 @@ static int rpi_touchscreen_probe(struct i2c_client *i2c,
 		return ret;
 
 	return 0;
+
+error:
+	of_node_put(endpoint);
+	return -ENODEV;
 }
 
 static int rpi_touchscreen_remove(struct i2c_client *i2c)
-- 
2.20.1

