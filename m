Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE6B383392
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhEQPAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239917AbhEQO55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5619E61492;
        Mon, 17 May 2021 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261545;
        bh=tAekEOvL2wP0X/tfz0scn9Z3VWzIT3iXFUdUORNX87s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgkOdmR9xiVI96dQ1B/kS8opTsK51eh7B/ov1WTFLQDFJlIUIvvQyG1fJP2kcKEzu
         ToELvOSYXdqQOI5XDcLis/Gak+sEFsLKZzL87o4bgLInjEMJh8kNIsWae3teRBhesk
         7zDa5852obEH7wnyR0v49ZdXo5+5YGLL7hkbSC9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sriram Dash <dash.sriram@gmail.com>,
        Shradha Todi <shradha.t@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 127/329] PCI: endpoint: Fix NULL pointer dereference for ->get_features()
Date:   Mon, 17 May 2021 16:00:38 +0200
Message-Id: <20210517140306.412557707@linuxfoundation.org>
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

From: Shradha Todi <shradha.t@samsung.com>

[ Upstream commit 6613bc2301ba291a1c5a90e1dc24cf3edf223c03 ]

get_features ops of pci_epc_ops may return NULL, causing NULL pointer
dereference in pci_epf_test_alloc_space function. Let us add a check for
pci_epc_feature pointer in pci_epf_test_bind before we access it to avoid
any such NULL pointer dereference and return -ENOTSUPP in case
pci_epc_feature is not found.

When the patch is not applied and EPC features is not implemented in the
platform driver, we see the following dump due to kernel NULL pointer
dereference.

Call trace:
 pci_epf_test_bind+0xf4/0x388
 pci_epf_bind+0x3c/0x80
 pci_epc_epf_link+0xa8/0xcc
 configfs_symlink+0x1a4/0x48c
 vfs_symlink+0x104/0x184
 do_symlinkat+0x80/0xd4
 __arm64_sys_symlinkat+0x1c/0x24
 el0_svc_common.constprop.3+0xb8/0x170
 el0_svc_handler+0x70/0x88
 el0_svc+0x8/0x640
Code: d2800581 b9403ab9 f9404ebb 8b394f60 (f9400400)
---[ end trace a438e3c5a24f9df0 ]---

Link: https://lore.kernel.org/r/20210324101609.79278-1-shradha.t@samsung.com
Fixes: 2c04c5b8eef79 ("PCI: pci-epf-test: Use pci_epc_get_features() to get EPC features")
Signed-off-by: Sriram Dash <dash.sriram@gmail.com>
Signed-off-by: Shradha Todi <shradha.t@samsung.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 7a1f3abfde48..5f6ce120a67a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -830,15 +830,18 @@ static int pci_epf_test_bind(struct pci_epf *epf)
 		return -EINVAL;
 
 	epc_features = pci_epc_get_features(epc, epf->func_no);
-	if (epc_features) {
-		linkup_notifier = epc_features->linkup_notifier;
-		core_init_notifier = epc_features->core_init_notifier;
-		test_reg_bar = pci_epc_get_first_free_bar(epc_features);
-		if (test_reg_bar < 0)
-			return -EINVAL;
-		pci_epf_configure_bar(epf, epc_features);
+	if (!epc_features) {
+		dev_err(&epf->dev, "epc_features not implemented\n");
+		return -EOPNOTSUPP;
 	}
 
+	linkup_notifier = epc_features->linkup_notifier;
+	core_init_notifier = epc_features->core_init_notifier;
+	test_reg_bar = pci_epc_get_first_free_bar(epc_features);
+	if (test_reg_bar < 0)
+		return -EINVAL;
+	pci_epf_configure_bar(epf, epc_features);
+
 	epf_test->test_reg_bar = test_reg_bar;
 	epf_test->epc_features = epc_features;
 
-- 
2.30.2



