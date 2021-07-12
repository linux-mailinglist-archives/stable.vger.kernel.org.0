Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A573C4D0C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbhGLHLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242871AbhGLHHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EC89613B5;
        Mon, 12 Jul 2021 07:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073461;
        bh=AxcC7+c1L3kF4aUcbEf73AJDLNLG6y/n0FMjJUZ2mL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x171eGS6cus3j5XVrgsjhuHEbJHiXftxfsH9kNd3L7Gx8c5u97wXErylx006oJLyl
         ZCzAxCLz6+a1tfYTC16Muf0E+c03DYT49tCAXbS/t/cuC8LN8Y96kP8aAIU1yr5EmA
         r46YfNBfDeObmF56hoaHa7s1ESTWBcsDcBeiSnyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 249/700] spi: Avoid undefined behaviour when counting unused native CSs
Date:   Mon, 12 Jul 2021 08:05:32 +0200
Message-Id: <20210712061002.187430766@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f60d7270c8a3d2beb1c23ae0da42497afa3584c2 ]

ffz(), that has been used to count unused native CSs,
might cause undefined behaviour when called against ~0U.
To fix that, open code it with ffs(~value) - 1.

Fixes: 7d93aecdb58d ("spi: Add generic support for unused native cs with cs-gpios")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210420164425.40287-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index af126053213f..2350463bfb8f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2630,7 +2630,7 @@ static int spi_get_gpio_descs(struct spi_controller *ctlr)
 		native_cs_mask |= BIT(i);
 	}
 
-	ctlr->unused_native_cs = ffz(native_cs_mask);
+	ctlr->unused_native_cs = ffs(~native_cs_mask) - 1;
 
 	if ((ctlr->flags & SPI_MASTER_GPIO_SS) && num_cs_gpios &&
 	    ctlr->max_native_cs && ctlr->unused_native_cs >= ctlr->max_native_cs) {
-- 
2.30.2



