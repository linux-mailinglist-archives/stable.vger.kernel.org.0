Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C53CA9A4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbhGOTHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242439AbhGOTGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF7C613CF;
        Thu, 15 Jul 2021 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375792;
        bh=LcNL+hWRmsP7dl5Pm/XW7pnFZsSnmwQz0WjmeYEgdL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/hY5G21JmxTWZZVCaBGTJniOOzoUOkM5jIrSF/ZbwK7BYR4n7qjgIwn61klI6Ldz
         EGR1UNWY6Ih23e+qp9n+TVGkugTK2GUaAxz8zhZuugOgQAGFm3rq9npAuCmkveKEdr
         oNPYs2dpZ1nA9hg0qKdmDhKmT183hUrnz2hkNTE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.12 237/242] drm/ast: Remove reference to struct drm_device.pdev
Date:   Thu, 15 Jul 2021 20:39:59 +0200
Message-Id: <20210715182634.577299401@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 0ecb51824e838372e01330752503ddf9c0430ef7 upstream.

Using struct drm_device.pdev is deprecated. Upcast with to_pci_dev()
from struct drm_device.dev to get the PCI device structure.

v9:
	* fix remaining pdev references

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Fixes: ba4e0339a6a3 ("drm/ast: Fixed CVE for DP501")
Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210429105101.25667-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -411,7 +411,6 @@ struct ast_private *ast_device_create(co
 		return ast;
 	dev = &ast->base;
 
-	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
 	ast->regs = pcim_iomap(pdev, 1, 0);
@@ -453,8 +452,8 @@ struct ast_private *ast_device_create(co
 
 	/* map reserved buffer */
 	ast->dp501_fw_buf = NULL;
-	if (dev->vram_mm->vram_size < pci_resource_len(dev->pdev, 0)) {
-		ast->dp501_fw_buf = pci_iomap_range(dev->pdev, 0, dev->vram_mm->vram_size, 0);
+	if (dev->vram_mm->vram_size < pci_resource_len(pdev, 0)) {
+		ast->dp501_fw_buf = pci_iomap_range(pdev, 0, dev->vram_mm->vram_size, 0);
 		if (!ast->dp501_fw_buf)
 			drm_info(dev, "failed to map reserved buffer!\n");
 	}


