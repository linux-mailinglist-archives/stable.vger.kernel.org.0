Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1459C11328A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfLDSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbfLDSJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:09:13 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1862120674;
        Wed,  4 Dec 2019 18:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482952;
        bh=2t/IrvB4eJyhojy7MPif2j02JqHk+eNwDHMPvDXIcdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iNZjC62PusGuXklXtIiWUWHfJMxYC75tiAPhb9MdOtjSZkfNu1Os9pZP3tDJtKAB
         KGDSdNVoyMN7B7cWhaMcvkvQ7+msxklXXoQbBADSyZjoq32BWvUKPhLf+s3ncjOnq/
         xzwtrDmwKUPHPW3iISpaIqjHBDiYyhSGe7HQm9uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 202/209] mailbox: mailbox-test: fix null pointer if no mmio
Date:   Wed,  4 Dec 2019 18:56:54 +0100
Message-Id: <20191204175337.394459343@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@st.com>

commit 6899b4f7c99c72968e58e502f96084f74f6e5e86 upstream.

Fix null pointer issue if resource_size is called with no ioresource.

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mailbox/mailbox-test.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -363,22 +363,24 @@ static int mbox_test_probe(struct platfo
 
 	/* It's okay for MMIO to be NULL */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	size = resource_size(res);
 	tdev->tx_mmio = devm_ioremap_resource(&pdev->dev, res);
-	if (PTR_ERR(tdev->tx_mmio) == -EBUSY)
+	if (PTR_ERR(tdev->tx_mmio) == -EBUSY) {
 		/* if reserved area in SRAM, try just ioremap */
+		size = resource_size(res);
 		tdev->tx_mmio = devm_ioremap(&pdev->dev, res->start, size);
-	else if (IS_ERR(tdev->tx_mmio))
+	} else if (IS_ERR(tdev->tx_mmio)) {
 		tdev->tx_mmio = NULL;
+	}
 
 	/* If specified, second reg entry is Rx MMIO */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	size = resource_size(res);
 	tdev->rx_mmio = devm_ioremap_resource(&pdev->dev, res);
-	if (PTR_ERR(tdev->rx_mmio) == -EBUSY)
+	if (PTR_ERR(tdev->rx_mmio) == -EBUSY) {
+		size = resource_size(res);
 		tdev->rx_mmio = devm_ioremap(&pdev->dev, res->start, size);
-	else if (IS_ERR(tdev->rx_mmio))
+	} else if (IS_ERR(tdev->rx_mmio)) {
 		tdev->rx_mmio = tdev->tx_mmio;
+	}
 
 	tdev->tx_channel = mbox_test_request_channel(pdev, "tx");
 	tdev->rx_channel = mbox_test_request_channel(pdev, "rx");


