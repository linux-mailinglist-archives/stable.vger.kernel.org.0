Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1DC55AA7
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfFYWLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:11:15 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37241 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 18:11:15 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A500C886BF;
        Wed, 26 Jun 2019 10:11:10 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1561500670;
        bh=VTKifGQSMyc0p8/UOeOVCWiP56S29r6HjQ7HWgB/EdQ=;
        h=From:To:Cc:Subject:Date;
        b=bT4Fj73ZBuGvjDiyU+LMqCObw5RXXmExUTt/4AeCdqw36yJObKg0RkS9SiC5YyFXI
         6EqMeU7YYZRHycl+uh3pCvufEhWzCtZL82Wwnbo9/5t6cTwfGmaiiPUsrbkSCjiI4L
         /SJ0XG3bsl3bTxeeYaaiWmaTVWrcB9popHaCpol312js7B8zLXxlSr094rpFgfA/0x
         xD59A17g5RL4ePwrY54cLZg+Plbc7hZCqprvb1SP1hf2FqKTVjsVzMVIG3WZ7vtLxF
         9CTZ8GRgCMFE16qNhJTKoJWikQRxdlHsQEiMoL0Ocq3R43QiAmFeZ/X7RyXFPC2Lzx
         vtwDcNSt+1Dpw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d129bfd0000>; Wed, 26 Jun 2019 10:11:09 +1200
Received: from joshuas-dl.ws.atlnz.lc (joshuas-dl.ws.atlnz.lc [10.33.13.27])
        by smtp (Postfix) with ESMTP id BD3D813EED3;
        Wed, 26 Jun 2019 10:11:11 +1200 (NZST)
Received: by joshuas-dl.ws.atlnz.lc (Postfix, from userid 1634)
        id 5863F1A0472; Wed, 26 Jun 2019 10:11:10 +1200 (NZST)
From:   Joshua Scott <joshua.scott@alliedtelesis.co.nz>
To:     linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     Joshua Scott <joshua.scott@alliedtelesis.co.nz>,
        stable@vger.kernel.org
Subject: [PATCH v3] ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node
Date:   Wed, 26 Jun 2019 10:11:08 +1200
Message-Id: <20190625221108.21455-1-joshua.scott@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Switch to the "marvell,armada-38x-uart" driver variant to empty
the UART buffer before writing to the UART_LCR register.

Signed-off-by: Joshua Scott <joshua.scott@alliedtelesis.co.nz>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>.
Cc: stable@vger.kernel.org
Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp=
-98dx3236")

---
Changes in v3:

Updated title, added tested-by, and Fixes tag

Changes in v2:

Andrew Lunn was able to test on a Marvell 370RD reference design, and
the character loss issue did not occur.

The fix has now been changed to only affect the following SOCs:
 * 98DX323x
 * 98DX3333
 * 98DX4251

v1 message:

We have found that like the armada 38x, other Marvell SOCs can lose
characters when the UART_LCR register is written to without first
waiting for the buffer to empty.

We have observed this behaviour on the following Marvell switch SOCs:

 * 98DX323x
 * 98DX3333
 * 98DX4251

However, we do not currently have access to non-switch SOCs which share
the same parent device-tree.

The question we have is, should the fix be applied to the common
armada-370-xp device-tree, or should it be restricted to only affect the
SOCs listed above.

If anybody is able to check, we would like to find out if the issue
affects other armada-xp / armada-370 based SOCs.

The issue can be reproduced, if logging in using the serial port, with:
    resize && echo "hello world"

On affected devices, the first couple letters of "hello world" are
lost. On some SOCs this can be seen at 115200 baud, and on others
we have had to slow down to 9600 to see the issue.

Cheers,
Joshua Scott
---
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi b/arch/arm/boot/dt=
s/armada-xp-98dx3236.dtsi
index 59753470cd34..267d0c178e55 100644
--- a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
+++ b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
@@ -336,3 +336,11 @@
 	status =3D "disabled";
 };
=20
+&uart0 {
+	compatible =3D "marvell,armada-38x-uart";
+};
+
+&uart1 {
+	compatible =3D "marvell,armada-38x-uart";
+};
+
--=20
2.21.0

