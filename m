Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFEB3BB339
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhGDXRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhGDXO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B2B615FF;
        Sun,  4 Jul 2021 23:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440319;
        bh=GKouUk8aDWduzqzmTINVVQTIzZrxjfxi9+MXQT7MVCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAlQ4v94a9ozPfY5/ISGEfjBlzfZ/wAoowIf/IB3JBUMVHT6aM1e97mkYweIw4dRa
         Kpzm8Yw3AUSPW8PaNMkprip/TsuC7iEgUZVrtgcYjyIB7Esf7xYaDJzzJUGHT6yRAs
         El8WpYjTKer+R7SyMkTCNbZuqkLHrm08afgL8JEnfuvdcFfn6OgbhzguXmmR+wKIV1
         A+IiyV1YdA5km+d0x9cBEDGgA6szb2tS+kMDQYNJHv7egSPvh5X7urs++WDnCphByu
         +NzKyC3+NLCaXeEMjF+RF8NrHQKmQPqQi02K0V0YHakWpPplozFkL6yf7sc+eq146q
         eoU11uCOebZIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/20] spi: omap-100k: Fix the length judgment problem
Date:   Sun,  4 Jul 2021 19:11:38 -0400
Message-Id: <20210704231155.1491795-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231155.1491795-1-sashal@kernel.org>
References: <20210704231155.1491795-1-sashal@kernel.org>
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
index 1eccdc4a4581..2eeb0fe2eed2 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -251,7 +251,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
-- 
2.30.2

