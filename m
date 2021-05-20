Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D938A4E1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhETKK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235663AbhETKHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95587613CA;
        Thu, 20 May 2021 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503701;
        bh=nNUIKOtOdN/94SchlFzWSoxeDMp8+TNm7vFVQLQC7j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTtpNmJkttT5HYS74F1LDldz4WB7r0dRVlnM1W5AFUvYe6Xj+OcdqPafOuoUvZKdA
         pnnEax15UiNXUbsvsdhWJIUjcXUuoBRzMPt8O//L+OLOeObiQy553Rz4Uvgdcn0Agu
         gyOZyr/9kxLOmw75c2/L8CJLKq7nWIakezkgXEOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 341/425] PCI: endpoint: Fix missing destroy_workqueue()
Date:   Thu, 20 May 2021 11:21:50 +0200
Message-Id: <20210520092142.623541747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 4bbd26e8a9e2..09a1e449cd1c 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -572,6 +572,7 @@ static int __init pci_epf_test_init(void)
 					     WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	ret = pci_epf_register_driver(&test_driver);
 	if (ret) {
+		destroy_workqueue(kpcitest_workqueue);
 		pr_err("Failed to register pci epf test driver --> %d\n", ret);
 		return ret;
 	}
@@ -582,6 +583,8 @@ module_init(pci_epf_test_init);
 
 static void __exit pci_epf_test_exit(void)
 {
+	if (kpcitest_workqueue)
+		destroy_workqueue(kpcitest_workqueue);
 	pci_epf_unregister_driver(&test_driver);
 }
 module_exit(pci_epf_test_exit);
-- 
2.30.2



