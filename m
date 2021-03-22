Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F0A3441FB
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhCVMhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhCVMgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78406619AC;
        Mon, 22 Mar 2021 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416552;
        bh=s61fcqChpRmIDZQfoVuhuZBpj2wXAuozfm8Mz7MOXIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2HVGfxPt+aQTCjfKFMwkywKJO+IERu8UB9EoC5XQhkLXziW6gj6TQ+h8AvgWLpaB
         vrI9mI2BdjWoAI2MLzMwte248XYo/ZdzvVA6RBSDOZyQQfBFBGWqRxP17olSKlLM0w
         an1zQRjig4F5Qo8upCY4k8NA0ws5kP2d6IY2DHwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 003/157] spi: cadence: set cqspi to the driver_data field of struct device
Date:   Mon, 22 Mar 2021 13:26:00 +0100
Message-Id: <20210322121933.869963563@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

commit ea94191e584b146878f0b7fd4b767500d7aae870 upstream.

When initialize cadence qspi controller, it is need to set cqspi
to the driver_data field of struct device, because it will be
used in function cqspi_remove/suspend/resume(). Otherwise, there
will be a crash trace as below when invoking these finctions.

Fixes: 31fb632b5d43 ("spi: Move cadence-quadspi driver to drivers/spi/")
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Link: https://lore.kernel.org/r/20210311091220.3615-1-Meng.Li@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1198,6 +1198,7 @@ static int cqspi_probe(struct platform_d
 	cqspi = spi_master_get_devdata(master);
 
 	cqspi->pdev = pdev;
+	platform_set_drvdata(pdev, cqspi);
 
 	/* Obtain configuration from OF. */
 	ret = cqspi_of_get_pdata(cqspi);


