Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F414505DF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKONrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhKONlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 08:41:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E0161B27;
        Mon, 15 Nov 2021 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983531;
        bh=kwM6GRZtwha79xTy0Omej+vH1bkmDkBzkbJKTf6s7+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cc7uP1kq22rAUeqnjUscDk0jXMC1uFxG00g52jJoU3stHV5X88Ipj8lqmtcCiIRh7
         AhaXV2dFQL1DDVOYTn1pwjmeNn6inhYht7eOAYiTIxTK2GyltpyrVss2qpKjtMFcqr
         M1rd55EXRGVBqiwc65kX4Hjrrn4PZI52sa6aBiwrxY02+QAQ/EIZFddgBIDSv3tmQO
         mibgWbeOIS7FRVgPee0roMeVrgRE8FXS8hBra1N6fDgk0F0sdeSN2ynnZFDp0C8TsE
         rnTBPfTwWRbYByXyWPln8us18fvfsXeAXdqLJVpWSYh4AHyQUXfVkbI5/FIYkAEH8n
         d0pHkZ3b7agrQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmcBy-0002zf-NM; Mon, 15 Nov 2021 14:38:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH 3/3] serial: liteuart: fix minor-number leak on probe errors
Date:   Mon, 15 Nov 2021 14:37:45 +0100
Message-Id: <20211115133745.11445-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115133745.11445-1-johan@kernel.org>
References: <20211115133745.11445-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to release the allocated minor number before returning on
probe errors.

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable@vger.kernel.org      # 5.11
Cc: Filip Kokosinski <fkokosinski@antmicro.com>
Cc: Mateusz Holenko <mholenko@antmicro.com>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/liteuart.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
index da792d0df790..2941659e5274 100644
--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -270,8 +270,10 @@ static int liteuart_probe(struct platform_device *pdev)
 
 	/* get membase */
 	port->membase = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(port->membase))
-		return PTR_ERR(port->membase);
+	if (IS_ERR(port->membase)) {
+		ret = PTR_ERR(port->membase);
+		goto err_erase_id;
+	}
 
 	/* values not from device tree */
 	port->dev = &pdev->dev;
@@ -287,7 +289,16 @@ static int liteuart_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, port);
 
-	return uart_add_one_port(&liteuart_driver, &uart->port);
+	ret = uart_add_one_port(&liteuart_driver, &uart->port);
+	if (ret)
+		goto err_erase_id;
+
+	return 0;
+
+err_erase_id:
+	xa_erase(&liteuart_array, uart->id);
+
+	return ret;
 }
 
 static int liteuart_remove(struct platform_device *pdev)
-- 
2.32.0

