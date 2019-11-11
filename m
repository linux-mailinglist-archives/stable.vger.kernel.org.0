Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB080F6E94
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKKGb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:31:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39151 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbfKKGb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:31:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D042421910;
        Mon, 11 Nov 2019 01:31:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WlLEV4
        LEa4lVr4uNtjyF5wsHoAbSCCcKLfCDuIWENxI=; b=Z5xQr3q9Bdo05EXdh4TMEY
        FRYgOx/Hq2BRdXL0eHozIYvLclke0HwOUHjeWuUIfjDi9Eta2JvY0PxfpkVrDuvv
        Iqw10b2YlBFr/9JXLuG/a/rmE7jN8PVPQpS4dhPnpPg4gOnsMtHkr1d0jBvzOYaE
        +0SJRGLRfL9mEB3HJ0D3JiRfhB0YqmWXMspXk9lmvGDsZx6v5qMGd+qzyn/u8/35
        Sr3ZfBsJ9ln/RGDF7tLudvnyDBqfGj4wLVto5/2xJDzkHtQn0PU/L28+enaiH80C
        DsTqYbaMyA3XXxK0QI46tziZBYxkff+a4VlFYquY52lHEs+6mPZTkmY8r0taxxCQ
        ==
X-ME-Sender: <xms:XQDJXd3JVaII9D6fre7HO7orPyHb-Sjh--cW0J-m_jDcZx034084Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:XQDJXUftTvAObhw77xoCUJTCWwX2W8EObkzP4ywVhyKQq0DpOKH-Vw>
    <xmx:XQDJXcUsVFX8z3_iwscZ4yN-c7MDIKO9N1-EyHen2c-KoDuZ4kZtZQ>
    <xmx:XQDJXYA2F5biT1EbSnxBzpWLhYQsPO8RfNTaraBs4usiYD7jLAHOMQ>
    <xmx:XQDJXT7MMZTD-rYD8Ti1a-vTW3kFl8XtGP-tRzeToAwSKzmfJr5rWQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 521CF8005B;
        Mon, 11 Nov 2019 01:31:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] can: flexcan: disable completely the ECC mechanism" failed to apply to 4.4-stable tree
To:     qiangqing.zhang@nxp.com, mkl@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:31:46 +0100
Message-ID: <157345390698136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

