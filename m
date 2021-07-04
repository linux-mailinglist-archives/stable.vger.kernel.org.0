Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04A23BB290
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhGDXPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhGDXOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E29613FC;
        Sun,  4 Jul 2021 23:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440250;
        bh=VVcjGQYbJrYJ1CLTZT5bHW7YYA5rx/mZZv2CqF8HFWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuB5NCOsouMA8tD7A37c8VsgW1NgOMIMJgZhsf/t+Nz13DS3LdqsdkmD9PVMw5DLD
         JBfQFoVn2V49IItxEATgl+Npu8rJbZX2+hm4LAoYM7OFR+CJVfP3VogBnE7YUnAQqj
         Xh0Msa8YDBj4KWrERiwUgHCCL6amrkXUBRgC8rfH+5rg/u8PfCzBMpc1mmE/jS/EGl
         pWlZ1T/1mGqgvdGS1mlGPc3cqR1isc9HuieylW5ACXOZsqKhz/NdUUeEcNudNYPFnE
         fQeCEnR1Az5s6y3S6vEGOsBqhMcnfJSPYIsucEf21wEnIu//BqbTKj77Ky9glumq/T
         yFOUtakAoKMyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/31] spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
Date:   Sun,  4 Jul 2021 19:10:17 -0400
Message-Id: <20210704231043.1491209-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Fang <f.fangjian@huawei.com>

[ Upstream commit 9e37a3ab0627011fb63875e9a93094b6fc8ddf48 ]

In function 'spi_test_run_iter': Value 'tx_buf' might be 'rx_buf'.

Signed-off-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/1620629903-15493-5-git-send-email-f.fangjian@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-loopback-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index b9a7117b6dce..85d3475915dd 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -877,7 +877,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 		test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
-- 
2.30.2

