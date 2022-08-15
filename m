Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B68159461D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345447AbiHOWDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245296AbiHOV75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F65DDF;
        Mon, 15 Aug 2022 12:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A586361187;
        Mon, 15 Aug 2022 19:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9981EC433D6;
        Mon, 15 Aug 2022 19:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592091;
        bh=t3iB/2Yj1yWIBXjHaQU4ieYA3xkYdMWZDE4hvUfw3Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMoct8EmhT4CaxHoVDumzZOfO9DdicQ5EZEQP2nXgZ8XzjacGcxnqtV5IyjkVTfJP
         /4IPrPynUJWv/7gFYqflOmkgOcyp/9ni9kePd9o7rPCHqIu9rSlfyT+88fjk9Z6w9n
         dpkA96shdGtMig+Gf63S+sD13oPed1K2GAbtYfrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.19 0057/1157] fbcon: Fix accelerated fbdev scrolling while logo is still shown
Date:   Mon, 15 Aug 2022 19:50:13 +0200
Message-Id: <20220815180441.754835347@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 3866cba87dcd0162fb41e9b3b653d0af68fad5ec upstream.

There is no need to directly skip over to the SCROLL_REDRAW case while
the logo is still shown.

When using DRM, this change has no effect because the code will reach
the SCROLL_REDRAW case immediately anyway.

But if you run an accelerated fbdev driver and have
FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION enabled, console scrolling is
slowed down by factors so that it feels as if you use a 9600 baud
terminal.

So, drop those unnecessary checks and speed up fbdev console
acceleration during bootup.

Cc: stable@vger.kernel.org # v5.10+
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/YpkYxk7wsBPx3po+@p100
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1760,8 +1760,6 @@ static bool fbcon_scroll(struct vc_data
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
-		if (logo_shown >= 0)
-			goto redraw_up;
 		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, t, b - t - count,
@@ -1850,8 +1848,6 @@ static bool fbcon_scroll(struct vc_data
 	case SM_DOWN:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
-		if (logo_shown >= 0)
-			goto redraw_down;
 		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,


