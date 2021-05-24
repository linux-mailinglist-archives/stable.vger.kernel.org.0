Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435CC38EF20
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhEXP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233991AbhEXPzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB43F613F6;
        Mon, 24 May 2021 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870903;
        bh=eSo3u7S8Y8x03P5HuFzkqcHPD8cByTV/ijpy0qViCm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdkskQtXOCv2swJnsKdcJxwS0GlcravoZraUJ0WcQx0ZnoZRfF7TxnW9mqFrcMXa7
         ssw7VG+WGAQebCYYqL1RTieZOYHa77aVXUcazVGh+rmuOv9rwry+ywaBrYClQJrGtz
         Qh71zKSPaUhtINTZQOWTG4GiFVEsHK8eW5+/G6tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.10 053/104] Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"
Date:   Mon, 24 May 2021 17:25:48 +0200
Message-Id: <20210524152334.604507033@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 754f39158441f4c0d7a8255209dd9a939f08ce80 upstream.

This reverts commit 32f47179833b63de72427131169809065db6745e.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be not be needed at all as the
change was useless because this function can only be called when
of_match_device matched on something.  So it should be reverted.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: stable <stable@vger.kernel.org>
Fixes: 32f47179833b ("serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference")
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-6-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -818,9 +818,6 @@ static int mvebu_uart_probe(struct platf
 		return -EINVAL;
 	}
 
-	if (!match)
-		return -ENODEV;
-
 	/* Assume that all UART ports have a DT alias or none has */
 	id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (!pdev->dev.of_node || id < 0)


