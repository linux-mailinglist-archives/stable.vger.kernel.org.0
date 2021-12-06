Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FF469F7F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391511AbhLFPpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390747AbhLFPmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A5EC07E5E1;
        Mon,  6 Dec 2021 07:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55EB861319;
        Mon,  6 Dec 2021 15:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB4C34901;
        Mon,  6 Dec 2021 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804623;
        bh=m/W/Y+r4mKH9k0xm3+I+PBATpxydoO0HgN2oo5CifXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QK5U9LYvodXxyZyM/txqvnVH5Fe4kXRAmRRlgazYnrDulqBe6KHJwtPJ3giRgJpYV
         YzVWRsHcnwS6J3hopi5NeWoiXlDuU5Fe2wUsJyN6IUT9uAW2iltcYwCAc3CtBIi+wR
         yjKK0mOG8kq7QShfZz7r9WHfUxlkXrwM8CqNa7NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Stafford Horne <shorne@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 206/207] serial: liteuart: fix minor-number leak on probe errors
Date:   Mon,  6 Dec 2021 15:57:40 +0100
Message-Id: <20211206145617.422222108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit dd5e90b16cca8a697cbe17b72e2a5f49291cabb2 upstream.

Make sure to release the allocated minor number before returning on
probe errors.

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable@vger.kernel.org      # 5.11
Cc: Filip Kokosinski <fkokosinski@antmicro.com>
Cc: Mateusz Holenko <mholenko@antmicro.com>
Reviewed-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211117100512.5058-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/liteuart.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -270,8 +270,10 @@ static int liteuart_probe(struct platfor
 
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
@@ -287,7 +289,16 @@ static int liteuart_probe(struct platfor
 
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


