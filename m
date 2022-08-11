Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A302259001A
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiHKPhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiHKPha (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:37:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5F198CB8;
        Thu, 11 Aug 2022 08:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DBC6B82160;
        Thu, 11 Aug 2022 15:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8010AC433D7;
        Thu, 11 Aug 2022 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232012;
        bh=QAMyQ7TtC5clwhU+ZhDJUtEIO92newKmfdyvarN1nDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOTDY1paGPom0sraDpnI3FX8hGmjieJD/zA7JDqBnxny8YT+trQJmO2r8/Fi5n6UH
         aHTB8tJlJmAHLucbVk2SzyK7jMMYsJrf/N8PoNjbWnVL41JOdlM9m5HrLes0AWYPJt
         0klRXKQTkZSq0+GPrIoEnrsXfjoSzZhLkHt2/Nmhai4GzvGTMZVozyGMHr+S9D9Fm1
         TIvQjDW4Az75t3Z30ttlFihVjCtB0KdfW5uKgpJXlVPujzoN2GwDPKpF8ZENRWwLgD
         P0WdIYjsyp945e54gI/nzO1HZMg9QtohvemDgTvi5Cv7XMRUOWORxaGvsHLlOAJ0fr
         vNoOpiByDwanA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>,
        kernel test robot <lkp@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>, airlied@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 046/105] drm/ast: Fixed the casting issue reported by sparse
Date:   Thu, 11 Aug 2022 11:27:30 -0400
Message-Id: <20220811152851.1520029-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>

[ Upstream commit 232b95ba4e83ca0a77f19fc772ccc6581051e5cc ]

V1:
1.Fixed sparse:cast truncates bits form constant value ()cast
  truncates bits from constant value (ffffffffffffff00 becomes 0)

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220623083116.35365-1-kuohsiang_chou@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_dp.c  | 10 +++++-----
 drivers/gpu/drm/ast/ast_drv.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_dp.c b/drivers/gpu/drm/ast/ast_dp.c
index f573d582407e..56483860306b 100644
--- a/drivers/gpu/drm/ast/ast_dp.c
+++ b/drivers/gpu/drm/ast/ast_dp.c
@@ -34,7 +34,7 @@ int ast_astdp_read_edid(struct drm_device *dev, u8 *ediddata)
 		 * CRE4[7:0]: Read-Pointer for EDID (Unit: 4bytes); valid range: 0~64
 		 */
 		ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE4,
-					(u8) ~ASTDP_EDID_READ_POINTER_MASK, (u8) i);
+				       ASTDP_AND_CLEAR_MASK, (u8)i);
 		j = 0;
 
 		/*
@@ -274,8 +274,8 @@ void ast_dp_set_mode(struct drm_crtc *crtc, struct ast_vbios_mode_info *vbios_mo
 	 * CRE1[7:0]: MISC1 (default: 0x00)
 	 * CRE2[7:0]: video format index (0x00 ~ 0x20 or 0x40 ~ 0x50)
 	 */
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE0, (u8) ~ASTDP_CLEAR_MASK,
-				ASTDP_MISC0_24bpp);
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE1, (u8) ~ASTDP_CLEAR_MASK, ASTDP_MISC1);
-	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE2, (u8) ~ASTDP_CLEAR_MASK, ModeIdx);
+	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE0, ASTDP_AND_CLEAR_MASK,
+			       ASTDP_MISC0_24bpp);
+	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE1, ASTDP_AND_CLEAR_MASK, ASTDP_MISC1);
+	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xE2, ASTDP_AND_CLEAR_MASK, ModeIdx);
 }
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index a34db4380f68..2e44b971c3a6 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -433,7 +433,7 @@ int ast_mode_config_init(struct ast_private *ast);
  */
 #define ASTDP_MISC0_24bpp			BIT(5)
 #define ASTDP_MISC1				0
-#define ASTDP_CLEAR_MASK			GENMASK(7, 0)
+#define ASTDP_AND_CLEAR_MASK		0x00
 
 /*
  * ASTDP resoultion table:
-- 
2.35.1

