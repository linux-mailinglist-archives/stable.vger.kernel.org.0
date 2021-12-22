Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9DC47CC33
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 05:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbhLVEgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 23:36:08 -0500
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:29793
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242462AbhLVEgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 23:36:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9VV2lisNiUQSIBc1/9NZe1GPaQHdeyVlLJhor5RvmTxkiNOeBaMGZFwz3+NcV9eD2kvrAuMqeiH6qnmUq4vH+N+BVB7uhXc4js0iW7OKhwGpAhHNYwRBCUsJHK1b6VPZijv4WgZam6wqB9LeMJmjzP4N2T5FI2TjKF4ILupGKuhbDQ/wV76LKSNka9sIbenvyaQVSw+qVlNFx+ZyAnOQh181SMt5sO0NMCeoBGmVpiCKW0FRULLdTVkNB+MjxmD1X4pehfTvtEb8BSEE0yV2c/NllkQn9CaQPIy0EuxPDbuJPMn45TvP6FYsWNaBwY4TXcRpLVDc2hj7geta7NzzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpdaTXp8hGaMh37AOkeTpiHVVpn64sbkzY/eMfM+n/A=;
 b=MM0/6weniO4McHUlqv+cBIAoMC/0XZBZ6JUHSLjawL+9jLTj1mydkP+VJ1HrqI4b9p4hWz4+qMTE2veeRCsRk/LktJNd/BwLNOOWJla3VW/PWeKUxxixR/ysFSuLirUqNRoi+W7GJFf6Pyonm8CR3yXcdzz+n/bE2gbo0rJNbJT+qvFmXYw4o6jCh2HCNMq9JXzvdl7tRR23hON4fetm0GRcf/H8YLINfOd0wwsu2W5Aw4AO3oG0lI4SdXnBKjt9GKdHmnK9EPjGql+MSxwixcPGBp40Bf8z+h0B2OCHZYaa3rXMaGk0gpwM0u6r1eGQkL8BTRt//DG0+DqekGOKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=suse.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpdaTXp8hGaMh37AOkeTpiHVVpn64sbkzY/eMfM+n/A=;
 b=BV0bWKXkfLW68a8D2Ocj0Vl7u81loMuRdiC+S8MuKzc31lKG/1TtexFhYF+9haz7zBtb+u/C28wm8VaC3GxxCaJmvgC5qHi0lYIIFsreqNLrzTrX+bFAwdSXoP2s02lHt1clKmFyBO5AHMJSUQD4hSd5lHKPMeoekWW0+GQvsVk5Nj1xGsWDPuSjsSdrrFSUPwFcmp1iHDL09s9F3kcUk2MIp0Sr+axixjmv9T7XDoCFh0g1K7//IeEfI6Nj9rhLebYQpwFcm/V6Q4zm+c0xRMVEvI3Pf+fzeuzcls8wjPE8igYfMi0PvJSvgQegGiNxbxmBrgfNK8ikKVMDQ9YflQ==
