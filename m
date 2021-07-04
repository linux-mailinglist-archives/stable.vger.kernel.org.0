Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42B93BAFFA
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhGDXHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhGDXHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18ADC613D2;
        Sun,  4 Jul 2021 23:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439882;
        bh=bNjkqoyhJ5ZdEXcY3Uw5trWV/WihKOhEWTJBt87HekM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3h8Evy2Lflu45S4YpRJxGK51I7SRjBTwF5iesUSMQKAYhemi99S8KUMWcRyVqYki
         dtCJFxX9ef+pyfLqdnOGQsYViEFfYjJRfmPnkuZ8nqxOPKE1k6X87lC3h6QuvKQJBT
         SDWaClNiWKrHPm0jbdhdMkzLgvK0sTx7zsrrlFg6/hsuXHfPYOzRj2CRNfWhgC3e64
         PkT2Mxm7EX4ywQLV8LUeWopQxYP7qhvTBfYP5r+VUnRi7LAegZbfWzFXE0BH0nALEx
         Vcxt9DAJWnOe0Krw4FKOTK/YdiU73VU3bNTJ3AfHR1XtWcap4Ag8syV/NoYcJ3HEQo
         XN9RRKqb4kDJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 16/85] spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
Date:   Sun,  4 Jul 2021 19:03:11 -0400
Message-Id: <20210704230420.1488358-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index f1cf2232f0b5..4d4f77a186a9 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -875,7 +875,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 		test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
-- 
2.30.2

