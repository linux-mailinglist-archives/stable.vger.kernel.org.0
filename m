Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E44386FEB
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 04:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346253AbhERC0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 22:26:41 -0400
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:4929
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237658AbhERC0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 22:26:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmqdnXpr1lRR36BDuJ7satSlKY5QPr6utELvNvHYgQktR1EmXotvh78thSHpabfFHdOi02AwVCO9ftwGBEC3x8JyLP3Vc/fs4C2AfjLWtCVsbHkx0SNWtMpx+Nan7+pqjruuVxk8nj1NYQZPTs47W2Z0OUkIYzT2BU2ZmX3ysELrzCKZhPkp/ZLMXiCMqlG+msCBXdoRgFVis+VkYAFmjHVNJdnEAcPXkuJOmBKbhHvVL+H2gnbjHGZjxNZfrFQKJeN+7KTd0WWkmog5X1qKC5HknXtmz+zsvSF4m9PEHScmYc0XP31cYWjRd1j6dCNiX3i485IoSVALPaUc57ibXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s183yfy7xin+VA89uiIhMS4RtC9SO2mLh2+h/QaVISk=;
 b=ZraPsbtWjKBNzmYhK5EkCEGfe7k+FrJYEtFAhNMcirm2kjm5jw7j6nDrbYv1pX57P1fvngTMZBULPx2WwGxgsZkDiaY208oGhaKfZGIKDiut+pf0gbgsb12BSSJemHtIXUdMdIk9ePfbWM1FxY1d/vHkaQWDTlGwHy8tIw0uZ6rF4FRBFToO07Pw2R0eKZlofCfcdyopn4uO5x/IfMvnZ5aGohDbEe7feShBdAXn2n15N83H1RkOXaiPjtpZvwT86bk89GmpCGztGrWxQWCFdwRkNdw4VhVEsyMVWYZqkEenSc4TnIlOhqYwc+K9pBOI/8355Z+T67EfDoF2/4AfmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=amd.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s183yfy7xin+VA89uiIhMS4RtC9SO2mLh2+h/QaVISk=;
 b=KOGNq6ztx/6y4rJDn3u1vVxGU8xnu2xbKo0XaGFhEaaVEoQUYlmxgVCvI8fwFTASkc2BOrTr13OP9rl/ZFS8xZWlfVDajjmO+NZ8dLE2eCRwwSiMIvFA2DmSsFrF/TBG719VrjgS5BiMVB/iGXPGu7xd7V8aj25lewDU1NaivmY=
