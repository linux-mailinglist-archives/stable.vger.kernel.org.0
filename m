Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB26E6467
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjDRMs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjDRMsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCD11544C
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB13E6326B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FA8C4339B;
        Tue, 18 Apr 2023 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822114;
        bh=76JEB8B+ffeW5lKj1shZ3Oh+S8yHioOzXCNOOvpndbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1Szes4cp8is8XQEE9+Lzyl8cuED5kG2VRT7VyIJbXzBmdJdbhh+CRwxx23N4OvtQ
         ypIrMmDMxtnGWU14NbAn8AZIjblDvmuEhxv3ZeFuHk5kPv9HL/0y5xQqlYQ6O19sCT
         APbODTxi0HLWv//aOC2kWxC6n5qu8g1xK7CDCoo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Vetter <daniel.vetter@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Helge Deller <deller@gmx.de>, Xingyuan Mo <hdthky0@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6.2 027/139] fbcon: set_con2fb_map needs to set con2fb_map!
Date:   Tue, 18 Apr 2023 14:21:32 +0200
Message-Id: <20230418120314.669748026@linuxfoundation.org>
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

commit fffb0b52d5258554c645c966c6cbef7de50b851d upstream.

I got really badly confused in d443d9386472 ("fbcon: move more common
code into fb_open()") because we set the con2fb_map before the failure
points, which didn't look good.

But in trying to fix that I moved the assignment into the wrong path -
we need to do it for _all_ vc we take over, not just the first one
(which additionally requires the call to con2fb_acquire_newinfo).

I've figured this out because of a KASAN bug report, where the
fbcon_registered_fb and fbcon_display arrays went out of sync in
fbcon_mode_deleted() because the con2fb_map pointed at the old
fb_info, but the modes and everything was updated for the new one.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Helge Deller <deller@gmx.de>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Fixes: d443d9386472 ("fbcon: move more common code into fb_open()")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -846,10 +846,11 @@ static int set_con2fb_map(int unit, int
 		if (err)
 			return err;
 
-		con2fb_map[unit] = newidx;
 		fbcon_add_cursor_work(info);
 	}
 
+	con2fb_map[unit] = newidx;
+
 	/*
 	 * If old fb is not mapped to any of the consoles,
 	 * fbcon should release it.


