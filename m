Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD2F469F30
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391507AbhLFPpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390749AbhLFPmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52533C07E5E8;
        Mon,  6 Dec 2021 07:30:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6105612D3;
        Mon,  6 Dec 2021 15:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5934C34901;
        Mon,  6 Dec 2021 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804629;
        bh=tziYubwZ4pWbfOphR/KM2FADJdUUQLaBT8OhOe3U2ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5vE8UIwrpf7Juw73a9D3KEiX3yIH7DB0Zjz9SwPleF1Cv5sNEHJqZwT46vWcy/7r
         uFnUiVTc4UkYgr5p8WKczsACOi8wM3EPKFWaGtkHzUkK8GjkKv5iD1b5yqn+4AYENa
         oUIq9bsOOoTTfvBP8r7cJIqg0eyRpgSKshCbBXIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Stafford Horne <shorne@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 205/207] serial: liteuart: fix use-after-free and memleak on unbind
Date:   Mon,  6 Dec 2021 15:57:39 +0100
Message-Id: <20211206145617.389957289@linuxfoundation.org>
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

commit 05f929b395dec8957b636ff14e66b277ed022ed9 upstream.

Deregister the port when unbinding the driver to prevent it from being
used after releasing the driver data and leaking memory allocated by
serial core.

Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
Cc: stable@vger.kernel.org      # 5.11
Cc: Filip Kokosinski <fkokosinski@antmicro.com>
Cc: Mateusz Holenko <mholenko@antmicro.com>
Reviewed-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211117100512.5058-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/liteuart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -295,6 +295,7 @@ static int liteuart_remove(struct platfo
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct liteuart_port *uart = to_liteuart_port(port);
 
+	uart_remove_one_port(&liteuart_driver, port);
 	xa_erase(&liteuart_array, uart->id);
 
 	return 0;


