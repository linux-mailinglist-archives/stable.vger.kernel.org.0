Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330FA2E6667
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgL1NWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388293AbgL1NWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7778207CF;
        Mon, 28 Dec 2020 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161749;
        bh=ZPGfBGeYg9CItXjRwc2VcSkGB4JLLeRan4J7333eP2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or3TO5yge4D+cOl31Ys5GGCCnnsmi4+e+2N0v590qkCYundm7wxhMgWzgKhiIt92g
         KkR9vfmDz8C0Wva09yDRnzzRaIU5k1KoSjbUOcNLPfTC9V/CpBpXqk6yOmqzN34ReG
         yjEAJnLwR0X4l0uU0BUBd21akAJWVAc607cO+vYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepak R Varma <mh12gx2825@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/346] drm/tegra: replace idr_init() by idr_init_base()
Date:   Mon, 28 Dec 2020 13:46:28 +0100
Message-Id: <20201228124923.135109179@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak R Varma <mh12gx2825@gmail.com>

[ Upstream commit 41f71629b4c432f8dd47d70ace813be5f79d4d75 ]

idr_init() uses base 0 which is an invalid identifier for this driver.
The new function idr_init_base allows IDR to set the ID lookup from
base 1. This avoids all lookups that otherwise starts from 0 since
0 is always unused.


Signed-off-by: Deepak R Varma <mh12gx2825@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index a2bd5876c6335..00808a3d67832 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -242,7 +242,7 @@ static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 	if (!fpriv)
 		return -ENOMEM;
 
-	idr_init(&fpriv->contexts);
+	idr_init_base(&fpriv->contexts, 1);
 	mutex_init(&fpriv->lock);
 	filp->driver_priv = fpriv;
 
-- 
2.27.0