Received: from DM6PR06CA0046.namprd06.prod.outlook.com (2603:10b6:5:54::23) by
 PH0PR12MB5465.namprd12.prod.outlook.com (2603:10b6:510:ec::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.20; Wed, 22 Dec 2021 04:36:06 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::2b) by DM6PR06CA0046.outlook.office365.com
 (2603:10b6:5:54::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Wed, 22 Dec 2021 04:36:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Wed, 22 Dec 2021 04:36:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Dec
 2021 04:36:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Dec
 2021 04:36:02 +0000
Received: from audio.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 22 Dec 2021 04:35:59 +0000
From:   Sameer Pujar <spujar@nvidia.com>
To:     <tiwai@suse.com>, <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <robh+dt@kernel.org>, <thierry.reding@gmail.com>, <perex@perex.cz>
CC:     <jonathanh@nvidia.com>, <digetx@gmail.com>, <mkumard@nvidia.com>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v3 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
Date:   Wed, 22 Dec 2021 10:05:49 +0530
Message-ID: <1640147751-4777-2-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1640147751-4777-1-git-send-email-spujar@nvidia.com>
References: <1640147751-4777-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c023f8a-a0cc-44bf-68b1-08d9c504915a
X-MS-TrafficTypeDiagnostic: PH0PR12MB5465:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB546509F76837AB0BD617E054A77D9@PH0PR12MB5465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLzDMRANLxiyzIA0K/IPvALNauPqj63bQIxTI9b0TG3Gw26E4lWm5bYQb4xGP2FUuqPXo1Xdk6YpbeQR397pxcj9gWwH8vRNRvt2ZsDx647ez6jfczKfja3tNRVfkFpGhcFOV+b0+ykq0iWdIHuL4JSBPsoRCyObnPt6HB0MrKCqCyNkzFcPNHAEiAHsDAHWXq8L1ik+8J+UYSlG5CMPfLb+vlgn2PGTGRoCnt8H3wPOWxHgXZEBi+lk+jrIvXQdXcrzdge9sOI4v9Vkpwf2WnnNR/7/fBZPWGeasqsI0BkevGDLTrJ7O4f/PZXiTv0s5Y38wd52EV1xEhUFRclvYUpIP2MWopvchjQ3gcLtfFGDp72q+c7eiqjhGhlH/ZHNwD5kQub427e6YrA1jo0fhqO4KGOayuecfKDUqk4qv7Wx91G6luWs6FqhC03ha9nsDYoey9eJF7N82LmHDrxNYLm6PoSADc5z1rzfJe2QQEZkUoukix+SrlFHpOG8GmIifxz+klAqgm3CZRWfzopMSiQj8ibXjca1KPkjSK8SGrkdeaqK24NtB2xREB60U3+AivYHfR+8X54EK7H0ePQDbAi60vlISQfk8OYHgTKMGJpfrl4yjsVYfSC9ttqKUHst0f3+Fo4iYjN04/LWnDRcaqu1hZR7bNjbXsqc9SMYfJXrV2jbFlxTOzoIf515FjFf5JEx2hOP35+COe6v8Og2+QVVdv599A/QBeahjE0wN33zhhWfehBP4Kr47IEtPEUrkcmkx745isz0Pz/r3Jue2sw3LCvtaP3BR2aI4AfAN7V5TILcmwT/d/A5SAuWn8kK9RM0Ke4TYYgY3risP6XtMw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(26005)(8936002)(508600001)(6666004)(316002)(7696005)(2906002)(83380400001)(356005)(47076005)(8676002)(70586007)(7416002)(4326008)(5660300002)(36860700001)(81166007)(36756003)(110136005)(34020700004)(82310400004)(426003)(336012)(70206006)(54906003)(186003)(40460700001)(86362001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 04:36:05.7704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c023f8a-a0cc-44bf-68b1-08d9c504915a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5465
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HDA regression is recently reported on Tegra194 based platforms.
This happens because "hda2codec_2x" reset does not really exist
in Tegra194 and it causes probe failure. All the HDA based audio
tests fail at the moment. This underlying issue is exposed by
commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
response") which now checks return code of BPMP command response.
Fix this issue by skipping unavailable reset on Tegra194.

Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Cc: stable@vger.kernel.org
Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
---
 sound/pci/hda/hda_tegra.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index ea700395..7c3df54 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -68,14 +68,20 @@
  */
 #define TEGRA194_NUM_SDO_LINES	  4
 
+struct hda_tegra_soc {
+	bool has_hda2codec_2x_reset;
+};
+
 struct hda_tegra {
 	struct azx chip;
 	struct device *dev;
-	struct reset_control *reset;
+	struct reset_control_bulk_data resets[3];
 	struct clk_bulk_data clocks[3];
+	unsigned int nresets;
 	unsigned int nclocks;
 	void __iomem *regs;
 	struct work_struct probe_work;
+	const struct hda_tegra_soc *data;
 };
 
 #ifdef CONFIG_PM
@@ -170,7 +176,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
 	int rc;
 
 	if (!chip->running) {
-		rc = reset_control_assert(hda->reset);
+		rc = reset_control_bulk_assert(hda->nresets, hda->resets);
 		if (rc)
 			return rc;
 	}
@@ -187,7 +193,7 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
 	} else {
 		usleep_range(10, 100);
 
-		rc = reset_control_deassert(hda->reset);
+		rc = reset_control_bulk_deassert(hda->nresets, hda->resets);
 		if (rc)
 			return rc;
 	}
@@ -427,9 +433,17 @@ static int hda_tegra_create(struct snd_card *card,
 	return 0;
 }
 
+static const struct hda_tegra_soc tegra30_data = {
+	.has_hda2codec_2x_reset = true,
+};
+
+static const struct hda_tegra_soc tegra194_data = {
+	.has_hda2codec_2x_reset = false,
+};
+
 static const struct of_device_id hda_tegra_match[] = {
-	{ .compatible = "nvidia,tegra30-hda" },
-	{ .compatible = "nvidia,tegra194-hda" },
+	{ .compatible = "nvidia,tegra30-hda", .data = &tegra30_data },
+	{ .compatible = "nvidia,tegra194-hda", .data = &tegra194_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, hda_tegra_match);
@@ -449,6 +463,10 @@ static int hda_tegra_probe(struct platform_device *pdev)
 	hda->dev = &pdev->dev;
 	chip = &hda->chip;
 
+	hda->data = of_device_get_match_data(&pdev->dev);
+	if (!hda->data)
+		return -EINVAL;
+
 	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
 			   THIS_MODULE, 0, &card);
 	if (err < 0) {
@@ -456,11 +474,20 @@ static int hda_tegra_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
-	if (IS_ERR(hda->reset)) {
-		err = PTR_ERR(hda->reset);
+	hda->resets[hda->nresets++].id = "hda";
+	hda->resets[hda->nresets++].id = "hda2hdmi";
+	/*
+	 * "hda2codec_2x" reset is not present on Tegra194. Though DT would
+	 * be updated to reflect this, but to have backward compatibility
+	 * below is necessary.
+	 */
+	if (hda->data->has_hda2codec_2x_reset)
+		hda->resets[hda->nresets++].id = "hda2codec_2x";
+
+	err = devm_reset_control_bulk_get_exclusive(&pdev->dev, hda->nresets,
+						    hda->resets);
+	if (err)
 		goto out_free;
-	}
 
 	hda->clocks[hda->nclocks++].id = "hda";
 	hda->clocks[hda->nclocks++].id = "hda2hdmi";
-- 
2.7.4

