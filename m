Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661804E8691
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 09:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiC0HlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 03:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiC0HlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 03:41:12 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC99C77;
        Sun, 27 Mar 2022 00:39:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t13so8626814pgn.8;
        Sun, 27 Mar 2022 00:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=O3PyRZqqQh72JcsvYztaOf/qr4ybAn9k/u2PdxyHICY=;
        b=nvGGBOnXV1+wWMEOMbhZUSf6f5Zt9YLJWJ5ymTGyk9mxkOL6wNtSx2D1BBlCCV05ji
         YWbA5dxwDOK1lZMpsQBheNr3aLYi791kjM16ZggoHsF9+ZdWlCT1maMQuhfZkfrPxRby
         BEqbW6sS0eNA1TGvVzNN3kqX+0hiJ8SXGmrzNCuMgLALsmRgP/FIrJTu1JEN/SHX3M03
         BXU134bXzjlTl7hP6USgDEyR5oufYSyULlh5QjknFXm+sWYa6Fjv9HY90FJF9IA5cd8s
         5NshequTbJcgykoN8UI3aQtd23V1H7LlAar/JzAbY4t9pI7KVYWiXdqxaFpM5OWgS2oI
         Yjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O3PyRZqqQh72JcsvYztaOf/qr4ybAn9k/u2PdxyHICY=;
        b=mM1BaVCAx/32V5FKaJhmoEr1DevMz60Xvd9xJkPB+eX35IgkowLVf+kM/jU/KsJCRy
         tY2756FjK0UNR9vKXWrVjkT8BXf272uQZDqlYDi+VLWLhDFhXKTirbVHhuHzVIfhnC9h
         lWzzPVzfwn/ninCo0dvo3UPdkjrQVSjJsq6NNdyHyGk0NfJN4HIrBs7qoAwZfdf678Ar
         XhjH2oAa162n7f/7DgyyrNFvhm9Zx+tg5nVay2hXvT6YlYjaTjYdxJyLSvMwLf6HhdrZ
         g7ImmxGXm7w8Z6+aAvMrvs+b70S0DqISFLOlirUC8Sg/Vq9G/h7JAK20e8in3yv5ny1k
         WSWg==
X-Gm-Message-State: AOAM532BQS1U/9jerETmXkSApjVy1RRFEacxE1zVUio+n/EAPHbwDi5z
        fcMLW6Pgue16vNsLRSt8oAU=
X-Google-Smtp-Source: ABdhPJx3gRZk3pDQgkapY0ZHu5LFAijgb2Y/bH7NxBmXkU8qFs8ivrJQq62gnTVAQ8rgLDSqvn4npg==
X-Received: by 2002:a63:6a41:0:b0:386:5d6f:a643 with SMTP id f62-20020a636a41000000b003865d6fa643mr5911347pgc.169.1648366773155;
        Sun, 27 Mar 2022 00:39:33 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm9243231pgf.66.2022.03.27.00.39.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:39:32 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     bskeggs@redhat.com, kherbst@redhat.com, lyude@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch
Cc:     yangyingliang@huawei.com, contact@emersion.fr, airlied@gmail.com,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dispnv50: atom: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 15:39:25 +0800
Message-Id: <20220327073925.11121-1-xiam0nd.tong@gmail.com>
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

The bug is here:
	return encoder;

The list iterator value 'encoder' will *always* be set and non-NULL
by drm_for_each_encoder_mask(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element found.
Otherwise it will bypass some NULL checks and lead to invalid memory
access passing the check.

To fix this bug, just return 'encoder' when found, otherwise return
NULL.

Cc: stable@vger.kernel.org
Fixes: 12885ecbfe62d ("drm/nouveau/kms/nvd9-: Add CRC support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/nouveau/dispnv50/atom.h |  6 +++---
 drivers/gpu/drm/nouveau/dispnv50/crc.c  | 27 ++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/atom.h b/drivers/gpu/drm/nouveau/dispnv50/atom.h
index 3d82b3c67dec..93f8f4f64578 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
@@ -160,14 +160,14 @@ nv50_head_atom_get(struct drm_atomic_state *state, struct drm_crtc *crtc)
 static inline struct drm_encoder *
 nv50_head_atom_get_encoder(struct nv50_head_atom *atom)
 {
-	struct drm_encoder *encoder = NULL;
+	struct drm_encoder *encoder;
 
 	/* We only ever have a single encoder */
 	drm_for_each_encoder_mask(encoder, atom->state.crtc->dev,
 				  atom->state.encoder_mask)
-		break;
+		return encoder;
 
-	return encoder;
+	return NULL;
 }
 
 #define nv50_wndw_atom(p) container_of((p), struct nv50_wndw_atom, state)
diff --git a/drivers/gpu/drm/nouveau/dispnv50/crc.c b/drivers/gpu/drm/nouveau/dispnv50/crc.c
index 29428e770f14..b834e8a9ae77 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/crc.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/crc.c
@@ -390,9 +390,18 @@ void nv50_crc_atomic_check_outp(struct nv50_atom *atom)
 		struct nv50_head_atom *armh = nv50_head_atom(old_crtc_state);
 		struct nv50_head_atom *asyh = nv50_head_atom(new_crtc_state);
 		struct nv50_outp_atom *outp_atom;
-		struct nouveau_encoder *outp =
-			nv50_real_outp(nv50_head_atom_get_encoder(armh));
-		struct drm_encoder *encoder = &outp->base.base;
+		struct nouveau_encoder *outp;
+		struct drm_encoder *encoder, *enc;
+
+		enc = nv50_head_atom_get_encoder(armh);
+		if (!enc)
+			continue;
+
+		outp = nv50_real_outp(enc);
+		if (!outp)
+			continue;
+
+		encoder = &outp->base.base;
 
 		if (!asyh->clr.crc)
 			continue;
@@ -443,8 +452,16 @@ void nv50_crc_atomic_set(struct nv50_head *head,
 	struct drm_device *dev = crtc->dev;
 	struct nv50_crc *crc = &head->crc;
 	const struct nv50_crc_func *func = nv50_disp(dev)->core->func->crc;
-	struct nouveau_encoder *outp =
-		nv50_real_outp(nv50_head_atom_get_encoder(asyh));
+	struct nouveau_encoder *outp;
+	struct drm_encoder *encoder;
+
+	encoder = nv50_head_atom_get_encoder(asyh);
+	if (!encoder)
+		return;
+
+	outp = nv50_real_outp(encoder);
+	if (!outp)
+		return;
 
 	func->set_src(head, outp->or, nv50_crc_source_type(outp, asyh->crc.src),
 		      &crc->ctx[crc->ctx_idx]);
-- 
2.17.1

