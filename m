Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C8360889A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbiJVIUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiJVIS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:18:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532962CCA2E;
        Sat, 22 Oct 2022 00:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F67B82E0F;
        Sat, 22 Oct 2022 07:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95192C433C1;
        Sat, 22 Oct 2022 07:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424533;
        bh=yMjsvMrwdteaqkm298N96x25owWkPZMp9jiYpvA0zcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEXdAFJaoxPt/KzXnu989Z4E/Kr6g5yXLuSeG3FzRP/AbobYKlcrYvEbhPbN3ulJH
         uUphkDxofe8yxpuBcOcm6IqGBizr0xsbKJCkBVjhAyEnD4yrr/k2Tx5erizOE79Sqx
         9HKFyvTf8RuCk/dbuFdTkB6Dxdznb+smsARu1osA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>, stable <stable@kernel.org>
Subject: [PATCH 5.19 164/717] staging: greybus: audio_helper: remove unused and wrong debugfs usage
Date:   Sat, 22 Oct 2022 09:20:43 +0200
Message-Id: <20221022072444.515361630@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d517cdeb904ddc0cbebcc959d43596426cac40b0 upstream.

In the greybus audio_helper code, the debugfs file for the dapm has the
potential to be removed and memory will be leaked.  There is also the
very real potential for this code to remove ALL debugfs entries from the
system, and it seems like this is what will really happen if this code
ever runs.  This all is very wrong as the greybus audio driver did not
create this debugfs file, the sound core did and controls the lifespan
of it.

So remove all of the debugfs logic from the audio_helper code as there's
no way it could be correct.  If this really is needed, it can come back
with a fixup for the incorrect usage of the debugfs_lookup() call which
is what caused this to be noticed at all.

Cc: Johan Hovold <johan@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220902143715.320500-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/audio_helper.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -3,7 +3,6 @@
  * Greybus Audio Sound SoC helper APIs
  */
 
-#include <linux/debugfs.h>
 #include <sound/core.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
@@ -116,10 +115,6 @@ int gbaudio_dapm_free_controls(struct sn
 {
 	int i;
 	struct snd_soc_dapm_widget *w, *next_w;
-#ifdef CONFIG_DEBUG_FS
-	struct dentry *parent = dapm->debugfs_dapm;
-	struct dentry *debugfs_w = NULL;
-#endif
 
 	mutex_lock(&dapm->card->dapm_mutex);
 	for (i = 0; i < num; i++) {
@@ -139,12 +134,6 @@ int gbaudio_dapm_free_controls(struct sn
 			continue;
 		}
 		widget++;
-#ifdef CONFIG_DEBUG_FS
-		if (!parent)
-			debugfs_w = debugfs_lookup(w->name, parent);
-		debugfs_remove(debugfs_w);
-		debugfs_w = NULL;
-#endif
 		gbaudio_dapm_free_widget(w);
 	}
 	mutex_unlock(&dapm->card->dapm_mutex);


