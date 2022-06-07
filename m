Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855A4541911
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378020AbiFGVTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380755AbiFGVQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152DA46656;
        Tue,  7 Jun 2022 11:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A48D6156D;
        Tue,  7 Jun 2022 18:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F127C385A5;
        Tue,  7 Jun 2022 18:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628235;
        bh=0or0bOVZvhDFy8k7MzwZE5SMX4NHHdVIR77GgpLle00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RatjAeSCIjkUvraUyR3LNyKTSqhoBOpz2tC9SBOUtjniFthHnp9TXy/tPqQVz2TXR
         DQoO0uChwsmQQTjbag3rJadqp1czjOos4FOQJWOQf1Hqn/fPJv//vFTmlYBQGgosWT
         4A0khB616V6loWxXA01Atjp8He17jxZj2CsSTynE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 256/879] drm/omap: fix NULL but dereferenced coccicheck error
Date:   Tue,  7 Jun 2022 18:56:14 +0200
Message-Id: <20220607165010.280964708@linuxfoundation.org>
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

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 8f2a3970c969d0d8d7289a4c65edcedafc16fd92 ]

Fix the following coccicheck warning:
./drivers/gpu/drm/omapdrm/omap_overlay.c:89:22-25: ERROR: r_ovl is NULL
but dereferenced.

Here should be ovl->idx rather than r_ovl->idx.

Fixes: e02b5cc9e898ad ("drm/omap: Add a 'right overlay' to plane state")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220307095612.409090-1-wanjiabing@vivo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_overlay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_overlay.c b/drivers/gpu/drm/omapdrm/omap_overlay.c
index 10730c9b2752..b0bc9ad2ef73 100644
--- a/drivers/gpu/drm/omapdrm/omap_overlay.c
+++ b/drivers/gpu/drm/omapdrm/omap_overlay.c
@@ -86,7 +86,7 @@ int omap_overlay_assign(struct drm_atomic_state *s, struct drm_plane *plane,
 		r_ovl = omap_plane_find_free_overlay(s->dev, overlay_map,
 						     caps, fourcc);
 		if (!r_ovl) {
-			overlay_map[r_ovl->idx] = NULL;
+			overlay_map[ovl->idx] = NULL;
 			*overlay = NULL;
 			return -ENOMEM;
 		}
-- 
2.35.1



