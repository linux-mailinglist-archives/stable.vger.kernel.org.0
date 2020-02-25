Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA016F022
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 21:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgBYUec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 15:34:32 -0500
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:6141
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731776AbgBYUeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 15:34:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltp/Knx8KLVZBUcJalNrSK/AJOQtMTyPmqqoDj3AAQYDiYrsLBgFsdfm1hqmaeLcEtmwlcK2GvdhbtLpLIyt5JojY7cCKFaCTGr9MB2Dm66ZjbJYV8/UEas99bPQS85gQHfVpZe+wzaP7JsVgDnk7/wJXOCO76ZWyT+kBFBC/DEIL/2XRRfcsS9TS3iNhQsVizdBmwYGN6b5lwoQksNZuhtY0GRsH9MvQJqdm9MQUQ76suyAkF0nbWXna6oBikyEzwAWyQtieE4cSN7eDDIpIzmHNemNXhB46EInyRNFXz9u5W02ApkgVFXDVS2j9MFoFN9ogaYUtlvvk/U0SYs/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciSrhoRWl5fJZAbFD2m6ipK9I1Q384FlQu3j2N/Mfk4=;
 b=IoQkZSFr+VyewX0RZ+QtksGL0d+VG3Y0akEusroKbnVnTT89VE6UJZLPs7iiH7RPjmzMjBGMa/qFOvh9YaKnzWXVV9cJ7LWrUmOlUQCZAceRAhsYm3n127VFls/Dq5OHHirHRlm55wNoJzr6a9lqFTcGi1bHwQJgJ3hVq8k+ZazPfEScuTIFPSPhXvg3toR7jySLAmPHNEAZkq9nAdmor9o4hYTl1n/Nw7oqSNeYxlphsBYR2m96ueR5HDpwzBOp+xcH+DtAmWmFRkiF8UAnQKo6rJ2u87/e6OsqEk3w5cl8DgcKz1dZuPtoxxSBh9oloK8G4XLbJfCN8lAbg72onA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciSrhoRWl5fJZAbFD2m6ipK9I1Q384FlQu3j2N/Mfk4=;
 b=HoMgjm4Au0swH41Pf7oZcYNXiaVih+Adp/EHkGSNBkhvQHTdL9bxEiPB5GR0vaz/yGRJO1vrIh/WrwzYoFsjGAT0JSY0Z1yRTFcYREljtbzUU4Q977P4phbEWFA8RpEqVmTfz2tcJBVR2n2cwq8k9gs30x7+9MH0jkXtgueVZe8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB4434.namprd12.prod.outlook.com (2603:10b6:5:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Tue, 25 Feb
 2020 20:34:29 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 20:34:29 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/2] x86/efi: Add TPM related EFI tables to unencrypted mapping checks
Date:   Tue, 25 Feb 2020 14:34:01 -0600
Message-Id: <4144cd813f113c20cdfa511cf59500a64e6015be.1582662842.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1582662842.git.thomas.lendacky@amd.com>
References: <cover.1582662842.git.thomas.lendacky@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0012.namprd07.prod.outlook.com
 (2603:10b6:803:28::22) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0701CA0012.namprd07.prod.outlook.com (2603:10b6:803:28::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Tue, 25 Feb 2020 20:34:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71a4d733-cbf1-4b4f-9df0-08d7ba32192b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4434:|DM6PR12MB4434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44349F2BFE7D78D14A504C7DECED0@DM6PR12MB4434.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(189003)(199004)(956004)(6486002)(7416002)(52116002)(7696005)(66556008)(4744005)(316002)(5660300002)(2616005)(6666004)(66946007)(36756003)(86362001)(186003)(81156014)(2906002)(81166006)(4326008)(54906003)(16526019)(66476007)(8936002)(26005)(8676002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4434;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7/ThVTtYVBFCXtOyG3sHIWFh+APJUt4Ivc4vnNcWDf88abdBNjwgkKiJFFaTteRguDB93JmLbMzh1zxBaK177CVFdaiMfQMvrfAFJ5sczD7JGi3zw2OE+pdocgrvXoDlNyU1oJ+yJnCt8Oi43xzMUdh5VnZfm6Q1cHQvuTofHKwnXlIn44G3/bphlD7RVxKmhsZl0Lwer7ef2kOaCjegbGgnrIv+rB7O/c9l2YKH4dDtLDhdqrU5ouUavdNQrtd4rZrZdFpvDZVQx64xQnRoTe3xmOyz+IcTDJUAwJe6WupPa6SmqRFC/OeksuDE6RqMQEqxyzVwp/+66Nu6txyNY7qwMGjuRuz9FbGJF7Y1L/aEC25oEXQbjNW/LvJOggBRXRZufXcsnzUP9hThUKhAm6KZnLakRB5B8xX6fKjGcGuU0M2lk05v0ZjDNKhL7R3E
X-MS-Exchange-AntiSpam-MessageData: T4nbNLE7mjOFMGzoF7aW8jnjWZX0ci7u8oDGk2cgSzxLuW36M/r112f+TRbSzWkCwi8Y4cpJpqg58i0vkMnfPs2R2WgSBpQ/af/Us63RIyEgREc95JkooFU5EJT+neI7ds8xApkQ3QYuKBqH+OEKSw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a4d733-cbf1-4b4f-9df0-08d7ba32192b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 20:34:29.4347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQ6ft9FPinS9QFvTTY2V5m1u8bFz3T6hpDBPVtmerHPF2D3ydGqI7uE2lWyMzk5dNF6e1stu1j35OYLeLDrRDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4434
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When booting with SME active, EFI tables must be mapped unencrypted since
they were built by UEFI in unencrypted memory. Update the list of tables
to be checked during early_memremap() processing to account for the EFI
TPM tables.

This fixes a bug where an EFI TPM log table has been created by UEFI, but
it lives in memory that has been marked as usable rather than reserved.

Cc: <stable@vger.kernel.org> # 5.4.x-
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/platform/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 43b24e149312..0a8117865430 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -88,6 +88,8 @@ static const unsigned long * const efi_tables[] = {
 #ifdef CONFIG_EFI_RCI2_TABLE
 	&rci2_table_phys,
 #endif
+	&efi.tpm_log,
+	&efi.tpm_final_log,
 };
 
 u64 efi_setup;		/* efi setup_data physical address */
-- 
2.17.1

