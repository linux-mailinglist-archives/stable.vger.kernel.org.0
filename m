Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4703CDCBC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhGSOxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238504AbhGSOtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A19A60FEA;
        Mon, 19 Jul 2021 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708625;
        bh=ynYfoDlUb7M8ytx8991juFSHoDtobq7SQBQ/S5RtNgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TC2AI84/QwNGR5YbkaQ0Y/l7aueDt99LCJEP1hbLrdS/WqZcYsz32wTkKK2XaBYG
         YvgZY1cTH95omkjiF37v6ll0ME+9GNQjAbtw8PVxPtsDzcAohDNLwNs+BVKoR6yUnG
         /4hSnwqA2keiskiOnwuvXROa3wVHFuKTli3XGsy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.19 037/421] serial: sh-sci: Stop dmaengine transfer in sci_stop_tx()
Date:   Mon, 19 Jul 2021 16:47:28 +0200
Message-Id: <20210719144947.514105451@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 08a84410a04f05c7c1b8e833f552416d8eb9f6fe upstream.

Stop dmaengine transfer in sci_stop_tx(). Otherwise, the following
message is possible output when system enters suspend and while
transferring data, because clearing TIE bit in SCSCR is not able to
stop any dmaengine transfer.

    sh-sci e6550000.serial: ttySC1: Unable to drain transmitter

Note that this driver has already used some #ifdef in the .c file
so that this patch also uses #ifdef to fix the issue. Otherwise,
build errors happens if the CONFIG_SERIAL_SH_SCI_DMA is disabled.

Fixes: 73a19e4c0301 ("serial: sh-sci: Add DMA support.")
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210610110806.277932-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/sh-sci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -613,6 +613,14 @@ static void sci_stop_tx(struct uart_port
 	ctrl &= ~SCSCR_TIE;
 
 	serial_port_out(port, SCSCR, ctrl);
+
+#ifdef CONFIG_SERIAL_SH_SCI_DMA
+	if (to_sci_port(port)->chan_tx &&
+	    !dma_submit_error(to_sci_port(port)->cookie_tx)) {
+		dmaengine_terminate_async(to_sci_port(port)->chan_tx);
+		to_sci_port(port)->cookie_tx = -EINVAL;
+	}
+#endif
 }
 
 static void sci_start_rx(struct uart_port *port)


