Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACFB41E6DC
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 06:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351842AbhJAEnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 00:43:55 -0400
Received: from mail-dm6nam10on2048.outbound.protection.outlook.com ([40.107.93.48]:43287
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230477AbhJAEnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 00:43:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K50YGau1VYTtmEgIYlCu2/ttzYfnDotzopeBBuoCNe1YlHC1d/UrtsAqO2Y1G//pIYHO87kDO5hc7NgulCIte2QdHdDw/XoBB0Nl37qPK7Iqpb5+txq3HpZR+dilhmT7HV2gX+COspukuBu1ZItOQYMRtTOze03WxXZeg9DFCdDIpe0/kyM2MgUiTProkVUXVubGulw9y3bLJHBP1h3y2I9OJEJsBqVVkqwD9hJboH66FvbQTvwsdqjr05X3NQO6RKwene1KTPuw/A3Oow7HhpsXZV1bQKietVChfhdSl+q6HG+ymuKbVSiHLKEnLWy/ekJHAdFsLsoAuIV3waqbEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5aSIRvMfaRsNjy+ZOvu3++/rvF++EgsC6LnlkREbP5g=;
 b=V4niSoemJgichj16KU7KrTWtv7XBtVxk7vrVAfsPceT+PuLlcfLbe/TW7vA7pDLsL1iONPRpfjbiupJbEaXL+KFXjPzp2H2DqRlcyLwt1vZje4MuMElSuvOr85jzNNvgKxKJLlvTtuTrPp9F8Dmke+sJ9unigc154Vq8+HqQTa7PSQYOL2Gx8Kg0Ru6bEaqU3GbjtxgJUjVyQskxKQRnH2yd1lXtKB2ujd/Vmsu+g3I0iZARexMfj68xc6qrsvRiJ5gwaOgY3d19mXu5YpLoYhU57f6+rTkC4+GR+F/qFbtmeZMERu/jA+Jfk8dMHuaTGxsdq1CVL00+PP3f8C7xEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5aSIRvMfaRsNjy+ZOvu3++/rvF++EgsC6LnlkREbP5g=;
 b=ZhdLlL0aJuG3Wt/JXWrTXXbi0KtlaUKI6onn7G9WWkpTkfCX/5Ystw1FER4UypXe8JthVYDcaajAC04JoG6r43G7hyoQDg38GTqgeFR530lcYdOfm5UuHlfObe5mLx81Ac4xkyjB4sOKHT3EdrOT9DQaztOgLu+EfrnLQbLxw0w=
Received: from BN9PR03CA0416.namprd03.prod.outlook.com (2603:10b6:408:111::31)
 by BL0PR12MB2449.namprd12.prod.outlook.com (2603:10b6:207:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 1 Oct
 2021 04:42:09 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::90) by BN9PR03CA0416.outlook.office365.com
 (2603:10b6:408:111::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend
 Transport; Fri, 1 Oct 2021 04:42:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 04:42:09 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 30 Sep
 2021 23:42:07 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "Joerg Roedel" <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]
Date:   Thu, 30 Sep 2021 23:42:01 -0500
Message-ID: <efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60ac023a-53eb-4397-bd2c-08d98495d3f9
X-MS-TrafficTypeDiagnostic: BL0PR12MB2449:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2449DAAF25B6402C4578208BECAB9@BL0PR12MB2449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eC3RJXcv8Hc2EMHRJa1vo/6UwlYfP+38nf6obEkkiNMhteeqwUJdRihnoqjD+/FC/deQ9+OQMxDSXatUQzil9GDpD2ZT8nvahnlZ0mw7LwTBMylpeP4vTqexv4xiHgstI8qDuz6Vc15EsNuc/+hP54tt4drMXVef+lxroV0hpjfH3gUoj5n6VdJy/2tJS6P+C/QRQm6qUgjcwvLyBDzHUPbBe/xrpnzn+uqVcU1C25luMzvs+jSYgyOj5z6UsNjqP5I3OsaOWqFQy/AXdHiRu6JRBPWGcYwNAEURgrcleH6iQDHm0GWKdQIej2+UzRmFlTAoSUs8iCi3FJS+3zapwHi46mrNVc4viN1gqJZ4ZmC1jITsbSHy3FnNHYP4e1Hbcy35gv8CFmSKyE3A+8MMIKKGnm0ozRSBHJSkS/FhtViYAInznWTdQ2JqEmaIR+1necD7aEZxTYva12WbMBgmt3FsOTXmi/jb1Ayry8FLtXmUM40KA5tFL5cB7ep/tYWCvXhXWmVKI80IoCoBdFOZUpqulNCeJVY1gyLsTaeZKJaPB+x2S5Q6lNlPo3XzWFjGcIxx3KqPnaOZ72u4yTaIllLDdOV1d97Deo6ol9CC5X6jzgCELCABoPV/Nw6tVT+QC5nNYUw+fVMJQ+pgknMIGLiiOKHi25djMElPTuuaBUBFOTAEULXrVTfM8YjfhZkzynp0j89WhutOtID7zlzaFSEYG3KGEoE/7VyQ2ww2tEc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(336012)(2616005)(2906002)(82310400003)(186003)(4326008)(86362001)(70586007)(36860700001)(70206006)(47076005)(4744005)(16526019)(36756003)(110136005)(81166007)(426003)(5660300002)(26005)(6666004)(7696005)(8676002)(316002)(54906003)(356005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 04:42:09.0549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ac023a-53eb-4397-bd2c-08d98495d3f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2449
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After returning from a VMGEXIT NAE event, SW_EXITINFO1[31:0] is checked
for a value of 1, which indicates an error and that SW_EXITINFO2 contains
exception information. However, future versions of the GHCB specification
may define new values for SW_EXITINFO1[31:0], so really any non-zero value
should be treated as an error.

Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev-shared.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 34f20e08dc46..ff1e82ff52d9 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -130,6 +130,8 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 		} else {
 			ret = ES_VMM_ERROR;
 		}
+	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
+		ret = ES_VMM_ERROR;
 	} else {
 		ret = ES_OK;
 	}
-- 
2.33.0

