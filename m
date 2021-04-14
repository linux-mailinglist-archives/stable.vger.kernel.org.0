Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C3535EAB6
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 04:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhDNCTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 22:19:49 -0400
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:4800
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229710AbhDNCTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 22:19:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3EkyBX6mYB2BY9Y96koQilS6zcJzWw0KOtNwGJvqhJQQHxSKCjCwgS8G1Su57cbvuDDAqyB8QnTbr9u5hFHMGkF2X3hvznFy3L5wsd/fnNI7aZpXZHjjiahvKSc5GAHMc3GzNd4gRXISh9n/wKrM6T3M21U/H/rRvxOBWgSX9lotJlhK+yRGS7QqX9EmNJ3GcCou54RMJlYTRyW3VO4yKyG29O/qkHimB0xwcn55mg6SOVM7zaj+M52aD5k/sKCrtKnYcngaTO9uFuKLw08f3TYKQGzi4AMhGy/oRyI3/EdH3s6u2o2/DOZYXENH0mkY0BQimgorE6Cx1FsMIYRFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDJLbHPz4FknAPNEquUiwyE7zt+v0K60WCCqM3pC8As=;
 b=k49HGxqvpUAcwLvdeArrgPV1AxSK/Cne3/C9CqarioAga3/VTObf/ocCLwcX3+9277Ubl0CtkNkdVhPsydtHt14E62oaEckjrgJ3G3lscWFrxxKjSQ3wEBtva9o/RFT13hlj4cfnnTalM+Fh7zCdC3fW1u0fEYN0y7FEYZZlsSOkc7POAItE84W9sDlUlRfnXa8AWZnqL19GVn3XPxkwk1uE3r3dAW89LRLVdd0VG9gyMb8djaL4qcjQW8on3aYha0wls/zVnKz6a2JMvFsXuRi0m0iz9kICXmszZist5wkpTW/B8M+zJmvJh7b6a16HXhgSdLiLzAwDNr9tu4cv6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDJLbHPz4FknAPNEquUiwyE7zt+v0K60WCCqM3pC8As=;
 b=AB91yUIqRhoenftzFguO2PV11EcZ4m0tYwkxbRKWqFRrTvr2tzAuOakM3jx72kKCcl6cFLBTj45hTwlY52+qDgdua6IAGQG+0wJBKIlDG+KHGN9dR644Iok3dHK4FFUbA10sqiDC5FcAAtE+adYVwrFhYAafBZS/O3P+Z0fSxfE=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2600.namprd12.prod.outlook.com (2603:10b6:a03:69::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 02:19:27 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Wed, 14 Apr 2021
 02:19:27 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org
Cc:     stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Date:   Wed, 14 Apr 2021 10:18:14 +0800
Message-Id: <1618366694-14092-2-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618366694-14092-1-git-send-email-Prike.Liang@amd.com>
References: <1618366694-14092-1-git-send-email-Prike.Liang@amd.com>
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HK2PR03CA0053.apcprd03.prod.outlook.com
 (2603:1096:202:17::23) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HK2PR03CA0053.apcprd03.prod.outlook.com (2603:1096:202:17::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.6 via Frontend Transport; Wed, 14 Apr 2021 02:19:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c921e9b-ea81-480b-ee9d-08d8feebba36
X-MS-TrafficTypeDiagnostic: BYAPR12MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB2600023F3F481C41A31C1364FB4E9@BYAPR12MB2600.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1N70bft35xyt5NpjDTmlK56XeyisPsFbStj9XnYTbuXTR+N53LKlzd+MIoGFAtcMQWicuoahEt7KXUXya98rClKkzyHSaKl75aPFuRybudDsc7ZXSRlz+eLXYhJqQGaKPZiswzZGSS7pf/j5dKDjsIvTGdiGXAO+XnfE66l9YGYtEII/7SBMVy0R/nwABtK749abERqLeca0x+E6tXoViwasCMazTSso9+WMzkGHisMUYU8rjDI2uvvmU3LHGI6WCvwYzgXQ2DWZLoCs9FJSWQM2Jp8GynNqHHL2Qea79BspkHv/4Ty5V0IYsgLlSVvZmDK7ZWFSuHnNE8y1znR1GyEpIEILwfvxiCVItCNMi2bWYLppNPWnBieaYG4rTtyWlnHmiCR8l7Qc8S+Dl2BCr3HovZc2alqf38mbF1ONhuWgwqO7TFBKhhEXXfc+U3OyT/DnGw+sbBqjkb1EvBhp/MctQwZsQkhe5rxRK72v+SnBlty5GnnX0X5BNAUyzln6JkjznOyJFEVvqd4gt3rJRTRMDJyztEHddReWRAgLnV8VY/arv/qJpSUh6ACLuN8Ey9n9j5BUt5U0MbkQuOp2POWgFBZQKWbf3efqCqD1Kh7QSMtq8wxqAzaLSQLzs+/Y3rip81fvMPnnBUah6aYHk0iQrGQvcmINvisJf1iCPfg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(4326008)(6486002)(54906003)(5660300002)(38100700002)(26005)(83380400001)(36756003)(52116002)(186003)(66946007)(2906002)(16526019)(38350700002)(86362001)(478600001)(66556008)(8676002)(15650500001)(7696005)(6666004)(956004)(316002)(8936002)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qsyWw3x5Tx2jmk2I9SY6+k99pAyNHTw+kQ53lApAKI0RRWg7XMaL3AxeP1kM?=
 =?us-ascii?Q?XlQTy2tuAFmlxoarxYaYpnZmcd7xE/ZCeBz26ZvutwmzcSJrpXX1RVi9bE6E?=
 =?us-ascii?Q?JJqudh2TSQS/BSMxRBZvbt1VHgmjcFqb9yjl8kA0XfM14TMHFo0QbSwNtcom?=
 =?us-ascii?Q?igoX2LV5gwimjc1yngwfwdtWMRZbK/GR6KnSBr2GJo4yWNmks+6YuQu5ymqd?=
 =?us-ascii?Q?iXXfzHVmKeSPhhrJeGvD2G1pTRqyVfz4FTQT+4LfHrLmIq93bCv1N3CM9pK8?=
 =?us-ascii?Q?wBM2IXHy9Mc8/D2PZGFK4s3A33pUkeAqm6A564xx9yq4Vu2VVir7hry5vrQg?=
 =?us-ascii?Q?Gt3Msm15lVZagoSnQR/IeYf29QZmRym3ku2Oy60pPVnmkRQvUkaEmwyY3Jo6?=
 =?us-ascii?Q?Bic+CBlPnAuCgcyBQl0QZgg2uBEeYlJEfQAzIUMK1VAFvwLWOq+NCbkV6C1Z?=
 =?us-ascii?Q?ZZ49Aa8PCPVCuxzsSkowrwes4C301bwZ/jNPhgAhGcVip78XAJ60Z5TBj1wS?=
 =?us-ascii?Q?pGtVF4WOJ2LX4BzWV4/1Nsjh9YJ1iHFXc7uMcTAjYSCwZz7tnmYDcBRn100k?=
 =?us-ascii?Q?mh+m7NRKOIg7yinzPIQLeVMpArYCPCBlIwtsL0dtf3wa1IwgWNwMjbOPVl1R?=
 =?us-ascii?Q?h+olno2vMj7eUPkjq6RMiCbjgPqflcrhyVkvq9vaNgAVT5s2WEGiCPhao0zY?=
 =?us-ascii?Q?4/c5WOrsdhREQ9z14aE/lmBpXppyC/fh1gi1zcWZvC2/vzJfEZJ2QNkNoVWg?=
 =?us-ascii?Q?a7iuj6I7XUllBwEoXSe237n79PYG2nyv/g1Tum3H50ofL/AZnLfNo7GkC9sN?=
 =?us-ascii?Q?s9pQ3kj82RprBGsxU6ylRDL2IJ3gzcGf3D6XGbfRnqFo0fHwW2y2NPogtjWC?=
 =?us-ascii?Q?NjDt15ICXlWSNsLeMs8NuwWJdsjsPXCm62w33jp5was9a1zFAoX7prhBLXeL?=
 =?us-ascii?Q?+H9NBSmM0fXMy12LgS4LNZIQK6FFeADGIQcCCX1RNSYGYuNlh0PSUhvqvXYE?=
 =?us-ascii?Q?uH6NqGokrvOIFCaiQRcxu6lHsU5O2tGSHHsXufv1G93L6Na+CvvPs1ax9/SI?=
 =?us-ascii?Q?zSUwO6KK8uWB4eRtzmkimceiUoPrspLfI/XVnis6Uv0u/mdHiOxKM0tEeLsM?=
 =?us-ascii?Q?sh0fLpqFAqlzZpbvbpu2Qn86Hs3fKeVoJ00i9cnBoZk2hyebwSD6Th8O8FRo?=
 =?us-ascii?Q?+ZTYTordpiig7hYE7/RYAtmAU3yT8WeAwJ3UoSGmAXf5Khg5tSecRi0/wJKR?=
 =?us-ascii?Q?RX+rCodHx8wBPaBjq8EgTzq+9OfgQQXZ6bs2YHRaJ4e9TbaIttNCyc+9IuVE?=
 =?us-ascii?Q?iBFXdY3/Gl0APlX5MqzcWcYg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c921e9b-ea81-480b-ee9d-08d8feebba36
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 02:19:27.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYmRB8YQRGCHEZ89kLxiWmq4dVVesyQ985gpLr3c2Gqq26sRXHVmTRpVaMMmdTXD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2600
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The NVME device pluged in some AMD PCIE root port will resume timeout
from s2idle which caused by NVME power CFG lost in the SMU FW restore.
This issue can be workaround by using PCIe power set with simple
suspend/resume process path instead of APST. In the onwards ASIC will
try do the NVME shutdown save and restore in the BIOS and still need
PCIe power setting to resume from RTD3 for s2idle.

Update the nvme_acpi_storage_d3() _with previously added quirk.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org> # 5.11+
---
 drivers/nvme/host/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4..dd46d9e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 {
 	struct acpi_device *adev;
 	struct pci_dev *root;
+	struct pci_dev *rdev;
 	acpi_handle handle;
 	acpi_status status;
 	u8 val;
@@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	if (!root)
 		return false;
 
+	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
+	if (rdev->dev_flags & PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)
+		return NVME_QUIRK_SIMPLE_SUSPEND;
+
 	adev = ACPI_COMPANION(&root->dev);
 	if (!adev)
 		return false;
-- 
2.7.4

