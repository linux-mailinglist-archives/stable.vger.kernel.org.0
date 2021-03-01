Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A69A3283CE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhCAQZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhCAQV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4020464EF4;
        Mon,  1 Mar 2021 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615527;
        bh=FjDngh74X+U3M/nHRDotPT07tm0Eav9e8hfaO3dXWp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zy7kMhUE8x+GguSPxhm8bdgSDDSnEaBURBDofA89HR00P9YXEGSy3TZ4G0i1OLffX
         UXFy24ZxHbW4Cznl3xMbZnigxEtObDApRe5plA8nJcLQt28NxlcRx+l9AC0GBi2QXG
         HXwZGXTz5LTCD1xeZYbWLaWd/vVRxbD57RXjf3fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jialin Zhang <zhangjialin11@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 21/93] drm/gma500: Fix error return code in psb_driver_load()
Date:   Mon,  1 Mar 2021 17:12:33 +0100
Message-Id: <20210301161007.941771359@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index db98ab5cde3d8..15a909efe0c70 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -325,6 +325,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto out_err;
 
+	ret = -ENOMEM;
+
 	dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, 0);
 	if (!dev_priv->mmu)
 		goto out_err;
-- 
2.27.0



