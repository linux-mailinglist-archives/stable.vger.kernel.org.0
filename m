Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2C52900D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbiEPUHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349815AbiEPUAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406044A08;
        Mon, 16 May 2022 12:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7091760EC4;
        Mon, 16 May 2022 19:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B439C385AA;
        Mon, 16 May 2022 19:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730828;
        bh=WWp5/fwmERuhj14JqsIQ06X/O1ig7VgEOoMipSi2itU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggAZORhuCw4rgiIfa7het5bPZFIYbxnFyXK0pR/dSSndHplRAl1V9z6ZBcaX6RqnF
         HjcDMGK44e167KJ9cykRPiGHp3LMALaUWF+hdYxhJsAxHmOo9DeGHaSN+4AqlF5YMa
         jc0FRoCzHtF4wmUNUe62hLtuyvh5D5oy52ByO4h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 019/114] drm/nouveau: Fix a potential theorical leak in nouveau_get_backlight_name()
Date:   Mon, 16 May 2022 21:35:53 +0200
Message-Id: <20220516193626.047502062@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ab244be47a8f111bc82496a8a20c907236e37f95 ]

If successful ida_simple_get() calls are not undone when needed, some
additional memory may be allocated and wasted.

Here, an ID between 0 and MAX_INT is required. If this ID is >=100, it is
not taken into account and is wasted. It should be released.

Instead of calling ida_simple_remove(), take advantage of the 'max'
parameter to require the ID not to be too big. Should it be too big, it
is not allocated and don't need to be freed.

While at it, use ida_alloc_xxx()/ida_free() instead to
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Fixes: db1a0ae21461 ("drm/nouveau/bl: Assign different names to interfaces")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[Fixed formatting warning from checkpatch]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/9ba85bca59df6813dc029e743a836451d5173221.1644386541.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index daf9f87477ba..a2141d3d9b1d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -46,8 +46,9 @@ static bool
 nouveau_get_backlight_name(char backlight_name[BL_NAME_SIZE],
 			   struct nouveau_backlight *bl)
 {
-	const int nb = ida_simple_get(&bl_ida, 0, 0, GFP_KERNEL);
-	if (nb < 0 || nb >= 100)
+	const int nb = ida_alloc_max(&bl_ida, 99, GFP_KERNEL);
+
+	if (nb < 0)
 		return false;
 	if (nb > 0)
 		snprintf(backlight_name, BL_NAME_SIZE, "nv_backlight%d", nb);
@@ -414,7 +415,7 @@ nouveau_backlight_init(struct drm_connector *connector)
 					    nv_encoder, ops, &props);
 	if (IS_ERR(bl->dev)) {
 		if (bl->id >= 0)
-			ida_simple_remove(&bl_ida, bl->id);
+			ida_free(&bl_ida, bl->id);
 		ret = PTR_ERR(bl->dev);
 		goto fail_alloc;
 	}
@@ -442,7 +443,7 @@ nouveau_backlight_fini(struct drm_connector *connector)
 		return;
 
 	if (bl->id >= 0)
-		ida_simple_remove(&bl_ida, bl->id);
+		ida_free(&bl_ida, bl->id);
 
 	backlight_device_unregister(bl->dev);
 	nv_conn->backlight = NULL;
-- 
2.35.1



