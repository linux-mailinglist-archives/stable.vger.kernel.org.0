Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6043524B
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 20:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhJTSEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 14:04:44 -0400
Received: from mail-mw2nam08on2083.outbound.protection.outlook.com ([40.107.101.83]:56705
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230493AbhJTSEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 14:04:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apFd5mpCnSI1EBEyt4IWBfa0Q8YsYxaH1pr0LV5QQaSsDUfB3ynkaYuR+Uz8UdtuksFtlULthbF6r0mcFTu17sLUC++nodyD0rf+1oOnAdvh+WlQqs9y0e++KZ+rvRMp5wuxOO6P6WJKo7ic8rDkTLpg3C9CEvYcb7EbTNqs4aagnDbI134TzvVdt7ITK5RdxcQwlVfPS33sdA6i/TeP6AFrjzZFxbrQJud7LKwEGp1vXPHBdENP4IZP4YBdqNXjirbk74tYQA8rXaW4XYgo/1LLR7huw5ge8Ul8aS75VsyvEeebN5tnVy4lxJJB0KLu79o2PAMFA9w4k0ton0bS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrTVy2YsTGVgb5qlzQ39z9i5J5xokYg/dGW8AyfPzdw=;
 b=XXBZSviEN1QaRmFACeaK34eZhC5Bmvw9kjpLTC+087WHjxKU3QHkh+AckQBK5HBshHLOQvOaZ1VqC8FSxmj324pIaGxzssqSRGLKQpSXnjdWeUAwbxapu2QVKNQ+K4Os+ez+0TX9WoG1xd8Kpg8rKv2D3j/b2nSCBr772pD9gXIPMf0eraljps6cQ4wmzpH8LrLWZeq68gvVUkEw0ZbgJ+ahzRd97lyJC3xZFlftNvn5LD6sm7brVnePw7kQPk8Fultis263diTs5wpnMgk7duycslbCRuQNxGrfsj03m9tlS5cu5roMW/9g2+pSZ+HIMT9brv4u0ICQLKaHfhVIIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrTVy2YsTGVgb5qlzQ39z9i5J5xokYg/dGW8AyfPzdw=;
 b=z6YqLWncrEga4iiniAw9eaEWt65d+GU6q2dSRNC5SJUO77edQyJInOtBLcM4kmNIFaHtkDWfAVCUE0yflrNFIfTKjfWnQp2ed2bCIq9n3wsGspdCLldkv5Kp5MW94aRXMRVBS7nmtn7GzjnRLcoiubAnuQzr0IuzzBsTqnm9gLY=
Received: from BN1PR12CA0029.namprd12.prod.outlook.com (2603:10b6:408:e1::34)
 by BL1PR12MB5093.namprd12.prod.outlook.com (2603:10b6:208:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Wed, 20 Oct
 2021 18:02:25 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::47) by BN1PR12CA0029.outlook.office365.com
 (2603:10b6:408:e1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Wed, 20 Oct 2021 18:02:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 18:02:25 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Wed, 20 Oct
 2021 13:02:24 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-efi@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Wed, 20 Oct 2021 13:02:11 -0500
Message-ID: <ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fd01d4b-661e-4d11-8636-08d993f3c5b2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5093:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50931FBE2960A0AE82E8C0F9ECBE9@BL1PR12MB5093.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Yc04aWGR0bFHkH2Kig+Jg1lg/toRpfIGtNGxU7UD+DeA5wrBq5HNRvGErtS9DaK8zHSKTa0lewSxsqregsmQVAHs1sAr7XBNFPxkZGBmpPH3DNhy2Xm9S6t5KVgw4gZtvekj1GQSO2wROMtZrDWkFeM2Yn3jz2+YDTfryFcecNKsk/DtZFPwWlvnxcuZzewb1AYYhsJ3VlwHs3pUtOB1grP8jgNKGxQbJ0GVM/SG9SPKGu8Bs3/4SzT74qx+kOpa85d3mcqXzgJYID4cDKltm+dAY4dSkJDhcyzdUF6dDGK5594RSRR4xD+j3GUfOFJpczjRTmp8rmDzRWqtym5H0QRhKKTGkOOE45vLtO3tbC2DIHbJYNmL+2yOc2aaTV6d2NtxMOHgQPlxL8LYn3TqyS79a16ogRoB9wJvrAdtpJJOmls7BQfZR0Nsg8TSjf6FQb11blVLD3ixiL1R1UB4xLEeAVPH+E0DLwDq2/aGkL8Z8JoK5dC9JGU/mbnaKSe0+iKWemP8hokyEYgIQOvNbw8cWqeFfsZPSgeRv6XT1CGfr2gUHDZIBYDX2vIx1MPtuw7BN2lFF7TqagqbJNHGyXXcAtEB39JvcTEj5iD2zj/W1solqaJMWyhM6NzVA+ULR2XicPlp/itQ9pqT9cAdSrPIN/JV9UFn/5RPniTFQFcvWc94R8M3eHCRzggYUF0EQz9Gp1SpVZypMQSfXdBAdbB9WqGquLTJpt6OHmXaXA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7696005)(2906002)(186003)(54906003)(110136005)(356005)(16526019)(6666004)(316002)(336012)(86362001)(2616005)(508600001)(426003)(5660300002)(83380400001)(47076005)(36756003)(70586007)(8936002)(7416002)(8676002)(36860700001)(81166007)(82310400003)(4326008)(26005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 18:02:25.2343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd01d4b-661e-4d11-8636-08d993f3c5b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reserving memory using efi_mem_reserve() calls into the x86
efi_arch_mem_reserve() function. This function will insert a new EFI
memory descriptor into the EFI memory map representing the area of
memory to be reserved and marking it as EFI runtime memory. As part
of adding this new entry, a new EFI memory map is allocated and mapped.
The mapping is where a problem can occur. This new memory map is mapped
using early_memremap() and generally mapped encrypted, unless the new
memory for the mapping happens to come from an area of memory that is
marked as EFI_BOOT_SERVICES_DATA memory. In this case, the new memory will
be mapped unencrypted. However, during replacement of the old memory map,
efi_mem_type() is disabled, so the new memory map will now be long-term
mapped encrypted (in efi.memmap), resulting in the map containing invalid
data and causing the kernel boot to crash.

Since it is known that the area will be mapped encrypted going forward,
explicitly map the new memory map as encrypted using early_memremap_prot().

Cc: <stable@vger.kernel.org> # 4.14.x
Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/platform/efi/quirks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index b15ebfe40a73..b0b848d6933a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -277,7 +277,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
-	new = early_memremap(data.phys_map, data.size);
+	new = early_memremap_prot(data.phys_map, data.size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;
-- 
2.33.1

