Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590775C0312
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiIUQAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiIUP6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2F4A0614;
        Wed, 21 Sep 2022 08:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE2B1B830A8;
        Wed, 21 Sep 2022 15:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D938C433C1;
        Wed, 21 Sep 2022 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775464;
        bh=T/OSn7g8E83BV4oJQxv3LmYq9FP3m06f7Yi8R7gKf8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dl8gOSNqRPL/faREUQV2s1payBjYk9SGewUe5jLV1p54tuCQCm/PryM/eofJ+ivaO
         r5ogh8PCi4wG/E1MONsy2rQXirwqY8ZxB0mt40irx/oXjCZbjP6E+ywmxBWENk1Fwn
         soaqYSMhHBp027/yM6/99R/Rx6HVeQaHcslNn7Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stuart Menefy <stuart.menefy@mathembedded.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/39] drm/meson: Correct OSD1 global alpha value
Date:   Wed, 21 Sep 2022 17:46:21 +0200
Message-Id: <20220921153646.274933035@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Menefy <stuart.menefy@mathembedded.com>

[ Upstream commit 6836829c8ea453c9e3e518e61539e35881c8ed5f ]

VIU_OSD1_CTRL_STAT.GLOBAL_ALPHA is a 9 bit field, so the maximum
value is 0x100 not 0xff.

This matches the vendor kernel.

Signed-off-by: Stuart Menefy <stuart.menefy@mathembedded.com>
Fixes: bbbe775ec5b5 ("drm: Add support for Amlogic Meson Graphic Controller")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220908155103.686904-1-stuart.menefy@mathembedded.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_plane.c b/drivers/gpu/drm/meson/meson_plane.c
index 35338ed18209..255c6b863f8d 100644
--- a/drivers/gpu/drm/meson/meson_plane.c
+++ b/drivers/gpu/drm/meson/meson_plane.c
@@ -163,7 +163,7 @@ static void meson_plane_atomic_update(struct drm_plane *plane,
 
 	/* Enable OSD and BLK0, set max global alpha */
 	priv->viu.osd1_ctrl_stat = OSD_ENABLE |
-				   (0xFF << OSD_GLOBAL_ALPHA_SHIFT) |
+				   (0x100 << OSD_GLOBAL_ALPHA_SHIFT) |
 				   OSD_BLK0_ENABLE;
 
 	priv->viu.osd1_ctrl_stat2 = readl(priv->io_base +
-- 
2.35.1



