Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05C7451470
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349266AbhKOUF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344358AbhKOTYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678B16366E;
        Mon, 15 Nov 2021 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002587;
        bh=808IRSV1ctutIU14jsPC+s3hg0ikRxgE78tFuB8fxVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HifV8EVjemv0OLvendHc14ve6kxb/3GeGmDJhWBowCXD/5t/tuJG57Q5hcMo8C0np
         2uiXKEsmK9YuIKmIsFku8uJKQF/WNgDGZRV5RYIUKv1+TDdSvwgKDFRbEFytkcrvsV
         ZedceMC7WPVynbwLiH3Okxuiz2FkBRKmm9gpzgeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Palmer <daniel@0x0f.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 623/917] serial: 8250_dw: Drop wrong use of ACPI_PTR()
Date:   Mon, 15 Nov 2021 18:01:58 +0100
Message-Id: <20211115165449.917846980@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ebabb77a2a115b6c5e68f7364b598310b5f61fb2 ]

ACPI_PTR() is more harmful than helpful. For example, in this case
if CONFIG_ACPI=n, the ID table left unused which is not what we want.

Instead of adding ifdeffery here and there, drop ACPI_PTR().

Fixes: 6a7320c4669f ("serial: 8250_dw: Add ACPI 5.0 support")
Reported-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211005134516.23218-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index a3a0154da567d..49559731bbcf1 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -726,7 +726,7 @@ static struct platform_driver dw8250_platform_driver = {
 		.name		= "dw-apb-uart",
 		.pm		= &dw8250_pm_ops,
 		.of_match_table	= dw8250_of_match,
-		.acpi_match_table = ACPI_PTR(dw8250_acpi_match),
+		.acpi_match_table = dw8250_acpi_match,
 	},
 	.probe			= dw8250_probe,
 	.remove			= dw8250_remove,
-- 
2.33.0



