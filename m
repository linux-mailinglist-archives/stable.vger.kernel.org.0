Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21327177EA1
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgCCRot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbgCCRor (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:44:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C776E214DB;
        Tue,  3 Mar 2020 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257487;
        bh=IO9nZ9LQSp+rwMwlknX2fsvdw8F3hdCvSXPpEBCc1iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGRzzRFsyL8OjPVl2Qy7GPqNV/vVoLbTZHObESV+m4JABuCBIaeC7vHOTAu4P/XAo
         XZmzi6K+hI2eeudvgYPAhAxMjUSTHcdvdQV2uq0BAJmhBPUCjt9PuGuH1b9WLkiygs
         ccx3pAS5FTk3wVUYQiS51O0bI0oq5/LKwonT7URE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 015/176] bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.
Date:   Tue,  3 Mar 2020 18:41:19 +0100
Message-Id: <20200303174306.342265984@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
@@ -11775,6 +11775,14 @@ static int bnxt_init_one(struct pci_dev
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


