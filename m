Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0E3E41B1
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 10:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhHIIhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 04:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233903AbhHIIhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 04:37:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C648960F55;
        Mon,  9 Aug 2021 08:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628498246;
        bh=R6f+F81a+bR8dSwMtGor4u+YmpNqE1+rY42YLnIBePg=;
        h=Subject:To:Cc:From:Date:From;
        b=Z58rDO7C1Ks4nK+o9qL6Fb9D9BJfagiaqcScIdwg8VLMAf8XMxrOUOUAx6pfWDom5
         Slb+WfPpbMwQPMB75hBE0iQNZHklhs5nfLEkALoZFWiyYLiaZIjQgQ8Ye6d7YTus3k
         ybeDcWgMS08iI8f53VHuN/jK6VQDrEpRGzPy3GvQ=
Subject: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: fix the wrong return value in" failed to apply to 5.10-stable tree
To:     sherry.sun@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 10:37:16 +0200
Message-ID: <162849823620124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 06e91df16f3e1ca1a1886968fb22d4258f3b6b6f Mon Sep 17 00:00:00 2001
From: Sherry Sun <sherry.sun@nxp.com>
Date: Thu, 29 Jul 2021 16:31:09 +0800
Subject: [PATCH] tty: serial: fsl_lpuart: fix the wrong return value in
 lpuart32_get_mctrl

Patch e60c2991f18b make the lpuart32_get_mctrl always return 0, actually
this will break the functions of device which use flow control such as
Bluetooth.
For lpuart32 plaform, the hardware can handle the CTS automatically.
So we should set TIOCM_CTS active. Also need to set CAR and DSR active.

Patch has been tested on lpuart32 platforms such as imx8qm and imx8ulp.

Fixes: e60c2991f18b ("serial: fsl_lpuart: remove RTSCTS handling from get_mctrl()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20210729083109.31541-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 508128ddfa01..f0e5da77ed6d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1415,7 +1415,7 @@ static unsigned int lpuart_get_mctrl(struct uart_port *port)
 
 static unsigned int lpuart32_get_mctrl(struct uart_port *port)
 {
-	unsigned int mctrl = 0;
+	unsigned int mctrl = TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
 	u32 reg;
 
 	reg = lpuart32_read(port, UARTCTRL);

