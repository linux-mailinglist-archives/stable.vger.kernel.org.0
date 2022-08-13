Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520C5591A5F
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiHMMwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiHMMwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5041C14D39
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E2760D2F
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2067C433C1;
        Sat, 13 Aug 2022 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395150;
        bh=vIrf1l6v+IEQy+jPhk3o5s7DP5b/XKNgQPVdeDFO4QM=;
        h=Subject:To:Cc:From:Date:From;
        b=tVari8aaqiyMlJXcDYsO8kokIcniOuIazhq3E2glIPDkKiXBaLOof1es7D46/hBD9
         n/h5G69k13Z6LMCwXyyZPuoWb9noJfy6DjhHSGD4FM0sW+nQKJWbQ8r1OlItrf/wFa
         AOpDBxKHSPdY0eaAqZo/rKBOaJo2OxcOzCctXsTY=
Subject: FAILED: patch "[PATCH] drm/nouveau: Don't pm_runtime_put_sync(), only" failed to apply to 5.15-stable tree
To:     lyude@redhat.com, airlied@linux.ie, hdegoede@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:52:21 +0200
Message-ID: <166039514117948@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c96cfaf8fc02d4bb70727dfa7ce7841a3cff9be2 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Thu, 14 Jul 2022 13:42:34 -0400
Subject: [PATCH] drm/nouveau: Don't pm_runtime_put_sync(), only
 pm_runtime_put_autosuspend()

While trying to fix another issue, it occurred to me that I don't actually
think there is any situation where we want pm_runtime_put() in nouveau to
be synchronous. In fact, this kind of just seems like it would cause
issues where we may unexpectedly block a thread we don't expect to be
blocked.

So, let's only use pm_runtime_put_autosuspend().

Changes since v1:
* Use pm_runtime_put_autosuspend(), not pm_runtime_put()

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: David Airlie <airlied@linux.ie>
Fixes: 3a6536c51d5d ("drm/nouveau: Intercept ACPI_VIDEO_NOTIFY_PROBE")
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://patchwork.freedesktop.org/patch/msgid/20220714174234.949259-3-lyude@redhat.com

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 9f5a45f24e5b..a2f5df568ca5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -515,7 +515,7 @@ nouveau_display_hpd_work(struct work_struct *work)
 
 	pm_runtime_mark_last_busy(drm->dev->dev);
 noop:
-	pm_runtime_put_sync(drm->dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
 }
 
 #ifdef CONFIG_ACPI
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 5226323e55d3..3c7e0c9d6baf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -467,7 +467,7 @@ nouveau_fbcon_set_suspend_work(struct work_struct *work)
 	if (state == FBINFO_STATE_RUNNING) {
 		nouveau_fbcon_hotplug_resume(drm->fbcon);
 		pm_runtime_mark_last_busy(drm->dev->dev);
-		pm_runtime_put_sync(drm->dev->dev);
+		pm_runtime_put_autosuspend(drm->dev->dev);
 	}
 }
 

