Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9601541DFC
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381886AbiFGWX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382614AbiFGWVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DF126C0DF;
        Tue,  7 Jun 2022 12:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D8566077B;
        Tue,  7 Jun 2022 19:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50086C385A5;
        Tue,  7 Jun 2022 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629730;
        bh=Mfy3ytbbDKigbAx7RnPOWXW8wcLTxwl+MTXvB2B/5Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiPJY7w0tVg8yjxLDIiCO4WICmFQHqaZ8fWc/Ty9jJLg2V4ixnWEqz/w+pdXuVIsQ
         6NlF/fORZjmihiFJSpPnJfAj9xGZejWgzS4k9JRjpP4Yco5r0jR8v4mf7hPD2v71Yt
         BKDDb/tTyd4hR2WYEiyvZH/z2t/CE8SNf+R+cZmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.18 795/879] drm/nouveau/kms/nv50-: atom: fix an incorrect NULL check on list iterator
Date:   Tue,  7 Jun 2022 19:05:13 +0200
Message-Id: <20220607165025.938481961@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 6ce4431c7ba7954c4fa6a96ce16ca1b2943e1a83 upstream.

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
Reviewed-by: Lyude Paul <lyude@redhat.com>
[Changed commit title]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220327073925.11121-1-xiam0nd.tong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/atom.h |    6 +++---
 drivers/gpu/drm/nouveau/dispnv50/crc.c  |   27 ++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/atom.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/atom.h
@@ -160,14 +160,14 @@ nv50_head_atom_get(struct drm_atomic_sta
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
--- a/drivers/gpu/drm/nouveau/dispnv50/crc.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/crc.c
@@ -390,9 +390,18 @@ void nv50_crc_atomic_check_outp(struct n
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
@@ -443,8 +452,16 @@ void nv50_crc_atomic_set(struct nv50_hea
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


