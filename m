Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B316B1AC44E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506745AbgDPN5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506726AbgDPN5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:57:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D85F21734;
        Thu, 16 Apr 2020 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045456;
        bh=4lyHPOia/diCQ/+NljQpEdlVVkc7jJ+7eEXLzgL9/kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j80IicQV9x9L224uo1io9Ir5x9RudD/1prY13cpcsrb0kA35IgvFUrXQrPwJpjBXz
         LnoEYRfLp2CakQD+xcTI9H2WrEec5aajBTcZzSZ2gu1wpfHDMMEO8Apm5SgmRmoa2F
         hju+iT/CQB4sp2agMGnBDPq6oQ4TcxdI7e3N29SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 5.6 102/254] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
Date:   Thu, 16 Apr 2020 15:23:11 +0200
Message-Id: <20200416131338.805474836@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 604f3956524a6a53c1e3dd27b4b685b664d181ec upstream.

There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
the fixup to only affect the relevant PCIe bridges.

Fixes: 322f03436692 ("PCI: qcom: Use default config space read function")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/dwc/pcie-qcom.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_
 {
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
 
 static struct platform_driver qcom_pcie_driver = {
 	.probe = qcom_pcie_probe,


