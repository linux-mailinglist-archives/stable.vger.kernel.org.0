Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED794505CF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhKONqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhKONlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 08:41:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F9761AF0;
        Mon, 15 Nov 2021 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983531;
        bh=ly2sCGr9GxslTECmWWpOexhBh5/QS9xbKc6+ky/VYHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUFfjMDcZ75HMJvUHuXCOB8UToKmaLijZzALQ7HH3tyzYj+pV1CqX4j9WwU7IFjK5
         +EosK9ap+xRivNOUkA2e1Atb/u4GsK9f7KouwJ8bMEZ2q0Ll8HwEVLlL9dxA8JKieq
         Y3FSRl1hpCIUlXAsFulG9Y9hVTcAeeGrPnvSzzxnVAMUGa++ngmFUaqN6skiLVNYpK
         8ZF/znPu9nmrgcvlmTMGpZmqCPjJpeki3G6YzVlKW2xw6Cke8OxyMbBTrJaZU3ttVM
         QbUSe1FK5oNJha9UANaDwmcpC0qautAmLwyPdbPOeJzkIi+K5ltPVXLJTaaKyvLD77
         A1/vT2foFlMtw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmcBy-0002zb-Hz; Mon, 15 Nov 2021 14:38:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH 1/3] serial: liteuart: fix compile testing
Date:   Mon, 15 Nov 2021 14:37:43 +0100
Message-Id: <20211115133745.11445-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115133745.11445-1-johan@kernel.org>
References: <20211115133745.11445-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow the liteuart driver to be compile tested by fixing the broken
Kconfig dependencies.

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable@vger.kernel.org	# 5.11
Cc: Filip Kokosinski <fkokosinski@antmicro.com>
Cc: Mateusz Holenko <mholenko@antmicro.com>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 6ff94cfcd9db..67de892e0947 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1531,9 +1531,9 @@ config SERIAL_MILBEAUT_USIO_CONSOLE
 
 config SERIAL_LITEUART
 	tristate "LiteUART serial port support"
+	depends on LITEX || COMPILE_TEST
 	depends on HAS_IOMEM
-	depends on OF || COMPILE_TEST
-	depends on LITEX
+	depends on OF
 	select SERIAL_CORE
 	help
 	  This driver is for the FPGA-based LiteUART serial controller from LiteX
-- 
2.32.0

