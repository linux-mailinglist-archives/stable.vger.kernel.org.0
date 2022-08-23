Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664F259EA7B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiHWSDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiHWSCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:02:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A23CBD0A2;
        Tue, 23 Aug 2022 09:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJrcQPd57XbdZuiNiDPo6kiXIpxV+K8PZGd/VCFqEKPipvZbrqqfQ7qNwVcUNMjO4s4Z8Oy6nVwUVkBuk3iotPNA+GtocZTq7T2585mXl3yR+TUK+VgeteS/IgK/LCwbC4+18Mr2vuzFo50iHWriWsS0rgSoEbGNuXFq4VUqEQ1GLU2tGuXrreFR7lmvP+HjwDeiewZ0QybR8vccTm7gJzceN2JBmp9hn0gEkWZNUr2Y1bfLcLH/mhuWTQ0dZZesZBDTAWDzkETViq6EH5+A2KIJSjfNcYNmZjiJoMpcWXezyIHrfO5L2wgON9HEIR7RMqM4P+BPNlHYWWUza9CWxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7sGmbYyJuEGhnZFnpdDsPafQBlNlSEPoMPk9IInwQg=;
 b=lyWF82IWhONRWKUOwNikIIdwIKAy8+R0QUB6TlLykFCkLsU2qQxfF6NIRttli1GeebGCZqYgyvh1G0/NPVg5/tPa/XOUShpSFuI/JYcnIMzyCHtw4u4y1YM7zYdoKpoRg9ana0gMtXmaZe2z5b63ymsvhZw+ZW4+/XewisjN2XWEktrN3vUYsC4Hfoj6152wUFiRFrAQa5vKnHcLSFd+AFjOvfHsbqQgr7s/plzat3KYbAG3P3m7e+8hcgE8AZfdzWUDuP5lly9s5IzkBQ6Gbxt4ImU9eK2JDJk92qYL4fnzdprY97PtHGGgUPpl1dlzaDcwMZtMr93K/ectCtZcNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7sGmbYyJuEGhnZFnpdDsPafQBlNlSEPoMPk9IInwQg=;
 b=RycdBKr6DwVR6powAuGGuy63PtDylJEirJNN/zkHvmMm5W2j0267H66272HmxO/CElY3brxzkCcRQbGiE0F87GjgAw9jxvS0bI8mPjMuj5j5I1yG1vnkGiDy+gB5fdkauWgkcy+kLZQn7ruLtYFNZrMop7U8oCchAoMuo2TbP44=
