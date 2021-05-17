Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E5C382FA7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbhEQOSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238881AbhEQOQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 293366141F;
        Mon, 17 May 2021 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260596;
        bh=R0S8WlO7HPuf0vhLANuXfoyu57mtiN/wLKBnlGBLcxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WS27Zld+bpql1P8x/93Fwm8obKsIsPDT67mgCw7DefRvPIBy3lHjHlNK3Ds64r/i
         zTSu9IFs6ZHo2QPn1Jck+U4L/6V5PDc6TmG4I+Lm5VsO0BKi9dz58V28jLgEmrajsA
         x9AanNs22yBp1CBIzfYdZ6iPWCtVbufdOpm3WHQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 154/363] PCI: endpoint: Fix missing destroy_workqueue()
Date:   Mon, 17 May 2021 16:00:20 +0200
Message-Id: <20210517140307.822933515@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit acaef7981a218813e3617edb9c01837808de063c ]

Add the missing destroy_workqueue() before return from
pci_epf_test_init() in the error handling case and add
destroy_workqueue() in pci_epf_test_exit().

Link: https://lore.kernel.org/r/20210331084012.2091010-1-yangyingliang@huawei.com
Fixes: 349e7a85b25fa ("PCI: endpoint: functions: Add an EP function to test PCI")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index bc35b3566be6..f9760e73d568 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -925,6 +925,7 @@ static int __init pci_epf_test_init(void)
 
 	ret = pci_epf_register_driver(&test_driver);
 	if (ret) {
+		destroy_workqueue(kpcitest_workqueue);
 		pr_err("Failed to register pci epf test driver --> %d\n", ret);
 		return ret;
 	}
@@ -935,6 +936,8 @@ module_init(pci_epf_test_init);
 
 static void __exit pci_epf_test_exit(void)
 {
+	if (kpcitest_workqueue)
+		destroy_workqueue(kpcitest_workqueue);
 	pci_epf_unregister_driver(&test_driver);
 }
 module_exit(pci_epf_test_exit);
-- 
2.30.2



