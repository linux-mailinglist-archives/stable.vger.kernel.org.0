Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EF7191CB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfEITAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbfEISvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857F7217F5;
        Thu,  9 May 2019 18:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427910;
        bh=ejtJlRKggDYSrnvS5XNrV6OwQHBXLxSQjZ7wIfmVLJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1ioYN+7WxP6hj/BEWCGAkdN2/6xUc6XCUKXqN0rz0ju6mqVH/jJJFlBIseo+mE78
         V3MCTX/MPKVEPKxsmtDt/a35PcI4BrxXbwBWUK5AjI7bwlgfWubJj0DpkAwPRZCrAS
         t/PrB3TnilZjJA5fyOIPUoP4A/CJalTUlfNUQC1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 49/95] drm/sun4i: tcon top: Fix NULL/invalid pointer dereference in sun8i_tcon_top_un/bind
Date:   Thu,  9 May 2019 20:42:06 +0200
Message-Id: <20190509181312.902008471@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1a07a94b47b1f528f39c3e6187b5eaf02efe44ea ]

There are two problems here:

1. Not all clk_data->hws[] need to be initialized, depending on various
   configured quirks. This leads to NULL ptr deref in
   clk_hw_unregister_gate() in sun8i_tcon_top_unbind()
2. If there is error when registering the clk_data->hws[],
   err_unregister_gates error path will try to unregister
   IS_ERR()=true (invalid) pointer.

For problem (1) I have this stack trace:

Unable to handle kernel NULL pointer dereference at virtual
  address 0000000000000008
Call trace:
 clk_hw_unregister+0x8/0x18
 clk_hw_unregister_gate+0x14/0x28
 sun8i_tcon_top_unbind+0x2c/0x60
 component_unbind.isra.4+0x2c/0x50
 component_bind_all+0x1d4/0x230
 sun4i_drv_bind+0xc4/0x1a0
 try_to_bring_up_master+0x164/0x1c0
 __component_add+0xa0/0x168
 component_add+0x10/0x18
 sun8i_dw_hdmi_probe+0x18/0x20
 platform_drv_probe+0x3c/0x70
 really_probe+0xcc/0x278
 driver_probe_device+0x34/0xa8

Problem (2) was identified by head scratching.

Signed-off-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190405233048.3823-1-megous@megous.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_tcon_top.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_tcon_top.c b/drivers/gpu/drm/sun4i/sun8i_tcon_top.c
index fc36e0c10a374..b1e7c76e9c172 100644
--- a/drivers/gpu/drm/sun4i/sun8i_tcon_top.c
+++ b/drivers/gpu/drm/sun4i/sun8i_tcon_top.c
@@ -227,7 +227,7 @@ static int sun8i_tcon_top_bind(struct device *dev, struct device *master,
 
 err_unregister_gates:
 	for (i = 0; i < CLK_NUM; i++)
-		if (clk_data->hws[i])
+		if (!IS_ERR_OR_NULL(clk_data->hws[i]))
 			clk_hw_unregister_gate(clk_data->hws[i]);
 	clk_disable_unprepare(tcon_top->bus);
 err_assert_reset:
@@ -245,7 +245,8 @@ static void sun8i_tcon_top_unbind(struct device *dev, struct device *master,
 
 	of_clk_del_provider(dev->of_node);
 	for (i = 0; i < CLK_NUM; i++)
-		clk_hw_unregister_gate(clk_data->hws[i]);
+		if (clk_data->hws[i])
+			clk_hw_unregister_gate(clk_data->hws[i]);
 
 	clk_disable_unprepare(tcon_top->bus);
 	reset_control_assert(tcon_top->rst);
-- 
2.20.1



