Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A4423A6E4
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgHCMzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgHCMW2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FCBB2076E;
        Mon,  3 Aug 2020 12:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457347;
        bh=4y2n0jy/N97pc+QEFGNpXS+JrtHgv7CaUW3acs2G54A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Jh8i7AdZehGmf/f0EoItYD0cUHdMwhaO/nlrGSZLE5fdU7dN7Ryt6oaYxMVE7Cx0
         u0g8D5ZnfWknBfvShI87oQ6mdxOmxE3G7dGflumGjN6MaAaLxm9jJ+dXqjU2WlTjCg
         TCI/RUL23hes2g1ygd6eGRnqJhepFyGjCLOVtWKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH 5.7 027/120] drm/mcde: Fix stability issue
Date:   Mon,  3 Aug 2020 14:18:05 +0200
Message-Id: <20200803121904.168818490@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit aa7bf898d4bf921f61fab078040e8baec3f28126 upstream.

Whenever a display update was sent, apart from updating
the memory base address, we called mcde_display_send_one_frame()
which also sent a command to the display requesting the TE IRQ
and enabling the FIFO.

When continuous updates are running this is wrong: we need
to only send this to start the flow to the display on
the very first update. This lead to the display pipeline
locking up and crashing.

Check if the flow is already running and in that case
do not call mcde_display_send_one_frame().

This fixes crashes on the Samsung GT-S7710 (Skomer).

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Stephan Gerhold <stephan@gerhold.net>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200718233323.3407670-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mcde/mcde_display.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/mcde/mcde_display.c
+++ b/drivers/gpu/drm/mcde/mcde_display.c
@@ -1060,9 +1060,14 @@ static void mcde_display_update(struct d
 	 */
 	if (fb) {
 		mcde_set_extsrc(mcde, drm_fb_cma_get_gem_addr(fb, pstate, 0));
-		if (!mcde->video_mode)
-			/* Send a single frame using software sync */
-			mcde_display_send_one_frame(mcde);
+		if (!mcde->video_mode) {
+			/*
+			 * Send a single frame using software sync if the flow
+			 * is not active yet.
+			 */
+			if (mcde->flow_active == 0)
+				mcde_display_send_one_frame(mcde);
+		}
 		dev_info_once(mcde->dev, "sent first display update\n");
 	} else {
 		/*


