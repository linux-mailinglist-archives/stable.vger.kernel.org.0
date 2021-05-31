Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76D395CE5
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhEaNkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhEaNhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 580A86144F;
        Mon, 31 May 2021 13:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467560;
        bh=mJeqKre+1wmJpQ/4NRYPtBLkivBvz8xppH54EUsGy8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDn4iLvH5ru132p5zBc0DLKWICgtbAglrE7dVrpVHowtgVbXTdkN9xd29riv/e0XJ
         GoB3THIFErtHmCfMPxSrP4DhplFkntRZPPm7oGHmPCsnP7/eWK8cTe3nGM85LXHydx
         CpIiFmat2A8SSipS7vphCUtaFTgGSja9fmp1O+5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/116] serial: max310x: unregister uart driver in case of failure and abort
Date:   Mon, 31 May 2021 15:14:12 +0200
Message-Id: <20210531130642.735432583@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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



