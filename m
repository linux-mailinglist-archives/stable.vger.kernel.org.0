Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF7D150B23
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgBCQZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgBCQZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:00 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E072080C;
        Mon,  3 Feb 2020 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747100;
        bh=p2WfEJ8ZKgV4J+cESH1NT9VjmZZwXfOgTWMsFY15Pwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yuFftj6/DW5PhQ4EYHw4DpJfB45Z2FGnNY9ZLVnaoYcCO+rfCUYm1qQQOyiJSS3j+
         8UKjIib+/xGkjZ2JYxpMID27dK63EqHzx+rH+vcnzASfuhzLJIAIeRuUCJ/Oijy/Pp
         +NXDXk58Fad/p1KMZ+PftH6cTLbcL1CkBgtdvmAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: [PATCH 4.9 12/68] serial: 8250_bcm2835aux: Fix line mismatch on driver unbind
Date:   Mon,  3 Feb 2020 16:19:08 +0000
Message-Id: <20200203161906.890593314@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit dc76697d7e933d5e299116f219c890568785ea15 upstream.

Unbinding the bcm2835aux UART driver raises the following error if the
maximum number of 8250 UARTs is set to 1 (via the 8250.nr_uarts module
parameter or CONFIG_SERIAL_8250_RUNTIME_UARTS):

(NULL device *): Removing wrong port: a6f80333 != fa20408b

That's because bcm2835aux_serial_probe() retrieves UART line number 1
from the devicetree and stores it in data->uart.port.line, while
serial8250_register_8250_port() instead uses UART line number 0,
which is stored in data->line.

On driver unbind, bcm2835aux_serial_remove() uses data->uart.port.line,
which contains the wrong number.  Fix it.

The issue does not occur if the maximum number of 8250 UARTs is >= 2.

Fixes: bdc5f3009580 ("serial: bcm2835: add driver for bcm2835-aux-uart")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.6+
Cc: Martin Sperl <kernel@martin.sperl.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/912ccf553c5258135c6d7e8f404a101ef320f0f4.1579175223.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_bcm2835aux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_bcm2835aux.c
+++ b/drivers/tty/serial/8250/8250_bcm2835aux.c
@@ -119,7 +119,7 @@ static int bcm2835aux_serial_remove(stru
 {
 	struct bcm2835aux_data *data = platform_get_drvdata(pdev);
 
-	serial8250_unregister_port(data->uart.port.line);
+	serial8250_unregister_port(data->line);
 	clk_disable_unprepare(data->clk);
 
 	return 0;


