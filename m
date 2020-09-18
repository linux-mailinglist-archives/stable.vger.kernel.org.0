Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2401126EFF0
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgIRCjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:39:32 -0400
Received: from mail-eopbgr690064.outbound.protection.outlook.com ([40.107.69.64]:41966
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728934AbgIRCjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:39:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyTs59MxVuA/vaMplcLbnvF/lZiCcbnbZeS7wjTyvqSXGE9tMSElTOLYSVT6Bho1CQEm8/sWEPfGeOW6T1mvGbRywMAKVsiQDiNkRhtTnave/UJC4PR/xj1aoI7oPNwUaWk6xuWBDMgdgBofwbKRPli4jCMC7XhwHk+RXdhFeeZV73CAxTh+IUR9AgsCLEglKJrux2183Orx2i55YKAK7//bZ1o6PEOu2qrUtJSx0U6jpWDzm0qHFu4vi7vJ2FpJpBoFswCaHc3C0syAzXLCiwEBKUB7f2dXX1XwdqIMvn/Owzl2np9E85WkVeoFY3uJqfrIpKw2NQC4+vHVtGN8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yP60YshwKbHburKxkHxlnX926F7ioHmz6g3y1uFqgRg=;
 b=Zb6AFu01HucvTnPT9OPMic4JuGn+qtQmqHVfNlTkZJpm2SfR25TiCp2hpSh1SBNLUP66F1QChJTw47Z5LCKBImj4n9FHEVSb7aVod4BDaqhpWKEGFFJaMHERIA9FXwF/gBp590f8gxxyfi/yuW45Jy7LSAr8RHbguax8hnwrv/J1Gcn+Bn11UZLmN+lEBaqND+qDZOHEWXSHOVL9AFhCjbt5F0fvHtdQknIvrElqNbBSrqqST8EN0iJd1MNxrmb4nqTxMuFFFdGt4OF/jXbGHI517vklJ7ZVwlzYFTgLKolflKtPPLsn/JNqENHAoENqteZ0kjQ/k5TxQ9zv1OmPOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yP60YshwKbHburKxkHxlnX926F7ioHmz6g3y1uFqgRg=;
 b=QLrZzUk5/aho3fEK3AYNMF823BBSNAoXk6HsQ9+aYnFdNF0YK/C3rgKccH4qS3OszlshzVPwpsRmbiA7rCy2gak5lzm1Gjdir2cC2jeAPcEgAF3M2lpVxFss0KdhTZQg4wPuGZ0k87M5o0YpqX0Uj1CLUyzgEG67i2/rBd1RRBQ=
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=vmware.com;
Received: from BLAPR05MB7444.namprd05.prod.outlook.com (2603:10b6:208:284::17)
 by BL0PR05MB5443.namprd05.prod.outlook.com (2603:10b6:208:6a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.6; Fri, 18 Sep
 2020 02:39:18 +0000
Received: from BLAPR05MB7444.namprd05.prod.outlook.com
 ([fe80::4cf2:fe2a:d67d:d60e]) by BLAPR05MB7444.namprd05.prod.outlook.com
 ([fe80::4cf2:fe2a:d67d:d60e%9]) with mapi id 15.20.3370.021; Fri, 18 Sep 2020
 02:39:18 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     aditr@vmware.com, jgg@nvidia.com, dledford@redhat.com,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
Cc:     Vishnu Dasa <vdasa@vmware.com>, pv-drivers@vmware.com
Subject: [PATCH for-rc] RDMA/vmw_pvrdma: Correctly set and check device ib_active status
Date:   Fri, 18 Sep 2020 02:38:59 +0000
Message-Id: <20200918023859.22181-1-vdasa@vmware.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To BLAPR05MB7444.namprd05.prod.outlook.com
 (2603:10b6:208:284::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.vmware.com (66.170.99.1) by BY5PR17CA0021.namprd17.prod.outlook.com (2603:10b6:a03:1b8::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 02:39:17 +0000
X-Mailer: git-send-email 2.18.4
X-Originating-IP: [66.170.99.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bce24f12-b378-4cef-8cd8-08d85b7c0a91
X-MS-TrafficTypeDiagnostic: BL0PR05MB5443:
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR05MB5443C43E9BBB0123EA4107A8CE3F0@BL0PR05MB5443.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qjvcBn3Sz5KhcegXNh780YANLyjjyeSqwpMTU3jHB75KRbmpO9MhZ7tU0X9SDyAxcmo7gnSdWGGJwS4n7/EODlr9PppymYckNwrbcK1lelqt8k2lspJ+fTe+VRfl4q9ml7XprxUI/vldKr7JJ/UtYJh99BcgPgjGoVlzixoZy/9MEdNP2NlYbhQrnTVgtzCANJX++svjukRVD9bzdali21LZFnGxNSFNckV9++/kZk6iVp8ah0Z0ovaVGWNB0EgXH+RipSmyyx//bv+dyMMjFZo0d71vTae69OkGRz41+iugOXiPmLKnLtuNc8ouZ7htfoNqUvZ2SxuUByGAd9RJdE+TGXp6w7/mQCM6BMvnN2XuWxNZlN1+s5m5q4AEC7a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR05MB7444.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(107886003)(86362001)(6486002)(316002)(186003)(7696005)(66476007)(66946007)(2906002)(16526019)(66556008)(36756003)(52116002)(1076003)(8676002)(6666004)(26005)(5660300002)(478600001)(956004)(83380400001)(2616005)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M0hT/f7SvmDIPBbrbonc1MpZzOK0F2fG5UTy/mhI0G5aYmHgpRQxIoAeCmlSeVHyBPF4ZsBWi8SpyXAHco1jSDAZ4HcZB9caDkR8vekH8XoZUOZf6AdJORnya0P0UrFsowr67tyR0tnYBua+09tGriV/zj6J/+P2BtTIEFi28uM1QHXNGp4ORve7jlkSKLVfFWDYSTxz7WSEdz4YUrh/pB/mOhTqtXsinz71Ua/Xj3OC9MgVrQlmJEOf2HrQPMkSjukbI3umufe1MV5Qy4AB6BUQzaHF1ulECDPAZ4Xsaklbs0P4MWX/Dib1d7aY11TzdNV0E7ECug9nvrPw6hN/TjDaU0phiLQlWqciVnRw3RtJ6iMYu1+3vrxp6Kqe9teDdt5AHHAGVhj2H/FnGtU5r/idvHyPVcajtVYdpr2oqXSaIjgHtlUTUBojx6sILGv/qJ39aDw+Gt3KjyR6KY9bnSnADZIQrhx3lJKqEzK1OVxnDQt1HHXgGFDEIlcwoYBZC5HuWMCcWrzP4zAIgf91DVdwB4YG6Q/KXzsEzUHSw5zspi5JUclSapTETNQcGy0bRXPFUqkxH8BmXOT6FAlv1rSRdpWsl8a7zKkPjaufSFH1g6kyCD+PqpnUcLRY5kn5YpS5bJbdIRtdsCrgvNyK7Q==
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce24f12-b378-4cef-8cd8-08d85b7c0a91
X-MS-Exchange-CrossTenant-AuthSource: BLAPR05MB7444.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 02:39:18.8460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lAkcAI4zOx1YMiX8YuSjODnj01TR5X4M9DuzUS+H9DGKcNJIhPNk+hYe2AxlnulXzMD0+pTjYriOYKn/uEvwXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB5443
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Avoid calling ib_dispatch_event on an inactive device in order to
prevent writing to invalid I/O mapped addresses which could cause a
guest crash.

Also, set the ib_active status to 'false' in pvrdma_pci_remove and
in the failure path of pvrdma_pci_probe.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Acked-by: Adit Ranadive <aditr@vmware.com>
Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 780fd2dfc07e..ff4fd6e078e7 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -692,6 +692,16 @@ static void pvrdma_netdevice_event_handle(struct pvrdma_dev *dev,
 	struct pci_dev *pdev_net;
 	unsigned int slot;
 
+	/*
+	 * Do not dispatch events if the device is inactive.  Otherwise
+	 * we'll try to ib_dispatch_event() on an invalid device.
+	 */
+	if (!dev->ib_active) {
+		dev_dbg(&dev->pdev->dev, "ignore netdev event %ld on %s\n",
+			event, dev->ib_dev.name);
+		return;
+	}
+
 	switch (event) {
 	case NETDEV_REBOOT:
 	case NETDEV_DOWN:
@@ -1049,6 +1059,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 err_unreg_ibdev:
+	dev->ib_active = false;
 	ib_unregister_device(&dev->ib_dev);
 err_disable_intr:
 	pvrdma_disable_intrs(dev);
@@ -1108,6 +1119,7 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 	}
 
 	/* Unregister ib device */
+	dev->ib_active = false;
 	ib_unregister_device(&dev->ib_dev);
 
 	mutex_lock(&pvrdma_device_list_lock);
-- 
2.18.4

