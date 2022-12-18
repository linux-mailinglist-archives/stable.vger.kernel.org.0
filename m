Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CF465014C
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiLRQ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiLRQZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:25:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663F5D2E9;
        Sun, 18 Dec 2022 08:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52ED0B80B43;
        Sun, 18 Dec 2022 16:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFD6C433EF;
        Sun, 18 Dec 2022 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379791;
        bh=WeOOt14tkYeELBrtRWfPT2/q6Bw4lnOCH2VvxZFmpcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNsBKwMiHF7SXQpY6ydtCcRf52PlEq7oJJawGXjBjNa44qvdewSLlw7Vsgnb9P3D+
         +0qDhu3ZFrvjvn74PM8GwPDGEVjxwwmw4Q+IcCiGIQ+lgNYJDOkS2crYmJvwQx/RPv
         zKundxAGeU6kL58Igj/oain46/cZ9KPyoA0snM/QsT1jUCu+lNfuRfmJDH0nhTx6UO
         D/jTkfHwHdLeaQsGjZDI5FEWAdjTBRr7Eb7mDBlG511bX23s3Yqg27XGYqB0ywGkiw
         bvWWlijFldqRRBnHCJYZ6y53Mn3bAbE+/smni73Xu1yAP+qsurVfqRFY05+WIAsLBv
         vkPZoa3y2Vx0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>, p.zabel@pengutronix.de,
        airlied@gmail.com, daniel@ffwll.ch, matthias.bgg@gmail.com,
        ndesaulniers@google.com, dri-devel@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 35/73] drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()
Date:   Sun, 18 Dec 2022 11:07:03 -0500
Message-Id: <20221218160741.927862-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 890d637523eec9d730e3885532fa1228ba678880 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/mediatek/mtk_hdmi.c:1407:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' with an expression of type 'int (struct drm_bridge *, const struct drm_display_info *, const struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = mtk_hdmi_bridge_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

->mode_valid() in 'struct drm_bridge_funcs' expects a return type of
'enum drm_mode_status', not 'int'. Adjust the return type of
mtk_hdmi_bridge_mode_valid() to match the prototype's to resolve the
warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 3196189429bc..7613b0fa2be6 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1203,9 +1203,10 @@ static enum drm_connector_status mtk_hdmi_detect(struct mtk_hdmi *hdmi)
 	return mtk_hdmi_update_plugged_status(hdmi);
 }
 
-static int mtk_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
-				      const struct drm_display_info *info,
-				      const struct drm_display_mode *mode)
+static enum drm_mode_status
+mtk_hdmi_bridge_mode_valid(struct drm_bridge *bridge,
+			   const struct drm_display_info *info,
+			   const struct drm_display_mode *mode)
 {
 	struct mtk_hdmi *hdmi = hdmi_ctx_from_bridge(bridge);
 	struct drm_bridge *next_bridge;
-- 
2.35.1

