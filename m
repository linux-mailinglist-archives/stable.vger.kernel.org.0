Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAF73BB2D1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhGDXQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhGDXOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A4261452;
        Sun,  4 Jul 2021 23:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440252;
        bh=GKouUk8aDWduzqzmTINVVQTIzZrxjfxi9+MXQT7MVCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsDXt8atA6ggKd97pOjTxKdQKogOBQ8DU1Ib7Q2aHwcu0CZ2qBkM9+9to+ahGjw1t
         1golzUZWeza2s50CnuulTG3Fc7rN7KGUyop60nhxs4uKn7KSfl/2amqfo3C+Apky7o
         Up5ZzFH5y1UqFBnWC6AQ8tuTOf4cF7Arw4ubqtLy+FanY8xOjmTmOEmsn3HphPODBZ
         tb7KRQbWd2ZPTaO2XlKEkgEUq3aQXgEjmnO2iPZrESK8deYd2N5wgd+PwAHc3YIhly
         1L7VfUXeduLUj/YOcX37x1O+qLhH8blYsziONiL8BH2+327fFxBwo26HC/c9UkEjrL
         C7nRiQIEqIemQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/31] spi: omap-100k: Fix the length judgment problem
Date:   Sun,  4 Jul 2021 19:10:19 -0400
Message-Id: <20210704231043.1491209-7-sashal@kernel.org>
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

