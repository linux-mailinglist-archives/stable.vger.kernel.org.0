Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE3F6DEEDB
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjDLIpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjDLIpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F315869B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3D062AE9
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813BBC4339B;
        Wed, 12 Apr 2023 08:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289095;
        bh=ada9z2yj0rwKdAG0HOG8J0ATX7rRaXOe3vsYDDjSg4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCv5get2zu0TqfndTpzPMa819t5lAdwuzZcIeUdYRGfvmbxHLlV6jxZgMwgtv1o0H
         0p1ObolDUVKAXZP/jVZUO0UJwM9NWHsxYVur5v6Valzakj/W8+G1tg9Eq8sVx0UKTY
         moixgS5CcVPNd6p69aaw/xdPpHSwTKCZI40T9eYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.1 134/164] drm/nouveau/disp: Support more modes by checking with lower bpc
Date:   Wed, 12 Apr 2023 10:34:16 +0200
Message-Id: <20230412082842.299127374@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

commit 7f67aa097e875c87fba024e850cf405342300059 upstream.

This allows us to advertise more modes especially on HDR displays.

Fixes using 4K@60 modes on my TV and main display both using a HDMI to DP
adapter. Also fixes similar issues for users running into this.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230330223938.4025569-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |   32 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_dp.c    |    8 +++++---
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -410,6 +410,35 @@ nv50_outp_atomic_check_view(struct drm_e
 	return 0;
 }
 
+static void
+nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_state *crtc_state)
+{
+	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
+	struct nouveau_encoder *nv_encoder = nouveau_encoder(encoder);
+	struct drm_display_mode *mode = &asyh->state.adjusted_mode;
+	unsigned int max_rate, mode_rate;
+
+	switch (nv_encoder->dcb->type) {
+	case DCB_OUTPUT_DP:
+		max_rate = nv_encoder->dp.link_nr * nv_encoder->dp.link_bw;
+
+		/* we don't support more than 10 anyway */
+		asyh->or.bpc = min_t(u8, asyh->or.bpc, 10);
+
+		/* reduce the bpc until it works out */
+		while (asyh->or.bpc > 6) {
+			mode_rate = DIV_ROUND_UP(mode->clock * asyh->or.bpc * 3, 8);
+			if (mode_rate <= max_rate)
+				break;
+
+			asyh->or.bpc -= 2;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static int
 nv50_outp_atomic_check(struct drm_encoder *encoder,
 		       struct drm_crtc_state *crtc_state,
@@ -428,6 +457,9 @@ nv50_outp_atomic_check(struct drm_encode
 	if (crtc_state->mode_changed || crtc_state->connectors_changed)
 		asyh->or.bpc = connector->display_info.bpc;
 
+	/* We might have to reduce the bpc */
+	nv50_outp_atomic_fix_depth(encoder, crtc_state);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -245,8 +245,6 @@ void nouveau_dp_irq(struct nouveau_drm *
 }
 
 /* TODO:
- * - Use the minimum possible BPC here, once we add support for the max bpc
- *   property.
  * - Validate against the DP caps advertised by the GPU (we don't check these
  *   yet)
  */
@@ -258,7 +256,11 @@ nv50_dp_mode_valid(struct drm_connector
 {
 	const unsigned int min_clock = 25000;
 	unsigned int max_rate, mode_rate, ds_max_dotclock, clock = mode->clock;
-	const u8 bpp = connector->display_info.bpc * 3;
+	/* Check with the minmum bpc always, so we can advertise better modes.
+	 * In particlar not doing this causes modes to be dropped on HDR
+	 * displays as we might check with a bpc of 16 even.
+	 */
+	const u8 bpp = 6 * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;


