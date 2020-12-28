Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B77A2E3DB6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440615AbgL1OTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440595AbgL1OTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43822229C4;
        Mon, 28 Dec 2020 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165102;
        bh=pbv/90rDytlLbLe153ID88PZs21iMaEh9hAlauAntUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpaiWdsg1nB6pNUjBHmBxAHDw05EfsoMDyzu3sPJ7d/xrA3drT0dPnfhOJx6bxX0a
         CjbLJ1BcIrvvR1SEX/gZdGJFMfdKQudKauLWKpATnUyeKmRIxMKtv5ub/W3puLPW/2
         52D/Arb5Ggi2/kC6vUrigmxeXpfshuOTZjGk1bXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/717] misc: pci_endpoint_test: fix return value of error branch
Date:   Mon, 28 Dec 2020 13:46:20 +0100
Message-Id: <20201228125039.304254225@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 1749c90489f2afa6b59dbf3ab59d58a9014c84a1 ]

We return 'err' in the error branch, but this variable may be set as
zero before. Fix it by setting 'err' as a negative value before we
goto the error label.

Fixes: e03327122e2c ("pci_endpoint_test: Add 2 ioctl commands")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/1605790158-6780-1-git-send-email-wangxiongfeng2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 146ca6fb3260f..d3844730eacaf 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -811,8 +811,10 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	if (!pci_endpoint_test_alloc_irq_vectors(test, irq_type))
+	if (!pci_endpoint_test_alloc_irq_vectors(test, irq_type)) {
+		err = -EINVAL;
 		goto err_disable_irq;
+	}
 
 	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
 		if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
@@ -849,8 +851,10 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 		goto err_ida_remove;
 	}
 
-	if (!pci_endpoint_test_request_irq(test))
+	if (!pci_endpoint_test_request_irq(test)) {
+		err = -EINVAL;
 		goto err_kfree_test_name;
+	}
 
 	misc_device = &test->miscdev;
 	misc_device->minor = MISC_DYNAMIC_MINOR;
-- 
2.27.0



