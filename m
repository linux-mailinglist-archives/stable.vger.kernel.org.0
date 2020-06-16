Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD471FB69F
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgFPPjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbgFPPi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:38:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C592B20B1F;
        Tue, 16 Jun 2020 15:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321938;
        bh=gt+AjfnTogwCXDa0RqxlbheP0cl930vbYCf3oDXcGJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnMk4zXvXWJYlcntdsMLGWQ3V8cKfnuI5QX3RWq0sN45Mk0cJ+RTFmXAJX0phiGgz
         jaPqBJiB5KdfWoHYrBL8S2+0Avh4zYQy+PwllSuJZdTpGPNXKZ/oGe4cnittFrSbHk
         H+kwx8gVtXUX+7lfngOME2x8Pm1Z0e13OhQGGMl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 072/134] spi: pxa2xx: Fix runtime PM ref imbalance on probe error
Date:   Tue, 16 Jun 2020 17:34:16 +0200
Message-Id: <20200616153104.227144164@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 65e318e17358a3fd4fcb5a69d89b14016dee2f06 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1889,7 +1889,6 @@ static int pxa2xx_spi_probe(struct platf
 	return status;
 
 out_error_pm_runtime_enabled:
-	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 out_error_clock_enabled:


