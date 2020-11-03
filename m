Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3562A5163
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgKCUkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgKCUkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098202236F;
        Tue,  3 Nov 2020 20:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436029;
        bh=Y1Pn9np0wB+6pPQcbGHYcjbaA8ylYPCflBapr0RiuGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXs3QOfm4HdPfsZ3ErT87YQ5VeULbP93eRTmoA3JqO6tnWV0BtaY6JX4tJiU5fgOC
         Kz3yWglRS2/KF3I3zuYrp6IydHYnvA+uxv8EEECBcl6HDUtfWgHYMSLDe14IilXXLg
         tjrZ9SY2tSEdnHyiaGcdt7u6FeFLkZ64JvRr9HXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 073/391] drm/ast: Separate DRM driver from PCI code
Date:   Tue,  3 Nov 2020 21:32:04 +0100
Message-Id: <20201103203352.132041253@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit d50ace1e72f05708cc5dbc89b9bbb9873f150092 ]

Putting the DRM driver to the top of the file and the PCI code to the
bottom makes ast_drv.c more readable. While at it, the patch prefixes
file-scope variables with ast_.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200730135206.30239-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_drv.c | 59 ++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index 0b58f7aee6b01..9d04f2b5225cf 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -43,9 +43,33 @@ int ast_modeset = -1;
 MODULE_PARM_DESC(modeset, "Disable/Enable modesetting");
 module_param_named(modeset, ast_modeset, int, 0400);
 
-#define PCI_VENDOR_ASPEED 0x1a03
+/*
+ * DRM driver
+ */
+
+DEFINE_DRM_GEM_FOPS(ast_fops);
+
+static struct drm_driver ast_driver = {
+	.driver_features = DRIVER_ATOMIC |
+			   DRIVER_GEM |
+			   DRIVER_MODESET,
+
+	.fops = &ast_fops,
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = DRIVER_DATE,
+	.major = DRIVER_MAJOR,
+	.minor = DRIVER_MINOR,
+	.patchlevel = DRIVER_PATCHLEVEL,
 
-static struct drm_driver driver;
+	DRM_GEM_VRAM_DRIVER
+};
+
+/*
+ * PCI driver
+ */
+
+#define PCI_VENDOR_ASPEED 0x1a03
 
 #define AST_VGA_DEVICE(id, info) {		\
 	.class = PCI_BASE_CLASS_DISPLAY << 16,	\
@@ -56,13 +80,13 @@ static struct drm_driver driver;
 	.subdevice = PCI_ANY_ID,		\
 	.driver_data = (unsigned long) info }
 
-static const struct pci_device_id pciidlist[] = {
+static const struct pci_device_id ast_pciidlist[] = {
 	AST_VGA_DEVICE(PCI_CHIP_AST2000, NULL),
 	AST_VGA_DEVICE(PCI_CHIP_AST2100, NULL),
 	{0, 0, 0},
 };
 
-MODULE_DEVICE_TABLE(pci, pciidlist);
+MODULE_DEVICE_TABLE(pci, ast_pciidlist);
 
 static void ast_kick_out_firmware_fb(struct pci_dev *pdev)
 {
@@ -94,7 +118,7 @@ static int ast_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		return ret;
 
-	dev = drm_dev_alloc(&driver, &pdev->dev);
+	dev = drm_dev_alloc(&ast_driver, &pdev->dev);
 	if (IS_ERR(dev))
 		return  PTR_ERR(dev);
 
@@ -118,11 +142,9 @@ err_ast_driver_unload:
 err_drm_dev_put:
 	drm_dev_put(dev);
 	return ret;
-
 }
 
-static void
-ast_pci_remove(struct pci_dev *pdev)
+static void ast_pci_remove(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 
@@ -217,30 +239,12 @@ static const struct dev_pm_ops ast_pm_ops = {
 
 static struct pci_driver ast_pci_driver = {
 	.name = DRIVER_NAME,
-	.id_table = pciidlist,
+	.id_table = ast_pciidlist,
 	.probe = ast_pci_probe,
 	.remove = ast_pci_remove,
 	.driver.pm = &ast_pm_ops,
 };
 
-DEFINE_DRM_GEM_FOPS(ast_fops);
-
-static struct drm_driver driver = {
-	.driver_features = DRIVER_ATOMIC |
-			   DRIVER_GEM |
-			   DRIVER_MODESET,
-
-	.fops = &ast_fops,
-	.name = DRIVER_NAME,
-	.desc = DRIVER_DESC,
-	.date = DRIVER_DATE,
-	.major = DRIVER_MAJOR,
-	.minor = DRIVER_MINOR,
-	.patchlevel = DRIVER_PATCHLEVEL,
-
-	DRM_GEM_VRAM_DRIVER
-};
-
 static int __init ast_init(void)
 {
 	if (vgacon_text_force() && ast_modeset == -1)
@@ -261,4 +265,3 @@ module_exit(ast_exit);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL and additional rights");
-
-- 
2.27.0



