Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5D8F6E92
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKKGbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:31:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59313 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbfKKGbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:31:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A11A4200E3;
        Mon, 11 Nov 2019 01:31:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JpbBe7
        JAMEXbE+BVd+hx6dN968A8obzQ1BWfqlD6V1g=; b=Tk1PYCCjgkTvgKGlAr44Cl
        vPlVmbZV1qzI7fypyXcNMzgarug00KSyUek3znYxnrFqiyqskY86jTB2YU81F9+h
        EZcfs0vP6ceQyOuSVCEWmnpgHcrDSlb+zB6Hz7BRNQ7KP5UW0JIsDLXWkJ9ZrRtQ
        Zw/e2Rmmi+qG1A/1KrM0++6CPxCJkRXUSahTgOkLQd+lI2Vrfu60k7RoId+Slf5C
        Mmq4IgDkRPruj0ajc/lTjyMSz34qGCBoCu5XvsM4pVGwMZXunIYseOQKCRjEBvUK
        38xTgLOICQxnUkdfdKXlau6Z0hairwjE8RW4utLNSSCPx4+yMwU4rSW7KHx1TUrg
        ==
X-ME-Sender: <xms:UwDJXbR76eBFmrFaJuZGd6wSTIXyWjusgumXOHIQZZ8i5C4r21tOrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:UwDJXRBZokvqDWxtTq6YwM4N7hNLzWspIdz_ZL3Un_ozl__cy0FNxA>
    <xmx:UwDJXb04j8xXRJIfLM5uqT3N95HXvgs6EUBv2w11HCHYSedtzTmLng>
    <xmx:UwDJXfX_LwnHiyCS7U2BZK3mj4_BCrxqLxWLS9nzti35VvbLcl_72w>
    <xmx:VADJXb2r8t3qh1fH8DawAm8-MdTvyup3LMVdHJ6xd2KRnp3iZ55O6A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96E803060064;
        Mon, 11 Nov 2019 01:31:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] can: flexcan: disable completely the ECC mechanism" failed to apply to 4.14-stable tree
To:     qiangqing.zhang@nxp.com, mkl@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:31:46 +0100
Message-ID: <157345390614177@kroah.com>
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

From 5e269324db5adb2f5f6ec9a93a9c7b0672932b47 Mon Sep 17 00:00:00 2001
From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Thu, 15 Aug 2019 08:00:26 +0000
Subject: [PATCH] can: flexcan: disable completely the ECC mechanism

The ECC (memory error detection and correction) mechanism can be
activated or not, controlled by the ECCDIS bit in CAN_MECR. When
disabled, updates on indications and reporting registers are stopped.
So if want to disable ECC completely, had better assert ECCDIS bit, not
just mask the related interrupts.

Fixes: cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index dc5695dffc2e..1cd5179cb876 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1188,6 +1188,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		reg_mecr = priv->read(&regs->mecr);
 		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
 		priv->write(reg_mecr, &regs->mecr);
+		reg_mecr |= FLEXCAN_MECR_ECCDIS;
 		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		priv->write(reg_mecr, &regs->mecr);

