Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB321F9BE
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgGNSqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbgGNSqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:46:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E03622AAA;
        Tue, 14 Jul 2020 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752371;
        bh=pieAcDd6bFTdpg6107qY4pEzKvJ8WHGm9bg/hlipDIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3QCZBsFF8vNi1fYu/TiR57v4qfozFVzMNIA1vIDO1rkDaZeBfAhgbUyZV3h8QpCB
         7uWncq0LTzHW1LIyItJ6uXLQT9ytiTFeh0lyvsTMJhEAY7NbbqT28TGZTn6ziNvOpq
         k/eY8fe45ewgxfbmfQ9de8CucGks8LAnVfy9hvpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/58] drm/sun4i: mixer: Call of_dma_configure if theres an IOMMU
Date:   Tue, 14 Jul 2020 20:43:50 +0200
Message-Id: <20200714184057.012718826@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 842ec61f4006a6477a9deaedd69131e9f46e4cb5 ]

The main DRM device is actually a virtual device so it doesn't have the
iommus property, which is instead on the DMA masters, in this case the
mixers.

Add a call to of_dma_configure with the mixers DT node but on the DRM
virtual device to configure it in the same way than the mixers.

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/9a4daf438dd3f2fe07afb23688bfb793a0613d7d.1589378833.git-series.maxime@cerno.tech
(cherry picked from commit b718102dbdfd0285ad559687a30e27cc9124e592)
[Maxime: Applied to -fixes since it missed the merge window and display is
         broken without it]
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_mixer.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.c b/drivers/gpu/drm/sun4i/sun8i_mixer.c
index 71a798e5d5591..ddab3fab36a1a 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -435,6 +435,19 @@ static int sun8i_mixer_bind(struct device *dev, struct device *master,
 	mixer->engine.ops = &sun8i_engine_ops;
 	mixer->engine.node = dev->of_node;
 
+	if (of_find_property(dev->of_node, "iommus", NULL)) {
+		/*
+		 * This assume we have the same DMA constraints for
+		 * all our the mixers in our pipeline. This sounds
+		 * bad, but it has always been the case for us, and
+		 * DRM doesn't do per-device allocation either, so we
+		 * would need to fix DRM first...
+		 */
+		ret = of_dma_configure(drm->dev, dev->of_node, true);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * While this function can fail, we shouldn't do anything
 	 * if this happens. Some early DE2 DT entries don't provide
-- 
2.25.1



