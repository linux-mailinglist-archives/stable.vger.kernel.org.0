Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F1BCD674
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbfJFRna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbfJFRn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:43:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D46520862;
        Sun,  6 Oct 2019 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383808;
        bh=9T7/eaUJAeVaHklqNckNEqYtv7SCBRVS9WgcTLmyNp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHnHrZYWwdEauWFmTprDV1I07LQqhkqIrE4D+UlIhIk9D1Czau4I0uO3WHcu0DEwx
         1hs/6ElsNtw04JLWJhk8K0ZiovCTDCImF06WtrFTXl4sndy5sbSOWixD3+H/0jI/Ys
         10f5rYz7CiFbJ89mugttMv5km27syBg8wB/7VMYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Wilczynski <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 103/166] PCI: Add pci_info_ratelimited() to ratelimit PCI separately
Date:   Sun,  6 Oct 2019 19:21:09 +0200
Message-Id: <20191006171222.195618557@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczynski <kw@linux.com>

[ Upstream commit 7f1c62c443a453deb6eb3515e3c05650ffe0dcf0 ]

Do not use printk_ratelimit() in drivers/pci/pci.c as it shares the rate
limiting state with all other callers to the printk_ratelimit().

Add pci_info_ratelimited() (similar to pci_notice_ratelimited() added in
the commit a88a7b3eb076 ("vfio: Use dev_printk() when possible")) and use
it instead of printk_ratelimit() + pci_info().

Link: https://lore.kernel.org/r/20190825224616.8021-1-kw@linux.com
Signed-off-by: Krzysztof Wilczynski <kw@linux.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c   | 4 ++--
 include/linux/pci.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1b27b5af3d552..1f17da3dfeac5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -890,8 +890,8 @@ static int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
 
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
-	if (dev->current_state != state && printk_ratelimit())
-		pci_info(dev, "Refused to change power state, currently in D%d\n",
+	if (dev->current_state != state)
+		pci_info_ratelimited(dev, "Refused to change power state, currently in D%d\n",
 			 dev->current_state);
 
 	/*
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 82e4cd1b7ac3c..ac8a6c4e17923 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2435,4 +2435,7 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #define pci_notice_ratelimited(pdev, fmt, arg...) \
 	dev_notice_ratelimited(&(pdev)->dev, fmt, ##arg)
 
+#define pci_info_ratelimited(pdev, fmt, arg...) \
+	dev_info_ratelimited(&(pdev)->dev, fmt, ##arg)
+
 #endif /* LINUX_PCI_H */
-- 
2.20.1



