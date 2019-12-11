Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB57311AEDC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfLKPIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbfLKPIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BCA222C4;
        Wed, 11 Dec 2019 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076929;
        bh=uDFUA9JX959zDWtIDmfvG05ifKToXnSxeZF2PdDumeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAmm5Qj2cFxxuX4kvV5sYrLn7BcG7vSTwXadHtwUoPEsFN0dlNwcURL1VIJNuj5Qm
         sC3vPBi+a3sM6KKrdh3IdQMQkA2F4EW928eGgVJPHnuT9B3NURhLnissMup0ykmq2c
         OJDRnpw9mlRV14sNkDeYUrrmPETPnAhWVhPO4Ruk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 08/92] mailbox: tegra: Fix superfluous IRQ error message
Date:   Wed, 11 Dec 2019 16:04:59 +0100
Message-Id: <20191211150223.724847486@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit c745da8d4320c49e54662c0a8f7cb6b8204f44c4 upstream.

Commit 7723f4c5ecdb ("driver core: platform: Add an error message to
platform_get_irq*()") added an error message to avoid drivers having
to print an error message when IRQ lookup fails. However, there are
some cases where IRQs are optional and so new optional versions of
the platform_get_irq*() APIs have been added for these cases.

The IRQs for Tegra HSP module are optional because not all instances
of the module have the doorbell and all of the shared interrupts.
Hence, since the above commit was applied the following error messages
are now seen on Tegra194 ...

 ERR KERN tegra-hsp c150000.hsp: IRQ doorbell not found
 ERR KERN tegra-hsp c150000.hsp: IRQ shared0 not found

The Tegra HSP driver deliberately does not fail if these are not found
and so fix the above errors by updating the Tegra HSP driver to use
the platform_get_irq_byname_optional() API.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20191011083459.11551-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mailbox/tegra-hsp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -657,7 +657,7 @@ static int tegra_hsp_probe(struct platfo
 	hsp->num_db = (value >> HSP_nDB_SHIFT) & HSP_nINT_MASK;
 	hsp->num_si = (value >> HSP_nSI_SHIFT) & HSP_nINT_MASK;
 
-	err = platform_get_irq_byname(pdev, "doorbell");
+	err = platform_get_irq_byname_optional(pdev, "doorbell");
 	if (err >= 0)
 		hsp->doorbell_irq = err;
 
@@ -677,7 +677,7 @@ static int tegra_hsp_probe(struct platfo
 			if (!name)
 				return -ENOMEM;
 
-			err = platform_get_irq_byname(pdev, name);
+			err = platform_get_irq_byname_optional(pdev, name);
 			if (err >= 0) {
 				hsp->shared_irqs[i] = err;
 				count++;


