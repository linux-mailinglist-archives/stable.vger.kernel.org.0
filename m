Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDCB4B1A2F
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 01:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245055AbiBKALs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 19:11:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbiBKALr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 19:11:47 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A57926FC;
        Thu, 10 Feb 2022 16:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AONr9A2WDS6yR43XRW7qxRs6/qYKm1ywFKL8pRnKDXg8Zj/zoLAaNIyBxNH9w5qqW1vp1dO/Z/spAKzfxUWSuqfJMOG6/GNZY/+4H4Ga+PLy/i3srteq4HKzy3Y01y7POrnFe3VJ1ypcVWYb02cTgjHJQ72tcbUYtq5anhYY5pfR8NXKiQhkIxqlex9XatoiEkdsbFJYckUL2zV2dN25c3C4FQknrbjT7DLN7+ZQZrxcY7S5xa+X8EKS/rzdjC/sFAt3A3TLMwOUFxiAATbq2wSRJWvKJ3SgD3io1eYuBxy69oeWh6TRigoCRWGoLKUcUNlbvJmHbzpo3XQPDtVY4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ax7GcyIU06oh3uKl3dUe4F4MxhsjFdyeETm14vD/NFQ=;
 b=GMsssHGlGjVEavizCw3IPf2QghphC+o96EY6FQ2B5BihYoLQoUDbGxAdX2ZfEcXyo5V4awjme5cGHFBhtHSITzEjBSyiP0zFz4srFkB18+X6aU9PidxxliUjeNKzG3E4iannduNZYbquzhMAfaZi5Yrd82DK6kXPwW06zcLYvXc8YC2CAcPyKFWh3IZDCQrMB5WTtv51+aq0fLzDREEY5fsDooGhT6G3Z0DY63Lu50mtKNAlXrz293kt8CViuYt72WrL82IzUHjjUxAkR45QZVWyUP4ALvPRhBd6EuP8Ma/tJV3VNWP4ipXXDcrPalSJiwtiWLfYqd9krSFScmPPoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ax7GcyIU06oh3uKl3dUe4F4MxhsjFdyeETm14vD/NFQ=;
 b=K+tlfHI/bWTUwoiVDbRvcHJvzIIkuILSGjK6uPJZ2A/0pR2UGOX+kSamafLG9dP+p4b7q3ZbfChm+WXJjJTw3LVsB0jnY+iSSjVS2vqTQHUxvTmakEZV+iNHtG009iklVKMinW/NyYc464hWuVl0JvYXYpTHtZWXxtlLWrtN4VU=
Received: from DS7PR03CA0016.namprd03.prod.outlook.com (2603:10b6:5:3b8::21)
 by MN2PR12MB3501.namprd12.prod.outlook.com (2603:10b6:208:c7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 00:11:45 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::8e) by DS7PR03CA0016.outlook.office365.com
 (2603:10b6:5:3b8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Fri, 11 Feb 2022 00:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 00:11:45 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 10 Feb
 2022 18:11:44 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v6] KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Thu, 10 Feb 2022 18:08:51 -0600
Message-ID: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c810aad0-5b70-4857-9e84-08d9ecf31712
X-MS-TrafficTypeDiagnostic: MN2PR12MB3501:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB35012271A7BE62644FC202FCF3309@MN2PR12MB3501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJpUiHUFwwi/KKB4LY6uoD/plpbPIggZ+jMXnAuoz5SrUSbpppQq/iD1mmtmHhmZChXVEWvwCF9XN9haQNyOIwGqrRCrzXqKXIAARb+COB/14+OfE45SxFZO7IIk6jPOOoLNynqoL4wM5SxDR2syxhJqoRc5O3EXK8xk0yvS8nv/pTxDIubNbrqx6JQN4V/h88zeFGWLyZ2fnvSNQRJ7SliOQ8gb0PW8vKwSkmohKDYAvblt7SuHvRqx1aGevz2mmBnt7yri3vJFO6CfyJ004RFPFhaE+MUWT0uL+djxhISEIAti/WCLB33HnoJ/5EFEIMQknKR6ph2gV1KuYVK013nfOMOcPp9+sgIda2an7gDQs9HRA43sCeYDgBlgFNRo19y9KOvFlx5Gu7g2j2wCDBPDHHyrrC8a3AQvA09sol02Tsa0EzlUlcZziIe/zXiCU+l8R9hbkF+mXMrWcTyE7fuYe4VQv5HCLO2GWhTu9tG8OuxG7vqLj++upcQH7Ubiz/ryNK3VF6BtaArOX2Q9ZuyRbb5RzhQEFp72TXtKCeZ08hvsUiIglM2D2hQmbYYhV1Ma4fvYfE7007hq75Aw8l+fXR7/SdVntTBrQG+VxOhS4C4BPdpb633dDmdvjcENvhQ8k03ZI7oUQA4uMF1/VZ/qR2B45bP2MuddGRjiknk463J3jxUKnZYWRQIW/FupFrrSTcO+8x2mwQuBxYLcrQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(40460700003)(426003)(2906002)(5660300002)(2616005)(83380400001)(356005)(186003)(26005)(1076003)(47076005)(7416002)(81166007)(44832011)(16526019)(36756003)(336012)(36860700001)(8676002)(86362001)(82310400004)(54906003)(316002)(110136005)(4326008)(7696005)(70206006)(70586007)(6666004)(8936002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 00:11:45.6846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c810aad0-5b70-4857-9e84-08d9ecf31712
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3501
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Expand KVM's mask for the AVIC host physical ID to the full 12 bits defined
by the architecture.  The number of bits consumed by hardware is model
specific, e.g. early CPUs ignored bits 11:8, but there is no way for KVM
to enumerate the "true" size.  So, KVM must allow using all bits, else it
risks rejecting completely legal x2APIC IDs on newer CPUs.

This means KVM relies on hardware to not assign x2APIC IDs that exceed the
"true" width of the field, but presumably hardware is smart enough to tie
the width to the max x2APIC ID.  KVM also relies on hardware to support at
least 8 bits, as the legacy xAPIC ID is writable by software.  But, those
assumptions are unavoidable due to the lack of any way to enumerate the
"true" width.

Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Fixes: 44a95dae1d22 ("KVM: x86: Detect and Initialize AVIC support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 7 +------
 arch/x86/kvm/svm/svm.h  | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..e4cfd8bf4f24 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -974,17 +974,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	lockdep_assert_preemption_disabled();
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..cede59cd8999 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -565,7 +565,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-- 
2.25.1

