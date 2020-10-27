Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D0429B8C9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801983AbgJ0PpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799762AbgJ0PdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:33:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A603722202;
        Tue, 27 Oct 2020 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812794;
        bh=68MZxKVkVV8Jbhxo8M3XddQfLsQPWjQhEbfXZvfq0+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or8x2oKSfqHklVdfQJk3kNcwkSoaP/yPUwi8y2TBNgdGNN5z3pgMrmkYT9S5rK5Z8
         7abvGQqTZ4DyjJA3ks776uZvjNCu9Dyq65tfmplLDDSVphonc7qpWgks3SQU6Ziswq
         R57jnlGOkIhDtcRm6hLcVZaQh8odwQBm1R7YDNDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 332/757] tty: hvc: fix link error with CONFIG_SERIAL_CORE_CONSOLE=n
Date:   Tue, 27 Oct 2020 14:49:42 +0100
Message-Id: <20201027135506.128546197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 75fc65079d8253e1c25a5f8348111a85d71e0f01 ]

aarch64-linux-gnu-ld: drivers/tty/hvc/hvc_dcc.o: in function `dcc_early_write':
hvc_dcc.c:(.text+0x164): undefined reference to `uart_console_write'

The driver uses the uart_console_write(), but SERIAL_CORE_CONSOLE is not
selected, so uart_console_write is not defined, then we get the error.
Fix this by selecting SERIAL_CORE_CONSOLE.

Fixes: d1a1af2cdf19 ("hvc: dcc: Add earlycon support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20200919063535.2809707-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index d1b27b0522a3c..8d60e0ff67b4d 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -81,6 +81,7 @@ config HVC_DCC
 	bool "ARM JTAG DCC console"
 	depends on ARM || ARM64
 	select HVC_DRIVER
+	select SERIAL_CORE_CONSOLE
 	help
 	  This console uses the JTAG DCC on ARM to create a console under the HVC
 	  driver. This console is used through a JTAG only on ARM. If you don't have
-- 
2.25.1



