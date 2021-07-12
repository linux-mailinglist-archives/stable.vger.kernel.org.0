Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0743C5364
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352368AbhGLHyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350307AbhGLHut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C53AB619B1;
        Mon, 12 Jul 2021 07:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075857;
        bh=2acFx/bocHz/BY6z/Ky0/gyfY/VmjF3xWOK7UBhn3pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj5X3pd7OHRuNQEp9v20rMgIab+uwsyeiIIPqxFn6vDEAI4/x+t6y1dAzs1zqin9i
         sSta3t9JMtFHubZ80pCdR1J2tr8/c0c/tHmnPgipOwMqr2LLOmz+4qGxi1MLMa+zGQ
         k3TQtEPF8lqG0q2/7Msnq9r+ljKmMPqLqk7efPGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 395/800] video: fbdev: imxfb: Fix an error message
Date:   Mon, 12 Jul 2021 08:06:58 +0200
Message-Id: <20210712061009.204005204@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 767d724a160eb1cd00c86fb8c2e21fa1ab3c37ac ]

'ret' is known to be 0 here.
No error code is available, so just remove it from the error message.

Fixes: 72330b0eeefc ("i.MX Framebuffer: Use readl/writel instead of direct pointer deref")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/d7b25026f82659da3c6f7159eea480faa9d738be.1620327302.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imxfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index 7f8debd2da06..ad598257ab38 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -992,7 +992,7 @@ static int imxfb_probe(struct platform_device *pdev)
 	info->screen_buffer = dma_alloc_wc(&pdev->dev, fbi->map_size,
 					   &fbi->map_dma, GFP_KERNEL);
 	if (!info->screen_buffer) {
-		dev_err(&pdev->dev, "Failed to allocate video RAM: %d\n", ret);
+		dev_err(&pdev->dev, "Failed to allocate video RAM\n");
 		ret = -ENOMEM;
 		goto failed_map;
 	}
-- 
2.30.2



