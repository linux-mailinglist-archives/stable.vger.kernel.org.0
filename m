Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B396B26B567
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgIOXnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B1F423C30;
        Tue, 15 Sep 2020 14:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179928;
        bh=1I+s6HHLg63YP5caFLsr4RT9yTBRAYg2mwr4C+GZO34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPKs4zfnEZd8oyr327H+TVP9Ud1i1hOvsNjbBXFHp6UXEEX1sV/AqS06GAmmqfo7L
         kYG7zN7b2wY+mV5VAMwxHAhWWmMg2B1zBP7tm1Ne6qIZQg6/OKAXyrZh6p7gMsCbYm
         HF4lVfCY++EhykrgFqZ9Hu38gH/w0+OoIWgWujcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 023/177] drm/sun4i: add missing put_device() call in sun8i_r40_tcon_tv_set_mux()
Date:   Tue, 15 Sep 2020 16:11:34 +0200
Message-Id: <20200915140654.761406185@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 07b5b12d97dc9f47ff3dff46c4f944a15bd762e5 ]

If sun8i_r40_tcon_tv_set_mux() succeed, sun8i_r40_tcon_tv_set_mux()
doesn't have a corresponding put_device(). Thus add put_device()
to fix the exception handling for this function implementation.

Fixes: 0305189afb32 ("drm/sun4i: tcon: Add support for R40 TCON")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200826010826.1785487-1-yukuai3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 359b56e43b83c..24d95f058918c 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -1433,14 +1433,18 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
 	if (IS_ENABLED(CONFIG_DRM_SUN8I_TCON_TOP) &&
 	    encoder->encoder_type == DRM_MODE_ENCODER_TMDS) {
 		ret = sun8i_tcon_top_set_hdmi_src(&pdev->dev, id);
-		if (ret)
+		if (ret) {
+			put_device(&pdev->dev);
 			return ret;
+		}
 	}
 
 	if (IS_ENABLED(CONFIG_DRM_SUN8I_TCON_TOP)) {
 		ret = sun8i_tcon_top_de_config(&pdev->dev, tcon->id, id);
-		if (ret)
+		if (ret) {
+			put_device(&pdev->dev);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.25.1



