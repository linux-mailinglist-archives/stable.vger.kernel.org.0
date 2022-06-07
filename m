Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B354190D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239161AbiFGVTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380797AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257CF52B3D;
        Tue,  7 Jun 2022 11:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97281CE244E;
        Tue,  7 Jun 2022 18:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7A2C385A5;
        Tue,  7 Jun 2022 18:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628245;
        bh=4M718MF/c9068y/4EsWfAgSxjWRXy65Wpxn5CQQyKp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbHcdTFcdH1DN6TeOayvjBvyXub0EXsmQqbQen5G/L0N6LWTBOqaQ3Uy6fufcnm/x
         dnOqbPGcm0E+VWVgimTCtFLwynh34L5vrRUAgfSS9XzEH86SZAhWlu7Yemxq8p95FM
         A2enMTi+ubIh6fDpXpZt7NhT2VrYZlMaE8IU1vYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 259/879] drm: ssd130x: Fix COM scan direction register mask
Date:   Tue,  7 Jun 2022 18:56:17 +0200
Message-Id: <20220607165010.369618689@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit efb37e66b7572ce4696aa0ac21675e17d6b9a17d ]

The SSD130x's command to toggle COM scan direction uses bit 3 and only
bit 3 to set the direction of the scanout. The driver has an incorrect
GENMASK(3, 2), causing the setting to be set on bit 2, rendering it
ineffective.

Fix the mask to only bit 3, so that the requested setting is applied
correctly.

Fixes: a61732e80867 ("drm: Add driver for Solomon SSD130x OLED displays")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220308160758.26060-1-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index ce4dc20412e0..ccd378135589 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -61,7 +61,7 @@
 #define SSD130X_SET_COM_PINS_CONFIG		0xda
 #define SSD130X_SET_VCOMH			0xdb
 
-#define SSD130X_SET_COM_SCAN_DIR_MASK		GENMASK(3, 2)
+#define SSD130X_SET_COM_SCAN_DIR_MASK		GENMASK(3, 3)
 #define SSD130X_SET_COM_SCAN_DIR_SET(val)	FIELD_PREP(SSD130X_SET_COM_SCAN_DIR_MASK, (val))
 #define SSD130X_SET_CLOCK_DIV_MASK		GENMASK(3, 0)
 #define SSD130X_SET_CLOCK_DIV_SET(val)		FIELD_PREP(SSD130X_SET_CLOCK_DIV_MASK, (val))
-- 
2.35.1



