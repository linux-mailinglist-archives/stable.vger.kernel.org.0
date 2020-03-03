Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF55178007
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbgCCRyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732331AbgCCRyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:54:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0532146E;
        Tue,  3 Mar 2020 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258054;
        bh=OozF0n4biiFo40h+gvtJt74tu01cqRvrmfum7rt5Q3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1toMsWJUG0o9ZntDbKB7b3mTzyca0e2262QSobW+ypIpBH5w7jVHcvj5Bl1dZbfw+
         2UmPXaEX8hi0VzMR1/QeHNBPWpFrCRVLZdEbyAbwkkc1nh6QDNJJxDhVtigFWeopTp
         6fUakvi3N+ify0DiFxvVp5mkw7Fx1isc3EhnnGXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 016/152] bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.
Date:   Tue,  3 Mar 2020 18:41:54 +0100
Message-Id: <20200303174304.335852104@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 8743db4a9acfd51f805ac0c87bcaae92c42d1061 ]

If crashed kernel does not shutdown the NIC properly, PCIe FLR
is required in the kdump kernel in order to initialize all the
functions properly.

Fixes: d629522e1d66 ("bnxt_en: Reduce memory usage when running in kdump kernel.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11712,6 +11712,14 @@ static int bnxt_init_one(struct pci_dev
 	if (version_printed++ == 0)
 		pr_info("%s", version);
 
+	/* Clear any pending DMA transactions from crash kernel
+	 * while loading driver in capture kernel.
+	 */
+	if (is_kdump_kernel()) {
+		pci_clear_master(pdev);
+		pcie_flr(pdev);
+	}
+
 	max_irqs = bnxt_get_max_irq(pdev);
 	dev = alloc_etherdev_mq(sizeof(*bp), max_irqs);
 	if (!dev)


