Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F31E45BE01
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344487AbhKXMnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345182AbhKXMlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:41:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AEC961213;
        Wed, 24 Nov 2021 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756671;
        bh=B8oUvBQjdesKuKZ/Flr4mrKu3hS6pyPQbKCxiJf3CvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eofCf3Js5d3VQtBgzaQ4J2T528MGYpHRZSWmVpRR9PXKirWWC1vMQleo+wxZhMucP
         h7mjF7XYZCd5CHjujYjunttByRUzhXojcEA0sD60Aj0EwmCsnUGitOPEP2R1Hskuoz
         giP50+ePHu3GMafNWj49woegBMzSo2k8YVu8W6Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 164/251] PCI: aardvark: Dont spam about PIO Response Status
Date:   Wed, 24 Nov 2021 12:56:46 +0100
Message-Id: <20211124115715.973424066@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
 drivers/pci/host/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index a77c422170bd2..a572b2fb7af81 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -448,7 +448,7 @@ static int advk_pcie_check_pio_status(struct advk_pcie *pcie, u32 *val)
 	else
 		str_posted = "Posted";
 
-	dev_err(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
+	dev_dbg(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
 		str_posted, strcomp_status, reg, advk_readl(pcie, PIO_ADDR_LS));
 
 	return -EFAULT;
-- 
2.33.0



