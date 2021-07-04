Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0148F3BB2AE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhGDXQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234260AbhGDXO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65E56135A;
        Sun,  4 Jul 2021 23:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440317;
        bh=6RJKt1rJB+Tl9PSJdzMzybbrRaOroIwvNMi4G3NUILc=;
        h=From:To:Cc:Subject:Date:From;
        b=mKx1gdXaUrbNHoVuJ8o9cZww7pmAnjUA0PEu2IucBtMr/sipcyfdjuQh0MbCEcn5+
         6+SOqYBa2I3QOuhX3dsmpbnlFBdF4Hrj3Hw/sNgMkpYbrP4HbNDFjs93GCzTdXq6k8
         vzPkKkrKQ02WVpuV/xbliWP99TxgdaTg/6nCDxs3yFqEM/T7ieLz4b5O5xGnrEn5Bx
         gez8wLUG5swNvTYg7uFaCdkL9iqnLA8s4Ul7gSZd3Jfn7lXecLAdMpn04JwXGjh8Ve
         6ACRCzWu91oEr+KtJhKB9y8DewH/EQ6BCdXcTbgzPCXT66SoRjXzUacgVdbgGxNCvP
         EjlIxiqjv1vJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/20] spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
Date:   Sun,  4 Jul 2021 19:11:36 -0400
Message-Id: <20210704231155.1491795-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 7120083fe761..cac38753d0cd 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -803,7 +803,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 			test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
-- 
2.30.2

