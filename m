Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C9A45C0A2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345195AbhKXNJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348259AbhKXNJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:09:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 762546112E;
        Wed, 24 Nov 2021 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757604;
        bh=NufzgRR9jaHGr3RQ/AN4yYTC2QjS/MPP5Zd1zdSXEt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRtn7PedqGah75gDNhOZMzoF5LGySC5vmK5y6CX5FcWeqvQWyv4W/4yYiSTVKHfHm
         eR07eKrYqrqalrg5ghx83eUmZPaFeHEYuhHr/48yuAj+QKChvji7+WmhRj5F76Vv5i
         JHUcndn8oCGY4U0gRobnWbRlyLOnJP4v5KfAM+pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Palmer <daniel@0x0f.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/323] serial: 8250_dw: Drop wrong use of ACPI_PTR()
Date:   Wed, 24 Nov 2021 12:56:19 +0100
Message-Id: <20211124115725.322945582@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 284e8d052fc3c..c73d0eddd9b8d 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -769,7 +769,7 @@ static struct platform_driver dw8250_platform_driver = {
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



