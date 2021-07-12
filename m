Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CFB3C523A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349975AbhGLHpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241121AbhGLHmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37489601FE;
        Mon, 12 Jul 2021 07:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075564;
        bh=qTMTGeV9ciYP7Qn8FcEjRuogBwwuHoI6ciBk60nevYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M309S8M0SMRocpJ2faZOiJnCvuFK+647jrcr19U4IHOIL6Tdsq2SlvA+a/WJy6Y7Y
         4bo7jyy27Tm1oYkJWNh1mI81mnyp32lk4CrRoAIhiVhJoxzcD6oXd60+FGdXrG8Te2
         yi/0D9Qex20P7jHiW68oiGDCFIdvgXQuY3ZI+O0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 268/800] spi: Avoid undefined behaviour when counting unused native CSs
Date:   Mon, 12 Jul 2021 08:04:51 +0200
Message-Id: <20210712060952.435549469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index ae04ae79e56a..56c173869d97 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2622,7 +2622,7 @@ static int spi_get_gpio_descs(struct spi_controller *ctlr)
 		native_cs_mask |= BIT(i);
 	}
 
-	ctlr->unused_native_cs = ffz(native_cs_mask);
+	ctlr->unused_native_cs = ffs(~native_cs_mask) - 1;
 
 	if ((ctlr->flags & SPI_MASTER_GPIO_SS) && num_cs_gpios &&
 	    ctlr->max_native_cs && ctlr->unused_native_cs >= ctlr->max_native_cs) {
-- 
2.30.2



