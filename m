Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F42CD829
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfJFSAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 14:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbfJFR3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:29:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F1372080F;
        Sun,  6 Oct 2019 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382975;
        bh=qqZxm8KNU3bkkqJKEYWUqs8sTqIDkTaNn9u3huRE85Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqmX/2lj0ruEqh/hH10rDgml1pvWSma2L20uPKwwyehyTEfNSp1IcLQNmrMs7Ljp4
         idul9JaOqHSu6b4QkHHFb3u+92/yq3tjkwPZ9SXC3QEQBpVA2ie0JG+Q4srzB2atVJ
         IwRH5JHhnFQMfwER9FlqI21rpI2Lg4t3ktho8spg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/106] drm/panel: check failure cases in the probe func
Date:   Sun,  6 Oct 2019 19:20:13 +0200
Message-Id: <20191006171128.466992420@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



