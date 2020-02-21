Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15425167605
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbgBUIGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:06:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731977AbgBUIGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:06:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 864FE2465D;
        Fri, 21 Feb 2020 08:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272402;
        bh=eZh0i0gIregeCPldQnezjgGWqhzibJDxeHddPP7JMnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsPaf/ItEMTKYsBt7K1+zouphu2gX3ai6ISsLTDGYP/tIgwqk9t64ORX9KfYC5HN7
         +BD3SUbn8t/HW+A5m549r3K8iTcHSLi8/6gDf8LOPpxCJrgS3QkJkp+EDpSJlMMBea
         njI2qzo1GZLsIk0U0Xu/mxvwb72P2lc0rTiDUVyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/344] r8169: check that Realtek PHY driver module is loaded
Date:   Fri, 21 Feb 2020 08:38:48 +0100
Message-Id: <20200221072400.571282819@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit f325937735498afb054a0195291bbf68d0b60be5 ]

Some users complained about problems with r8169 and it turned out that
the generic PHY driver was used instead instead of the dedicated one.
In all cases reason was that r8169.ko was in initramfs, but realtek.ko
not. Manually adding realtek.ko to initramfs fixed the issues.
Root cause seems to be that tools like dracut and genkernel don't
consider softdeps. Add a check for loaded Realtek PHY driver module
and provide the user with a hint if it's not loaded.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5ae0b5663d540..a2cef6a004e73 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -7064,6 +7064,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chipset, region;
 	int jumbo_max, rc;
 
+	/* Some tools for creating an initramfs don't consider softdeps, then
+	 * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
+	 * PHY driver is used that doesn't work with most chip versions.
+	 */
+	if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
+		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+		return -ENOENT;
+	}
+
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
 	if (!dev)
 		return -ENOMEM;
-- 
2.20.1



