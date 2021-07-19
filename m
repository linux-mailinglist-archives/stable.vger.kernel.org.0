Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4813CE01B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245414AbhGSPNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345696AbhGSPM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1EDF61355;
        Mon, 19 Jul 2021 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709968;
        bh=bLkTOJtbe8Helps9fOjz0NsV36Nty9glQZHdOPbH0Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGXm+QmxDwNx06YAuHAX2QSyvAftseCmarIF6sApPImF3ydIdHIQq4hSNU50Lykt/
         PMmvN4cxaiLh+j7QnnfB/XPBpD3uh2czM842UPcUyXl4tljHG9pIXnfupb+1P5Knbz
         V3F/+793WsE0ERfo14Ph8cdtCx2nG8HNBrHzecLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.10 020/243] Revert "drm/ast: Remove reference to struct drm_device.pdev"
Date:   Mon, 19 Jul 2021 16:50:49 +0200
Message-Id: <20210719144941.585775782@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit fcb041ca5c7787b096aafc899e45f93583e66cbd which is
commit 0ecb51824e838372e01330752503ddf9c0430ef7 upstream.

Turns out this was incomplete, as it is missing a dependancy, so drop it
from the tree.

Link: https://lore.kernel.org/r/CAJn8CcHHKSo7GF29Z1ufXJJpMUzn6+fdvwiqe9=JvgpcfvnbHQ@mail.gmail.com
Reported-by: Xiaotian Feng <xtfeng@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michael J. Ruhl <michael.j.ruhl@intel.com>
Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -406,6 +406,7 @@ struct ast_private *ast_device_create(st
 		return ast;
 	dev = &ast->base;
 
+	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
 	ast->regs = pcim_iomap(pdev, 1, 0);
@@ -447,8 +448,8 @@ struct ast_private *ast_device_create(st
 
 	/* map reserved buffer */
 	ast->dp501_fw_buf = NULL;
-	if (dev->vram_mm->vram_size < pci_resource_len(pdev, 0)) {
-		ast->dp501_fw_buf = pci_iomap_range(pdev, 0, dev->vram_mm->vram_size, 0);
+	if (dev->vram_mm->vram_size < pci_resource_len(dev->pdev, 0)) {
+		ast->dp501_fw_buf = pci_iomap_range(dev->pdev, 0, dev->vram_mm->vram_size, 0);
 		if (!ast->dp501_fw_buf)
 			drm_info(dev, "failed to map reserved buffer!\n");
 	}


