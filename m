Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F285405A0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344911AbiFGR1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345877AbiFGRZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F761091A1;
        Tue,  7 Jun 2022 10:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3D2360BC6;
        Tue,  7 Jun 2022 17:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8B2C341C0;
        Tue,  7 Jun 2022 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622647;
        bh=RRWTUZVsSwee1Ch/9/1JO4bq3V/JSjTlgdIXBLugHgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwQUkiZzhqAUk6AuLhzAlNTef7yAO+vap4K3y00IdIfOSSdysOibsKNMrWWYBoX8g
         VN0DXbsZs/zXe2t7IlS2g8qKplWCs0isS+jp/A6QpwSi4rvBJHySZ93MhBo40eQAL7
         MhXc96t9MFWxxvBQDvB/cC0e4Q7GTUom2f1/XBns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/452] drm/vc4: txp: Force alpha to be 0xff if its disabled
Date:   Tue,  7 Jun 2022 18:59:51 +0200
Message-Id: <20220607164912.553909340@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 5453343a88ede8b12812fced81ecd24cb888ccc3 ]

If we use a format that has padding instead of the alpha component (such
as XRGB8888), it appears that the Transposer will fill the padding to 0,
disregarding what was stored in the input buffer padding.

This leads to issues with IGT, since it will set the padding to 0xff,
but will then compare the CRC of the two frames which will thus fail.
Another nice side effect is that it is now possible to just use the
buffer as ARGB.

Fixes: 008095e065a8 ("drm/vc4: Add support for the transposer block")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20220328153659.2382206-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_txp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
index d4e750cf3c02..f8fa09dfea5d 100644
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -301,6 +301,12 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
 
 	if (fb->format->has_alpha)
 		ctrl |= TXP_ALPHA_ENABLE;
+	else
+		/*
+		 * If TXP_ALPHA_ENABLE isn't set and TXP_ALPHA_INVERT is, the
+		 * hardware will force the output padding to be 0xff.
+		 */
+		ctrl |= TXP_ALPHA_INVERT;
 
 	gem = drm_fb_cma_get_gem_obj(fb, 0);
 	TXP_WRITE(TXP_DST_PTR, gem->paddr + fb->offsets[0]);
-- 
2.35.1



