Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10F53FE3D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243378AbiFGMDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243346AbiFGMCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:02:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA233A2F
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 05:02:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6CD761F920;
        Tue,  7 Jun 2022 12:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654603371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OPkzJv54bBcdb8Y6n/fghKQGahLDVTSc24YWr0WG7xw=;
        b=tvmNOMYiYkpSPs6U8TVFnmCO55iFPELgDpEm5E4U3w8wu/tz4ay/8hoAmwAvntvo30My7A
        IxGK/46lpSZg9ORjUGtaNCDkk498tP5AKLEZBsf+HsNBL8tS9KHfO0N9CKRhM/lJ5QMai0
        MyoFPwnM2E8OIM4VuoEYRdXbBKl3PcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654603371;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OPkzJv54bBcdb8Y6n/fghKQGahLDVTSc24YWr0WG7xw=;
        b=E2lqa9WJqFqgBuR7DM7kWdP7D/wHfSE3TBD9MziPADVqWOi5MJ+HH+IuE9sOMyqD5rtTpN
        9xfEPrjPefhir0DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D85B13638;
        Tue,  7 Jun 2022 12:02:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RioWDms+n2JXfAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 07 Jun 2022 12:02:51 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     airlied@redhat.com, airlied@linux.ie, daniel@ffwll.ch,
        jfalempe@redhat.com, regressions@leemhuis.info,
        kuohsiang_chou@aspeedtech.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Date:   Tue,  7 Jun 2022 14:02:48 +0200
Message-Id: <20220607120248.31716-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Include AST2600 in most of the branches for AST2500. Thereby revert
most effects of commit f9bd00e0ea9d ("drm/ast: Create chip AST2600").

The AST2600 used to be treated like an AST2500, which at least gave
usable display output. After introducing AST2600 in the driver without
further updates, lots of functions take the wrong branches.

Handling AST2600 in the AST2500 branches reverts back to the original
settings. The exception are cases where AST2600 meanwhile got its own
branch.

Reported-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: f9bd00e0ea9d ("drm/ast: Create chip AST2600")
Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.11+
---
 drivers/gpu/drm/ast/ast_main.c | 4 ++--
 drivers/gpu/drm/ast/ast_mode.c | 6 +++---
 drivers/gpu/drm/ast/ast_post.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index d770d5a23c1a..56b2ac138375 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -307,7 +307,7 @@ static int ast_get_dram_info(struct drm_device *dev)
 	default:
 		ast->dram_bus_width = 16;
 		ast->dram_type = AST_DRAM_1Gx16;
-		if (ast->chip == AST2500)
+		if ((ast->chip == AST2500) || (ast->chip == AST2600))
 			ast->mclk = 800;
 		else
 			ast->mclk = 396;
@@ -319,7 +319,7 @@ static int ast_get_dram_info(struct drm_device *dev)
 	else
 		ast->dram_bus_width = 32;
 
-	if (ast->chip == AST2500) {
+	if ((ast->chip == AST2600) || (ast->chip == AST2500)) {
 		switch (mcr_cfg & 0x03) {
 		case 0:
 			ast->dram_type = AST_DRAM_1Gx16;
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 323af2746aa9..1dde30b98317 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -310,7 +310,7 @@ static void ast_set_crtc_reg(struct ast_private *ast,
 	u8 jreg05 = 0, jreg07 = 0, jreg09 = 0, jregAC = 0, jregAD = 0, jregAE = 0;
 	u16 temp, precache = 0;
 
-	if ((ast->chip == AST2500) &&
+	if (((ast->chip == AST2600) || (ast->chip == AST2500)) &&
 	    (vbios_mode->enh_table->flags & AST2500PreCatchCRT))
 		precache = 40;
 
@@ -428,7 +428,7 @@ static void ast_set_dclk_reg(struct ast_private *ast,
 {
 	const struct ast_vbios_dclk_info *clk_info;
 
-	if (ast->chip == AST2500)
+	if ((ast->chip == AST2600) || (ast->chip == AST2500))
 		clk_info = &dclk_table_ast2500[vbios_mode->enh_table->dclk_index];
 	else
 		clk_info = &dclk_table[vbios_mode->enh_table->dclk_index];
@@ -476,7 +476,7 @@ static void ast_set_crtthd_reg(struct ast_private *ast)
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0xe0);
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0xa0);
 	} else if (ast->chip == AST2300 || ast->chip == AST2400 ||
-	    ast->chip == AST2500) {
+		   ast->chip == AST2500 || ast->chip == AST2600) {
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0x78);
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0x60);
 	} else if (ast->chip == AST2100 ||
diff --git a/drivers/gpu/drm/ast/ast_post.c b/drivers/gpu/drm/ast/ast_post.c
index 0aa9cf0fb5c3..eb1ff9084034 100644
--- a/drivers/gpu/drm/ast/ast_post.c
+++ b/drivers/gpu/drm/ast/ast_post.c
@@ -80,7 +80,7 @@ ast_set_def_ext_reg(struct drm_device *dev)
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, i, 0x00);
 
 	if (ast->chip == AST2300 || ast->chip == AST2400 ||
-	    ast->chip == AST2500) {
+	    ast->chip == AST2500 || ast->chip == AST2600) {
 		if (pdev->revision >= 0x20)
 			ext_reg_info = extreginfo_ast2300;
 		else
@@ -105,7 +105,7 @@ ast_set_def_ext_reg(struct drm_device *dev)
 	/* Enable RAMDAC for A1 */
 	reg = 0x04;
 	if (ast->chip == AST2300 || ast->chip == AST2400 ||
-	    ast->chip == AST2500)
+	    ast->chip == AST2500 || ast->chip == AST2600)
 		reg |= 0x20;
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xb6, 0xff, reg);
 }
@@ -382,7 +382,7 @@ void ast_post_gpu(struct drm_device *dev)
 	if (ast->chip == AST2600) {
 		ast_dp_launch(dev, 1);
 	} else if (ast->config_mode == ast_use_p2a) {
-		if (ast->chip == AST2500)
+		if (ast->chip == AST2500 || ast->chip == AST2600)
 			ast_post_chip_2500(dev);
 		else if (ast->chip == AST2300 || ast->chip == AST2400)
 			ast_post_chip_2300(dev);
-- 
2.36.1

