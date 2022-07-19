Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B1B57A6D4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 20:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiGSS5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 14:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbiGSS5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 14:57:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05B2A243
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 11:57:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nN0/wtzsRRM/e9tSGV/fobeurw4aOhfUyl6CG7CnO2uD7THfyjA0u9LOXs8S+yLn1895CWeGlB3UrfuPKegv/TfBUT44EI9wMSiorxRBF7itszxoPEXIygYJ9eP/BmLPvNZP/AuLEgnoi+yBCrXxsb/RqtPg/SpSBJYVA/19r7sFeZvgYiwMl2h0XNPSRwxsxjsT14TsFedmJEduWbOlZpXXP1gsIjvTT+ul5hw9dkmoYE8lnHTidNfYnhQ9JidI+BNf51FW0aj5Gx1xnG6sgG2w0ycJe8e2eutmkmAyX12i38ZUXc/7BGBVzgNXVV/cnnMnAyBYmdU7muZlrbdf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n12Gt8dAgnLnfYxmg7woTIl9fhJV/6vsblfzRxnyiww=;
 b=SchxEG3ijBGapx+r8E6Vhc8hsaQ07/Nhu5HpEq7EIR1cgRUEhNfZpm9QPbAkJb58iqBUYaczugTzwaCD6eCloFh+qQ1pJC3q06h4+y4sjkxzsMKAsOxHC5e5cBLXSjMhofhA1cXda+li4/0qDM80Si2Pn7Ijg7EBO7Km7qcRVrXSV0SqEb4rMG4+QwfxdF9TiGAQ1jW80RoQnW/z3MiSI1jAZsvLd+KFDZ6M6k2kTBjwBl2AlZMWjdGfENtYV/uqvnEenCYaB3wOT/AfJuaEzasFi3r12A/K1Fgc/4ZNqalAHsjRnLN46/lc/2jYOacJOrmUYZ2vZqSIxrWMZwK99g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n12Gt8dAgnLnfYxmg7woTIl9fhJV/6vsblfzRxnyiww=;
 b=t0Lxs3xK+W41apA0GMz5HPxz4ql75vMMqfEdK8944GZ2Xq/QEjJPJSSCgllDwCee+YM1wHKd4s6SWuoLkvzupFuLmWRg6ygqzH/J3f1sjXoiQluGgJcnYQBtvH7QGx1/z9L+qEs5M45mc0D++InLRTk93AA0BlAoam6LalPJ/Jc=
Received: from DS7PR03CA0069.namprd03.prod.outlook.com (2603:10b6:5:3bb::14)
 by CY4PR12MB1461.namprd12.prod.outlook.com (2603:10b6:910:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 18:57:12 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::b9) by DS7PR03CA0069.outlook.office365.com
 (2603:10b6:5:3bb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Tue, 19 Jul 2022 18:57:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Tue, 19 Jul 2022 18:57:12 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 19 Jul
 2022 13:57:11 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     <amd-gfx@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>, <hgoffin@amazon.com>
Subject: [PATCH] drm/amdgpu: fix check in fbdev init
Date:   Tue, 19 Jul 2022 14:56:59 -0400
Message-ID: <20220719185659.2068735-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 890e6be2-78e1-4da0-8d95-08da69b87d64
X-MS-TrafficTypeDiagnostic: CY4PR12MB1461:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/i8C54HeKNlcr+Te4IbCo0lqAdPA7yoMoMXBzuRjg9EDYaNDACn88zd1aqJOMGRlxe4j02k97knSjd3pk9zN4wkDs/haFrCIEWBn+8tfjZLNNMZcrAsOuIQ9uRKseq6ImeBrz9jcLlWVIgPX5PQgKCruGbrLfx5uENZxs3Oj8Xc882Ohx6euEm3Xl6aiB6sDKi5KvtIH9zh6gghAzZb3K8Qe5Nvh2G6iEw2M2hOC+hejm/05WpSOCEbDzm7bUwea2abTZan05V8IpXBK8sE4mL9AcYFl2goEyhs3M8pHbubfl2Sihn2OnK2boomkPkiv5mZIlHCI6OSHXJ6LTdVeY0LXNj3w7vkXEg+RkIGC483PeK4DUuXIiSSVrdb6c5LQdMMAwqBgbzRyrT3MAeapXp9kATTa0OkLTJWbtISGs5Mo19rMdYIH5U2fUyYFlYpPobIZVYT+nweXjWEWnoT5emkQjcqgyElZpz2I1uhWLujG2Q7Q7MAPMSiNagc+qe2tGdK31guKp7cN0t9aZwQNcP4QTxiw1uwS4FDo4eR6TGU1P7awrrTBGZwZ6epbeFBrvMEGbWNv0DyWn9LDpJi2XPtr6RgK5vSscMlM7TNzBkr+egJaT0y9e7jZscNd1YfgCPytTaXEIUTq4W+K+Sj324mJiu96Bb7HMrBY1Z+hii1fJh52id8KRJEPFh+syfYgVp0m2kAJxUJha6/qurqshoQ9w/WgvdR783RrGFBiTE+y6CxQw8v17mOrmuCWAQmzTc15dZIv8luTiWk8rFlmpH+6fnkUJ9cr4ZXhixa7CEP5V5OEl0soZ3p4K3DrQDg9K97nJE4kBHcsQ6U0JeYZg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(136003)(46966006)(40470700004)(36840700001)(36756003)(356005)(81166007)(82740400003)(47076005)(426003)(83380400001)(336012)(36860700001)(40460700003)(186003)(86362001)(16526019)(1076003)(2616005)(8936002)(2906002)(26005)(6916009)(70206006)(54906003)(7696005)(41300700001)(478600001)(6666004)(4326008)(316002)(5660300002)(8676002)(82310400005)(40480700001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 18:57:12.3893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 890e6be2-78e1-4da0-8d95-08da69b87d64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The new vkms virtual display code is atomic so there is
no need to call drm_helper_disable_unused_functions()
when it is enabled.  Doing so can result in a segfault.
When the driver switched from the old virtual display code
to the new atomic virtual display code, it was missed that
we enable virtual display unconditionally under SR-IOV
so the checks here missed that case.  Add the missing
check for SR-IOV.

There is no equivalent of this patch for Linus' tree
because the relevant code no longer exists.  This patch
is only relevant to kernels 5.15 and 5.16.

Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.15.x
Cc: hgoffin@amazon.com
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index cd0acbea75da..d58ab9deb028 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -341,7 +341,8 @@ int amdgpu_fbdev_init(struct amdgpu_device *adev)
 	}
 
 	/* disable all the possible outputs/crtcs before entering KMS mode */
-	if (!amdgpu_device_has_dc_support(adev) && !amdgpu_virtual_display)
+	if (!amdgpu_device_has_dc_support(adev) && !amdgpu_virtual_display &&
+	    !amdgpu_sriov_vf(adev))
 		drm_helper_disable_unused_functions(adev_to_drm(adev));
 
 	drm_fb_helper_initial_config(&rfbdev->helper, bpp_sel);
-- 
2.35.3

