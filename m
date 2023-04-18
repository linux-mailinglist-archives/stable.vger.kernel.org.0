Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FA36E6468
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjDRMs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjDRMsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863C715A22
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE8162120
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36278C433D2;
        Tue, 18 Apr 2023 12:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822111;
        bh=1domRJC5oA8iw/412KgCkjLcJGiBLfTKxMBj5hryJ+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJB75CUQZJs6EUIUOWBGkD0aqeIkDmw4sLR3i5wMF2F2cG34dHHSMJdumtpyiec8z
         mpsAkCh73Ypv6BluJWWy78mhUb0nI1eR1/T+mklPR42zwe1vYfe2Ooza+tr+HSxFrW
         5nru8cmaNuKkx9E6dBp/fxKVImN6orKdT7T2EflM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Vetter <daniel.vetter@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Helge Deller <deller@gmx.de>, Xingyuan Mo <hdthky0@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6.2 026/139] fbcon: Fix error paths in set_con2fb_map
Date:   Tue, 18 Apr 2023 14:21:31 +0200
Message-Id: <20230418120314.634298456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit edf79dd2172233452ff142dcc98b19d955fc8974 upstream.

This is a regressoin introduced in b07db3958485 ("fbcon: Ditch error
handling for con2fb_release_oldinfo"). I failed to realize what the if
(!err) checks. The mentioned commit was dropping the
con2fb_release_oldinfo() return value but the if (!err) was also
checking whether the con2fb_acquire_newinfo() function call above
failed or not.

Fix this with an early return statement.

Note that there's still a difference compared to the orginal state of
the code, the below lines are now also skipped on error:

	if (!search_fb_in_map(info_idx))
		info_idx = newidx;

These are only needed when we've actually thrown out an old fb_info
from the console mappings, which only happens later on.

Also move the fbcon_add_cursor_work() call into the same if block,
it's all protected by console_lock so doesn't matter when we set up
the blinking cursor delayed work anyway. This further simplifies the
control flow and allows us to ditch the found local variable.

v2: Clarify commit message (Javier)

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Helge Deller <deller@gmx.de>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Fixes: b07db3958485 ("fbcon: Ditch error handling for con2fb_release_oldinfo")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -823,7 +823,7 @@ static int set_con2fb_map(int unit, int
 	int oldidx = con2fb_map[unit];
 	struct fb_info *info = fbcon_registered_fb[newidx];
 	struct fb_info *oldinfo = NULL;
-	int found, err = 0, show_logo;
+	int err = 0, show_logo;
 
 	WARN_CONSOLE_UNLOCKED();
 
@@ -841,26 +841,25 @@ static int set_con2fb_map(int unit, int
 	if (oldidx != -1)
 		oldinfo = fbcon_registered_fb[oldidx];
 
-	found = search_fb_in_map(newidx);
-
-	if (!err && !found) {
+	if (!search_fb_in_map(newidx)) {
 		err = con2fb_acquire_newinfo(vc, info, unit);
-		if (!err)
-			con2fb_map[unit] = newidx;
+		if (err)
+			return err;
+
+		con2fb_map[unit] = newidx;
+		fbcon_add_cursor_work(info);
 	}
 
 	/*
 	 * If old fb is not mapped to any of the consoles,
 	 * fbcon should release it.
 	 */
-	if (!err && oldinfo && !search_fb_in_map(oldidx))
+	if (oldinfo && !search_fb_in_map(oldidx))
 		con2fb_release_oldinfo(vc, oldinfo, info);
 
 	show_logo = (fg_console == 0 && !user &&
 			 logo_shown != FBCON_LOGO_DONTSHOW);
 
-	if (!found)
-		fbcon_add_cursor_work(info);
 	con2fb_map_boot[unit] = newidx;
 	con2fb_init_display(vc, info, unit, show_logo);
 


