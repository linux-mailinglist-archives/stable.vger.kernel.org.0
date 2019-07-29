Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3F5799B9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfG2TY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfG2TYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:24:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9B221773;
        Mon, 29 Jul 2019 19:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428291;
        bh=tZB9Gyskz1FEISTkY/HUZLGh9BvMKzYiGk48nclEAFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnbBM35Za6wh1NPYXSTSGlHiU4y6PVax8Qo6TgVdI1dmgrKnQar3sO83FRspkorx5
         QBINcYaQkPk5Pb4uKeMTLnQaiuu1hOO/pyxtmqTlfGW6OCOiTnhLrUvORW4+nWr5GX
         5XeuWvEL2KdSxZMzX26+Rx7mchEeTTtM2EzRnwr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 030/293] tua6100: Avoid build warnings.
Date:   Mon, 29 Jul 2019 21:18:41 +0200
Message-Id: <20190729190824.087382719@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 621ccc6cc5f8d6730b740d31d4818227866c93c9 ]

Rename _P to _P_VAL and _R to _R_VAL to avoid global
namespace conflicts:

drivers/media/dvb-frontends/tua6100.c: In function ‘tua6100_set_params’:
drivers/media/dvb-frontends/tua6100.c:79: warning: "_P" redefined
 #define _P 32

In file included from ./include/acpi/platform/aclinux.h:54,
                 from ./include/acpi/platform/acenv.h:152,
                 from ./include/acpi/acpi.h:22,
                 from ./include/linux/acpi.h:34,
                 from ./include/linux/i2c.h:17,
                 from drivers/media/dvb-frontends/tua6100.h:30,
                 from drivers/media/dvb-frontends/tua6100.c:32:
./include/linux/ctype.h:14: note: this is the location of the previous definition
 #define _P 0x10 /* punct */

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/tua6100.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 18e6d4c5be21..859fa14b319c 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -75,8 +75,8 @@ static int tua6100_set_params(struct dvb_frontend *fe)
 	struct i2c_msg msg1 = { .addr = priv->i2c_address, .flags = 0, .buf = reg1, .len = 4 };
 	struct i2c_msg msg2 = { .addr = priv->i2c_address, .flags = 0, .buf = reg2, .len = 3 };
 
-#define _R 4
-#define _P 32
+#define _R_VAL 4
+#define _P_VAL 32
 #define _ri 4000000
 
 	// setup register 0
@@ -91,14 +91,14 @@ static int tua6100_set_params(struct dvb_frontend *fe)
 	else
 		reg1[1] = 0x0c;
 
-	if (_P == 64)
+	if (_P_VAL == 64)
 		reg1[1] |= 0x40;
 	if (c->frequency >= 1525000)
 		reg1[1] |= 0x80;
 
 	// register 2
-	reg2[1] = (_R >> 8) & 0x03;
-	reg2[2] = _R;
+	reg2[1] = (_R_VAL >> 8) & 0x03;
+	reg2[2] = _R_VAL;
 	if (c->frequency < 1455000)
 		reg2[1] |= 0x1c;
 	else if (c->frequency < 1630000)
@@ -110,18 +110,18 @@ static int tua6100_set_params(struct dvb_frontend *fe)
 	 * The N divisor ratio (note: c->frequency is in kHz, but we
 	 * need it in Hz)
 	 */
-	prediv = (c->frequency * _R) / (_ri / 1000);
-	div = prediv / _P;
+	prediv = (c->frequency * _R_VAL) / (_ri / 1000);
+	div = prediv / _P_VAL;
 	reg1[1] |= (div >> 9) & 0x03;
 	reg1[2] = div >> 1;
 	reg1[3] = (div << 7);
-	priv->frequency = ((div * _P) * (_ri / 1000)) / _R;
+	priv->frequency = ((div * _P_VAL) * (_ri / 1000)) / _R_VAL;
 
 	// Finally, calculate and store the value for A
-	reg1[3] |= (prediv - (div*_P)) & 0x7f;
+	reg1[3] |= (prediv - (div*_P_VAL)) & 0x7f;
 
-#undef _R
-#undef _P
+#undef _R_VAL
+#undef _P_VAL
 #undef _ri
 
 	if (fe->ops.i2c_gate_ctrl)
-- 
2.20.1



