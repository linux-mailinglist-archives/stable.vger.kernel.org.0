Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599B112C325
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfL2Pqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:46:40 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:33779 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2Pqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:46:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C569641D;
        Sun, 29 Dec 2019 10:46:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=K5JjRm
        i3UoM93fCb2Ebh9iszDrilbMYiNjq6bNVW24E=; b=q9hcTyI4CPakQmMzjFpdQw
        CJsB0ozwSmg/vf9TBCizDYLsRQsrSZCyHlCBwv69zjDUPUTD2tVanG9TxSjmM42W
        lm2qg0bQUKdmM4Ch+j1YaiYhhTJ36/OGITlm7WKq/BEoCWRLaA9S0qSKYZnT+Lzq
        oy7SYKEHv3goSzaF6d7s2dJ59udQENosEj7zEFu6vxiv/n3w3UofnBDrs4Lajuof
        Q42dXxQoQ2qSz00SmCxCrM7sMAH+IYrDcvlXvP9qWX0IXTlRHCSGLJY/m7cXu3BO
        dxcvdlyvkAZebYcqoY98LTDol0ibF0/tS9MT4bSmRy4oSXXZybu0glhf07cMYpCg
        ==
X-ME-Sender: <xms:XsoIXtVpkkqJdtuWshKzm7YdFMIn98HKCnlPOrzfsyZ762pmqWLS9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:XsoIXh1j7TKjvxoIKKweV56CS7RIpLO7uoA0thBFqs5DK05yLeI1ng>
    <xmx:XsoIXkYuhjwn19n8duy8KH60HRXZyNwjuB6YPJg9Fr4K_0Qk8sAwnQ>
    <xmx:XsoIXkqhO76vzDBqHEMVFbJMs6N7gJHCpTcjOfPFuOo_e_ovktoN-Q>
    <xmx:XsoIXsGiz9XzibDsjyQ8mLEyDapQDN57j2fl_oTIUt1WA2VXDa-fqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB06980059;
        Sun, 29 Dec 2019 10:46:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] serial: sprd: Add clearing break interrupt operation" failed to apply to 4.14-stable tree
To:     yonghan.ye@unisoc.com, baolin.wang7@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:46:28 +0100
Message-ID: <157763438824855@kroah.com>
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

From abeb2e9414d7e3a0d8417bc3b13d7172513ea8a0 Mon Sep 17 00:00:00 2001
From: Yonghan Ye <yonghan.ye@unisoc.com>
Date: Wed, 4 Dec 2019 20:00:07 +0800
Subject: [PATCH] serial: sprd: Add clearing break interrupt operation

A break interrupt will be generated if the RX line was pulled low, which
means some abnomal behaviors occurred of the UART. In this case, we still
need to clear this break interrupt status, otherwise it will cause irq
storm to crash the whole system.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Yonghan Ye <yonghan.ye@unisoc.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/925e51b73099c90158e080b8f5bed9b3b38c4548.1575460601.git.baolin.wang7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 31df23502562..f60a59d9bf27 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -679,6 +679,9 @@ static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
 	if (ims & SPRD_IMSR_TIMEOUT)
 		serial_out(port, SPRD_ICLR, SPRD_ICLR_TIMEOUT);
 
+	if (ims & SPRD_IMSR_BREAK_DETECT)
+		serial_out(port, SPRD_ICLR, SPRD_IMSR_BREAK_DETECT);
+
 	if (ims & (SPRD_IMSR_RX_FIFO_FULL | SPRD_IMSR_BREAK_DETECT |
 		   SPRD_IMSR_TIMEOUT))
 		sprd_rx(port);

