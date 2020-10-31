Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0102A1680
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgJaLqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgJaLqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A09E20731;
        Sat, 31 Oct 2020 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144771;
        bh=kKaUicY+ILG95ZazH/8LfT/W8u72NgUBaZYU/tltthw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf5PKvrfz8PzvnH0GF0xYsPC2rtfbPOjuAVB7gedElDrnbDYEnd2sJJ2PB0gr3GNP
         s5Sphph5mhrqcRxq6NlaR9zKdW2OMwK+pG4nn/UtrnwRTZ/AF4upKH0UrwO2NOoFY6
         Ut3YDANnXKcK9hOgrjnlONf8A0UbOIrQblmEdCEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.9 56/74] PCI: aardvark: Fix initialization with old Marvells Arm Trusted Firmware
Date:   Sat, 31 Oct 2020 12:36:38 +0100
Message-Id: <20201031113502.713721391@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b0c6ae0f8948a2be6bf4e8b4bbab9ca1343289b6 upstream.

Old ATF automatically power on pcie phy and does not provide SMC call for
phy power on functionality which leads to aardvark initialization failure:

[    0.330134] mvebu-a3700-comphy d0018300.phy: unsupported SMC call, try updating your firmware
[    0.338846] phy phy-d0018300.phy.1: phy poweron failed --> -95
[    0.344753] advk-pcie d0070000.pcie: Failed to initialize PHY (-95)
[    0.351160] advk-pcie: probe of d0070000.pcie failed with error -95

This patch fixes above failure by ignoring 'not supported' error in
aardvark driver. In this case it is expected that phy is already power on.

Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Link: https://lore.kernel.org/r/20200902144344.16684-3-pali@kernel.org
Fixes: 366697018c9a ("PCI: aardvark: Add PHY support")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: <stable@vger.kernel.org> # 5.8+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-aardvark.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1076,7 +1076,9 @@ static int advk_pcie_enable_phy(struct a
 	}
 
 	ret = phy_power_on(pcie->phy);
-	if (ret) {
+	if (ret == -EOPNOTSUPP) {
+		dev_warn(&pcie->pdev->dev, "PHY unsupported by firmware\n");
+	} else if (ret) {
 		phy_exit(pcie->phy);
 		return ret;
 	}


