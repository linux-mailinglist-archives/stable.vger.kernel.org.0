Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8070E3D2906
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhGVQAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhGVQAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE6D760E0C;
        Thu, 22 Jul 2021 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972038;
        bh=bxp28ytE6JLkgpD5YkX0/KOLSOb7QxiwSiht3C8xOdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPBrPcrWOP20vT0LAVx+WaZ7PxCDOqY1o0cZxuUxwS6ObrRvL4kyKjj7am/3YpvrG
         YWlsIzUoDF9pLiWkQnhaEA3I/SgMG+I49CFjuP1b621blMhKvoxeCci5nk2gAhD2xG
         5RsXEr3SlH1bWhbONRcUiBQyN7OYegprMYlb3pxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        newbyte@disroot.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 124/125] drm/panel: nt35510: Do not fail if DSI read fails
Date:   Thu, 22 Jul 2021 18:31:55 +0200
Message-Id: <20210722155628.826965016@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 1988e0d84161dabd99d1c27033fbd6ee439bf432 upstream.

Failing to read the MTP over DSI should not bring down the
system and make us bail out from using the display, it turns
out that this happens when toggling the display off and on,
and that write is often still working so the display output
is just fine. Printing an error is enough.

Tested by killing the Gnome session repeatedly on the
Samsung Skomer.

Fixes: 899f24ed8d3a ("drm/panel: Add driver for Novatek NT35510-based panels")
Cc: Stephan Gerhold <stephan@gerhold.net>
Reported-by: newbyte@disroot.org
Acked-by: Stefan Hansson <newbyte@disroot.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210603231830.3200040-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35510.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/panel/panel-novatek-nt35510.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35510.c
@@ -706,9 +706,7 @@ static int nt35510_power_on(struct nt355
 	if (ret)
 		return ret;
 
-	ret = nt35510_read_id(nt);
-	if (ret)
-		return ret;
+	nt35510_read_id(nt);
 
 	/* Set up stuff in  manufacturer control, page 1 */
 	ret = nt35510_send_long(nt, dsi, MCS_CMD_MAUCCTR,


