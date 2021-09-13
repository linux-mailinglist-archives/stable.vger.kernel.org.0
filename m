Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE6D4094BC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344068AbhIMOd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346534AbhIMObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AA2261B9F;
        Mon, 13 Sep 2021 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541120;
        bh=4kCv7o3DyBpw7GqvoIMxTDt9C8B3zSsa+dFEur62VKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyRwpPG3MOBs7BbBuGZ+Gb9m5trmeB721dIQe2lKOEjD6zzMV8cMPkzLPmwtyeJLc
         ZBumxYzeXfyQS9mn5l59M4zBJ6DXDhM6Eeenzx4/MonJMd/oOvTGXnKpP/6ETckymT
         yopgRC7j8KvKeBlUqFrrpX7P36kxJwIwbba0F+ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 139/334] drm: rcar-du: Dont put reference to drm_device in rcar_du_remove()
Date:   Mon, 13 Sep 2021 15:13:13 +0200
Message-Id: <20210913131118.059528344@linuxfoundation.org>
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



