Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFD0591A61
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbiHMMwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiHMMwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3318514D37
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D8F60D2F
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1C9C433D6;
        Sat, 13 Aug 2022 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395168;
        bh=zs14qoWKLBc4MmszQMoWHoS4ZoXSbFJYdrWgTXgDGT0=;
        h=Subject:To:Cc:From:Date:From;
        b=hL77b6upl8AjET69ycz6PPGgSi/f2RaJuzZNUIRb9BD9C8fDmmuGfHuqUfs5xnoZG
         j2RCP6WrZglxnUVRF7X3o5Ai2RWhxrSUSR0NSHg1R8zjcGGvoZrornMpueRwyAlGyr
         nUH7dKp2m9rPXi7UxK5R+Oa6YN9XVFjScYCxPNPY=
Subject: FAILED: patch "[PATCH] drm/nouveau/acpi: Don't print error when we get -EINPROGRESS" failed to apply to 5.4-stable tree
To:     lyude@redhat.com, airlied@linux.ie, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:52:37 +0200
Message-ID: <1660395157165172@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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

