Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9778617AFBA
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 21:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgCEUbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 15:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgCEUbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 15:31:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA6D207FD;
        Thu,  5 Mar 2020 20:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583440260;
        bh=B5RwAxCDpuFi5v3T3KrrV0JsAZRWkmeSkuEyybQvpIg=;
        h=Subject:To:From:Date:From;
        b=uTqXpBJTsWdD7918WIb7OcCmChgQKMwkuar6fPLqZ+5JaHWUNEEB7gNsIjsEzSr1E
         /vLceiIMGTZ23QVg3wLIqtcR4tIP7TnOpPU9lvKdsEI6NQ/sls7o5O5i/M2UtX4LXW
         LXYZV1oZrA8a8OcUI0ciPDfmfUQuUICvU3xpO374=
Subject: patch "tty:serial:mvebu-uart:fix a wrong return" added to tty-linus
To:     tangbin@cmss.chinamobile.com, gregkh@linuxfoundation.org,
        jslaby@suse.cz, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Mar 2020 21:30:57 +0100
Message-ID: <158344025716912@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty:serial:mvebu-uart:fix a wrong return

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4a3e208474204e879d22a310b244cb2f39e5b1f8 Mon Sep 17 00:00:00 2001
From: tangbin <tangbin@cmss.chinamobile.com>
Date: Thu, 5 Mar 2020 09:38:23 +0800
Subject: tty:serial:mvebu-uart:fix a wrong return

in this place, the function should return a
negative value and the PTR_ERR already returns
a negative,so return -PTR_ERR() is wrong.

Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200305013823.20976-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index c12a12556339..4e9a590712cb 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -851,7 +851,7 @@ static int mvebu_uart_probe(struct platform_device *pdev)
 
 	port->membase = devm_ioremap_resource(&pdev->dev, reg);
 	if (IS_ERR(port->membase))
-		return -PTR_ERR(port->membase);
+		return PTR_ERR(port->membase);
 
 	mvuart = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_uart),
 			      GFP_KERNEL);
-- 
2.25.1


