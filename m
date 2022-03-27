Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CD44E861B
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiC0Fzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiC0Fzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:55:41 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1B757173;
        Sat, 26 Mar 2022 22:54:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v4so11163475pjh.2;
        Sat, 26 Mar 2022 22:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=LIDQGlj3VLO68EFfP7fGx3WACork59rTmNVuYIV40DE=;
        b=q1T9x1irmTEDglNu4jA/LGN/tv+9XWlN8xmGoZRJ94dQYV4PFTPV+3L3D6La0T5TGO
         U7u5tZsTqJm/JgbrkP+OQlxzLLkeh4oACKfpJ6iH3azw4RA2mxRiB2By0FqZdKeiR8NK
         d6UJaVdF2yWaggbls8plj0d0/v3rL2+jiOEyoCkppbkHH/q/WxNnxLp7ed1z9AVoQSkq
         vPw7DDwGHJMnX4Doy3QuQrbWiTeq9wsbyNHKN5wC/oF42wohZagR1O+ZCi+G5rSAfwcB
         B/66OfrBlgVndH/XA71/creKi9QT6sKKlyswdatTFl96vg8weVg1aBPdaIiYMYbWhbY6
         CoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LIDQGlj3VLO68EFfP7fGx3WACork59rTmNVuYIV40DE=;
        b=qnIEhkRlsHDZjbILPKF59suh2GrsMeGKCHfBrb4eMdXgUTsx0AqIxFhlCS5zselCs9
         cf+4RbVp6oZMuJzExihF7V2MdBVxhJcRAz+cio5QoEqH0xZyfja+kru7j2pR6juufDyx
         Vf6uODrdQBWtV8NYHlCALtyIEDsx2Faqn+bsxr6l+8M6Sbq8vkiPNCNJht6d4wG1OvC6
         TyXuouqx1UyXX1EXJJ3JEmCbGZK0okJIIrjvbsKrw5qIzJgKEieBmWFA4MzNMhxxRGTl
         spuIfPXb4NjNGM+HPEfwnsac5r+53V9ny9vUxte95mi5FTRO3mmfnH74z6AaZIAvIFFW
         fn7g==
X-Gm-Message-State: AOAM530AOhXQUxN+QlKh+//qeQsW2WatObb6rFyZ67LSUQ+koa+WoV40
        Hk6D6gkg+wF89Tr1zjBf+HU=
X-Google-Smtp-Source: ABdhPJy4k07mvfzm2EG3bok+szq0r8f379ZtqpNiz3wD1da1BhAx93ZoSKYEp5L3TI3I5jVnEniXNA==
X-Received: by 2002:a17:90b:1a8b:b0:1c7:386b:4811 with SMTP id ng11-20020a17090b1a8b00b001c7386b4811mr22577530pjb.4.1648360442838;
        Sat, 26 Mar 2022 22:54:02 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id w61-20020a17090a6bc300b001c7ca8a1467sm8779049pjj.46.2022.03.26.22.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:54:02 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     yannick.fertre@foss.st.com
Cc:     raphael.gallais-pou@foss.st.com, philippe.cornu@foss.st.com,
        airlied@linux.ie, daniel@ffwll.ch, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, marex@denx.de,
        dri-devel@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] stm: ltdc: fix two incorrect NULL checks on list iterator
Date:   Sun, 27 Mar 2022 13:53:55 +0800
Message-Id: <20220327055355.3808-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The two bugs are here:
	if (encoder) {
	if (bridge && bridge->timings)

The list iterator value 'encoder/bridge' will *always* be set and
non-NULL by drm_for_each_encoder()/list_for_each_entry(), so it is
incorrect to assume that the iterator value will be NULL if the
list is empty or no element is found.

To fix the bug, use a new variable '*_iter' as the list iterator,
while use the old variable 'encoder/bridge' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 99e360442f223 ("drm/stm: Fix bus_flags handling")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/stm/ltdc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index dbdee954692a..d6124aa873e5 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -528,8 +528,8 @@ static void ltdc_crtc_mode_set_nofb(struct drm_crtc *crtc)
 	struct drm_device *ddev = crtc->dev;
 	struct drm_connector_list_iter iter;
 	struct drm_connector *connector = NULL;
-	struct drm_encoder *encoder = NULL;
-	struct drm_bridge *bridge = NULL;
+	struct drm_encoder *encoder = NULL, *en_iter;
+	struct drm_bridge *bridge = NULL, *br_iter;
 	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
 	u32 hsync, vsync, accum_hbp, accum_vbp, accum_act_w, accum_act_h;
 	u32 total_width, total_height;
@@ -538,15 +538,19 @@ static void ltdc_crtc_mode_set_nofb(struct drm_crtc *crtc)
 	int ret;
 
 	/* get encoder from crtc */
-	drm_for_each_encoder(encoder, ddev)
-		if (encoder->crtc == crtc)
+	drm_for_each_encoder(en_iter, ddev)
+		if (en_iter->crtc == crtc) {
+			encoder = en_iter;
 			break;
+		}
 
 	if (encoder) {
 		/* get bridge from encoder */
-		list_for_each_entry(bridge, &encoder->bridge_chain, chain_node)
-			if (bridge->encoder == encoder)
+		list_for_each_entry(br_iter, &encoder->bridge_chain, chain_node)
+			if (br_iter->encoder == encoder) {
+				bridge = br_iter;
 				break;
+			}
 
 		/* Get the connector from encoder */
 		drm_connector_list_iter_begin(ddev, &iter);
-- 
2.17.1

