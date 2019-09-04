Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6F4A8F89
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbfIDSES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389065AbfIDSEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27B9C22CF7;
        Wed,  4 Sep 2019 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620254;
        bh=j6slQnB2uX1cLMO5glRZ80zlNukpq06xFmMrLsE6Dh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRZaibZ2MUXljfSGixhx7L3eQvfvQaQWu5nF4L8bwkH/4V012XrKM9rnduTcSCeH5
         8l9E8TEuIGw29waffIhYS8RbuF1CzgFmBbmspmCOZMINmU2jNZTkpfQtHtrq5ayXDL
         ckrQQgqNu5u/a+lfXUJVv2zTekkigj7XzjoTXM4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Y.C. Chen" <yc_chen@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/57] drm/ast: Fixed reboot test may cause system hanged
Date:   Wed,  4 Sep 2019 19:53:37 +0200
Message-Id: <20190904175302.858386534@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 373700c05a00f..224fa1ef87ff9 100644
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
index 343867b182dd8..a09fafa270822 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -600,7 +600,7 @@ static int ast_crtc_mode_set(struct drm_crtc *crtc,
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



