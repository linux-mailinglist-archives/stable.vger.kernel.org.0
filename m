Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF133714CA
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhECMBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232994AbhECMAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:00:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48B4161221;
        Mon,  3 May 2021 11:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043188;
        bh=8BvqTsqadTxn2/rw4JTPfSiR1PYQa0Co9NzzaBakcDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIauaBr3Gksm5Bk4vYFU/GjEzife0onYYMjZhORLb1pXGiIqtlJYJ1cpQJVB2Cw3S
         JofSwsFYXaxAyfAgP7ZL/fKEzXsmQg6cQN9p96O7fry3xiSRAZ/Ad77E6qrG6nzhuf
         jH6Qhr29d5fK37Fz7PyC1rSCdV+NOsjsirARhIlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        stable <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 05/69] Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"
Date:   Mon,  3 May 2021 13:56:32 +0200
Message-Id: <20210503115736.2104747-6-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index e0c00a1b0763..51b0ecabf2ec 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -818,9 +818,6 @@ static int mvebu_uart_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!match)
-		return -ENODEV;
-
 	/* Assume that all UART ports have a DT alias or none has */
 	id = of_alias_get_id(pdev->dev.of_node, "serial");
 	if (!pdev->dev.of_node || id < 0)
-- 
2.31.1

