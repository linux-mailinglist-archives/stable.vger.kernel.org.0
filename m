Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866D84094F2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343732AbhIMOgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347535AbhIMOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 162C361BD4;
        Mon, 13 Sep 2021 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541189;
        bh=PSdgZwWfBa37uKwmv+1AQxPWJiOH+uzkAICtnW3d8aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBRpZ2DbK3d4UOxCh7tLg/9KeZLJluj9LhGyAFSE790zR9CyT40qok+pzHorGgEWR
         FwI8R59L7UTPNx6GwP7W3EEOoXE5QtL/1S1wjjZJQHY+q41p54+mlQgFWAmaLGfGnj
         wO0wEU+9hdHh2+5Kh1uG6bSxGSuknz/GDAGhYJmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 198/334] drm/bridge: ti-sn65dsi86: Avoid creating multiple connectors
Date:   Mon, 13 Sep 2021 15:14:12 +0200
Message-Id: <20210913131120.110075410@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit c7782443a88926a4f938f0193041616328cf2db2 ]

If we created our own connector because the driver does not support the
NO_CONNECTOR flag, we don't want the downstream bridge to *also* create
a connector.  And if this driver did pass the NO_CONNECTOR flag (and we
supported that mode) this would change nothing.

Fixes: 4e5763f03e10 ("drm/bridge: ti-sn65dsi86: Wrap panel with panel-bridge")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210811235253.924867-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index c9cddf317c72..3aeed2731945 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -531,6 +531,9 @@ static int ti_sn_bridge_attach(struct drm_bridge *bridge,
 	}
 	pdata->dsi = dsi;
 
+	/* We never want the next bridge to *also* create a connector: */
+	flags |= DRM_BRIDGE_ATTACH_NO_CONNECTOR;
+
 	/* Attach the next bridge */
 	ret = drm_bridge_attach(bridge->encoder, pdata->next_bridge,
 				&pdata->bridge, flags);
-- 
2.30.2



