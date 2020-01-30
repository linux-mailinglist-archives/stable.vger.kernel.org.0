Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD2714D89F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 11:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgA3KG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 05:06:59 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36053 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbgA3KG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 05:06:59 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id F29084A7;
        Thu, 30 Jan 2020 05:06:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 05:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mvMU4e
        iRCsBYlQE83R123s/ipVMrYU4cr7revGyc0xE=; b=IeiRuUv5Q2GSKPdDXfSZ+d
        0Wi8pbeNdLCkC35nbN8UPcVvrFvUNaCTfmQT+sk2VDkIeRVmukpjDq5cfVL8JuqY
        dM1PwHayEJtFkM6NtUokS2qnm1Cxs3x35MMazdThksAlR1gAO8wv4t4a1LPysOpy
        lEcHQNPwGPne9matB7q6L8wc6zDLqi3AG5BIu1WRikcK/G/6Ve+7jppaKUMI2I/r
        mnLQ/dS06GjDc7DEbGnNotvZR9nfxXZcgTNecLQDUZIt8pBbGPesLdv2Cf31cgc8
        15d50Dzi6hW8ybgkzf2/lih2VZhF6qpf2Q1BEsOnWiqt7BPgl9EP2ryQ7zwGnzGA
        ==
X-ME-Sender: <xms:waoyXrLKXsD7x10ASJWiR2sgpGO99sTmZVQ4H2a9BTfww9g8BzWzzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:waoyXj-zwTdABvqdHZqqarP0ll6JgpBUzf1Mf-CVVtpFG0m_FWVKaA>
    <xmx:waoyXlqXPfc9ay3UED4T0DBaDxedmC2ixDxnqSdsSXiRvS1dKCkRzQ>
    <xmx:waoyXsnuCr3a19nZoZifJo0EXJ54umPArXBoyPjhPfkN6pbXyI7Q-A>
    <xmx:waoyXscFZgMECxqpYiAjhqMMrK0_WN8_CAZQ_9tiH4GPsAlEcM0hSA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E0E33280063;
        Thu, 30 Jan 2020 05:06:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: turn off VBUS when leaving host mode" failed to apply to 4.9-stable tree
To:     b-liu@ti.com, balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 11:06:56 +0100
Message-ID: <1580378816222208@kroah.com>
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

From 09ed259fac621634d51cd986aa8d65f035662658 Mon Sep 17 00:00:00 2001
From: Bin Liu <b-liu@ti.com>
Date: Wed, 11 Dec 2019 10:10:03 -0600
Subject: [PATCH] usb: dwc3: turn off VBUS when leaving host mode

VBUS should be turned off when leaving the host mode.
Set GCTL_PRTCAP to device mode in teardown to de-assert DRVVBUS pin to
turn off VBUS power.

Fixes: 5f94adfeed97 ("usb: dwc3: core: refactor mode initialization to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f561c6c9e8a9..1d85c42b9c67 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1246,6 +1246,9 @@ static void dwc3_core_exit_mode(struct dwc3 *dwc)
 		/* do nothing */
 		break;
 	}
+
+	/* de-assert DRVVBUS for HOST and OTG mode */
+	dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
 }
 
 static void dwc3_get_properties(struct dwc3 *dwc)

