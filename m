Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0A599FE5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350177AbiHSPtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350187AbiHSPsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:48:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E76F6612C;
        Fri, 19 Aug 2022 08:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1BCFB82813;
        Fri, 19 Aug 2022 15:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C09C433C1;
        Fri, 19 Aug 2022 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924044;
        bh=OW7MHJJDMB0ZPHKRR7yn4xxzHOtfzGu1ZHz4XFdGZCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlhjNrfHgE/21UTFqkR1qqFskOXsDfFGfdZrMjMxppM6Fy+y8DJbpKkHn+HihWWBF
         ZilpBcXK3/bn0R4TgQYnzr1rMINp1WUQm8gR0kH4bHOxNvVaMmTyaUqPO/bm7ZyWlz
         dPKcKU2mx2BDjVnLdQqdlOX71EBwnktQMNx1VQwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 036/545] fbcon: Fix accelerated fbdev scrolling while logo is still shown
Date:   Fri, 19 Aug 2022 17:36:46 +0200
Message-Id: <20220819153830.838404235@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
@@ -1719,8 +1719,6 @@ static bool fbcon_scroll(struct vc_data
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
-		if (logo_shown >= 0)
-			goto redraw_up;
 		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, t, b - t - count,
@@ -1809,8 +1807,6 @@ static bool fbcon_scroll(struct vc_data
 	case SM_DOWN:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
-		if (logo_shown >= 0)
-			goto redraw_down;
 		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,


