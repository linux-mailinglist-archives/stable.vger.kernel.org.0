Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC2D12C778
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfL2RmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbfL2RmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1824A20718;
        Sun, 29 Dec 2019 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641343;
        bh=SO80qTfhuuZnOKrR0zqMqmPghi9X1Dt0wB0Ee1DHsyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avqHkO0MKaEBJlkD339mMtDajMW/k15GqcDepOjKZzviJke1TywoNDSiYCeO9gpQm
         Tmm2zWZTIjz7LWdzVa4QnA4HT3wHxf9EpJ4Aoq3ZaevjZWZw3whyniFUf7HRjdPzqC
         IeCRejNEdgjpeuhmXGJPf4hTHgda2hKBkYn6PYI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 027/434] NFC: nxp-nci: Fix probing without ACPI
Date:   Sun, 29 Dec 2019 18:21:20 +0100
Message-Id: <20191229172703.876687020@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 868afbaca1e2a7923e48b5e8c07be34660525db5 ]

devm_acpi_dev_add_driver_gpios() returns -ENXIO if CONFIG_ACPI
is disabled (e.g. on device tree platforms).
In this case, nxp-nci will silently fail to probe.

The other NFC drivers only log a debug message if
devm_acpi_dev_add_driver_gpios() fails.
Do the same in nxp-nci to fix this problem.

Fixes: ad0acfd69add ("NFC: nxp-nci: Get rid of code duplication in ->probe()")
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nxp-nci/i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -278,7 +278,7 @@ static int nxp_nci_i2c_probe(struct i2c_
 
 	r = devm_acpi_dev_add_driver_gpios(dev, acpi_nxp_nci_gpios);
 	if (r)
-		return r;
+		dev_dbg(dev, "Unable to add GPIO mapping table\n");
 
 	phy->gpiod_en = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_en)) {


