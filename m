Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48145934F6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiHOSSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbiHOSRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:17:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B74B7;
        Mon, 15 Aug 2022 11:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD47AB8106C;
        Mon, 15 Aug 2022 18:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC6AC433C1;
        Mon, 15 Aug 2022 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587311;
        bh=d0+uaXnzk2ajdnldlX+pjv1VYjPMK/590gVPt1rVsX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtWBUY2jtftIbQcGoXND4Z1xHJSwwPTeyoxqxM4XJnpj/tJwmBNuJS36ixoQWiNWK
         rU+o6HvTdTliyA9IgnKLuOZ5w2PULI4+1ycW3ihNhUAuanGgQx7nsBo9kBVODyZB8k
         g1+czifNltXz8FOjvfTtxUTn9HBrqh5Tckgp1XJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 044/779] fbcon: Fix accelerated fbdev scrolling while logo is still shown
Date:   Mon, 15 Aug 2022 19:54:48 +0200
Message-Id: <20220815180339.129054379@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -1706,8 +1706,6 @@ static bool fbcon_scroll(struct vc_data
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
-		if (logo_shown >= 0)
-			goto redraw_up;
 		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, t, b - t - count,
@@ -1796,8 +1794,6 @@ static bool fbcon_scroll(struct vc_data
 	case SM_DOWN:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
-		if (logo_shown >= 0)
-			goto redraw_down;
 		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,


