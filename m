Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41A5187D8B
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 10:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCQJ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 05:57:44 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35352 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgCQJ5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 05:57:43 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02H9vZcp102399;
        Tue, 17 Mar 2020 04:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584439055;
        bh=inOa9YadtuHCp1DLaC0SWlL5XKzD4ViNp1jWipFw0Co=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=daD68VTyUA2lvwMXchOFQq+FTDET/SmyeQZXP2CsgxCJpJNnztFdMjR5DMKCCmXJK
         ooysCBgp+zY5D1T/kTbbEliWpAn9LW0vZHmcGQsly99mOlAEZv8enhTV6iKgVi55OQ
         /DXI8g53nOur/VDz5KcjiTFPKqs/LOw+Iiz9Ih0I=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02H9vYJe117763
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Mar 2020 04:57:34 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 04:57:34 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 04:57:34 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02H9vIKV095155;
        Tue, 17 Mar 2020 04:57:31 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 4/5] misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices
Date:   Tue, 17 Mar 2020 15:31:57 +0530
Message-ID: <20200317100158.4692-5-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317100158.4692-1-kishon@ti.com>
References: <20200317100158.4692-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding more than 10 pci-endpoint-test devices results in
"kobject_add_internal failed for pci-endpoint-test.1 with -EEXIST, don't
try to register things with the same name in the same directory". This
is because commit 2c156ac71c6b ("misc: Add host side PCI driver for PCI
test function device") limited the length of the "name" to 20 characters.
Change the length of the name to 24 in order to support upto 10000
pci-endpoint-test devices.

Fixes: 2c156ac71c6b ("misc: Add host side PCI driver for PCI test function device")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/misc/pci_endpoint_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index bb8b94ac8d3b..ef21d2d2f8ae 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -749,7 +749,7 @@ static int pci_endpoint_test_probe(struct pci_dev *pdev,
 {
 	int err;
 	int id;
-	char name[20];
+	char name[24];
 	enum pci_barno bar;
 	void __iomem *base;
 	struct device *dev = &pdev->dev;
-- 
2.17.1

