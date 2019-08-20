Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200EA96132
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbfHTNmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729933AbfHTNmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:05 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9840922DD6;
        Tue, 20 Aug 2019 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308525;
        bh=XFlRnSuBi0sK6RamGh07WiJv/X0GSLiXcqA+17EEsxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP3YoUsfVoCGOsgcxSXZihaVvsJz5N3iVi7YgqBvV296WW9jHNqyzuLAu+jXoIwRG
         JsDkk0oI3+COxz3ouNb79buf/7jY6FopM2iHzFLR0pGMXfJho04eJdMP+DG8eSnaAM
         U98LhlcCzCxxRkKU+MwtSLqbYFpd6qvawU2b04Rs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 41/44] drm/ast: Fixed reboot test may cause system hanged
Date:   Tue, 20 Aug 2019 09:40:25 -0400
Message-Id: <20190820134028.10829-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Y.C. Chen" <yc_chen@aspeedtech.com>

[ Upstream commit 05b439711f6ff8700e8660f97a1179650778b9cb ]

There is another thread still access standard VGA I/O while loading drm driver.
Disable standard VGA I/O decode to avoid this issue.

Signed-off-by: Y.C. Chen <yc_chen@aspeedtech.com>
Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1523410059-18415-1-git-send-email-yc_chen@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_main.c | 5 ++++-
 drivers/gpu/drm/ast/ast_mode.c | 2 +-
 drivers/gpu/drm/ast/ast_post.c | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index 2854399856ba0..4aebe21e6ad9f 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -131,8 +131,8 @@ static int ast_detect_chip(struct drm_device *dev, bool *need_post)
 
 
 	/* Enable extended register access */
-	ast_enable_mmio(dev);
 	ast_open_key(ast);
+	ast_enable_mmio(dev);
 
 	/* Find out whether P2A works or whether to use device-tree */
 	ast_detect_config_mode(dev, &scu_rev);
@@ -576,6 +576,9 @@ void ast_driver_unload(struct drm_device *dev)
 {
 	struct ast_private *ast = dev->dev_private;
 
+	/* enable standard VGA decode */
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x04);
+
 	ast_release_firmware(dev);
 	kfree(ast->dp501_fw_addr);
 	ast_mode_fini(dev);
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 97fed0627d1c8..74da15a3341a8 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -601,7 +601,7 @@ static int ast_crtc_mode_set(struct drm_crtc *crtc,
 		return -EINVAL;
 	ast_open_key(ast);
 
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xa1, 0xff, 0x04);
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x06);
 
 	ast_set_std_reg(crtc, adjusted_mode, &vbios_mode);
 	ast_set_crtc_reg(crtc, adjusted_mode, &vbios_mode);
diff --git a/drivers/gpu/drm/ast/ast_post.c b/drivers/gpu/drm/ast/ast_post.c
index f7d421359d564..c1d1ac51d1c20 100644
--- a/drivers/gpu/drm/ast/ast_post.c
+++ b/drivers/gpu/drm/ast/ast_post.c
@@ -46,7 +46,7 @@ void ast_enable_mmio(struct drm_device *dev)
 {
 	struct ast_private *ast = dev->dev_private;
 
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xa1, 0xff, 0x04);
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x06);
 }
 
 
-- 
2.20.1

