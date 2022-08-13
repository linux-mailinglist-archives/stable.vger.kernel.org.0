Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF22591A64
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbiHMMw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiHMMw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBE814D37
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CAD1609D0
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A09AC433D6;
        Sat, 13 Aug 2022 12:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395176;
        bh=dAJeLsHSMWNibcFRkW3FwLA1umb4xZjZGaIbirPfBf8=;
        h=Subject:To:Cc:From:Date:From;
        b=o4FJCfvKoB48yLdZS4NYc4cqg27SBcqAkb7zgF/4U90kW24QvClyjxEiMCZpX1+N1
         Po4eKNRU1rTtraPG2bp2RmBCl/EtL68PKILVN7OuOwGY4z/GteqqPrlvDcDVwFZegk
         gZNKT9bc0hfhh6WOcJzJS/UUESFzWOkUXzIwLjhM=
Subject: FAILED: patch "[PATCH] drm/nouveau/acpi: Don't print error when we get -EINPROGRESS" failed to apply to 4.9-stable tree
To:     lyude@redhat.com, airlied@linux.ie, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:52:39 +0200
Message-ID: <166039515976137@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 53c26181950ddc3c8ace3c0939c89e9c4d8deeb9 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Thu, 14 Jul 2022 13:42:33 -0400
Subject: [PATCH] drm/nouveau/acpi: Don't print error when we get -EINPROGRESS
 from pm_runtime

Since this isn't actually a failure.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: David Airlie <airlied@linux.ie>
Fixes: 79e765ad665d ("drm/nouveau/drm/nouveau: Prevent handling ACPI HPD events too early")
Cc: <stable@vger.kernel.org> # v4.19+
Link: https://patchwork.freedesktop.org/patch/msgid/20220714174234.949259-2-lyude@redhat.com

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 2cd0932b3d68..9f5a45f24e5b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -537,7 +537,7 @@ nouveau_display_acpi_ntfy(struct notifier_block *nb, unsigned long val,
 				 * it's own hotplug events.
 				 */
 				pm_runtime_put_autosuspend(drm->dev->dev);
-			} else if (ret == 0) {
+			} else if (ret == 0 || ret == -EINPROGRESS) {
 				/* We've started resuming the GPU already, so
 				 * it will handle scheduling a full reprobe
 				 * itself

