Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BD838EBC7
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhEXPHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233594AbhEXPD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EE861400;
        Mon, 24 May 2021 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867843;
        bh=LSLv/cJ9GS5P3FoW2ST1fAGpkDOzWEU4nAYcEnOYDJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFg7ME8uNVmQxKPhPyr59qeGCgVVRljuLNCCGKE1qrhEhF4UsXiVNK6UqU15ZMREF
         920IqTHPc/wLEtAchCSOSy+FnQH1D/Oc2Kmq25vACWWXrb/7Sf3hiG/EDffkbo955/
         jainmOHFQSGJvSKketa295k7YwEmbz7kGKGDcyUzPeohWwVQR5tyTFm6XwD66D40uA
         WG6wtuUsmdmUciJo9lCVZelXo67x5zVJEvS5WFqY30GaOZv0BIaSaz6bC3D4f0v5le
         0GLpw1WraPkGkCcbOa0YXSA9y15elN+J/lY9rNDebKE40K8BvvQwiGbNoAW9fSanQY
         s86BT92k4W2Ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/21] serial: max310x: unregister uart driver in case of failure and abort
Date:   Mon, 24 May 2021 10:50:21 -0400
Message-Id: <20210524145040.2499322-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
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
index cec995ec11ea..454659544d35 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1385,10 +1385,12 @@ static int __init max310x_uart_init(void)
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

