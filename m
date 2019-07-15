Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87F6968B
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbfGOOGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733180AbfGOOGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:06:34 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA14F217D8;
        Mon, 15 Jul 2019 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199593;
        bh=1BP7zLJgItJyjAFPi5zPirlSmCu7VB9XYI7DzUuL87s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEerjeWWB/7bk8G2qq2ic9vzUbBNOr2nRv8lJPKcg7sVvPIhJvXEN/nq8fjIdRzsO
         nC/OBinlfHlEFX0lGeRmgkKOEN3Fhw+Mv/Gm+pufaMAs25YQF0Z1OE7jjSin0dGcyc
         LOFDKIoQJqN58vSUCN979KLzN56I7OMEX++1jWyY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 050/219] tua6100: Avoid build warnings.
Date:   Mon, 15 Jul 2019 10:00:51 -0400
Message-Id: <20190715140341.6443-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

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
index b233b7be0b84..e6aaf4973aef 100644
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

