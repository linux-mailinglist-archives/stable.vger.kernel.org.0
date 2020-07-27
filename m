Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F122F22F1A5
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgG0Ode (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731077AbgG0ORe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:17:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84ECF2070A;
        Mon, 27 Jul 2020 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859454;
        bh=sr55WZBKO1zAa55a/U4uiXMrVkozFZ9KxigTSgpK8Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmMvAPYBSOd6sjOwSpP2Wp1w1ks/PVJydrZ68kNu0bODQSuMdL+HOuTKxfwTm5B5L
         GTeZ7n1OAEKWft9n1Qx/KKnbJAnG8Z4rmxXLTTC+VrhJZiVXPlEN6pkbD4k6ljCxg5
         QL3Jrra2Yo9N64Fk7Y7zd7rmkqulY47VvFiINGWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Johan Hovold <johan@kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 115/138] serial: tegra: fix CREAD handling for PIO
Date:   Mon, 27 Jul 2020 16:05:10 +0200
Message-Id: <20200727134931.199769367@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b374c562ee7ab3f3a1daf959c01868bae761571c upstream.

Commit 33ae787b74fc ("serial: tegra: add support to ignore read") added
support for dropping input in case CREAD isn't set, but for PIO the
ignore_status_mask wasn't checked until after the character had been
put in the receive buffer.

Note that the NULL tty-port test is bogus and will be removed by a
follow-on patch.

Fixes: 33ae787b74fc ("serial: tegra: add support to ignore read")
Cc: stable <stable@vger.kernel.org>     # 5.4
Cc: Shardar Shariff Md <smohammed@nvidia.com>
Cc: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20200710135947.2737-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial-tegra.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -651,11 +651,14 @@ static void tegra_uart_handle_rx_pio(str
 		ch = (unsigned char) tegra_uart_read(tup, UART_RX);
 		tup->uport.icount.rx++;
 
-		if (!uart_handle_sysrq_char(&tup->uport, ch) && tty)
-			tty_insert_flip_char(tty, ch, flag);
+		if (uart_handle_sysrq_char(&tup->uport, ch))
+			continue;
 
 		if (tup->uport.ignore_status_mask & UART_LSR_DR)
 			continue;
+
+		if (tty)
+			tty_insert_flip_char(tty, ch, flag);
 	} while (1);
 }
 


