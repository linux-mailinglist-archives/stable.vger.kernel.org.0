Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F3D431E1D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhJRN5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234379AbhJRNzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7116161A09;
        Mon, 18 Oct 2021 13:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564413;
        bh=kwp69nCicNMGTGijpilK/aeFbRLe8dLyuEcvNpJsi54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqvlK5oFA5yOEB/LXCY4Q1LF17OQr3YcCoMghYWyQc9KZ/yUxTDBugr9vYOnMs8q7
         Uaz8/wb7wfu6nqoAR/fbQpiULYxHDZHmJn1vz6eMzjeLFJcs5bOGRuTdn3GQNY1/3t
         7MPtpWFr7nWf/5O4pGQXjwG9RwTfTPAElmT2M10E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.14 081/151] Input: resistive-adc-touch - fix division by zero error on z1 == 0
Date:   Mon, 18 Oct 2021 15:24:20 +0200
Message-Id: <20211018132343.325869282@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit fe0a7e3d012738b0034b3c97ddb0e8bc0a3ff0e6 upstream.

For proper pressure calculation we need at least x and z1 to be non
zero. Even worse, in case z1 we may run in to division by zero
error.

Fixes: 60b7db914ddd ("Input: resistive-adc-touch - rework mapping of channels")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20211007095727.29579-1-o.rempel@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/resistive-adc-touch.c |   29 +++++++++++++-----------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/drivers/input/touchscreen/resistive-adc-touch.c
+++ b/drivers/input/touchscreen/resistive-adc-touch.c
@@ -71,19 +71,22 @@ static int grts_cb(const void *data, voi
 		unsigned int z2 = touch_info[st->ch_map[GRTS_CH_Z2]];
 		unsigned int Rt;
 
-		Rt = z2;
-		Rt -= z1;
-		Rt *= st->x_plate_ohms;
-		Rt = DIV_ROUND_CLOSEST(Rt, 16);
-		Rt *= x;
-		Rt /= z1;
-		Rt = DIV_ROUND_CLOSEST(Rt, 256);
-		/*
-		 * On increased pressure the resistance (Rt) is decreasing
-		 * so, convert values to make it looks as real pressure.
-		 */
-		if (Rt < GRTS_DEFAULT_PRESSURE_MAX)
-			press = GRTS_DEFAULT_PRESSURE_MAX - Rt;
+		if (likely(x && z1)) {
+			Rt = z2;
+			Rt -= z1;
+			Rt *= st->x_plate_ohms;
+			Rt = DIV_ROUND_CLOSEST(Rt, 16);
+			Rt *= x;
+			Rt /= z1;
+			Rt = DIV_ROUND_CLOSEST(Rt, 256);
+			/*
+			 * On increased pressure the resistance (Rt) is
+			 * decreasing so, convert values to make it looks as
+			 * real pressure.
+			 */
+			if (Rt < GRTS_DEFAULT_PRESSURE_MAX)
+				press = GRTS_DEFAULT_PRESSURE_MAX - Rt;
+		}
 	}
 
 	if ((!x && !y) || (st->pressure && (press < st->pressure_min))) {


