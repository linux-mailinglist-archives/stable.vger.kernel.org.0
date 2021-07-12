Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC2A3C4991
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhGLGpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238112AbhGLGng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B57C601FC;
        Mon, 12 Jul 2021 06:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071978;
        bh=k3bwyIczrE2Y2eF6MIV29TNp8aa1DkSMtyR35Abh6O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdnQz4THpDBUjZz5aLppCqoG5ZuBkOZI3PDVqKLITFBthoszpcz+lO8yd/cwPvaS6
         DfcTrY8Et06xY/ic/boo+jvNaD4dXswJWWcb0ZNpAf1yqe1/tqyAeHtal0PUDav/3o
         HLJvTc0dioeVdKo82XxxYzJobcIGRazH9kunYDIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/593] drm/ast: Fix missing conversions to managed API
Date:   Mon, 12 Jul 2021 08:07:43 +0200
Message-Id: <20210712060918.268611517@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9ea172a9a3f4a7c5e876469509fc18ddefc7d49d ]

The commit 7cbb93d89838 ("drm/ast: Use managed pci functions")
converted a few PCI accessors to the managed API and dropped the
manual pci_iounmap() calls, but it seems to have forgotten converting
pci_iomap() to the managed one.  It resulted in the leftover resources
after the driver unbind.  Let's fix them.

Fixes: 7cbb93d89838 ("drm/ast: Use managed pci functions")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421170458.21178-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index 77066bca8793..ee82b2ddf932 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -409,7 +409,7 @@ struct ast_private *ast_device_create(struct drm_driver *drv,
 	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
-	ast->regs = pci_iomap(dev->pdev, 1, 0);
+	ast->regs = pcim_iomap(pdev, 1, 0);
 	if (!ast->regs)
 		return ERR_PTR(-EIO);
 
@@ -425,7 +425,7 @@ struct ast_private *ast_device_create(struct drm_driver *drv,
 
 	/* "map" IO regs if the above hasn't done so already */
 	if (!ast->ioregs) {
-		ast->ioregs = pci_iomap(dev->pdev, 2, 0);
+		ast->ioregs = pcim_iomap(pdev, 2, 0);
 		if (!ast->ioregs)
 			return ERR_PTR(-EIO);
 	}
-- 
2.30.2



