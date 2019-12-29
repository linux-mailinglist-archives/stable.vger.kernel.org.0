Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62B12C324
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL2Pqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:46:31 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:56065 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2Pqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:46:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8657E416;
        Sun, 29 Dec 2019 10:46:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:46:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4sa8xq
        eeSjRJ1zoCUsHnFWPITn+5Mc1Xyjs65jehzqk=; b=HiRpqM9a0troAe6R4CmiYK
        S7z7rUNzWBtS2lN2dlWHkQ6CejsGWxqGGvkczVCConnKS35OctMTINwlo2MqTkbQ
        im6/kOV/QGqJZya7LSAtpIHck7KaOkj2AXLidqMpi/NCfzCgIDs9VC3BWf0i77UH
        u9ZCnkml4UyW1s85NteCOQnP/SSl7F4eWB0CKhGgfpt4ftC0OVB94LkHR2YpSOWD
        il/3Ag7YG9gI+dTbsyLKrjQyL0CUk7Qv91fsFUjZI4XO5XWFNgtIB632JWw9t9od
        CUsjAzvtlu2qG4WsAlj5/HFHrk+NgVbh//eXfXdXqnDuY3LdTC6PTG4rnYx/0IzQ
        ==
X-ME-Sender: <xms:VcoIXig_9x8RDNOue_X5ERae6kHhKJFlQbbNBmmCxeCZdra_4keODw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:VcoIXjzdVunOZ1ydFPHbXOvUvbcJo52XcnM1iHCYJdkYk80p0HXtDg>
    <xmx:VcoIXi9K1Y2UeWuu8h5dVEiVXaDXJsl9ozzqKMCj0Nd9yS8mNXBdhQ>
    <xmx:VcoIXjJmaW9PF4efE9x2VPAYr-jxDeVBtp0Rxx3CbpZ7OYCzbtMQhQ>
    <xmx:VsoIXl7L2B3prSHk2AZ3b-KhrFUtRMYqWvORqUMblRBRQOd1r0yspA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78DC43060A32;
        Sun, 29 Dec 2019 10:46:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] serial: sprd: Add clearing break interrupt operation" failed to apply to 4.19-stable tree
To:     yonghan.ye@unisoc.com, baolin.wang7@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:46:28 +0100
Message-ID: <157763438810028@kroah.com>
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