Received: from MW4PR03CA0018.namprd03.prod.outlook.com (2603:10b6:303:8f::23)
 by MN2PR12MB3101.namprd12.prod.outlook.com (2603:10b6:208:c4::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 16:08:14 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::95) by MW4PR03CA0018.outlook.office365.com
 (2603:10b6:303:8f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22 via Frontend
 Transport; Tue, 23 Aug 2022 16:08:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.15 via Frontend Transport; Tue, 23 Aug 2022 16:08:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 23 Aug
 2022 11:08:12 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <x86@kernel.org>, <watnuss@gmx.de>,
        "Jeremi Piotrowski" <jpiotrowski@linux.microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86/boot: Don't propagate uninitialized boot_params->cc_blob_address
Date:   Tue, 23 Aug 2022 11:07:34 -0500
Message-ID: <20220823160734.89036-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e3c68a-d64c-4367-1878-08da8521aecf
X-MS-TrafficTypeDiagnostic: MN2PR12MB3101:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kof/ubIBetUo8M8bT0QwBnkquRG6Jl6fTv9Ns4s7ARLm+4Ko2jRIGVwD7eeh3YsmDusRC/filsYWofr4UBhas0oj1mIGtbv3DNikvdeIZjNMCOTowMdYBG6bzfZTjkGcxRsImBpzFv/+VlKRwQFId66Mse2cLkJWMb41S+VivM8BVTcxxaTQUnU8NIwH9lZS2O616w6+U1tYnQrtiqL9h3a9AHfrkSmGLmP0W4TI7D1SxEN0aaFYqJqqjtJA/evxAvW7XaZ3v6CS49Rmw7kuOxaNZJb3hdE0NeDOfpf3xMKTz1ng2WdXQch8LD9FRFE+1TqT7JCmSAZFqF7nVKz+6potJG9c1b/LL8KdN1jOGRsDjK5ndA6E5Bs0oXiz18vCKNSH+agpzUPA3WRORbL94qBNbm6zL/Yleuw7MgK42Ms3UXHaXOrMz/QR+tYJpvknDnc70+V29cStLRmODeFYPsgfleFIlZg+5QjoXgBNaISLGtBkfC8kogokNL/cG33rNhEtb1X/2MAAWAhVK51wrRQyJ2x6TL4I9SPQ4LN08vigWTpo4KWXB7g0SfDZ26vlJ/dGpJcrnRGFoEiIwAAmWYJXXFWMw/HHabL3YXawM51wcUqSVA7g3CPLjEfHOWYusn7AQ1gbwaRl9nk+Ow/oXT5cuN3ZudMMkNjnP654uXQjScC9wR2OKBIIY2PGSodGUOTyPtrGA2qjqPWxKC0r1TdJX5FCf8h9gEo95G2e9mWUdiRWBNqbcd+Q+/lM+Q3mnAxJMgRvo7Yxbw6ger4mj/fHzlu+PaARBIKXu8Ikbv9/O3eHCYjcFIgKXmUq2zPKdR9J7O4+ZTLilrtkbFHY6Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(36840700001)(46966006)(40470700004)(966005)(478600001)(40480700001)(83380400001)(316002)(26005)(82310400005)(16526019)(54906003)(6916009)(47076005)(336012)(36756003)(1076003)(36860700001)(2616005)(186003)(70586007)(82740400003)(4326008)(8676002)(426003)(70206006)(41300700001)(2906002)(6666004)(356005)(44832011)(81166007)(40460700003)(86362001)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 16:08:13.7694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e3c68a-d64c-4367-1878-08da8521aecf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some cases bootloaders will leave boot_params->cc_blob_address
uninitialized rather than zero'ing it out. This field is only meant to
be set by the boot/compressed kernel to pass information to the
uncompressed kernel when SEV-SNP support is enabled, so there are no
cases where the bootloader-provided values should be treated as
anything other than garbage. Otherwise, the uncompressed kernel may
attempt to access this bogus address, leading to a crash during early
boot.

Normally sanitize_boot_params() would be used to clear out such fields,
but that happens too late: sev_enable() may have already initialized it
to a valid value that should not be zero'd out. Instead, have
sev_enable() zero it out unconditionally beforehand.

Also ensure this happens for !CONFIG_AMD_MEM_ENCRYPT as well by also
including this handling in the sev_enable() stub function.

Fixes: b190a043c49a ("x86/sev: Add SEV-SNP feature detection/setup")
Cc: stable@vger.kernel.org
Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Reported-by: watnuss@gmx.de
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216387
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/boot/compressed/misc.h | 11 ++++++++++-
 arch/x86/boot/compressed/sev.c  |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 4910bf230d7b..aa7889751abc 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -132,7 +132,16 @@ void snp_set_page_private(unsigned long paddr);
 void snp_set_page_shared(unsigned long paddr);
 void sev_prep_identity_maps(unsigned long top_level_pgt);
 #else
-static inline void sev_enable(struct boot_params *bp) { }
+static inline void sev_enable(struct boot_params *bp)
+{
+	/*
+	 * bp->cc_blob_address should only be set by boot/compressed kernel.
+	 * Initialize it to 0 to ensure that uninitialized values from
+	 * buggy bootloaders aren't propagated.
+	 */
+	if (bp)
+		bp->cc_blob_address = 0;
+}
 static inline void sev_es_shutdown_ghcb(void) { }
 static inline bool sev_es_check_ghcb_fault(unsigned long address)
 {
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 52f989f6acc2..c93930d5ccbd 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -276,6 +276,14 @@ void sev_enable(struct boot_params *bp)
 	struct msr m;
 	bool snp;
 
+	/*
+	 * bp->cc_blob_address should only be set by boot/compressed kernel.
+	 * Initialize it to 0 to ensure that uninitialized values from
+	 * buggy bootloaders aren't propagated.
+	 */
+	if (bp)
+		bp->cc_blob_address = 0;
+
 	/*
 	 * Setup/preliminary detection of SNP. This will be sanity-checked
 	 * against CPUID/MSR values later.
-- 
2.25.1

