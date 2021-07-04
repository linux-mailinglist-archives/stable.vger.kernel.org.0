Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD0B3BB26F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhGDXPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhGDXO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A2A61997;
        Sun,  4 Jul 2021 23:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440190;
        bh=lEsf+MMZK+3GJndDa9D1xTAMOcuSfzQ+aaQ+k6xq4QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPVJck0NfeeTo3nHagrp+tj1UQ2+/Z+oglrwcCBYkaA1Yf+KN5KtRBGlS5ToC0zUg
         9eMIGqeMmxvUSBqI1agn8Gc0oiWz88vgfAEYHuSnZmOHpBsWE2GbdBkX+YDzwHvIFH
         fE7a/nuc+FUvmId05g32XgcUa1ZwyOo6lB0UL8jZxiL1mfGakAnunaWWC7X+Kbgod8
         WDlRtpEdIpA5LU4cSo+4YMdb0X36xFLIVdfTxeDb8vAPExsK0aRasgsm1cRpntyZiM
         ozL9gC/0BPC6mVSjwi8mdaW9ZeipWZSny6KmlHOKLqmEhDVkv2j6pT6AQPGwOWNw9X
         eKVVK1Jy9vibQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/50] spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
Date:   Sun,  4 Jul 2021 19:08:57 -0400
Message-Id: <20210704230938.1490742-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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
index 51633b2b6437..69a9df2cbbcf 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -868,7 +868,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 		test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
-- 
2.30.2

