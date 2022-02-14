Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2FE4B494A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344979AbiBNKH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:07:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345957AbiBNKHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F314474DFD;
        Mon, 14 Feb 2022 01:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2052B80DC6;
        Mon, 14 Feb 2022 09:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE517C340F3;
        Mon, 14 Feb 2022 09:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832193;
        bh=3UEe5fMMHX7Zx1snaaS1yRSYxwXrqkfm5SBnrj3gR2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLTS1u8/e1ITZyZy9zB+kivGSiJlKUS/k5qZezYyrx4mWyivosXMy4oKQ/jrYLIkJ
         F/dSYR5ezYYeu7IW86UP+l0zLHPk3iJKw1Is61qFEyXIBXyfcIF0P/JZ7F4VbOa5h6
         n+7/O1GJ6aK+hu4Xs59te8FbpfCOHX1pdCFrQMVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Helge Deller <deller@gmx.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/172] fbcon: Avoid cap set but not used warning
Date:   Mon, 14 Feb 2022 10:26:07 +0100
Message-Id: <20220214092510.192509674@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 50b10528aad568c95f772039d4b3093b4aea7439 ]

Fix this kernel test robot warning:

  drivers/video/fbdev/core/fbcon.c: In function 'fbcon_init':
  drivers/video/fbdev/core/fbcon.c:1028:6: warning: variable 'cap' set but not used [-Wunused-but-set-variable]

The cap variable is only used when CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
is enabled. Drop the temporary variable and use info->flags instead.

Fixes: 87ab9f6b7417 ("Revert "fbcon: Disable accelerated scrolling")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/YgFB4xqI+As196FR@p100
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index f7b7d35953e81..a53c1f6906f09 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1025,7 +1025,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 	struct vc_data *svc = *default_mode;
 	struct fbcon_display *t, *p = &fb_display[vc->vc_num];
 	int logo = 1, new_rows, new_cols, rows, cols;
-	int cap, ret;
+	int ret;
 
 	if (WARN_ON(info_idx == -1))
 	    return;
@@ -1034,7 +1034,6 @@ static void fbcon_init(struct vc_data *vc, int init)
 		con2fb_map[vc->vc_num] = info_idx;
 
 	info = registered_fb[con2fb_map[vc->vc_num]];
-	cap = info->flags;
 
 	if (logo_shown < 0 && console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
 		logo_shown = FBCON_LOGO_DONTSHOW;
@@ -1137,8 +1136,8 @@ static void fbcon_init(struct vc_data *vc, int init)
 	ops->graphics = 0;
 
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
-	if ((cap & FBINFO_HWACCEL_COPYAREA) &&
-	    !(cap & FBINFO_HWACCEL_DISABLED))
+	if ((info->flags & FBINFO_HWACCEL_COPYAREA) &&
+	    !(info->flags & FBINFO_HWACCEL_DISABLED))
 		p->scrollmode = SCROLL_MOVE;
 	else /* default to something safe */
 		p->scrollmode = SCROLL_REDRAW;
-- 
2.34.1



