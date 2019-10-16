Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8ED9E37
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395449AbfJPV5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391557AbfJPV5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:04 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62395218DE;
        Wed, 16 Oct 2019 21:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263023;
        bh=sjlIwSJ0FHNExo6dFzqdzejm/T15u+XJksiKzHvoJgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhlC38FM7TPtkU4bXAgRSRaLhnoY3uYVq6sw09a3BQtLi4522OUxiKxKJ7HbrI5ny
         /eYZFVkyUbPolmxLy4pXFqWXJkO2uyeWYB4w4xBCaGwEFSxrcZYpYxSs/9rG4B2Ig7
         gJu5ME1iVCdDLc0yUT7+5/axyj7ximTkQFLw9Dic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH 4.19 24/81] serial: uartlite: fix exit path null pointer
Date:   Wed, 16 Oct 2019 14:50:35 -0700
Message-Id: <20191016214827.455602067@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit a553add0846f355a28ed4e81134012e4a1e280c2 upstream.

Call uart_unregister_driver() conditionally instead of
unconditionally, only if it has been previously registered.

This uses driver.state, just as the sh-sci.c driver does.

Fixes this null pointer dereference in tty_unregister_driver(),
since the 'driver' argument is null:

  general protection fault: 0000 [#1] PREEMPT SMP KASAN PTI
  RIP: 0010:tty_unregister_driver+0x25/0x1d0

Fixes: 238b8721a554 ("[PATCH] serial uartlite driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable <stable@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Link: https://lore.kernel.org/r/9c8e6581-6fcc-a595-0897-4d90f5d710df@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/uartlite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -837,7 +837,8 @@ err_uart:
 static void __exit ulite_exit(void)
 {
 	platform_driver_unregister(&ulite_platform_driver);
-	uart_unregister_driver(&ulite_uart_driver);
+	if (ulite_uart_driver.state)
+		uart_unregister_driver(&ulite_uart_driver);
 }
 
 module_init(ulite_init);


