Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC20E47B221
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 18:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbhLTRap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 12:30:45 -0500
Received: from mail-bn1nam07on2057.outbound.protection.outlook.com ([40.107.212.57]:58668
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240216AbhLTRak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 12:30:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cX8fLgLSvQwZgSMfPJnFuk/nkmT58p+CXUgfCjpT9xtZF1rdTCRClH2r2fNN5r/1wluTYeBZI9UyTuKWygKaBthUpk3V6sQBPBQk/Q2TNwV3UeWZnejxjV4f5YFobCi7q2ec1+pq1x+xTfec16smQAGZf202NAPuInvRy60t++OtkqyHbvLkckQc1203FcaXvae3BCpR/sv4BS7PFwZleN0a+dbFp7jvQIh3ZIoUvmhXvGv3VlzSFW3aNPiho4DByu0Swa1FounyyIuhNOPzp+t4M7xMO2BtDPV+JuCUlSvskQJYutQZ2vkLt5YAd6Za3RZZvewGn4N8dvPC+H1Gwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBMj28G4lKaOP1IblIEhgKmSuZdjCAxJ9lk9/1VutR0=;
 b=maNNmLNkDelc2sD+3YaSHGt0omEdtt9fqKCSW9asmZdot0Q0UgFR/O2UGSlbOBmfMCZpoIzP1JhvAehl1mWuSu/GRLtfgEtH8PURu6dMZBxJJLZn3MO/kjiEYZA/HmfboVCHtUznlipriEUVQ/dm2ej9nf+K8XW1DxMuPnMzLMoXcL//GdYYIfLY4y9XUdjWtlprcQxnPmuwru2sLzxWoHam4RuM2g5BSMvs90b1uqplROYLIt1RQvlenYdmnLQwiZxUU356abD9nyrqg7u0WTMpQN6T+iUQBCiMMC15ZEmBmoWvAaTbpQKkWfM1HUCgG9S//rXuJol/8BMrnkFTjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=suse.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBMj28G4lKaOP1IblIEhgKmSuZdjCAxJ9lk9/1VutR0=;
 b=g9wVc9MmNotHcpakNO81+6PNCWak8IUnOYs75NhGpfoqaTw9wgZdDFKvceZrPnjjIsVk3sql5V/YiTbZEIJW0IsxGw0H28E6oEXazQU8D5PHeatwiAsD/ztQhIsQdFwzmqWEBhx7j/T0DEiS99xjq2MyY5f7yBzdFO82VQeBuO54NJSwLJBODjA0LlnJvOkQL2yn+FvR4OQxY8QeQ4qNZr3DhrLOaVepoHwso2QSTrECENGnP5iyEkjFAloC2D1rWwoEXusjNQo1FoihqYelDqoz3WfFDRL6DQmUQVT/2poLtQY7L39/e5geMJpq8PDvbH5ldQGVC+9aE5+i1+Mz8Q==
Received: from BN9PR03CA0359.namprd03.prod.outlook.com (2603:10b6:408:f6::34)
 by BL0PR12MB4961.namprd12.prod.outlook.com (2603:10b6:208:1c9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Mon, 20 Dec
 2021 17:30:37 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::5a) by BN9PR03CA0359.outlook.office365.com
 (2603:10b6:408:f6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Mon, 20 Dec 2021 17:30:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 17:30:37 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 17:30:36 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 17:30:35 +0000
Received: from audio.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 20 Dec 2021 17:30:32 +0000
From:   Sameer Pujar <spujar@nvidia.com>
To:     <tiwai@suse.com>, <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <robh+dt@kernel.org>, <thierry.reding@gmail.com>, <perex@perex.cz>
CC:     <jonathanh@nvidia.com>, <digetx@gmail.com>, <mkumard@nvidia.com>,
        <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sameer Pujar <spujar@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] ALSA: hda/tegra: Fix Tegra194 HDA reset failure
Date:   Mon, 20 Dec 2021 23:00:06 +0530
Message-ID: <1640021408-12824-2-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1640021408-12824-1-git-send-email-spujar@nvidia.com>
References: <1640021408-12824-1-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e008a5a2-0118-4c3f-46cb-08d9c3de6fdd
X-MS-TrafficTypeDiagnostic: BL0PR12MB4961:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB496151AB2FD9319265A1B86FA77B9@BL0PR12MB4961.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AvgF44KpK93M5L8dH9lxzcSLo02/fjszhXxV6z9/5HUqA85/BAsX2X3tqoemUzyPzXM/ZUC0fe8Qqo+OqUi6546IcNOUT3JLr7A9DY/w0gYodmO9zHBk86bZ6e+3acFckjpNbv9g+ZWN+Rovp0BlEDCZsiuxAnQD0rYF4vmz6w9Tok547nudykH+zQ76kkIt/EH6bkHlx02EJcKb0DioWbQrBpCwYVBuKqRLn7F7zg6KcgRnhcELdIP5opxDuHmK7syFGXktutsEJyUyQRpf9hdgRFYv2EvqnoOL3fgKlj6qh6p8MhKS7n5Co0isVlt+dXS1s3n4daMRpP/aZj0jnSGFp5NQA1zV6KivUu7UhUk3WSx5zbKrKn/LY0IEyzsBeSzK12PiCrfuP3aOUd1EXM4nS8sGNsVgL7DkIiPcxsXboff4fcNbfBqJ4SJm+4mdfFVO1RmVsGTX0sEpI1QEydag5Ib56IRobbwMxzDJiLOPV3INEsqwNNFc2S8LBJ2PHqL+l1/lsgm2ldkugMX88tyuMBxgXB/mSvmVILjxEURpZ296qW36Aq3vppLW/aCEiZLrxpKysXm0cdTTrpKO4KfYJNdP8QPFCOEFkfnaJ7k14PpwATIsIkin9PeaMGWJ+2dtT72bnwjfrRrGZO17NZ4SquUhdn4v2vvoqklmIuwOZY68kA/1gP5IYbNYBbopD/m7kMuHwaRBrnE+1vJwR65/IRPXzqjQRBMN5cI7Y4pybgI4gszw28IyuGbArpzNHkge3uIP8GFHhBl1pYJs9tsiZbBW8cSTqA9e9g0tata7+dkk5mUAHJGsRDSJ6767MqhBKBH+BrA/xl2CmILKRA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70586007)(36756003)(4326008)(356005)(34020700004)(40460700001)(47076005)(26005)(508600001)(186003)(70206006)(82310400004)(7696005)(81166007)(336012)(316002)(36860700001)(2616005)(83380400001)(2906002)(8676002)(426003)(6666004)(5660300002)(7416002)(8936002)(110136005)(54906003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 17:30:37.4845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e008a5a2-0118-4c3f-46cb-08d9c3de6fdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4961
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
 sound/pci/hda/hda_tegra.c | 96 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 86 insertions(+), 10 deletions(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index ea700395..be010cd 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -68,14 +68,21 @@
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
+	struct reset_control *reset_hda;
+	struct reset_control *reset_hda2hdmi;
+	struct reset_control *reset_hda2codec_2x;
 	struct clk_bulk_data clocks[3];
 	unsigned int nclocks;
 	void __iomem *regs;
 	struct work_struct probe_work;
+	const struct hda_tegra_soc *data;
 };
 
 #ifdef CONFIG_PM
@@ -170,9 +177,26 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
 	int rc;
 
 	if (!chip->running) {
-		rc = reset_control_assert(hda->reset);
-		if (rc)
+		rc = reset_control_assert(hda->reset_hda);
+		if (rc) {
+			dev_err(dev, "hda reset assert failed, err: %d\n", rc);
+			return rc;
+		}
+
+		rc = reset_control_assert(hda->reset_hda2hdmi);
+		if (rc) {
+			dev_err(dev, "hda2hdmi reset assert failed, err: %d\n",
+				rc);
+			return rc;
+		}
+
+		rc = reset_control_assert(hda->reset_hda2codec_2x);
+		if (rc) {
+			dev_err(dev,
+				"hda2codec_2x reset assert failed, err: %d\n",
+				rc);
 			return rc;
+		}
 	}
 
 	rc = clk_bulk_prepare_enable(hda->nclocks, hda->clocks);
@@ -187,9 +211,27 @@ static int __maybe_unused hda_tegra_runtime_resume(struct device *dev)
 	} else {
 		usleep_range(10, 100);
 
-		rc = reset_control_deassert(hda->reset);
-		if (rc)
+		rc = reset_control_deassert(hda->reset_hda);
+		if (rc) {
+			dev_err(dev, "hda reset deassert failed, err: %d\n",
+				rc);
 			return rc;
+		}
+
+		rc = reset_control_deassert(hda->reset_hda2hdmi);
+		if (rc) {
+			dev_err(dev, "hda2hdmi reset deassert failed, err: %d\n",
+				rc);
+			return rc;
+		}
+
+		rc = reset_control_deassert(hda->reset_hda2codec_2x);
+		if (rc) {
+			dev_err(dev,
+				"hda2codec_2x reset deassert failed, err: %d\n",
+				rc);
+			return rc;
+		}
 	}
 
 	return 0;
