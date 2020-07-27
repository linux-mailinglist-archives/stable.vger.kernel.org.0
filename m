Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AFC22F0A2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732580AbgG0O0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732552AbgG0O0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FE1207FC;
        Mon, 27 Jul 2020 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859977;
        bh=YoCy38iOHeTU55I0Spc40QOQcTYhXBtxt9aDG9lTwgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxHqAKvsdun/7U2pyE2LJh1OWKQGm0p/eqj3bh37ti2mW6zNwxg9clFXoA7LtaoNW
         Zgy+NySm1u4RhRSRxX80etkjk3YUqpY5jNrOzupdZXAD3ClwVBL1vZ16BEuBZQ6TnV
         uVbUKO4XoKEK/PrwbXwVz9GgbSR8IzB/OAOKlRv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shardar Shariff Md <smohammed@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Johan Hovold <johan@kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.7 151/179] serial: tegra: fix CREAD handling for PIO
Date:   Mon, 27 Jul 2020 16:05:26 +0200
Message-Id: <20200727134940.027896061@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
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
@@ -653,11 +653,14 @@ static void tegra_uart_handle_rx_pio(str
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
 


