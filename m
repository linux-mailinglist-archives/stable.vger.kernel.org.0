Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3F43BB1A4
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGDXMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhGDXLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF90F6195D;
        Sun,  4 Jul 2021 23:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440104;
        bh=uu4IOEsZsfgAPk2eecSoxen6XKp6DK3pLY4HKZJa1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4PXTlLbLMepqKchiFhrPu9yM97irXR29DJfQsYS5TKWwHiIqqqplR53RYM3dwFwp
         LVM2bZHoHwRRFvUqWxxSkW/MghS+1yJO2OWoV406V27W7m2lMtCFBmL9LoUyhBej62
         6cnFzKK+Ks33PlIrlOhvMutM4mkPHPmHWviTPier9m+QwVar0PQUAfz8AqdxNA207r
         a9BZUrZD9imtOdmXBuGuRNR8o6ugx9OX9m4MA8jN9Nt+RZW0SmLhXanJQA4Yzctx20
         an7UmswNDtqOd6ydB71GhTZsfLwRwXVubCVbqC/mLihpjJAGyAVRnilx8xi8zn4sjm
         c+HZvVtcT257A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Fang <f.fangjian@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/70] spi: spi-loopback-test: Fix 'tx_buf' might be 'rx_buf'
Date:   Sun,  4 Jul 2021 19:07:08 -0400
Message-Id: <20210704230804.1490078-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
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
index df981e55c24c..89b91cdfb2a5 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -874,7 +874,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 		test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
-- 
2.30.2

