Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D69185C07
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 11:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgCOKrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 06:47:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57929 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728278AbgCOKrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 06:47:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 40AD222063;
        Sun, 15 Mar 2020 06:47:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 15 Mar 2020 06:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FXIKXd
        2id/Kdsa5WulyY8T3Ws5QPzH8zOhn2FP3TpuI=; b=xzLtF223L+RLxyA4KNBwFo
        EgyxGPU3pvnuZYYsGPnTB49OvMIz76JlaR22bLxo851ZixV02ru4W5EmdGnwpHSp
        J45O1iXIyg8ZIkFey6MfnSXrDxnE1p53gdJuhQivoBoeynT7fypvhq5PMSqu/ATK
        UlWoa9wGEre0YYK1wSHs3RLHeUE4xH+9fgXOJtUkdim9TvZwS7D6iueKD8WaQNTD
        496S02U8+UA2BaYvowQ53O2UcuHVCtdIRO6C+07hNmkN7wpd3yOGzD1K9UjxzB/l
        nIOgVP/wq//X2AXIGCmin2rx3kW0pioILZupZ9Mei1ImwdoycaAYmAOnXh3OTxEA
        ==
X-ME-Sender: <xms:xQduXpTuznwDJcK3gPge68DiHzzIgTGKfbctfBmcsG_q7L22vr4QWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeftddgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xQduXq5e44FB5Jt7GdjwNXTNFdf2oMe76s_QsXWkTFSzXktl8rLJJw>
    <xmx:xQduXuWx4Ip6MTaqubZKG6PlZNGxU38F0vB7BbUwUtnJOWUZ6Ojyuw>
    <xmx:xQduXg_7BemJpUhI17Z3fJP58XNRpLPYlC-YfnG8i_WQAk-7IvWdow>
    <xmx:xwduXtUXVH3EUoqhoGyzgEmnZ9YFyM0sYYtzCWHaRQfB5WQlr91_gw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 995483280066;
        Sun, 15 Mar 2020 06:47:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: fix lockup on warm boot" failed to apply to 4.19-stable tree
To:     rmk+kernel@armlinux.org.uk, andrew@lunn.ch, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Mar 2020 11:47:31 +0100
Message-ID: <15842692511666@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

