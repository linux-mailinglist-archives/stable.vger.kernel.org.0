Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CE03BB2EF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhGDXQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233467AbhGDXO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419D661959;
        Sun,  4 Jul 2021 23:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440192;
        bh=74xzt05qMpxL9HP0JbjXN2a93+3P8I224lauiDtI4N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuPiAP65OxFNKxZDy3UYm9nXA5RqUdYQkD+SCl67Aly3xu+Uzi+R5RV5Yq/WbKmDP
         Qy9Vl9lgfdVCZfwjmnsazsZYWB+RvfeLUkzMtsUTAVztJL6nyhBB8ssx73qXri4XLr
         FbkunmGOVCNARv5/Joi/svAmWjwLs/9JrsJsCjF0tkfcgtaZdhvSoLtzNgcdH7q/fs
         IrVgvrTXmhaG+ni+Ew8nUG9kU3dVVw9luLT5HYIra3g+Mr6nNu8MSRHsCpgx1pmMKh
         aD2OpxmoUWis+hcaRm2A9w3LpuzwYR/++BfNBMOCfx5r0r24aR8y/ubkA5yGmAqNdN
         h/taZb3AIxn6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/50] spi: omap-100k: Fix the length judgment problem
Date:   Sun,  4 Jul 2021 19:08:59 -0400
Message-Id: <20210704230938.1490742-11-sashal@kernel.org>
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

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit e7a1a3abea373e41ba7dfe0fbc93cb79b6a3a529 ]

word_len should be checked in the omap1_spi100k_setup_transfer
function to see if it exceeds 32.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Link: https://lore.kernel.org/r/1619695248-39045-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap-100k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index b8e201c09484..f64d030c760a 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -242,7 +242,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
-- 
2.30.2

