Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C06361A1E
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 08:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhDPG4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 02:56:06 -0400
Received: from mail-eopbgr770083.outbound.protection.outlook.com ([40.107.77.83]:35631
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231193AbhDPG4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 02:56:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRO8thKJneYh9g1oGaYB8DVshwo6x35LI51WRtM14CUQc8yJEY4E94ijnB+tZk0eNTLU5emjt3uBJcYbAObIJ1rABmyJ6YY15lrIDELHJ10E/FiYaIDhaQmZfLTwf6G+7K7EHSxf1Ug4nTODXpBFYoz/Eakz48XIW16i0x2croJA75lqi2/O6rJiVHJ5CZHdPMeUISJzfjY/4fU7xBtV7TJlbjE2eOIQH9Si0flVZBdz1mprc8aADh0HQAFkhclDKTftH2ITItkQin5UpJcyY/RtHTcm0VTbTtCiipPvfH+/+txKqc4bBax9BIcnJoDZtG+Ye3n/bVLhwIy+hOhNWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1r8/cHTLWb7e6n5OlHBs6nbH+K6AmR79XCoWkT0eOFU=;
 b=TSGwEgzVj1PzdaNnHitQPSWgZmkZiRuoYPXQOJNjDDH5YOmAnPwMpyzkV8gFV8EH0eOxM99VK0MzwIbVVqYK322hjVfyaRTdkCWqNR49ItGEWUW4LrOV7iSxN7J1X6hL5/M7QBrCZsDEtTY8UBc4Y3SzHXCaGk62WAQXlPq2wY75Vja4F8VhBDOZumgoYEQLLLNcMv7lywoH+WAftHT1QyT3+8P2TAXkCLXMSqAShXP/t9nRkUerjqhVZFzR5MWk1mI9MBkWSq7oVqhH7S7mUqnajkv/DUsjRgCQSvBplS0wonPGYVtHb7GJV3GB71Uv6qAkvlnFgg3U4shhC6ZnXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1r8/cHTLWb7e6n5OlHBs6nbH+K6AmR79XCoWkT0eOFU=;
 b=4MZY6dfRbMEi6kcbSkOSRK5z7u3KKxmuIFqzXslk1B5dTDVFn8Wuxgix/3a/bOxEl+s2qOQm91Mb+eUbT8vTVk6/fCE9s1+GenjPxOOaCaNjQQCdPacxtMcJVVG2ut6hjyLzYtgGYV3T8wr+L/hDjKwMKOAuKp0N1dEUJ66VQDQ=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB3141.namprd12.prod.outlook.com (2603:10b6:a03:da::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 06:55:40 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 06:55:40 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        hch@infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam-sundar.S-k@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v5 2/2] nvme-pci: add AMD PCIe quirk for simple suspend/resume
Date:   Fri, 16 Apr 2021 14:54:35 +0800
Message-Id: <1618556075-24589-3-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618556075-24589-1-git-send-email-Prike.Liang@amd.com>
References: <1618556075-24589-1-git-send-email-Prike.Liang@amd.com>
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0012.apcprd03.prod.outlook.com
 (2603:1096:203:c8::17) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0012.apcprd03.prod.outlook.com (2603:1096:203:c8::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4065.7 via Frontend Transport; Fri, 16 Apr 2021 06:55:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94840a52-5d85-42fa-978e-08d900a4a5ba
X-MS-TrafficTypeDiagnostic: BYAPR12MB3141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB3141D9BCEAB73B67AE4DF4BEFB4C9@BYAPR12MB3141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXYd7WsBA4dT/WkNYTejhkYvblOCps1UbYHuNnX0WZ/9psKaqAy+6Iko6hAPm/qj/dW5qZ3910EsSh+vkWAVTnjD56+dV+ywU6BGSBV6pnDFQErt3RQDni48NPOX0GVbNQHc1HN3+gTaRL9pfR8RHrzFkRuabtXvDdCTwtE2PwCP7a2WnixfC9RvuEczynl9u/xS6PeI9OzVSWEZbvYeS6T4Nq7wORTJouxjoSnK4L+FfMFLOo3q2fst2o1WCkblghSPlrhGCjLELhQXBe9KOiLrZoooDIHEc2Q+zEMnJsa5XlSCCWd5ai0TKnXFOPz1C/cL8pLA9dk2cOuxFXO8hrjagZhB7FnAf+fDs1HZA557pZFAJNamk8N15MLcs0+xOEW1k5TQeuL2S5AG4zxVa0HqSAW4ZRNVR3YT145xAS7YBjkkFR/0ivnGhMtxPYvYQHYy5XbBxlJLAnLDpAWB2RSHJblBpgiXnTd6Sdkyuqq34sD2CR9PxbISiqZhKJWx33sz4CUFonpCV7smoJYH/ZNznmYjiV2L7G5LwI6m3/5XlClATvxb/eDeZGPEgjG43tuEOzZB/LuJ+xNFF4WETZdLQQIZcRPWlaIWAbX+vc41J4uhFn/FMnN3fc9kKFQ5BCjDcFJEdcHc+NGbxpYFPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(16526019)(8676002)(15650500001)(186003)(54906003)(83380400001)(2906002)(86362001)(38100700002)(66556008)(4326008)(26005)(5660300002)(8936002)(956004)(36756003)(52116002)(478600001)(316002)(2616005)(6486002)(38350700002)(66476007)(66946007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ju9Ypkd33EynIuWVYhw8NoaPBw29SAqeshn2uFd5SpI1eWe4mQgSDJ9iUV46?=
 =?us-ascii?Q?/2UUMOD5LutKI0xMJr54aj31VDR2X976T3qlQDcwsoyutVZumbIrYmDaK/SV?=
 =?us-ascii?Q?bAH81Bq+B8XDAhz0hv8r5q0QLG/jjFO8MbZm30nU34WzrwdVBOMH35UCA5aP?=
 =?us-ascii?Q?rTkYxajueCCxgiDYXeCCMol5TmGogu0213vjOAagFl/t5eaFfxkOyc0n6O89?=
 =?us-ascii?Q?W59gVCsFvCKCdSgYqxFd8gHcDxYbkCwycD2E6tc2ugphuS7oDpOVWuPliVX7?=
 =?us-ascii?Q?3AtH1HzayGsoGu7JSgTSkXu/2OKMQbt10eZT7Q8SWP7v0mSkiiP91XizR8L9?=
 =?us-ascii?Q?0V23mj/Hra031v4Lc74P5eeipyc70aaR+WSpEyMBT38PypuwYauBt7rXmdzr?=
 =?us-ascii?Q?0OKrUeIxSmp96o0rhgShR/sNCRABmG532mrrK3C/etKIS3XIoJcDIJjxqspv?=
 =?us-ascii?Q?UxgOwM0vwzTefW3iiGrKFrHrl/lPUAK3USi9aZTPMNug0nCm5g3EWAaCP0L+?=
 =?us-ascii?Q?La6sk3PByVrMiUoCWWqS1WnR9XzjZ50+JnbFktyCEO/9eiSagGEeLc1SKWez?=
 =?us-ascii?Q?D0CNZbhHCLYEZH6aTeS9OZbJwYZp13SJRtC6VGlwo0h6u/3RsONbYiEtMJWY?=
 =?us-ascii?Q?TLYenb4Ohg0AjN/3Lyd0gpQRx01fvW7d+EeYyxn9DwnF13fcFLhK65jxjMXe?=
 =?us-ascii?Q?Mmpbys77gLHwX2ZZSggqPX0SuyMFV80qOWzWKoDM6s9CIvYd9pLJTpCi+vcb?=
 =?us-ascii?Q?I6hKrxr6rTbliTaN1NdflCcFCTXXC9BjLVoC8y7HxWCgaEg+N6HokJHgkKn7?=
 =?us-ascii?Q?q//8o2UGkr+3VDnFarSpEhsuhemkYgrAkR0rVglQXy1YCf+4aLJPi6cP2xVE?=
 =?us-ascii?Q?fKGSU5xi5udSvdiCWU2+7Pa+14yeCE+bJeu18y2TUFwr3NFssVUGfJ96wZa2?=
 =?us-ascii?Q?HvwQiYgq8LyncbUzu7Sk0GVwKAqYt2ybxM7oTD/SGaHzm1p4k3vQ5UTU6ECm?=
 =?us-ascii?Q?kqluA4sEunuof95wntebZ7q/ZJgmHmwCI+Dopo68CGDjzGM8jzjex1H9q7Dg?=
 =?us-ascii?Q?Ct30RbPGfwstDHCwjYL+13g1/8euxyS8unGY5ikb/Pf633eoJ8ibchX5j2bU?=
 =?us-ascii?Q?kSrksixcu6WDXIP479KLxFVdBgymvXEyTvVt6aUVvZygu6DhAXKGsraQ7b4z?=
 =?us-ascii?Q?n8fKs9LYAttnIml4PQnygzDFsHlBCDS9B1XxuzcUJp6ZmajHKMy80TQFrt4e?=
 =?us-ascii?Q?xU/FMSq8tgc/P3WmqOTPBo4NhMZ3hPBwsrw6mEm1TqZowc7YJEDZSwQ6duAy?=
 =?us-ascii?Q?ZR50YqLvaVRxDGhb5TDmbDqr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94840a52-5d85-42fa-978e-08d900a4a5ba
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 06:55:40.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDdOc++MOQ28Slc/4aLD7vKx0HUKaxM28Top6ACp3ig7FKIueYggNMakNTwkt/pW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3141
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the NVMe controller default suspend-resume seems only save/restore the
NVMe link state by APST opt and the NVMe remains in D0 during this time.
Then the NVMe device will be shutdown by SMU firmware in the s2idle entry
and then will lost the NVMe power context during s2idle resume.Finally,
the NVMe command queue request will be processed abnormally and result
in access timeout.This issue can be settled by using PCIe power set with
simple suspend-resume process path instead of APST get/set opt.

This patch is updating the nvme_acpi_storage_d3() with previously
added quirk.

Cc: <stable@vger.kernel.org> # 5.11+
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
Changes in v2:
Fix the patch format and check chip root complex DID instead of PCIe RP
to avoid the storage device plugged in internal PCIe RP by USB adaptor.

Changes in v3:
According to Christoph Hellwig do NVME PCIe related identify opt better in
PCIe quirk driver rather than in NVME module.

Changes in v4:
Split the fix to PCIe and NVMe part and then call the pci_dev_put() put
the device reference count and finally refine the commit info.

Changes in v5:
According to Christoph Hellwig and Keith Busch better use a passthrough device(bus)
gloable flag to identify the NVMe shutdown opt rather than look up the device BDF.
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4..617256e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2836,6 +2836,8 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	acpi_status status;
 	u8 val;
 
+	if (dev->bus->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
+		return true;
 	/*
 	 * Look for _DSD property specifying that the storage device on the port
 	 * must use D3 to support deep platform power savings during
-- 
2.7.4

