Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EAA6AEBB5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjCGRsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjCGRro (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:47:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AEF6233A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94399614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E12BC433EF;
        Tue,  7 Mar 2023 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210936;
        bh=HHqz1FCC9gX9Ud92cqAbmZ7w/4XG6y8eRiWOVWIJ4zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QQpVMcfgXsBXMnDBchk+y2uMu9IMvvJPWzWWz28Z8wa7ZSuoc18WkPG3Uz9AR4FY
         abwcBF0wL1RBluIZztY7FhC0WJzEbEd0+3wfWspHPivnbL93eU1HVfuo6BMi4107kL
         10lgosb+XEMd5Ora1Is/NW7oBrVn7/OV9vLgiMXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Wheeler <Daniel.Wheeler@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Brandon Syu <Brandon.Syu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0702/1001] drm/amd/display: fix mapping to non-allocated address
Date:   Tue,  7 Mar 2023 17:57:54 +0100
Message-Id: <20230307170052.085637256@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Syu <Brandon.Syu@amd.com>

[ Upstream commit 9190d4a263264eabf715f5fc1827da45e3fdc247 ]

[Why]
There is an issue mapping non-allocated location of memory.
It would allocate gpio registers from an array out of bounds.

[How]
Patch correct numbers of bounds for using.

Tested-by: Daniel Wheeler <Daniel.Wheeler@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Brandon Syu <Brandon.Syu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/gpio/dcn20/hw_factory_dcn20.c   | 6 ++++--
 .../gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c   | 6 ++++--
 .../gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c   | 6 ++++--
 drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h             | 7 +++++++
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/gpio/dcn20/hw_factory_dcn20.c b/drivers/gpu/drm/amd/display/dc/gpio/dcn20/hw_factory_dcn20.c
index 9b63c6c0cc844..e0bd0c722e006 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/dcn20/hw_factory_dcn20.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/dcn20/hw_factory_dcn20.c
@@ -138,7 +138,8 @@ static const struct ddc_sh_mask ddc_shift[] = {
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 3),
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 4),
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 5),
-	DDC_MASK_SH_LIST_DCN2(__SHIFT, 6)
+	DDC_MASK_SH_LIST_DCN2(__SHIFT, 6),
+	DDC_MASK_SH_LIST_DCN2_VGA(__SHIFT)
 };
 
 static const struct ddc_sh_mask ddc_mask[] = {
@@ -147,7 +148,8 @@ static const struct ddc_sh_mask ddc_mask[] = {
 	DDC_MASK_SH_LIST_DCN2(_MASK, 3),
 	DDC_MASK_SH_LIST_DCN2(_MASK, 4),
 	DDC_MASK_SH_LIST_DCN2(_MASK, 5),
-	DDC_MASK_SH_LIST_DCN2(_MASK, 6)
+	DDC_MASK_SH_LIST_DCN2(_MASK, 6),
+	DDC_MASK_SH_LIST_DCN2_VGA(_MASK)
 };
 
 #include "../generic_regs.h"
diff --git a/drivers/gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c b/drivers/gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c
index 687d4f128480e..36a5736c58c92 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c
@@ -145,7 +145,8 @@ static const struct ddc_sh_mask ddc_shift[] = {
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 3),
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 4),
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 5),
-	DDC_MASK_SH_LIST_DCN2(__SHIFT, 6)
+	DDC_MASK_SH_LIST_DCN2(__SHIFT, 6),
+	DDC_MASK_SH_LIST_DCN2_VGA(__SHIFT)
 };
 
 static const struct ddc_sh_mask ddc_mask[] = {
@@ -154,7 +155,8 @@ static const struct ddc_sh_mask ddc_mask[] = {
 	DDC_MASK_SH_LIST_DCN2(_MASK, 3),
 	DDC_MASK_SH_LIST_DCN2(_MASK, 4),
 	DDC_MASK_SH_LIST_DCN2(_MASK, 5),
-	DDC_MASK_SH_LIST_DCN2(_MASK, 6)
+	DDC_MASK_SH_LIST_DCN2(_MASK, 6),
+	DDC_MASK_SH_LIST_DCN2_VGA(_MASK)
 };
 
 #include "../generic_regs.h"
diff --git a/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c b/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
index 9fd8b269dd79c..985f10b397509 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c
@@ -149,7 +149,8 @@ static const struct ddc_sh_mask ddc_shift[] = {
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 3),
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 4),
 	DDC_MASK_SH_LIST_DCN2(__SHIFT, 5),
-	DDC_MASK_SH_LIST_DCN2(__SHIFT, 6)
+	DDC_MASK_SH_LIST_DCN2(__SHIFT, 6),
+	DDC_MASK_SH_LIST_DCN2_VGA(__SHIFT)
 };
 
 static const struct ddc_sh_mask ddc_mask[] = {
@@ -158,7 +159,8 @@ static const struct ddc_sh_mask ddc_mask[] = {
 	DDC_MASK_SH_LIST_DCN2(_MASK, 3),
 	DDC_MASK_SH_LIST_DCN2(_MASK, 4),
 	DDC_MASK_SH_LIST_DCN2(_MASK, 5),
-	DDC_MASK_SH_LIST_DCN2(_MASK, 6)
+	DDC_MASK_SH_LIST_DCN2(_MASK, 6),
+	DDC_MASK_SH_LIST_DCN2_VGA(_MASK)
 };
 
 #include "../generic_regs.h"
diff --git a/drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h b/drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h
index 308a543178a56..59884ef651b39 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h
+++ b/drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h
@@ -113,6 +113,13 @@
 	(PHY_AUX_CNTL__AUX## cd ##_PAD_RXSEL## mask_sh),\
 	(DC_GPIO_AUX_CTRL_5__DDC_PAD## cd ##_I2CMODE## mask_sh)}
 
+#define DDC_MASK_SH_LIST_DCN2_VGA(mask_sh) \
+	{DDC_MASK_SH_LIST_COMMON(mask_sh),\
+	0,\
+	0,\
+	0,\
+	0}
+
 struct ddc_registers {
 	struct gpio_registers gpio;
 	uint32_t ddc_setup;
-- 
2.39.2



