Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E09344120
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCVMbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbhCVMah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B04E6198D;
        Mon, 22 Mar 2021 12:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416237;
        bh=s61fcqChpRmIDZQfoVuhuZBpj2wXAuozfm8Mz7MOXIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swnwn68ciTuQJ/+NzOIJGBL7YTcWofMYNchdghGt0BnpGY4IsZWtTsXLBKlIQdvA+
         QGY6I6HUkK9x/QmOlWCxSPZ/YPVNsgh3Dif3TGosoMrJVF0sz+BQ3EumoL6N+Wa6/R
         qa135kvGs6WnlreHiUFZPTRd2w3ksKuI5448Y8yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Li <Meng.Li@windriver.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 003/120] spi: cadence: set cqspi to the driver_data field of struct device
Date:   Mon, 22 Mar 2021 13:26:26 +0100
Message-Id: <20210322121929.781902327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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


