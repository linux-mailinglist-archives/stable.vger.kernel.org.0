Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC4347E2AC
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 12:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhLWLyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 06:54:06 -0500
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:35553
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348041AbhLWLyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 06:54:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijIX6Iz2pBBXZcyaXsoWBWvU/V9x3cJ97G3yYcBjVs73yTHnrqDUYR8lKyE5ZoIxIJjCzugh4T5VWXhaVVPpue12+/dGL1su8lWAkFcqBYs6vJl3uF/uJYrVLAsf3pSWIN0GuNV3kpaTHPJ4SH8APWojIjSrIz5jSNUrv9L44AY67rcsSLPidTRRscSHzUmOK1uyznV3/NDXZu8oVecxWgvKpqJS1Pkj6gBjllgqDbGBkHILotII0z2xhKiADrXdekZqXJTRzs/vk92ROV3WXrnUfh955UOBhnWv4mEK+mAYdqW77w5oq8YwfiXZkSAxoYhrLlN8F/p83nMYHdQlcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JthUVBn/n9x7garHu4PkRdUcAg4FGaoozbAcDRTDcgU=;
 b=couGccpC/XqKuUc0ef3FbvmF3IjX9CRiHGTf992YT9TgZQdRjKi7kic3BC6yi2qG7qUC3CJvlAHrCc4xlFT4MoOJZTjkdEHuXJq0ctZ3g83SA1cN+mPa5Jo3Cxy6k72BHYp245xP+ta9YyUJn2YuoU7Ruq8sEaHPTI/MApfn7QyBwnOmKsHRd4d6ln1rLU8BYjFDihQdCMEf5CtbGsVmQq3+NggPDa4XMW5B8EoJpQHsOHHkxAexD4cA0kwuCPvABplYeYZ8yyw7oRaUJ5RnpCAeZ158swnclyvAeHfWH+kQSDRh1WEcW0dviTqt1Dx+5U2w+SRC8KQVG00wTT/vXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=suse.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JthUVBn/n9x7garHu4PkRdUcAg4FGaoozbAcDRTDcgU=;
 b=kXjm0N6lMUTi0mC8Lsl8FAReePDUv6/ZSJ81oXZLmmqZsY83o+r0S1NMVSlChiuHl+mnyPPQoMgKiq3ryxmpnkjljIb/prml3CIPWywb3JkncA15vLi0P7cCFw4som0FWakwAby2nUbAFOIHSwrqa8ADw21M6+WmKASVOzBfwcSPrLwvFPYwFk84myP9IVEBGiTPvakfPpWdURDLmRb06GhKwIjI63bGfHq9h1ymhIid6T9mLKFEoqm3kLqXarQlGAy0JPFB8czrYCP502J9aXfBYnOrzukaT0bKWyNehPfa5WLdyHTFtldFm+/B2xtun8D96zdajvexN4KGUU9AlA==
Received: from CO2PR04CA0079.namprd04.prod.outlook.com (2603:10b6:102:1::47)
 by BN9PR12MB5180.namprd12.prod.outlook.com (2603:10b6:408:11d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Thu, 23 Dec
 2021 11:54:03 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::b0) by CO2PR04CA0079.outlook.office365.com
 (2603:10b6:102:1::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18 via Frontend
 Transport; Thu, 23 Dec 2021 11:54:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 11:54:02 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 11:54:02 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 11:54:01 +0000
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 11:53:58 +0000
From:   Sameer Pujar <spujar@nvidia.com>
To:     <tiwai@suse.com>, <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <robh+dt@kernel.org>, <thierry.reding@gmail.com>, <perex@perex.cz>
CC:     <jonathanh@nvidia.com>, <digetx@gmail.com>, <mkumard@nvidia.com>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v4 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
Date:   Thu, 23 Dec 2021 17:23:49 +0530
Message-ID: <1640260431-11613-2-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1640260431-11613-1-git-send-email-spujar@nvidia.com>
References: <1640260431-11613-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 802b4ad0-d585-4524-0d20-08d9c60aea36
X-MS-TrafficTypeDiagnostic: BN9PR12MB5180:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB518015FEB7D04C306BE57B53A77E9@BN9PR12MB5180.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Y8oKu62bOUs4tBtGDMWKvWVYppqlfxlj7F43MiBgqrZwz9QcBbldOdDe+O214WXoeqYoBJqHkZT8SxU2TKChGpFftZdznEqNDNca4IUQ67aRXGV1JOGbhBW1PuaxaZG8/D1XehehU3QzjjaA14buCs1g6IMlTEQYYW9aqdyeuX8xMWWouRqJPeKm2mhquU19MiNkU771TjUDuSlKXMag5C26gD5LpvGSAwa9eLkKg569+s7XZx8RWre89eKjN4Nik93sxw6KKfEdTJunKKwVOHNyc+SbwXXwqd2uFBwUmCUk+OC9qM9FwRzktkj+mSUEEKgUY+mkoxAXpIX+y2whIc2UegdrCAWGha8ZM6L0iaD0oOjJrH/KLrKElgtUtvose6BHmWZKBrWnS9948ErzX1gcSXnVJdUu69tl6xWybVfbH+AluEwkCOkhAi2vxjRncuB/e+pIqwcud2jwD7VkHRoQHEH6OKHi+Ic7SPhW9PGc6S/1mLkBT0rSgiPalrCWRzP8B/TgEzwzY4BxgEOnjNJ0KC761R5gRmB7mF9dCosf+79A3AiZaj0rJfuuGB9E99vZ6fz7Y2xTgx6DSBSz5ktG2lQrdOD2UQi0D1VZTyIZIkO5sQl4SanmrOZnx03BUeqJ62DjnS9r3Q8yFlx4RmSYsfFhG/1y1eMbpLZTMW1SNLJ/KE8lybJHdyWDoXpjxwHfRV3TEa3eg5EkMLtpN4TE4+OOGOxExhTxGj3WS5+BwuGwYP5TSrA74c1QyOiStEH7iMveD8kzo28TU8tuEOpK0o+yARwmm/qbjPY/IQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(81166007)(5660300002)(4326008)(316002)(426003)(186003)(26005)(36860700001)(336012)(36756003)(6666004)(508600001)(2906002)(2616005)(40460700001)(83380400001)(7416002)(356005)(8936002)(54906003)(7696005)(47076005)(82310400004)(70206006)(8676002)(110136005)(70586007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 11:54:02.9613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 802b4ad0-d585-4524-0d20-08d9c60aea36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5180
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

Cc: stable@vger.kernel.org
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
---
 sound/pci/hda/hda_tegra.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index ea700395..773f490 100644
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
+	const struct hda_tegra_soc *soc;
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
@@ -449,6 +463,8 @@ static int hda_tegra_probe(struct platform_device *pdev)
 	hda->dev = &pdev->dev;
 	chip = &hda->chip;
 
+	hda->soc = of_device_get_match_data(&pdev->dev);
+
 	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
 			   THIS_MODULE, 0, &card);
 	if (err < 0) {
@@ -456,11 +472,20 @@ static int hda_tegra_probe(struct platform_device *pdev)
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
+	if (hda->soc->has_hda2codec_2x_reset)
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