@@ -427,9 +469,17 @@ static int hda_tegra_create(struct snd_card *card,
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
@@ -449,6 +499,10 @@ static int hda_tegra_probe(struct platform_device *pdev)
 	hda->dev = &pdev->dev;
 	chip = &hda->chip;
 
+	hda->data = of_device_get_match_data(&pdev->dev);
+	if (!hda->data)
+		return -EINVAL;
+
 	err = snd_card_new(&pdev->dev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1,
 			   THIS_MODULE, 0, &card);
 	if (err < 0) {
@@ -456,12 +510,34 @@ static int hda_tegra_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	hda->reset = devm_reset_control_array_get_exclusive(&pdev->dev);
-	if (IS_ERR(hda->reset)) {
-		err = PTR_ERR(hda->reset);
+	hda->reset_hda = devm_reset_control_get_exclusive(&pdev->dev, "hda");
+	if (IS_ERR(hda->reset_hda)) {
+		err = PTR_ERR(hda->reset_hda);
 		goto out_free;
 	}
 
+	hda->reset_hda2hdmi = devm_reset_control_get_exclusive(&pdev->dev,
+							       "hda2hdmi");
+	if (IS_ERR(hda->reset_hda2hdmi)) {
+		err = PTR_ERR(hda->reset_hda2hdmi);
+		goto out_free;
+	}
+
+	/*
+	 * "hda2codec_2x" reset is not present on Tegra194. Though DT would
+	 * be updated to reflect this, but to have backward compatibility
+	 * below is necessary.
+	 */
+	if (hda->data->has_hda2codec_2x_reset) {
+		hda->reset_hda2codec_2x =
+			devm_reset_control_get_exclusive(&pdev->dev,
+							 "hda2codec_2x");
+		if (IS_ERR(hda->reset_hda2codec_2x)) {
+			err = PTR_ERR(hda->reset_hda2codec_2x);
+			goto out_free;
+		}
+	}
+
 	hda->clocks[hda->nclocks++].id = "hda";
 	hda->clocks[hda->nclocks++].id = "hda2hdmi";
 	hda->clocks[hda->nclocks++].id = "hda2codec_2x";
-- 
2.7.4

