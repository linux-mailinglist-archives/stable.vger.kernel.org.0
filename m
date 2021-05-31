Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C462D3961FC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhEaOtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233589AbhEaOrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:47:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D84661C8B;
        Mon, 31 May 2021 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469358;
        bh=N6QBhbaoixqNSH7hQZQXy04G9OzUiSPwdaXmmotnH0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSTdotlYRfWKePpI7h4+Ex04WN4XZnD2U/bK4KAaK4UtHKuvFt5lhCg+RoNq8bXa6
         e/F3SCYt/r5U5F9IBXpZXZsE2BIRW8FfuLTJSKTCvYO7mvw1KjLzVLcB596+drN7S/
         E+wXoxQOF3GimrksqD1SxOfaotYX1iZXM+UJLfdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 166/296] serial: max310x: unregister uart driver in case of failure and abort
Date:   Mon, 31 May 2021 15:13:41 +0200
Message-Id: <20210531130709.452194626@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

[ Upstream commit 3890e3dea315f1a257d1b940a2a4e2fa16a7b095 ]

The macro "spi_register_driver" invokes the function
"__spi_register_driver()" which has a return type of int and can fail,
returning a negative value in such a case. This is currently ignored and
the init() function yields success even if the spi driver failed to
register.

Fix this by collecting the return value of "__spi_register_driver()" and
also unregister the uart driver in case of failure.

Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-12-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 93f69b66b896..43e55e6abea6 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1518,10 +1518,12 @@ static int __init max310x_uart_init(void)
 		return ret;
 
 #ifdef CONFIG_SPI_MASTER
-	spi_register_driver(&max310x_spi_driver);
+	ret = spi_register_driver(&max310x_spi_driver);
+	if (ret)
+		uart_unregister_driver(&max310x_uart);
 #endif
 
-	return 0;
+	return ret;
 }
 module_init(max310x_uart_init);
 
-- 
2.30.2



