Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C042328F92
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbhCATxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242262AbhCAToS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4E476530E;
        Mon,  1 Mar 2021 17:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620566;
        bh=/lKOxMtG0S0yFvvTOIJuuC5LA/v9R6ZFqwpviflAANY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVHoSHTn0vuy/Sixvutu6rlwNzvLTLI9z1KCbt4rgwMSUGevgE6KPUDRd9Rge2IR4
         FlfVb0zhkiyyeV2wR0J6njV3DDpznqc31jZBSnRr50uXXnPMPZPzR/Ec896fNE3//j
         CWKMGfZnoiWfjEJZoOokzOiCGGZjiQVjydQa8K5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jialin Zhang <zhangjialin11@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 169/775] drm/gma500: Fix error return code in psb_driver_load()
Date:   Mon,  1 Mar 2021 17:05:37 +0100
Message-Id: <20210301161209.994756870@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jialin Zhang <zhangjialin11@huawei.com>

[ Upstream commit 6926872ae24452d4f2176a3ba2dee659497de2c4 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 5c49fd3aa0ab ("gma500: Add the core DRM files and headers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jialin Zhang <zhangjialin11@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201130020216.1906141-1-zhangjialin11@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/psb_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index cc2d59e8471da..134068f9328d5 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -312,6 +312,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto out_err;
 
+	ret = -ENOMEM;
+
 	dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, 0);
 	if (!dev_priv->mmu)
 		goto out_err;
-- 
2.27.0



