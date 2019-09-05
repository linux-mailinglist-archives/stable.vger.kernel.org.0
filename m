Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA26A9C75
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 09:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbfIEH6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 03:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731717AbfIEH6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 03:58:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DAA3217D7;
        Thu,  5 Sep 2019 07:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567670313;
        bh=fxU2JdtZx7yowam8bcRWTc5HX16xqIVncuLl6Pece6k=;
        h=Subject:To:From:Date:From;
        b=ZFxMP4uA+3tuc98f1Iwa5D7Y05GP7WAzFxL6usVUQdJZLHeY68k/6Kn2abDbQYtrr
         pl50Uu+1PV+y2aCm+jcsFrywj7jzlRsz3dZCrbIV3R7MdnBl6iuUZhNwQl5oWb0kVp
         IHzQdy8FgruLRLw3oJ2RqXcEt5TG3AsdrTmZlVUU=
Subject: patch "serial: sprd: correct the wrong sequence of arguments" added to tty-testing
To:     chunyan.zhang@unisoc.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zhang.lyra@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Sep 2019 09:58:20 +0200
Message-ID: <1567670300231166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sprd: correct the wrong sequence of arguments

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 9c801e313195addaf11c16e155f50789d6ebfd19 Mon Sep 17 00:00:00 2001
From: Chunyan Zhang <chunyan.zhang@unisoc.com>
Date: Thu, 5 Sep 2019 15:41:51 +0800
Subject: serial: sprd: correct the wrong sequence of arguments

The sequence of arguments which was passed to handle_lsr_errors() didn't
match the parameters defined in that function, &lsr was passed to flag
and &flag was passed to lsr, this patch fixed that.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190905074151.5268-1-zhang.lyra@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sprd_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index f8db5c8e4e39..771d11196523 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -617,7 +617,7 @@ static inline void sprd_rx(struct uart_port *port)
 
 		if (lsr & (SPRD_LSR_BI | SPRD_LSR_PE |
 			   SPRD_LSR_FE | SPRD_LSR_OE))
-			if (handle_lsr_errors(port, &lsr, &flag))
+			if (handle_lsr_errors(port, &flag, &lsr))
 				continue;
 		if (uart_handle_sysrq_char(port, ch))
 			continue;
-- 
2.23.0


