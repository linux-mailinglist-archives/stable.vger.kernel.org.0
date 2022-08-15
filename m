Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9059435E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244911AbiHOWMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346791AbiHOWKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:10:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFDC11A2EF;
        Mon, 15 Aug 2022 12:38:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8418ACE12C4;
        Mon, 15 Aug 2022 19:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C428C433C1;
        Mon, 15 Aug 2022 19:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592300;
        bh=V1Q9LMJoIqpGyydO3a1zid7QGNBisxqlZD0J0mhVsWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAC7oPGaBF9SX1agSG2cBN8Xl+8BWYiQSu8YSQC/liH4wloTNOaNNeGl3yoRJyM/E
         GZaNDgUG8vqEPCJYoD6oAbhp4UQv2XPV9cIiHG3hZyIAxwlopxz7dNk3e/KpGcQOpT
         4CHGgpx3YDnsesOXEfHvM9nmad1Kzi3GrrwHwSis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.19 0090/1157] drm/nouveau: Dont pm_runtime_put_sync(), only pm_runtime_put_autosuspend()
Date:   Mon, 15 Aug 2022 19:50:46 +0200
Message-Id: <20220815180443.180446825@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit c96cfaf8fc02d4bb70727dfa7ce7841a3cff9be2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -515,7 +515,7 @@ nouveau_display_hpd_work(struct work_str
 
 	pm_runtime_mark_last_busy(drm->dev->dev);
 noop:
-	pm_runtime_put_sync(drm->dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
 }
 
 #ifdef CONFIG_ACPI
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -466,7 +466,7 @@ nouveau_fbcon_set_suspend_work(struct wo
 	if (state == FBINFO_STATE_RUNNING) {
 		nouveau_fbcon_hotplug_resume(drm->fbcon);
 		pm_runtime_mark_last_busy(drm->dev->dev);
-		pm_runtime_put_sync(drm->dev->dev);
+		pm_runtime_put_autosuspend(drm->dev->dev);
 	}
 }
 


