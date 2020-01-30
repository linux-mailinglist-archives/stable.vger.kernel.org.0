Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04714E0EF
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgA3SkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgA3SkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:40:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C1D92083E;
        Thu, 30 Jan 2020 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409604;
        bh=qKhS42DKhwOlaVHptcXhWdipn3EhSDcP09MoYcfm5sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkG6Go+cjyEItyjxzjHRhNNOGPcWjfPojv8iesteLRWbCo+cx/depf3TBIuMdpyBH
         T0eCQD8Mj1W8kt74LUvO9SKve+VSaf7qJcfJLrnTbyqx4To4xZsWx5gGR30lTeAm5l
         RcfxCtX9jqTJk6ncQYoT417qReUgDqdYLLoGlKH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Subject: [PATCH 5.5 17/56] serial: 8250_bcm2835aux: Fix line mismatch on driver unbind
Date:   Thu, 30 Jan 2020 19:38:34 +0100
Message-Id: <20200130183612.395861450@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
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
@@ -113,7 +113,7 @@ static int bcm2835aux_serial_remove(stru
 {
 	struct bcm2835aux_data *data = platform_get_drvdata(pdev);
 
-	serial8250_unregister_port(data->uart.port.line);
+	serial8250_unregister_port(data->line);
 	clk_disable_unprepare(data->clk);
 
 	return 0;


