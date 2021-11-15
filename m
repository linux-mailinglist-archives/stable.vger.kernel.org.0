Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5D4522C5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378585AbhKPBQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244487AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A333C634CB;
        Mon, 15 Nov 2021 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000497;
        bh=wwvbXkoupwqbRam/tSaKkNDGNTsMuDG73U5havGj0C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuQFFLB8PD4hqQpHU3nyULt6QJ1+B0elfmjopZyyRAKIFtHCWekiovqURsx5+nOPT
         aSLjITX7z+PDbWMg7XxAALjyEgIxk6QDjCD8UKuf2e1UnCPz39xMGAiSBq8ven5hTQ
         zAZSGDJvVB6OBqYY5u/Be0Xc7qBqARoVCCYBQ3AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 682/849] PCI: aardvark: Dont spam about PIO Response Status
Date:   Mon, 15 Nov 2021 18:02:45 +0100
Message-Id: <20211115165443.342738421@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 464de7e7fff767e87429cd7be09c4f2cb50a6ccb ]

Use dev_dbg() instead of dev_err() in advk_pcie_check_pio_status().

For example CRS is not an error status, it just says that the request
should be retried.

Link: https://lore.kernel.org/r/20211005180952.6812-4-kabel@kernel.org
Fixes: 8c39d710363c1 ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index d003c0b8393cf..16b07103312b7 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -778,7 +778,7 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, bool allow_crs, u3
 	else
 		str_posted = "Posted";
 
-	dev_err(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
+	dev_dbg(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
 		str_posted, strcomp_status, reg, advk_readl(pcie, PIO_ADDR_LS));
 
 	return -EFAULT;
-- 
2.33.0



