Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6DD3C535C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352330AbhGLHyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350219AbhGLHuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9024619A8;
        Mon, 12 Jul 2021 07:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075850;
        bh=pMyYFDtfX5GiJ4MJlfvITZ+k3OY0N/qMEdULP036w3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUJeaasN6PHj5oIY9A8HA9qWMaZ27ix2ekcmFapVtbUxuZ85bBNtmXr1fKujn7GD2
         3R3DdeYixQ65dgaNPAhi7ZrQkYb/QayBqCTDmbhMEQckQPp/zqenskL+kOZBX7OE/1
         fJEeVwPJ2P71p/m4/VgY7Z33t3PzALe+ZvUUzqHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 392/800] drm/ast: Fix missing conversions to managed API
Date:   Mon, 12 Jul 2021 08:06:55 +0200
Message-Id: <20210712061008.902205826@linuxfoundation.org>
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
index 0ac3c2039c4b..c29cc7f19863 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -413,7 +413,7 @@ struct ast_private *ast_device_create(const struct drm_driver *drv,
 
 	pci_set_drvdata(pdev, dev);
 
-	ast->regs = pci_iomap(pdev, 1, 0);
+	ast->regs = pcim_iomap(pdev, 1, 0);
 	if (!ast->regs)
 		return ERR_PTR(-EIO);
 
@@ -429,7 +429,7 @@ struct ast_private *ast_device_create(const struct drm_driver *drv,
 
 	/* "map" IO regs if the above hasn't done so already */
 	if (!ast->ioregs) {
-		ast->ioregs = pci_iomap(pdev, 2, 0);
+		ast->ioregs = pcim_iomap(pdev, 2, 0);
 		if (!ast->ioregs)
 			return ERR_PTR(-EIO);
 	}
-- 
2.30.2



