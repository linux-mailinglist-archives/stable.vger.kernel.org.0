Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C7A382F7B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhEQOQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239049AbhEQOOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC23B613ED;
        Mon, 17 May 2021 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260557;
        bh=WEzSxR3LYmg8uei0Xm7ZiJWB/DnMKejsL2tNj8d4wK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVkFBJiytH5I6C2tLWL691OsW4vmif7ty6b6I3NkrbyvQwg5ED0WKPh4hoa/SDn1h
         kGbedZ8Nj3YQrq3KpEWDQeXnSm6wBLSTrAqW48Lt6/+7pvh/h3+c1CJR9qKWlDTAvw
         PYLJZTi9eqfJxpCjZJCc8/vOkVZyK3Y0ElzN1GzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 134/363] PCI: brcmstb: Fix error return code in brcm_pcie_probe()
Date:   Mon, 17 May 2021 16:00:00 +0200
Message-Id: <20210517140307.147277690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b5d9209d50838474fc1b2901d0e11bba59906428 ]

Fix to return negative error code -ENODEV from the unsupported revision
error handling case instead of 0, as done elsewhere in this function.

Link: https://lore.kernel.org/r/20210308135619.19133-1-weiyongjun1@huawei.com
Fixes: 0cdfaceb9889 ("PCI: brcmstb: support BCM4908 with external PERST# signal controller")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index e330e6811f0b..69c999222cc8 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1296,6 +1296,7 @@ static int brcm_pcie_probe(struct platform_device *pdev)
 	pcie->hw_rev = readl(pcie->base + PCIE_MISC_REVISION);
 	if (pcie->type == BCM4908 && pcie->hw_rev >= BRCM_PCIE_HW_REV_3_20) {
 		dev_err(pcie->dev, "hardware revision with unsupported PERST# setup\n");
+		ret = -ENODEV;
 		goto fail;
 	}
 
-- 
2.30.2



