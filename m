Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B5F5EE492
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 20:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiI1SpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 14:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiI1SpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 14:45:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C891615C;
        Wed, 28 Sep 2022 11:45:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APfnm3ZojMt3MIVmwB4HuYwLCCZIT+HXpyNFwym09G5eOyPTzvzt8KS5Wj71g9OJ44CIZ55YraCQPX3hak5z6yEomx6HgfnVQPMRxiUzkM4AyATvjlgBmM07ThFMPQgadPFYplBBb9MtPlIucYFFl09LwE0mu6I5mgs7pue1IntMoo9eJoEtyQ5FfT6XdFxfIrBuuQwpXfKdBPvQ40Y4WVt2TnVThoY6WHuy7J39Pn4zH6GEhuPmXbjBY/PRBlV0sLURnmqpHomv5kEHYSBe+cwAeEp0GzPuzWnPwgNYb31DIobrYG5KF2Q0l+e6Nutdi0IfahIwcf/qQ06PoFzN6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7338DyfAYmFWtd48FePCvMlZm8mI4MEqqYuX8f7/yTw=;
 b=ldksk4V+kovRvRqcMuSfrp0PoVgTUJrufKOoD6fZoO5lFvUbnJFvh6F+f0TxzTsKU8+drV2FhfRCYhYZE/S4Yd2J5VBk3uzAZ2mdU96+ClJIr8e6rwmU/MaT9nZhKIAc12NUYy+YRbCklcIkjoVs85+ghVD/HqsGol2ZvCUMbRfUiolqAr2vjEA46cKKb8Ps3nqh8Scc/sd97Be6Stc7O0NovADWhyKxulgOezGrHJIIrl2CvFEtucoLjFm5HRXYIWSxwm3DpmuNt+PvNG5u3+akKWrlkuyGA2CCz9fePVHokUj5RYJ1WKn3dCKBn8qgZ3bR4BioWZjEt2nZh+13SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7338DyfAYmFWtd48FePCvMlZm8mI4MEqqYuX8f7/yTw=;
 b=H7tseHVKR1VLAqin+LsxcZ87nQdWJPhgTy4Q6FknlvVAYzOg6X71gYQfPfZ+i7QfIxmGc+wsNkYB046ik6FrM1qfvdH1x0zSQT9xUbznPfarfocY4h6uqW2+6nkDdPLCdhR6F7zuiO6Jl6KyP40kJfZhuk263lCXNhbjVtrNyNA=
Received: from DS7PR05CA0101.namprd05.prod.outlook.com (2603:10b6:8:56::21) by
 DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Wed, 28 Sep 2022 18:45:16 +0000
Received: from CY4PEPF0000B8E9.namprd05.prod.outlook.com
 (2603:10b6:8:56:cafe::43) by DS7PR05CA0101.outlook.office365.com
 (2603:10b6:8:56::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.13 via Frontend
 Transport; Wed, 28 Sep 2022 18:45:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8E9.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.13 via Frontend Transport; Wed, 28 Sep 2022 18:45:16 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 28 Sep
 2022 13:45:15 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "John Allen" <john.allen@amd.com>
CC:     <stable@vger.kernel.org>,
        Rijo-john Thomas <Rijo-john.Thomas@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Date:   Wed, 28 Sep 2022 13:45:05 -0500
Message-ID: <20220928184506.13981-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E9:EE_|DM6PR12MB4356:EE_
X-MS-Office365-Filtering-Correlation-Id: 62dcf765-d12c-4a6f-c471-08daa18195ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnAD+TRy5W3qZwNJmmKw6eZBD5a3H173HSQkXCj7edK2nuEwk+tGTyy9D9KnkIYUA9hKw78fnWsNTpLiGSxTgnOGaFFNCnZzuhScmDrQQVOKXDATgt25oTOZzNzxrpbL+REUXF0wXdzqz8FdTaikOylMMfUYZwjjEh4cWoK7DYzD8rTjPHf9npLHjHGfKw5zZpgW+T3mygAXe6hOXILB4nnJZHswl7gJ5rDUMDdFKAZNEIxMDKSWjim/H5NgyKqOGdohc0EGm7++jLaM/IIPz1cFo4cpYOylr9Eb32z55Get3dWU+kmkFr8a9WrKg8AL0tKslchMnLyiI728E4y8GRwhPSe0ktzN2h1aLdbjcOhmENRUgvxxgX0rRVG7eJs1gCRW/Rm34vzLNz7TU+4G0L3gIMVosfIZ48ArMVGGUyeWmq3jG1Qun8Iuse5Y3XFQT8H4Cj1Bm7mQIbVhGylrXzej8/4s5ND5er8hd3aGJViMoF4tU0w1DndHLY1YkIS/Eb30ZRV0EP8BaV33wOQ618ZBvjwCCf48Yugl3L168fzirKRONK1t/UDgqHbH4RDkqAQSqMJ64xN3LsEROr574gf+plcuXUAcCYeXtdxEMbiG721mAP7Hz7AGYepS2Lpor8Wr9ZHTsmlx2MNAjS32ffOqQA5uRi4OsyevOnHaAfMcboBkFLUf3u2RQiVeTjoaKrD4vJdiOW9ongZ45OX+exBSeoJNw7ZwMM5C6blgIDRQJcaquSfG3pnNvcLn/gvKduE+jEBk2ooZFLj6Z8Cfe21e6poleOrCD4hFnJ7BZrlptGdJijkdmtkK4Urjxihz
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199015)(40470700004)(46966006)(36840700001)(8676002)(4326008)(54906003)(70586007)(70206006)(6636002)(40460700003)(86362001)(316002)(478600001)(110136005)(40480700001)(36756003)(47076005)(426003)(83380400001)(7696005)(6666004)(5660300002)(2616005)(44832011)(8936002)(2906002)(336012)(26005)(1076003)(16526019)(186003)(41300700001)(82740400003)(81166007)(82310400005)(356005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 18:45:16.3271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62dcf765-d12c-4a6f-c471-08daa18195ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SoCs containing 0x14CA are present both in datacenter parts that
support SEV as well as client parts that support TEE.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Rijo-john Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 792d6da7f0c0..084d052fddcc 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -381,6 +381,15 @@ static const struct psp_vdata pspv3 = {
 	.inten_reg		= 0x10690,
 	.intsts_reg		= 0x10694,
 };
+
+static const struct psp_vdata pspv4 = {
+	.sev			= &sevv2,
+	.tee			= &teev1,
+	.feature_reg		= 0x109fc,
+	.inten_reg		= 0x10690,
+	.intsts_reg		= 0x10694,
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -426,7 +435,7 @@ static const struct sp_dev_vdata dev_vdata[] = {
 	{	/* 5 */
 		.bar = 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-		.psp_vdata = &pspv2,
+		.psp_vdata = &pspv4,
 #endif
 	},
 	{	/* 6 */
-- 
2.34.1

