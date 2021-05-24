Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE5338EB7D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhEXPDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233817AbhEXPBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04BD961482;
        Mon, 24 May 2021 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867811;
        bh=mJeqKre+1wmJpQ/4NRYPtBLkivBvz8xppH54EUsGy8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xx6ca8OdtGsb7pMI3ESTbeoEEH2vY7zkB/e1Yjj0QkDGgxCP+nbdD57O2WRy20VZr
         r1Yf5rqnm/4YNlQ5fY8KJpAUZ2sEb2UG8Z8M/BfqnK/0Gdo2lMfxn+xKBO9eiHb+Z4
         SNMyoG82pMeTkb3byXkJS9n7mE0VrwSkWlfOQA+TchfJswVRUHz/u4i2jsHrw6TNZW
         7b7ceaEE5XqqAuD6gPjmkGrzjAUX3e7mxgUQcCQXZCIT06wMDFpL09qKwd6TSA4xor
         fVhsHrQTcG1SR8bB52QXN+KuHtj9Aqv/GbHdob8iuXF0/h4yLMYVkuskD2N7X/ekrW
         X1RXJUjekoKyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/25] serial: max310x: unregister uart driver in case of failure and abort
Date:   Mon, 24 May 2021 10:49:45 -0400
Message-Id: <20210524145008.2499049-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0c35c3c5e373..c1ab0dbda8a9 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1480,10 +1480,12 @@ static int __init max310x_uart_init(void)
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

