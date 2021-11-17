Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658FA4544A4
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbhKQKIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 05:08:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236055AbhKQKIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 05:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CEF560EBD;
        Wed, 17 Nov 2021 10:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637143542;
        bh=1XXwWsrGMJXdbhQwE4pOB+h2mN8wEfcH6Dlfo9qWuX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cT5V0Xe33OmJCbKgg8ObsE/4+rNzzN/ADgnZg3v83GvpiA79rQ0LyHHZa0Oi1igHR
         RXmAJXxjJKR9JcVgEnzpZbysTcyaU3evqPi678kCVQzHXbuZ+3Hq4ujxL8WWEEt5DR
         nkLoM2YOOgmBRoKJBFsGg3xuD3loyk3pGri+CWfPlljDw4z2GaV0TFcx92Q/T+eg22
         MzKSOzFQOPQRMaaRMmhqCLQsLEr0Hnv/yi6UlgKHE6lx7z62J53ql5h565i2cDlhq2
         39MFvH4IaPa5RONO/3fHds3Z7YBVKtlLb+tCIU6oWyYRLykvCdbme4FOhhPQfdpcWK
         GkORYNnd9Qfiw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mnHoi-0001KU-LF; Wed, 17 Nov 2021 11:05:24 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Stafford Horne <shorne@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Filip Kokosinski <fkokosinski@antmicro.com>
Subject: [PATCH v2 1/3] serial: liteuart: fix use-after-free and memleak on unbind
Date:   Wed, 17 Nov 2021 11:05:10 +0100
Message-Id: <20211117100512.5058-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117100512.5058-1-johan@kernel.org>
References: <20211117100512.5058-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Deregister the port when unbinding the driver to prevent it from being
used after releasing the driver data and leaking memory allocated by
serial core.

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable@vger.kernel.org      # 5.11
Cc: Filip Kokosinski <fkokosinski@antmicro.com>
Cc: Mateusz Holenko <mholenko@antmicro.com>
Reviewed-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/liteuart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
index f075f4ff5fcf..da792d0df790 100644
--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -295,6 +295,7 @@ static int liteuart_remove(struct platform_device *pdev)
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct liteuart_port *uart = to_liteuart_port(port);
 
+	uart_remove_one_port(&liteuart_driver, port);
 	xa_erase(&liteuart_array, uart->id);
 
 	return 0;
-- 
2.32.0

