Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84921185C08
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 11:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgCOKrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 06:47:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51017 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728278AbgCOKrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 06:47:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4760C2209B;
        Sun, 15 Mar 2020 06:47:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 15 Mar 2020 06:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Pxu4XN
        l99zOWKPHydP5aCJIQXRK4OjWw/Oicw5Zj4fk=; b=QSMIylEDSV0kv/LF3Ut3HQ
        ZxrStjt1F94+etSjQz8x4epxn5qA5W2TjkUMwvFfsgi0WxVvKMguKlaVpWZ94ap/
        ut09pu+8FfIeo26oMtE51ACVzdrfz301/0gn42QNGGofbwlWv0Y7UkoYUTe+VRKC
        mEuSJ+0xfwt43SlTZQ8fonHUXsMvZwMQKtGgjBoAbBWGSNWV3uQc5JuBB6A4acQ7
        HcPuNyYf6VebtY9K4xjq9cYf91J+xALhkw0tQCpZI+qcrWYJrWs88Vb1o0Zi5VJD
        NohBL79L8p5k3fBDFJ8DlC7Fspc07S1/Ib0R+TnTzQDnnlffZR6ZibcU0mndDJKQ
        ==
X-ME-Sender: <xms:zQduXqW7UD93Z-vnycsp4Ajo07qUL_o40gVhf2b53tR_vNCx6dV-Dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeftddgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zQduXiVZoIz3z6QtJjp4OQEb6VZHK5Zh_CoICowXSrYs7kXpl3FEUQ>
    <xmx:zQduXhIE59NhSgfACdtYYQpMeF_uUiOKG_nQOXIl9pNnRw-kbraziA>
    <xmx:zQduXnXmghMtwcVict9oditVOPdepQaenyWLQy6XIyuhRbP0F4R2xg>
    <xmx:zQduXkiYmRGhIZ-_9UL_Ae0do5-YpQ_AX47wRFYW4Jon13o1LGZsWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA4C83280065;
        Sun, 15 Mar 2020 06:47:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: fix lockup on warm boot" failed to apply to 4.14-stable tree
To:     rmk+kernel@armlinux.org.uk, andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Mar 2020 11:47:31 +0100
Message-ID: <158426925132136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0395823b8d9a4d87bd1bf74359123461c2ae801b Mon Sep 17 00:00:00 2001
From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 28 Feb 2020 19:39:41 +0000
Subject: [PATCH] net: dsa: mv88e6xxx: fix lockup on warm boot

If the switch is not hardware reset on a warm boot, interrupts can be
left enabled, and possibly pending. This will cause us to enter an
infinite loop trying to service an interrupt we are unable to handle,
thereby preventing the kernel from booting.

Ensure that the global 2 interrupt sources are disabled before we claim
the parent interrupt.

Observed on the ZII development revision B and C platforms with
reworked serdes support, and using reboot -f to reboot the platform.

Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt support.")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 01503014b1ee..8fd483020c5b 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1099,6 +1099,13 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 {
 	int err, irq, virq;
 
+	chip->g2_irq.masked = ~0;
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_g2_int_mask(chip, ~chip->g2_irq.masked);
+	mv88e6xxx_reg_unlock(chip);
+	if (err)
+		return err;
+
 	chip->g2_irq.domain = irq_domain_add_simple(
 		chip->dev->of_node, 16, 0, &mv88e6xxx_g2_irq_domain_ops, chip);
 	if (!chip->g2_irq.domain)
@@ -1108,7 +1115,6 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 		irq_create_mapping(chip->g2_irq.domain, irq);
 
 	chip->g2_irq.chip = mv88e6xxx_g2_irq_chip;
-	chip->g2_irq.masked = ~0;
 
 	chip->device_irq = irq_find_mapping(chip->g1_irq.domain,
 					    MV88E6XXX_G1_STS_IRQ_DEVICE);

