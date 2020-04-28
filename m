Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB7B1BC98D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgD1Sms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbgD1Smq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:42:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1464E20575;
        Tue, 28 Apr 2020 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099366;
        bh=3+ofRS7RE8FekExK6l1Hstl3mc2F4usOKMv2qO5BNHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bO3Cx0UAFnqyAxRz/zN+8C62fwNItTocxNoHmhFYJh3zZAyIBUI+MpT/xTYhTuKHq
         6hw4Q+kyh2cWvAP48Dibr4bFlIi19Syg2Jl7pisLh6ZDZRQiWI/8/1h3EgSisKFJ31
         XffWmNplSlsm7dSG3MV4UgTcF0Q4p7i1Uu8aOspI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.4 121/168] tty: rocket, avoid OOB access
Date:   Tue, 28 Apr 2020 20:24:55 +0200
Message-Id: <20200428182247.748810829@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 7127d24372bf23675a36edc64d092dc7fd92ebe8 upstream.

init_r_port can access pc104 array out of bounds. pc104 is a 2D array
defined to have 4 members. Each member has 8 submembers.
* we can have more than 4 (PCI) boards, i.e. [board] can be OOB
* line is not modulo-ed by anything, so the first line on the second
  board can be 4, on the 3rd 12 or alike (depending on previously
  registered boards). It's zero only on the first line of the first
  board. So even [line] can be OOB, quite soon (with the 2nd registered
  board already).

This code is broken for ages, so just avoid the OOB accesses and don't
try to fix it as we would need to find out the correct line number. Use
the default: RS232, if we are out.

Generally, if anyone needs to set the interface types, a module parameter
is past the last thing that should be used for this purpose. The
parameters' description says it's for ISA cards anyway.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20200417105959.15201-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/rocket.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -632,18 +632,21 @@ init_r_port(int board, int aiop, int cha
 	tty_port_init(&info->port);
 	info->port.ops = &rocket_port_ops;
 	info->flags &= ~ROCKET_MODE_MASK;
-	switch (pc104[board][line]) {
-	case 422:
-		info->flags |= ROCKET_MODE_RS422;
-		break;
-	case 485:
-		info->flags |= ROCKET_MODE_RS485;
-		break;
-	case 232:
-	default:
+	if (board < ARRAY_SIZE(pc104) && line < ARRAY_SIZE(pc104_1))
+		switch (pc104[board][line]) {
+		case 422:
+			info->flags |= ROCKET_MODE_RS422;
+			break;
+		case 485:
+			info->flags |= ROCKET_MODE_RS485;
+			break;
+		case 232:
+		default:
+			info->flags |= ROCKET_MODE_RS232;
+			break;
+		}
+	else
 		info->flags |= ROCKET_MODE_RS232;
-		break;
-	}
 
 	info->intmask = RXF_TRIG | TXFIFO_MT | SRC_INT | DELTA_CD | DELTA_CTS | DELTA_DSR;
 	if (sInitChan(ctlp, &info->channel, aiop, chan) == 0) {


