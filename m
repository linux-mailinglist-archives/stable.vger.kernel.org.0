Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB242012A0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388839AbgFSPyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388811AbgFSPWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D0D21927;
        Fri, 19 Jun 2020 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580119;
        bh=9Xe4Sx5w74/rmD8c1252EWSqEacJPDGX8bb4wGGi3ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKe2TS/1r45fjiyASEUfCNBXMtcDxGpLvxQBflgzXyx/H5CEJxESWm9AiLuXAT6GG
         iXnnvSM2mJwPEETwE7szEDaXLN+qToCtFBb4VFDyMWHpe8jk7VaHnAc5h1rHL5z9Rw
         IdXHlqddSldpZztq0ZWjnOx0bR28jnXvmqgeSbAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 130/376] drm/bridge: fix stack usage warning on old gcc
Date:   Fri, 19 Jun 2020 16:30:48 +0200
Message-Id: <20200619141716.488320804@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 78b0d99a68ecdc84728c99f4fef71942e9ecf35a ]

Some older versions of gcc badly optimize code that passes
an inline function argument into another function by reference,
causing huge stack usage:

drivers/gpu/drm/bridge/tc358768.c: In function 'tc358768_bridge_pre_enable':
drivers/gpu/drm/bridge/tc358768.c:840:1: error: the frame size of 2256 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Use a temporary variable as a workaround and add a comment pointing
to the gcc bug.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200428215408.4111675-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index 1b39e8d37834..6650fe4cfc20 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -178,6 +178,8 @@ static int tc358768_clear_error(struct tc358768_priv *priv)
 
 static void tc358768_write(struct tc358768_priv *priv, u32 reg, u32 val)
 {
+	/* work around https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+	int tmpval = val;
 	size_t count = 2;
 
 	if (priv->error)
@@ -187,7 +189,7 @@ static void tc358768_write(struct tc358768_priv *priv, u32 reg, u32 val)
 	if (reg < 0x100 || reg >= 0x600)
 		count = 1;
 
-	priv->error = regmap_bulk_write(priv->regmap, reg, &val, count);
+	priv->error = regmap_bulk_write(priv->regmap, reg, &tmpval, count);
 }
 
 static void tc358768_read(struct tc358768_priv *priv, u32 reg, u32 *val)
-- 
2.25.1



