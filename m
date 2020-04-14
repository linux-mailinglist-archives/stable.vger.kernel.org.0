Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9560F1A7A85
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 14:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439992AbgDNMSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 08:18:17 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60353 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439989AbgDNMSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 08:18:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A6687891;
        Tue, 14 Apr 2020 08:18:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 08:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oDEm0v
        MpAzw9WIVy+LWYZO0EinNV2CKi+CMARp0hSuo=; b=ypnPA6po0k7HURPld5M/0c
        UXyJLbUpEElA+Pbpx5UO3x1C3kOtaMBbblVzNKyhqRt4aogdNLuA0dBX1Ee++qhq
        23saRpkHVIb4W+rJPWtM8UrautRInkMdtbxOZjwWfLjerHUy8YyAuanTmZ+0pc8z
        MjuoLTGE02CSky4vBRHvmBGyS+NvWB1/jdmjlrab7VaHsW+O4I3THApNcEDl6qaM
        SdOdn+MJmAvCBxluirWEgzH+j61NoNVS0wtZKwxGyVDCsSvfXku/4dHEWq/6hJZu
        BmzsxlFm28sWrltOS+rXBfKOclNHYOYDDC4QjS8AHZdhtxh6gYTWJC9JMB6CBjCw
        ==
X-ME-Sender: <xms:BKqVXpdNf33Z3R9u041TdPHXXv62e9doIeg0Zu_P5-rkKA8GUSJbnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:BKqVXgRQpaFiMe0jccwkagi5dO9Nv6WB3x6hqn6RDJEeN6isjf4GHQ>
    <xmx:BKqVXrsF3mnXmIODdvL4juHzFw-vG5bG_A4o4m8bcAi5f5hlpj0xjw>
    <xmx:BKqVXkmwOtmi6NbrRnN9otXLJvG_Hxjk63A97ONBRQck-e9MehHgdg>
    <xmx:BKqVXgcFfnZf3mIxG1wE1pz2FlyYbU7ROXobaEKSDCNhqp3Nnm9yWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8B303060061;
        Tue, 14 Apr 2020 08:18:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] genirq/debugfs: Add missing sanity checks to interrupt" failed to apply to 4.19-stable tree
To:     tglx@linutronix.de, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 14:18:02 +0200
Message-ID: <1586866682199227@kroah.com>
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

From a740a423c36932695b01a3e920f697bc55b05fec Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 6 Mar 2020 14:03:42 +0100
Subject: [PATCH] genirq/debugfs: Add missing sanity checks to interrupt
 injection

Interrupts cannot be injected when the interrupt is not activated and when
a replay is already in progress.

Fixes: 536e2e34bd00 ("genirq/debugfs: Triggering of interrupts from userspace")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200306130623.500019114@linutronix.de

diff --git a/kernel/irq/debugfs.c b/kernel/irq/debugfs.c
index a949bd39e343..d44c8fd17609 100644
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -206,8 +206,15 @@ static ssize_t irq_debug_write(struct file *file, const char __user *user_buf,
 		chip_bus_lock(desc);
 		raw_spin_lock_irqsave(&desc->lock, flags);
 
-		if (irq_settings_is_level(desc) || desc->istate & IRQS_NMI) {
-			/* Can't do level nor NMIs, sorry */
+		/*
+		 * Don't allow injection when the interrupt is:
+		 *  - Level or NMI type
+		 *  - not activated
+		 *  - replaying already
+		 */
+		if (irq_settings_is_level(desc) ||
+		    !irqd_is_activated(&desc->irq_data) ||
+		    (desc->istate & (IRQS_NMI | IRQS_REPLAY))) {
 			err = -EINVAL;
 		} else {
 			desc->istate |= IRQS_PENDING;

