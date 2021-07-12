Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717D13C4DF8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbhGLHQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243012AbhGLHPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6064C613F5;
        Mon, 12 Jul 2021 07:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073903;
        bh=pMyYFDtfX5GiJ4MJlfvITZ+k3OY0N/qMEdULP036w3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o70JatFRmULYjD4zhCRDD3PGTw7RdzxCI4hReIb2qs7EEKD5IqSTv4IuiftJCv0Vk
         hQfxEd6lXMBsTFs5WllfCNGJsjEBb8QSKWA7GHYSqaxjSpDsAm/0zCd8lXuF5fiObD
         uMzysSxmSKmRRoglCArOFXvhCii5EjkfW1OKfPww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 355/700] drm/ast: Fix missing conversions to managed API
Date:   Mon, 12 Jul 2021 08:07:18 +0200
Message-Id: <20210712061014.125858181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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



