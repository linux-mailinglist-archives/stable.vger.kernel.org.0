Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3613C48C2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhGLGkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237997AbhGLGjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01243611F1;
        Mon, 12 Jul 2021 06:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071763;
        bh=CE/WAWc0p896qmORqkpfmtTh5+bSqWQBq/cJKattkkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgAkUPa/eBxftNhVtO4u+LK+aOyDi5INChJoy14IVsecCrU13xX4Jr5G1BtA5nRYN
         Lsw9QHtUhUb7Xj3T3i094Wca/9vNojSYeHQi/5oer9CtYfgzFBCLDYWyp1uXqbNbvz
         DclZ9G35S8LXIB1S96+pFjOKdeGqG5nNWyToUwLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/593] spi: Avoid undefined behaviour when counting unused native CSs
Date:   Mon, 12 Jul 2021 08:06:10 +0200
Message-Id: <20210712060906.041255997@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index a1a85f0baf7c..8c261eac2cee 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2614,7 +2614,7 @@ static int spi_get_gpio_descs(struct spi_controller *ctlr)
 		native_cs_mask |= BIT(i);
 	}
 
-	ctlr->unused_native_cs = ffz(native_cs_mask);
+	ctlr->unused_native_cs = ffs(~native_cs_mask) - 1;
 
 	if ((ctlr->flags & SPI_MASTER_GPIO_SS) && num_cs_gpios &&
 	    ctlr->max_native_cs && ctlr->unused_native_cs >= ctlr->max_native_cs) {
-- 
2.30.2



