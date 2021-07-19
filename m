Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411CC3CD90F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbhGSO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244342AbhGSOZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5AC6024A;
        Mon, 19 Jul 2021 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707145;
        bh=6RJKt1rJB+Tl9PSJdzMzybbrRaOroIwvNMi4G3NUILc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbMFQF4IHwTmK+v7C6pcI7RuctDXS20JL6Z0HZXA00DMtLLEL/lLkH+BCVe8YLVV1
         3/RP8YaTs0mWX7DnCg/PHXUW/4MB69qFfIr8blxiZxuGfHmIEW+GeOI4zvrBCS7d3s
         HWG0ODO/t+2Yd27xHK7rqLHuKoyzTed5/Gr55SEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Fang <f.fangjian@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 029/245] spi: spi-loopback-test: Fix tx_buf might be rx_buf
Date:   Mon, 19 Jul 2021 16:49:31 +0200
Message-Id: <20210719144941.348110284@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



