Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1062138340F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhEQPFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240946AbhEQPCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689DB6157E;
        Mon, 17 May 2021 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261653;
        bh=PyHuqQz0eNksafwwblkZC1GswweqceaQO5W9b2DiVyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZpDBLdRi7DOZF4hAWbgL0fApi8/MB7sV1a+v4t58b69nss1+O/Nw0j1dYa5T/O8C
         kxgJEWWodQbHMldcBx7JQPevja7u7NTlfJUfFwMBLxOk7GeLh0w4DOM+7uyoGV3TS9
         UfsPYolT46DFut+k/Ki9BqdeG/6Zn7+htux+lg7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 141/329] PCI: endpoint: Fix missing destroy_workqueue()
Date:   Mon, 17 May 2021 16:00:52 +0200
Message-Id: <20210517140306.885447672@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 5f6ce120a67a..d41570715dc7 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -922,6 +922,7 @@ static int __init pci_epf_test_init(void)
 
 	ret = pci_epf_register_driver(&test_driver);
 	if (ret) {
+		destroy_workqueue(kpcitest_workqueue);
 		pr_err("Failed to register pci epf test driver --> %d\n", ret);
 		return ret;
 	}
@@ -932,6 +933,8 @@ module_init(pci_epf_test_init);
 
 static void __exit pci_epf_test_exit(void)
 {
+	if (kpcitest_workqueue)
+		destroy_workqueue(kpcitest_workqueue);
 	pci_epf_unregister_driver(&test_driver);
 }
 module_exit(pci_epf_test_exit);
-- 
2.30.2



