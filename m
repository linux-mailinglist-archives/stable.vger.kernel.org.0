Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7359763E0C1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiK3T1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiK3T1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:27:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B299862DD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34C1861D9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C344C4314B;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669836417;
        bh=znC7oc0Eqelv+AbWaBkIcUV8ibH0DJjHig+VBhzLfbw=;
        h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
        b=S9iSDjUIMgQ35QEufOO6jpQQbfHrb++POF4slN/kK1RX6heM4J1s94hoE8h7prnf4
         1s0U+VFyvpCasBXZdA7lpRUBCHl3jmAEVNB0eqV35K6VoQ/jmoUWMlup+o3GEhdmM6
         2v5Hov/FLATMPYBRIFXcZUeTMHMPu1bqtku7kqMjOo8rdJg3Vc5Tavc2oloaSZKLAY
         Diwnf89ECkyF6uRbpjgS+LgyGd4HRLoRKrMdCB40i0y7RyoER601nC0vSHKImfslJA
         cvdjApLzXWyRNx/wCFlNvu8aAqjiP1HZguFpA+LjJTBI/KZFJGUyniDaXJGaGFtvO6
         IkmZgr6pq4DYA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 3537BC4708C;
        Wed, 30 Nov 2022 19:26:57 +0000 (UTC)
From:   Noralf =?utf-8?q?Tr=C3=B8nnes?= via B4 Submission Endpoint 
        <devnull+noralf.tronnes.org@kernel.org>
Date:   Wed, 30 Nov 2022 20:26:54 +0100
Subject: [PATCH v2 6/6] drm/gud: Enable synchronous flushing by default
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221122-gud-shadow-plane-v2-6-435037990a83@tronnes.org>
References: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
In-Reply-To: <20221122-gud-shadow-plane-v2-0-435037990a83@tronnes.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>, stable@kernel.org,
        Noralf =?unknown-8bit?q?Tr=C3=B8nnes?= <noralf@tronnes.org>
X-Mailer: b4 0.11.0-dev-cc6f6
X-Developer-Signature: v=1; a=ed25519-sha256; t=1669836415; l=2023;
 i=noralf@tronnes.org; s=20221122; h=from:subject:message-id;
 bh=h2o+XqMBQHUWEJfpLcc+HZU/hC6MAxxmg8TWrtkZl5c=; =?utf-8?q?b=3DPVR2ctkGVWUa?=
 =?utf-8?q?qtpGxbUgZ6431+rt3RQPRUMnZWnZ7iu59dZF437cyLiFf+lDYBYV9Ety0wLM71xE?=
 NwFjFV4RAr/uKnDq6ZbyeWe5J2FCEiZAER7z/jH+5e/qUwVYAyjZ
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

gud has a module parameter that controls whether framebuffer flushing
happens synchronously during the commit or asynchronously in a worker.

GNOME before version 3.38 handled all displays in the same rendering loop.
This lead to gud slowing down the refresh rate for a faster monitor. This
has now been fixed so lets change the default.

The plan is to remove async flushing in the future. The code is now
structured in a way that makes it easy to do this.

Link: https://blogs.gnome.org/shell-dev/2020/07/02/splitting-up-the-frame-clock/
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/gpu/drm/gud/gud_pipe.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/gud/gud_pipe.c b/drivers/gpu/drm/gud/gud_pipe.c
index 92189474a7ed..62c43d3632d4 100644
--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -25,17 +25,13 @@
 #include "gud_internal.h"
 
 /*
- * Some userspace rendering loops runs all displays in the same loop.
+ * Some userspace rendering loops run all displays in the same loop.
  * This means that a fast display will have to wait for a slow one.
- * For this reason gud does flushing asynchronous by default.
- * The down side is that in e.g. a single display setup userspace thinks
- * the display is insanely fast since the driver reports back immediately
- * that the flush/pageflip is done. This wastes CPU and power.
- * Such users might want to set this module parameter to false.
+ * Such users might want to enable this module parameter.
  */
-static bool gud_async_flush = true;
+static bool gud_async_flush;
 module_param_named(async_flush, gud_async_flush, bool, 0644);
-MODULE_PARM_DESC(async_flush, "Enable asynchronous flushing [default=true]");
+MODULE_PARM_DESC(async_flush, "Enable asynchronous flushing [default=0]");
 
 /*
  * FIXME: The driver is probably broken on Big Endian machines.

-- 
2.34.1
