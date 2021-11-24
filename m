Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0585545BA7E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhKXMLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242372AbhKXMJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:09:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02A260174;
        Wed, 24 Nov 2021 12:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755520;
        bh=v9pHMCjbcP4umAIkxK7QTpPF0wPM82LaS5Z/E0cUp8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvED/3owTV/E2P8LecDKU7CIuqssvtISiCN6DLY4OuxybdA79oCtYLatgBCI+N4Yt
         j3Ej4ZL3wggHCKEGcXvQNftf/DpCy7HgNPd3aJA+Ajtwn0tKfHw4E/H0xABJ6YCUdO
         a01bXfgz1OdF9leuI3RTIJqEmd/JezX9VF/N3Nug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Palmer <daniel@0x0f.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 093/162] serial: 8250_dw: Drop wrong use of ACPI_PTR()
Date:   Wed, 24 Nov 2021 12:56:36 +0100
Message-Id: <20211124115701.336025649@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
index 039837db65fcc..f3ed1eeaed4e1 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -607,7 +607,7 @@ static struct platform_driver dw8250_platform_driver = {
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