Received: from DM5PR13CA0063.namprd13.prod.outlook.com (2603:10b6:3:117::25)
 by DM6PR12MB3867.namprd12.prod.outlook.com (2603:10b6:5:1cf::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 02:25:17 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::54) by DM5PR13CA0063.outlook.office365.com
 (2603:10b6:3:117::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend
 Transport; Tue, 18 May 2021 02:25:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 02:25:17 +0000
Received: from prike.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 17 May
 2021 21:25:13 -0500
From:   Prike Liang <Prike.Liang@amd.com>
To:     <helgaas@kernel.org>, <linux-pci@vger.kernel.org>,
        <kbusch@kernel.org>, <axboe@fb.com>, <hch@lst.de>,
        <sagi@grimberg.me>, <linux-nvme@lists.infradead.org>
CC:     <Alexander.Deucher@amd.com>, <stable@vger.kernel.org>,
        <Shyam-sundar.S-k@amd.com>, Prike Liang <Prike.Liang@amd.com>,
        "Chaitanya Kulkarni" <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v5 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Date:   Tue, 18 May 2021 10:24:34 +0800
Message-ID: <1621304675-17874-2-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621304675-17874-1-git-send-email-Prike.Liang@amd.com>
References: <1621304675-17874-1-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37309e36-814d-4b8c-ed1d-08d919a42d73
X-MS-TrafficTypeDiagnostic: DM6PR12MB3867:
X-Microsoft-Antispam-PRVS: <DM6PR12MB386718156AF63D58FBC2C10EFB2C9@DM6PR12MB3867.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ap6CQ+qGYUN7DHPjnk72HoGiuurBHjeovwRKiatsrROGLreBLSdGklLbBZMBncADc8ke3sR0fPS6gGQ+5W3D6QcXYy40TGaQ4KoZWury+NKtiJ9jI2fMWxHHELK6eHo5H1fIVR2w8wpXpyh2ccaGyKnYepDXv4E396e8FWGKHjcVchk7CD6F+v2Pfrm5F9FWHRum5cUCdL6fdBlvGfYupEaWoJdXBGcprqTqCTUwuVvNsJXa+Jmxhe5EHMqhc8uzoWT0XJ3UCGTIgRT1aGdfJhu3XOhQSFHQ4UL2f7rNDBeCaPxeMlJZqkpa8v5cXnVn/1nm1WOdE4mB4ac8QhYLScYJ47l8GFN0u5KQhnDT2oovlFMO+Q9EZfiCdkvCJB132AxQkiD3hvAbhBb1PKSXaD0JJqKbO9yQ7nxdFB79Z/Y5jXA7sSmGDY3hoN6SoODKnIDkrelFA8LHmeYtEPPeupsQVnq0lYGpCrjGjULwJ+2QdH8RC3sddmC4O/EFz27+d0nNK0/i4vpkwjU7CbVvv67Dzz53yDWMSwlYx9uIy3cz5KZFv43C0AHqg4iSpYo1o7yWTYUY7cjzI8g60eyQxz2YG+RkXxS/vLg1eHX7pjU/xM7elDcE8ZIlTleSEl5vWzP9zdSEU5ACHe5IIsaY9W/Sr9Wmx1CRngU/aagtw9DMuVwhYsuA2WhxLjA/KaIm
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(16526019)(4326008)(2906002)(426003)(5660300002)(2616005)(36860700001)(54906003)(83380400001)(316002)(8676002)(110136005)(86362001)(356005)(70586007)(70206006)(47076005)(8936002)(26005)(36756003)(82740400003)(82310400003)(7696005)(6666004)(336012)(186003)(478600001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 02:25:17.6159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37309e36-814d-4b8c-ed1d-08d919a42d73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3867
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

In this patch prepare a PCIe RC bus flag to identify the platform whether
need the quirk.

Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Suggested-by: Keith Busch <kbusch@kernel.org>
Acked-by: Keith Busch <kbusch@kernel.org>
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
 drivers/pci/probe.c  | 5 ++++-
 drivers/pci/quirks.c | 7 +++++++
 include/linux/pci.h  | 2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 953f15a..34ba691e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -558,10 +558,13 @@ static struct pci_bus *pci_alloc_bus(struct pci_bus *parent)
 	INIT_LIST_HEAD(&b->resources);
 	b->max_bus_speed = PCI_SPEED_UNKNOWN;
 	b->cur_bus_speed = PCI_SPEED_UNKNOWN;
+	if (parent) {
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-	if (parent)
 		b->domain_nr = parent->domain_nr;
 #endif
+		if (parent->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
+			b->bus_flags |= PCI_BUS_FLAGS_DISABLE_ON_S2I;
+	}
 	return b;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3..7c4bb8e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -312,6 +312,13 @@ static void quirk_nopciamd(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8151_0,	quirk_nopciamd);
 
+static void quirk_amd_s2i_fixup(struct pci_dev *dev)
+{
+	dev->bus->bus_flags |= PCI_BUS_FLAGS_DISABLE_ON_S2I;
+	pci_info(dev, "AMD simple suspend opt enabled\n");
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1630, quirk_amd_s2i_fixup);
+
 /* Triton requires workarounds to be used by the drivers */
 static void quirk_triton(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 53f4904..dc65219 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -240,6 +240,8 @@ enum pci_bus_flags {
 	PCI_BUS_FLAGS_NO_MMRBC	= (__force pci_bus_flags_t) 2,
 	PCI_BUS_FLAGS_NO_AERSID	= (__force pci_bus_flags_t) 4,
 	PCI_BUS_FLAGS_NO_EXTCFG	= (__force pci_bus_flags_t) 8,
+	/* Driver must pci_disable_device() for suspend-to-idle */
+	PCI_BUS_FLAGS_DISABLE_ON_S2I	= (__force pci_bus_flags_t) 16,
 };
 
 /* Values from Link Status register, PCIe r3.1, sec 7.8.8 */
-- 
2.7.4

