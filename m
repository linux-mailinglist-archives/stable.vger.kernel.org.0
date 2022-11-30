Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46D063E0BC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiK3T1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiK3T1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:27:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E0786A12
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 484BDB81CB6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F164C433D6;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669836417;
        bh=qraWFVSmqORI1yMcPzet/9gkVQO5cbOkVvXOES6GcFQ=;
        h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
        b=lfJO+BvXK1ckCjnsPHudDFlz6u2m4DcFN/kZa7GakhlBySjqY1rOWVGruQDGYKIug
         7oVJw8w9Hm7/FhPuRj5oir2mkZ79ZTQxWOX6DhoEKsesqUSONKYkqY4bXaDFHmlcDw
         4riwoVP+VGmWCD8DYWvUP9LM59JG2MV2IXqjRqcdrYUWGgK/Qs0KPGwIvOQJ7eCewL
         gP3lPhwmWYx7nA3ZkDCK2GsB15uM2DnV2tjYrpS+epD3iXoRAlCKo3otX8YXZjKRek
         VMCigOcJ1iWfNPEfBFvLmi5vOrMLh9BBBAE2OWfi4S28EpcJUuNzdFdCjHU5tBlS6o
         JvnpWH80wadpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id E2805C4708C;
        Wed, 30 Nov 2022 19:26:56 +0000 (UTC)
From:   Noralf =?utf-8?q?Tr=C3=B8nnes?= via B4 Submission Endpoint 
        <devnull+noralf.tronnes.org@kernel.org>
Date:   Wed, 30 Nov 2022 20:26:50 +0100
Subject: [PATCH v2 2/6] drm/gud: Don't retry a failed framebuffer flush
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221122-gud-shadow-plane-v2-2-435037990a83@tronnes.org>
References: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
In-Reply-To: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>, stable@kernel.org,
        Noralf =?unknown-8bit?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
X-Mailer: b4 0.11.0-dev-cc6f6
X-Developer-Signature: v=1; a=ed25519-sha256; t=1669836415; l=3429;
 i=noralf@tronnes.org; s=20221122; h=from:subject:message-id;
 bh=JgNUrup5eFPg7AS3RcWGGXUbXcgPsvtdWIu52mnjsLw=; =?utf-8?q?b=3Dw9GkJdswoEZI?=
 =?utf-8?q?vAEFarkHPd4n6fskkYVBIOS83rlWtU2/XJpmAYZ+ubw6D+QXPd711JJ4XHvhSsD+?=
 2aFQNnTTCD7KqPPMjVoPBvaD1FJR3nSZN5A067xrRSv0+KMhgr6e
X-Developer-Key: i=noralf@tronnes.org; a=ed25519;
 pk=0o9is4iddvvlrY3yON5SVtAbgPnVs0LfQsjfqR2Hvz8=
X-Endpoint-Received: by B4 Submission Endpoint for noralf@tronnes.org/20221122 with auth_id=8
X-Original-From: Noralf =?utf-8?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
Reply-To: <noralf@tronnes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

If a framebuffer flush fails the driver will do one retry by requeing the
worker. Currently the worker is used even for synchronous flushing, but a
later patch will inline it, so this needs to change. Thinking about how to
solve this I came to the conclusion that this retry mechanism was a fix
for a problem that was only in the mind of the developer (me) and not
something that solved a real problem.

So let's remove this for now and revisit later should it become necessary.
gud_add_damage() has now only one caller so it can be inlined.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/gpu/drm/gud/gud_pipe.c | 48 +++++++-----------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index 61f4abaf1811..ff1358815af5 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -333,37 +333,6 @@ void gud_clear_damage(struct gud_device *gdrm)
 	gdrm->damage.y2 = 0;
 }
 
-static void gud_add_damage(struct gud_device *gdrm, struct drm_rect *damage)
-{
-	gdrm->damage.x1 = min(gdrm->damage.x1, damage->x1);
-	gdrm->damage.y1 = min(gdrm->damage.y1, damage->y1);
-	gdrm->damage.x2 = max(gdrm->damage.x2, damage->x2);
-	gdrm->damage.y2 = max(gdrm->damage.y2, damage->y2);
-}
-
-static void gud_retry_failed_flush(struct gud_device *gdrm, struct drm_framebuffer *fb,
-				   struct drm_rect *damage)
-{
-	/*
-	 * pipe_update waits for the worker when the display mode is going to change.
-	 * This ensures that the width and height is still the same making it safe to
-	 * add back the damage.
-	 */
-
-	mutex_lock(&gdrm->damage_lock);
-	if (!gdrm->fb) {
-		drm_framebuffer_get(fb);
-		gdrm->fb = fb;
-	}
-	gud_add_damage(gdrm, damage);
-	mutex_unlock(&gdrm->damage_lock);
-
-	/* Retry only once to avoid a possible storm in case of continues errors. */
-	if (!gdrm->prev_flush_failed)
-		queue_work(system_long_wq, &gdrm->work);
-	gdrm->prev_flush_failed = true;
-}
-
 void gud_flush_work(struct work_struct *work)
 {
 	struct gud_device *gdrm = container_of(work, struct gud_device, work);
@@ -407,14 +376,10 @@ void gud_flush_work(struct work_struct *work)
 		ret = gud_flush_rect(gdrm, fb, format, &rect);
 		if (ret) {
 			if (ret != -ENODEV && ret != -ECONNRESET &&
-			    ret != -ESHUTDOWN && ret != -EPROTO) {
-				bool prev_flush_failed = gdrm->prev_flush_failed;
-
-				gud_retry_failed_flush(gdrm, fb, &damage);
-				if (!prev_flush_failed)
-					dev_err_ratelimited(fb->dev->dev,
-							    "Failed to flush framebuffer: error=%d\n", ret);
-			}
+			    ret != -ESHUTDOWN && ret != -EPROTO)
+				dev_err_ratelimited(fb->dev->dev,
+						    "Failed to flush framebuffer: error=%d\n", ret);
+			gdrm->prev_flush_failed = true;
 			break;
 		}
 
@@ -439,7 +404,10 @@ static void gud_fb_queue_damage(struct gud_device *gdrm, struct drm_framebuffer
 		gdrm->fb = fb;
 	}
 
-	gud_add_damage(gdrm, damage);
+	gdrm->damage.x1 = min(gdrm->damage.x1, damage->x1);
+	gdrm->damage.y1 = min(gdrm->damage.y1, damage->y1);
+	gdrm->damage.x2 = max(gdrm->damage.x2, damage->x2);
+	gdrm->damage.y2 = max(gdrm->damage.y2, damage->y2);
 
 	mutex_unlock(&gdrm->damage_lock);
 

-- 
2.34.1
