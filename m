Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572972015B0
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390008AbgFSOzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390000AbgFSOzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:55:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B8E2158C;
        Fri, 19 Jun 2020 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578544;
        bh=QEa7XrlnLLr3eBhKtiELVI4afInNDVlo/26zr5Hf8z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dcXWTrC+tgHGnXkcTiMu9BYM+AsGPjlrzRc3/rtEg0dmXpU8O4IWRjMGERfOzRY3
         /cNxktcwTvIMgxIv6OTwa/J8u1CEAlCf3DIwTbGvv9tnlEi53vunXsiXWKoB0ZXWTX
         HXCzQjftVbOd3h9Mv2TGoaaixKTX8xHEdhNTQ+9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/267] spi: pxa2xx: Fix runtime PM ref imbalance on probe error
Date:   Fri, 19 Jun 2020 16:30:48 +0200
Message-Id: <20200619141651.902045265@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 65e318e17358a3fd4fcb5a69d89b14016dee2f06 ]

The PXA2xx SPI driver releases a runtime PM ref in the probe error path
even though it hasn't acquired a ref earlier.

Apparently commit e2b714afee32 ("spi: pxa2xx: Disable runtime PM if
controller registration fails") sought to copy-paste the invocation of
pm_runtime_disable() from pxa2xx_spi_remove(), but erroneously copied
the call to pm_runtime_put_noidle() as well.  Drop it.

Fixes: e2b714afee32 ("spi: pxa2xx: Disable runtime PM if controller registration fails")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org # v4.17+
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/58b2ac6942ca1f91aaeeafe512144bc5343e1d84.1590408496.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 6551188fea23..2525fd9c8aa4 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1748,7 +1748,6 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	return status;
 
 out_error_pm_runtime_enabled:
-	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 out_error_clock_enabled:
-- 
2.25.1



