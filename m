Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0583A7A8C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 07:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfIDFEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 01:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfIDFEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 01:04:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DC72339E;
        Wed,  4 Sep 2019 05:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567573486;
        bh=AzONJh3agZ7U5LiuXcD6cG97MHnD/wARmZk+Faomavw=;
        h=Subject:To:From:Date:From;
        b=I95/3phBmJwpYdIDEwHrp5ci9WBe9h7B4jyxaL6QG2VSPwLFkxRb+TfgOPYfiy+s6
         sOdIRnYAIpvJlI5Lnjpi3QI/bxJ9SLivOQO4VHD/j6CVgGXGRaJ3YsieP4rzTOUYw1
         gR66kA1VtdzuZmW76BZ4y/ax08lwMSkKVEA9QDgA=
Subject: patch "phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current" added to char-misc-next
To:     yoshihiro.shimoda.uh@renesas.com, kishon@ti.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Sep 2019 07:03:10 +0200
Message-ID: <1567573390233185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From e6839c31a608e79f2057fab987dd814f5d3477e6 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 6 Aug 2019 17:51:19 +0900
Subject: phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

The hardware manual should be revised, but the initial value of
VBCTRL.OCCLREN is set to 1 actually. If the bit is set, the hardware
clears VBCTRL.VBOUT and ADPCTRL.DRVVBUS registers automatically
when the hardware detects over-current signal from a USB power switch.
However, since the hardware doesn't have any registers which
indicates over-current, the driver cannot handle it at all. So, if
"is_otg_channel" hardware detects over-current, since ADPCTRL.DRVVBUS
register is cleared automatically, the channel cannot be used after
that.

To resolve this behavior, this patch sets the VBCTRL.OCCLREN to 0
to keep ADPCTRL.DRVVBUS even if the "is_otg_channel" hardware
detects over-current. (We assume a USB power switch itself protects
over-current and turns the VBUS off.)

This patch is inspired by a BSP patch from Kazuya Mizuguchi.

Fixes: 1114e2d31731 ("phy: rcar-gen3-usb2: change the mode to OTG on the combined channel")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 8ffba67568ec..b7f6b1324395 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -61,6 +61,7 @@
 					 USB2_OBINT_IDDIGCHG)
 
 /* VBCTRL */
+#define USB2_VBCTRL_OCCLREN		BIT(16)
 #define USB2_VBCTRL_DRVVBUSSEL		BIT(8)
 
 /* LINECTRL1 */
@@ -374,6 +375,7 @@ static void rcar_gen3_init_otg(struct rcar_gen3_chan *ch)
 	writel(val, usb2_base + USB2_LINECTRL1);
 
 	val = readl(usb2_base + USB2_VBCTRL);
+	val &= ~USB2_VBCTRL_OCCLREN;
 	writel(val | USB2_VBCTRL_DRVVBUSSEL, usb2_base + USB2_VBCTRL);
 	val = readl(usb2_base + USB2_ADPCTRL);
 	writel(val | USB2_ADPCTRL_IDPULLUP, usb2_base + USB2_ADPCTRL);
-- 
2.23.0


