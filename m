Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303074544A6
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 11:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhKQKIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 05:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236056AbhKQKIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 05:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EEB161BF4;
        Wed, 17 Nov 2021 10:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637143542;
        bh=CX8OUhMnhHykIog+bQcI6spbJp9/XgWWj4zovXpY2h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQrmuTT0TNAlG2gyDmRnQ1kBWulVLGbtZe7WruT61eVdP+mZ/ufyTGSkn5zOpdx94
         W9ADluPRDV2+FwNaMPBwCi4EgbyKvIhtP8CoJbPLvaJpeqJIOTLqtI1YQXoObUc1lI
         zFTSk1O5t8CkMYiqrZb1SIcKfHtxlsBnoDX72Fu5PNVv56v2B7NN0czYPsLFdZb3Zi
         y34w4jI91HYDEUoNUo7MpdF4UTq6ysofDmVsPgWcEyy8ewvN1MzaN26fvbS1PGy9aL
         S2KYYBDC1gU0cIpCwzzP9OWvTVJPQ9Wbr3sZ128mtLgHeImkoqekDOs0r6n76JlMFz
         J8w3B5Wbi3qfg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mnHoi-0001KW-O3; Wed, 17 Nov 2021 11:05:24 +0100
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
Subject: [PATCH v2 2/3] serial: liteuart: fix minor-number leak on probe errors
Date:   Wed, 17 Nov 2021 11:05:11 +0100
Message-Id: <20211117100512.5058-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117100512.5058-1-johan@kernel.org>
References: <20211117100512.5058-1-johan@kernel.org>
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
Reviewed-by: Stafford Horne <shorne@gmail.com>
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

