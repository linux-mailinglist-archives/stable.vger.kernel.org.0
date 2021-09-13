Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFE7409205
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbhIMOHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344551AbhIMOFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 874F061A59;
        Mon, 13 Sep 2021 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540368;
        bh=4kCv7o3DyBpw7GqvoIMxTDt9C8B3zSsa+dFEur62VKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eb+7NBO4bpDl4yc80JXsGnXHdLtO5Wgpg827wzRpIpmGiFyQp9BqQyrsytj0s9a5W
         CMaI53CV8//barowbsdSL0Heg1tsI8wlS0PvV4rkv/0o4/AdZYcB9VpnxtAxHYtPxY
         Y6hbcyGNjA394BR+XfqWYxGmMUl65tjsVjNFnR/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 133/300] drm: rcar-du: Dont put reference to drm_device in rcar_du_remove()
Date:   Mon, 13 Sep 2021 15:13:14 +0200
Message-Id: <20210913131113.884016854@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit c29b6b0b126e9ee69a5d6339475e831a149295bd ]

The reference to the drm_device that was acquired by
devm_drm_dev_alloc() is released automatically by the devres
infrastructure. It must not be released manually, as that causes a
reference underflow..

Fixes: ea6aae151887 ("drm: rcar-du: Embed drm_device in rcar_du_device")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index bfbff90588cb..c22551c2facb 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -556,8 +556,6 @@ static int rcar_du_remove(struct platform_device *pdev)
 
 	drm_kms_helper_poll_fini(ddev);
 
-	drm_dev_put(ddev);
-
 	return 0;
 }
 
-- 
2.30.2



