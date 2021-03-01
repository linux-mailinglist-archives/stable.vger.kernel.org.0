Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD1328608
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbhCARCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233525AbhCAQ4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:56:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CFB164FD2;
        Mon,  1 Mar 2021 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616565;
        bh=IVNC5ZX8q8y7rAJijhYCzaHK4HPSuhZTTeYeb4d30/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1KyxI1zNB9JNj+9LTLSfaaaTlHsUUP2NLgvA+LvSdPjaXREgtjd02ontxZyCJYXH
         ay7yWd8meaeE+LNON6zwGYaaLMpdhIAZeJettQTwgVztHCU8615B4eVPHLgl5tBvKj
         ShFBgg6SIUnRk706oZo3IQCZmErcgEYlfbmweMQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 4.19 019/247] PCI: qcom: Use PHY_REFCLK_USE_PAD only for ipq8064
Date:   Mon,  1 Mar 2021 17:10:39 +0100
Message-Id: <20210301161032.636433822@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
@@ -371,7 +371,9 @@ static int qcom_pcie_init_2_1_0(struct q
 
 	/* enable external reference clock */
 	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
-	val &= ~PHY_REFCLK_USE_PAD;
+	/* USE_PAD is required only for ipq806x */
+	if (!of_device_is_compatible(node, "qcom,pcie-apq8064"))
+		val &= ~PHY_REFCLK_USE_PAD;
 	val |= PHY_REFCLK_SSP_EN;
 	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
 


