Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B742328DA2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbhCATOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:14:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhCATJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D7336500C;
        Mon,  1 Mar 2021 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618580;
        bh=fTavofsiTBU1uDvNLu1N1qirRXEC5Cazlo9uY56ffdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ92I3gefQ15Wi0UA8z1qCW5nNl6K10REuVsAQiwDiIhISlvG8ZxylUVelf2uamTi
         LhOfvV611UqiiU2XdpoQZ1O55Nu2wQ7Ca3sikRmCu0OvmGulBcBpJmqpPwPqt+O8v2
         sp+x5ShUOc4kDYTg7p2lGJ2yfLaCmKxH0IoDY6CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jialin Zhang <zhangjialin11@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/663] drm/gma500: Fix error return code in psb_driver_load()
Date:   Mon,  1 Mar 2021 17:06:27 +0100
Message-Id: <20210301161148.640408337@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 34b4aae9a15e3..074f403d7ca07 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -313,6 +313,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto out_err;
 
+	ret = -ENOMEM;
+
 	dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, 0);
 	if (!dev_priv->mmu)
 		goto out_err;
-- 
2.27.0



