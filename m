Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BA01A7A84
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 14:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439990AbgDNMSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 08:18:14 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:56537 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439988AbgDNMSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 08:18:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A7087853;
        Tue, 14 Apr 2020 08:18:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 08:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6qQWV4
        bckEJM0e/Fx2aSz8/zUnOgF8wcwnGy+tpF2SU=; b=ioVhww6ZEip754ui0pZgVz
        GbRmZZTkxyBLBNXPrzCVNY1aglBxPVmQjQ2M6k5BxfgQp3s6SWut1H6g6YxlwPl4
        uaa1Hlfx5BSH7/pP3k88RH5V2hBlMTvB2Q+kpCJ2rgtEe971ZIeYIZHNuRmxqPBV
        sUSACkILSj9qVOQGUd+YGjYCUK3Eh2o2pZYNl77s7FYgsX4ZQeD5/hwK9uadtxPQ
        TgtbqKhSx6qqV4q/MJZUNwgdVPCxZ0fmaUpfql2RA9HiTtbTfVPbRzs1vpEmVZzx
        WmqKrLIgRAPcyZeGExucvYyjLkn+qk4/nGALa82NiSOubZIW5LiLXbJBPVHG0bpQ
        ==
X-ME-Sender: <xms:_KmVXqeJmM6Pk45eHdU_FYIMn06p9mLIUWLoiJtk__HueU8YoXTXMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_KmVXiLuyxDqOOWdqATMHkWw44BbP1sMufGb8IzKbtHjaJozS8iwRQ>
    <xmx:_KmVXt0xkFllqsWolXYuB6oZZU1KUNmqzfgp-fJ70k9TPoH_s4pwLg>
    <xmx:_KmVXsgjsZXGHZyLn6dnnJvwO1Ltww02oczkS0yRCi5zDfq7wapv1w>
    <xmx:_KmVXjPp08wFu8gp6QzJ_bz5XmivtYVgQevA_WG9UxYXpmlqq9akKw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE8C13060060;
        Tue, 14 Apr 2020 08:18:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] genirq/debugfs: Add missing sanity checks to interrupt" failed to apply to 4.14-stable tree
To:     tglx@linutronix.de, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 14:18:02 +0200
Message-ID: <1586866682118208@kroah.com>
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

