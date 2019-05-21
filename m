Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FF124C89
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 12:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEUKS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 06:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfEUKS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 06:18:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8311A21773;
        Tue, 21 May 2019 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558433939;
        bh=c7syVp+euvjnJkxRU1oOQXfGkTG/51g6ZcC2jmjPlTc=;
        h=Subject:To:From:Date:From;
        b=dqPkz5wSthMtocPmpaGcNZldoCjTJvUyD2HYmJckle5QR1WmJCBDhVza3gaI26tir
         9Socpn7u/Mfr/VcNKdSPKWjVJEsxBOubRPEAlYjj9dn77zUVcEoYOv1ICQTIGaYZUM
         mmOy8zeet7Im5x5xuehHTbsAQHwRoVQLW4FrDH6o=
Subject: patch "tty: max310x: Fix external crystal register setup" added to tty-linus
To:     joe.burmeister@devtank.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 May 2019 12:18:44 +0200
Message-ID: <15584339244214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: max310x: Fix external crystal register setup

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5d24f455c182d5116dd5db8e1dc501115ecc9c2c Mon Sep 17 00:00:00 2001
From: Joe Burmeister <joe.burmeister@devtank.co.uk>
Date: Mon, 13 May 2019 11:23:57 +0100
Subject: tty: max310x: Fix external crystal register setup

The datasheet states:

  Bit 4: ClockEnSet the ClockEn bit high to enable an external clocking
(crystal or clock generator at XIN). Set the ClockEn bit to 0 to disable
clocking
  Bit 1: CrystalEnSet the CrystalEn bit high to enable the crystal
oscillator. When using an external clock source at XIN, CrystalEn must
be set low.

The bit 4, MAX310X_CLKSRC_EXTCLK_BIT, should be set and was not.

This was required to make the MAX3107 with an external crystal on our
board able to send or receive data.

Signed-off-by: Joe Burmeister <joe.burmeister@devtank.co.uk>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 450ba6d7996c..e5aebbf5f302 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -581,7 +581,7 @@ static int max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
 	}
 
 	/* Configure clock source */
-	clksrc = xtal ? MAX310X_CLKSRC_CRYST_BIT : MAX310X_CLKSRC_EXTCLK_BIT;
+	clksrc = MAX310X_CLKSRC_EXTCLK_BIT | (xtal ? MAX310X_CLKSRC_CRYST_BIT : 0);
 
 	/* Configure PLL */
 	if (pllcfg) {
-- 
2.21.0


