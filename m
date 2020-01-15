Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330F913CFB5
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgAOWFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 17:05:33 -0500
Received: from mail-mw2nam10on2042.outbound.protection.outlook.com ([40.107.94.42]:63041
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729103AbgAOWFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 17:05:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zw7Az5kc20rsrW/b6pTFDktMvy6FWJi3CtzE5ZgiDQujlljlVMH81dRpJ2Z0PGuTfB6FkYbBl6v+zc9/I98KtFwWyj1QHOzESLCir1cfGBbANcHvHSXfCbL1gZ1d/q66bsSF1C/czmBaQ0b81rAKnhfTAUL+Wrj3QoU6qRlxYbivg3S/vuc4Nsj7s5d73fro1496EFGHeGqCqSgXRM/5Kq5EPNRL8Zh8p+A6HprzEo6/Kc4yyhA4WqcDG5NIqzuF4Fy/dkOfZ8PagFxfSFeIdhFlftoqXKLj5EmJ0qwhFsDnt6ZLsdndRya1aUAttGdpmwe6ZpRGM2+iR2TC1r4uug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+ou289xCuQSX/A+seFHx60Iisn9UY5OjNAxwUOxibU=;
 b=mcnfMNo/8KovLIIq2/1kEwgqA/+UST1jTJlwy8lTl/zBMuoKtvIej2hzRbx1oqwBSHDHjZfD5uOn9Gth3m6SySYG2GTyN7HXf0Db/eGHQr9d1yC/JSiJFgVpBNI0VlV7eXFByGP+9kMJY/eHVQS4Pvcyup35GbnH6g5wN4ZlMNiONxG8K/coYNCzMMEg8Cew1fSXaOCIXlyPfnSii3LYkDyRbObAtx/lEEz1b+EiSP3h37NG7ydN2ek5BNsHXfEXv5EfIJItw78RUT7oZh7ShlNYFTW7arEENtDUgMms2ANgHWc5ZzqrTg4vD9SJ/NYrHj9JM2MwVeXR81bQJmCX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+ou289xCuQSX/A+seFHx60Iisn9UY5OjNAxwUOxibU=;
 b=EvfFiNYC0tvWjNHzG2b8PgueiDIzU2X+HGqYWhB6SbptdwAVhRtmKkw4lzuBpjVPzcvdK1sYC03XcGid+lPkPAqESF36StatrbxwJ6H+AONzg8v//xuIpXHtJ/Te6Ob5NvmU/OpkRYGDKn5Y6Nu+ww6noHNjtJaEF7Tss/1Poyo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3945.namprd12.prod.outlook.com (10.255.172.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 22:05:29 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 22:05:29 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: [PATCH] x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained
Date:   Wed, 15 Jan 2020 16:05:16 -0600
Message-Id: <226de90a703c3c0be5a49565047905ac4e94e8f3.1579125915.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN6PR2101CA0005.namprd21.prod.outlook.com
 (2603:10b6:805:106::15) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR2101CA0005.namprd21.prod.outlook.com (2603:10b6:805:106::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.6 via Frontend Transport; Wed, 15 Jan 2020 22:05:28 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d334c43a-c0bd-465c-01a9-08d79a070817
X-MS-TrafficTypeDiagnostic: DM6PR12MB3945:|DM6PR12MB3945:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB39458FEAEBCF5CD1302C2427EC370@DM6PR12MB3945.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 02830F0362
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(199004)(189003)(86362001)(2906002)(316002)(2616005)(6486002)(956004)(81166006)(8676002)(4326008)(81156014)(54906003)(66556008)(186003)(7696005)(66476007)(16526019)(66946007)(52116002)(5660300002)(36756003)(8936002)(26005)(478600001)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3945;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69tVneRwqbsSID6raxP5YhqJpi1bWim29wRo7OoNxvjRNLbzFJ+BQO/ge9ryb7lRoKJHPm2L28B7BD1wzz9fnuIejcaTTv2gvRTQblaLCd2DUrbH9LCBPkZUJXt6QAuq3VVCiWXAH/N5Ax19BZ63Cs44S6M+FfNDtPRDJysAjR8ZGZWdPQk4LedwZ3lXCGWrO1BUPxriJasnquqLBdt896LxM3dnsczRnvaRbM0bfA/kBNYLMn0QYz4idw/Dlni3XXP2ozh+3fLGAuiRjchQr2H7nlxrTbGc9PrVLO1mf1oooK8GHx+cGoV8j2Qh5AyXtCnV2++rlh/0lLP5/OkQY2wNcbPpRGU/DR1INN9Q43xdBkEYTP59dVjhFPuf/y0okblJ+SBCWtFQ5ZyhD3KXusc+CXXnTKXxYYwmv7ZxndgQDCPN5UOA8zxkDfMuYzQk
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d334c43a-c0bd-465c-01a9-08d79a070817
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2020 22:05:28.9677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G26E0bXE/whmMmrFGwQYlkm6nolMqF2152UAVfAQFgU/3+z4e3kC1+MfKM63PIL5qdnd1CFTpN272EDYRxqCHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3945
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the SME and SEV features are present via CPUID, but memory encryption
support is not enabled (MSR 0xC001_0010[23]), the features are cleared
using clear_cpu_cap(). However, if get_cpu_cap() is later called, these
features will be reset back to present, which is not desired.

Change from using clear_cpu_cap() to setup_clear_cpu_cap() so that the
clearing of the features is maintained.

Cc: <stable@vger.kernel.org> # 4.16.x-
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 90f75e515876..62c30279be77 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -615,9 +615,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		return;
 
 clear_all:
-		clear_cpu_cap(c, X86_FEATURE_SME);
+		setup_clear_cpu_cap(X86_FEATURE_SME);
 clear_sev:
-		clear_cpu_cap(c, X86_FEATURE_SEV);
+		setup_clear_cpu_cap(X86_FEATURE_SEV);
 	}
 }
 
-- 
2.17.1

