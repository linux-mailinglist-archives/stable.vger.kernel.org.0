Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D5AF6E93
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfKKGb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:31:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57751 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbfKKGb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:31:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2195E20D12;
        Mon, 11 Nov 2019 01:31:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:31:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yLft/x
        FLqI3O8ApNS0x3CSbfXOPtnXv/oTBARD+Jw/w=; b=yRh8WbT52XpcKqtQ3NAa44
        EOr8U0jlayeGMCBSCGZSt2SU4i5lDZ3Rzvk5ok+Ez+5vdRcMQ7AygLybdIW5iYyS
        eIFaKOn+WvtuIrNXnAtalxw0/e/puTBc/1hcgP/FfA2XRxzjvMToA9LzISYl4D03
        F62E776yVh2YFPraNhbgFStD7X2HnfaXUIz7WKp/J2/igcOBqihI+idQtQjZHPY4
        CR1KEGoXaW/xNH/mSRgfm8fqK9hpi9ziIxpOpXgbBsnIvCFCv1iZT6evY6D/IQ2G
        2OM5OtObZt++830d9sGUEFSvtDamQPOQQkhixZYt0DA5TlmVYbaijPdraiT93r5g
        ==
X-ME-Sender: <xms:XADJXbniUFQrGeUxPKm4spwKnF7dDeR0dMaw7Xe-OwfselKmT73f4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:XADJXYMKFdQvtotzuWE8cbfBEpWG0SmCX2cCvRlUu4dUmcTMozlahQ>
    <xmx:XADJXaJpKk9_MPnAaIleZUfm-vqIKEUvHBw130q-auctmpOTSkSxXg>
    <xmx:XADJXTEEh-kkyoKqZXxfFk7XsY_TTHD_MdETyb3zxoSHFXyuICzEgg>
    <xmx:XADJXXE5rPAHGHiAfrKF47xBgZZ72baYjCQZAqiuZAv-7UQtpBNnVw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2F1E3060065;
        Mon, 11 Nov 2019 01:31:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] can: flexcan: disable completely the ECC mechanism" failed to apply to 4.9-stable tree
To:     qiangqing.zhang@nxp.com, mkl@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:31:46 +0100
Message-ID: <15734539068048@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

