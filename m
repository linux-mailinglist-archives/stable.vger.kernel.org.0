Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1145C033A
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiIUQA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiIUP6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A3FA1D0F;
        Wed, 21 Sep 2022 08:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E4663138;
        Wed, 21 Sep 2022 15:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178E1C4314B;
        Wed, 21 Sep 2022 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775467;
        bh=8KchVOiklKldhDSmnwE9qC9ds7RMp8LSqO/hd4CFmxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SkSbfEtMPxT5tKCyVrDyxBVx61P+3welRDsPS2Orgj2Ix35LsZ1SA63bGzloTu8B
         ONdNwX+jB/Tihqhk5+ltFQYJWF3YZhmXllTxl7fCwtqSMw0vlb2tpbzSQKNjtFZrR7
         kiO7j+nZ4ha0Soy/XXEjz4PL1lzvXUKLHQTDQGKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stuart Menefy <stuart.menefy@mathembedded.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/39] drm/meson: Fix OSD1 RGB to YCbCr coefficient
Date:   Wed, 21 Sep 2022 17:46:22 +0200
Message-Id: <20220921153646.309831615@linuxfoundation.org>
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

[ Upstream commit 6463d3930ba5b6addcfc8f80a4543976a2fc7656 ]

VPP_WRAP_OSD1_MATRIX_COEF22.Coeff22 is documented as being bits 0-12,
not 16-28.

Without this the output tends to have a pink hue, changing it results
in better color accuracy.

The vendor kernel doesn't use this register. However the code which
sets VIU2_OSD1_MATRIX_COEF22 also uses bits 0-12. There is a slightly
different style of registers for configuring some of the other matrices,
which do use bits 16-28 for this coefficient, but those have names
ending in MATRIX_COEF22_30, and this is not one of those.

Signed-off-by: Stuart Menefy <stuart.menefy@mathembedded.com>
Fixes: 728883948b0d ("drm/meson: Add G12A Support for VIU setup")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220908155243.687143-1-stuart.menefy@mathembedded.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_viu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index bb7e109534de..d4b907889a21 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -94,7 +94,7 @@ static void meson_viu_set_g12a_osd1_matrix(struct meson_drm *priv,
 		priv->io_base + _REG(VPP_WRAP_OSD1_MATRIX_COEF11_12));
 	writel(((m[9] & 0x1fff) << 16) | (m[10] & 0x1fff),
 		priv->io_base + _REG(VPP_WRAP_OSD1_MATRIX_COEF20_21));
-	writel((m[11] & 0x1fff) << 16,
+	writel((m[11] & 0x1fff),
 		priv->io_base +	_REG(VPP_WRAP_OSD1_MATRIX_COEF22));
 
 	writel(((m[18] & 0xfff) << 16) | (m[19] & 0xfff),
-- 
2.35.1



