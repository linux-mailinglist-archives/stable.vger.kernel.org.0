Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB94505D0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhKONqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:46:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231953AbhKONlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 08:41:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A624C63223;
        Mon, 15 Nov 2021 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983531;
        bh=TWtUPpql8iSS/HErxqI/cqS6lf5/rUzZFgHdOFCpt0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AibSsKbiwHSxnVgE22Z3v+iiFFUOhjG5/yy8rBslkLXG3D0K+PbViC6rFReGB+9Ah
         5KDgSH+xUnf1gQ2b1KQ2IMDs6Bfro2Sg4rK+FCLeh6VbZL7cKzFm+XU+ZuoVwZSl9H
         0cTd9RtU6BOSerYuX5XlGaKLQIimKDtbwMgyAfBT9n0n/qSg8ZoqKmcbgPvIx3K94f
         bOmHlnpD+SgEG9vEd/+5NkzrNWvxeHxCLGvsFmyk6NmrFl8Ddl/8ZnugTFoVOEya5t
         7gFUE20+LkmENgA11DCXfAnSt74dpDk337p5JvW2SYxGATEp5t9IR1+JNkhgALft3b
         L8aQuvgUcjFGQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mmcBy-0002zd-KH; Mon, 15 Nov 2021 14:38:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Stafford Horne <shorne@gmail.com>
Subject: [PATCH 2/3] serial: liteuart: fix use-after-free and memleak on unbind
Date:   Mon, 15 Nov 2021 14:37:44 +0100
Message-Id: <20211115133745.11445-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115133745.11445-1-johan@kernel.org>
References: <20211115133745.11445-1-johan@kernel.org>
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
Cc: Stafford Horne <shorne@gmail.com>
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

