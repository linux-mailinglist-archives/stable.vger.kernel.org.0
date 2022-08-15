Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F64A594A0D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343801AbiHOX32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343925AbiHOX0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91561474D4;
        Mon, 15 Aug 2022 13:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D2D760025;
        Mon, 15 Aug 2022 20:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2041CC433C1;
        Mon, 15 Aug 2022 20:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593980;
        bh=FU27mNks8W5srJ5JvNYi5+dQrXnSsKiy73X4z1VGlp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYf26RQI3lCEMsbeutyGd8QSEn9KF8SaTnQ+wlmNa6fFoEHe7bx18881GYO9rdRve
         smY6iR2jS0GGYIETkz6wN2Tc4VKmj/qgx68K/fr3JcAE0q9GlnB8niOJVKo73QKnUo
         sxD5A1jCTGHiinEiIQcQ8Hc9YEZXcjAQ3cjFyRqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@riseup.net>,
        Tales Lelo da Aparecida <tales.aparecida@gmail.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0357/1157] drm/vkms: check plane_composer->map[0] before using it
Date:   Mon, 15 Aug 2022 19:55:13 +0200
Message-Id: <20220815180453.997054498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tales Lelo da Aparecida <tales.aparecida@gmail.com>

[ Upstream commit 24f6fe3226c6f9f1b8406311a96b59c6e650b707 ]

Fix a copypasta error. The caller of compose_plane() already checks
primary_composer->map. In contrast, plane_composer->map is never
verified here before handling.

Fixes: 7938f4218168 ("dma-buf-map: Rename to iosys-map")
Reviewed-by: André Almeida <andrealmeid@riseup.net>
Signed-off-by: Tales Lelo da Aparecida <tales.aparecida@gmail.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220415111300.61013-2-tales.aparecida@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_composer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_composer.c b/drivers/gpu/drm/vkms/vkms_composer.c
index c6a1036bf2ea..b47ac170108c 100644
--- a/drivers/gpu/drm/vkms/vkms_composer.c
+++ b/drivers/gpu/drm/vkms/vkms_composer.c
@@ -157,7 +157,7 @@ static void compose_plane(struct vkms_composer *primary_composer,
 	void *vaddr;
 	void (*pixel_blend)(const u8 *p_src, u8 *p_dst);
 
-	if (WARN_ON(iosys_map_is_null(&primary_composer->map[0])))
+	if (WARN_ON(iosys_map_is_null(&plane_composer->map[0])))
 		return;
 
 	vaddr = plane_composer->map[0].vaddr;
-- 
2.35.1



