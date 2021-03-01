Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAC3287DA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhCAR3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238114AbhCARXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D15E6506F;
        Mon,  1 Mar 2021 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617323;
        bh=SJ5vF90bARy9K/DLjLbR53I86L6CcONxMB2UwlracaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ES1bh8VfjD2E/UskoMzG4KDbakTXfonU+izE78QgUmW4Q1KweWZv0JuKHrK+iVw4A
         IdJz3sCg2n8Eg/g669ibfgrSMkCWCWErrBN/Vi/ud/hl3imvY7AIRSHmo8B+XXe2aL
         s/0QENI+e7Ts9WL6rVOAK3Qm7hNDWTRTV3B/prZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 5.4 006/340] PCI: qcom: Use PHY_REFCLK_USE_PAD only for ipq8064
Date:   Mon,  1 Mar 2021 17:09:10 +0100
Message-Id: <20210301161048.615718917@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

commit 2cfef1971aea6119ee27429181d6cb3383031ac2 upstream.

The use of PHY_REFCLK_USE_PAD introduced a regression for apq8064 devices.
It was tested that while apq doesn't require the padding, ipq SoC must use
it or the kernel hangs on boot.

Link: https://lore.kernel.org/r/20201019165555.8269-1-ansuelsmth@gmail.com
Fixes: de3c4bf64897 ("PCI: qcom: Add support for tx term offset for rev 2.1.0")
Reported-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org	# v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -402,7 +402,9 @@ static int qcom_pcie_init_2_1_0(struct q
 
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
-	val &= ~PHY_REFCLK_USE_PAD;
+	/* USE_PAD is required only for ipq806x */
+	if (!of_device_is_compatible(node, "qcom,pcie-apq8064"))
+		val &= ~PHY_REFCLK_USE_PAD;
 	val |= PHY_REFCLK_SSP_EN;
 	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
 


