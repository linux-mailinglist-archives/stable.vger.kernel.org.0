Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384D34F9357
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 12:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiDHK4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 06:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiDHK4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 06:56:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB027BE2
        for <stable@vger.kernel.org>; Fri,  8 Apr 2022 03:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhWllUL7ciLrVvxdZsyWTUz/0iIZq2aUPtukhn1u35bbLnossHHa8lU+QB7f3bpBCdYbSp5nw0kj0rPdpEmtcYdQTkQMSZv67DFDWgtb+XAtFP2ge1MqeDOGy2YQ9mLrF7jdPUM/xre/qZjuvyypzeTYWL5p5mkBfY7RIi0W4N2Xin1e6/PLAK6RIudfSj8HNVvchfFMONLYLXGHHqkbMgDmeRylw/x6ahekdriZ8zYAB2CfpNeJtNOF9jdcN9NRCaU28Cje389+orYceBRB62LENkKcew7nsvRBJBFCHtNxCDkwibP1NG9dZfeLFRGgy5Qsu+j0kMnCdhTF1967/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=md4vi0L8KUfCjLJGjKMlx3qNIixRzegmGvJ7G2asNFw=;
 b=RK1CCC/RpRZCooV3E/KyiZkDw/QN/vwFqq7iWtYtQ9uABS5lp3z8sJUgl3mWdVwor1YZVNDn6LhoRw7VLeXkO1zeXHYMZXEMh5h5giw62C6lKafA7BFUlIdMgG2B2CjJfiRD0wKXGcDMBaKaglrD//C9fzCUAMWHOW2g2hIUaDu2OjOyaedTNrgx3M1YI0VRerngIBzMSfQWbc1LWK19JLXxUhRqjqmVgg4fQzWMEF+svf8V+o/n7sxj4QzNWjQcTkUGjSYaN5c5K6S3olBW4M3MVlkkPs4/sTZGhYv1vgI+E4B4ZKxiTHFQWY2TJZIVkBEtAxClXJY6bMCZIXbcFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md4vi0L8KUfCjLJGjKMlx3qNIixRzegmGvJ7G2asNFw=;
 b=XhmbM7y2xAT4vlBIHA5h3SEK6F/r2UyQ43kphsqrxNgMzj0qbGCEEQgtTaOidO6hap84fGP7XIiqCilpnsgTnEnl0SBUuQKDbJrgJrd09T4QXZs28BzNHuE4Mq50gSBTZ2Kx4xCmN11hFXCIQILCHBom2993Jid6JPcQ45MoZ9c=
Received: from MW3PR06CA0030.namprd06.prod.outlook.com (2603:10b6:303:2a::35)
 by MWHPR12MB1584.namprd12.prod.outlook.com (2603:10b6:301:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 10:54:23 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::4f) by MW3PR06CA0030.outlook.office365.com
 (2603:10b6:303:2a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Fri, 8 Apr 2022 10:54:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Fri, 8 Apr 2022 10:54:23 +0000
Received: from ethanolx5673host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 8 Apr
 2022 05:54:21 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <pbonzini@redhat.com>,
        <mlevitsk@redhat.com>, <seanjc@google.com>, <jon.grimm@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Fri, 8 Apr 2022 06:33:23 -0500
Message-ID: <20220408113323.4066-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e9fcf25-9a1b-4cb9-60c7-08da194e2451
X-MS-TrafficTypeDiagnostic: MWHPR12MB1584:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB15846C8243A80D5E3A63F632F3E99@MWHPR12MB1584.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgXgAEdtKMrx7CA1g4BZCdoMdyuIPnFWR5XhxV1pRt4qin0aj5lQhnUFSpTizleKYpBED8K6oR8gfG8W6spLCb0oJST6+oFo1KcgFYhCA2EJtFvkBQC4AP/5q2gKlSCZEJOay5RmoWJMeWnmko91Db+wHgIhHZtig86EgCS8PRNlExdP9+c9xfbLCsXTVkd/lGjSKPAr/yG7GC07q3rEdoUlHzGjjLnaNrZsTRPgM39BnwcYfu7FkKo0LwwS6mzRDjXbedoMunN0PT6XaPZ3xsd2/c7SW7hLWPwyu6HcduRC6skYXZzdLZG8/IAvOCEvv7MxBG+S0mgk73WtLaQo1cy2eKIjvwQLCh/ShahdI1+1r3aYiZu86FhpjL1yI34u4HkYl4WsHGhQekMbj+NyZn2nx1lCDM2hVrB8bY0Qy5aIKm+KNm6P8JSzSpc74F+3ugWx5jL9OAilsGslijFGO9N2QZR/R7p+wfUQrgHTbhSSij1c6VhbTSsuRMyukdqgWzQAIBMSmCArZLUwFLaA2te/Ha1yINF/I1wobGlzWilGOPzLC9zEaGENedUNrj3UkbXTrosPvwt2jBybJmswLzp3msrxd2aftEOkUoDwoF5QlxR8Cd7azctZZut4Zv3oRe1V5NyfIHGewguMT7QhlJuVQqw0AuPZRJb+BihO7B0QXb1jOOTfYQoRguCnKjXlVFHvdUmazXDIpwQIZJ2hKg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(426003)(44832011)(1076003)(2616005)(83380400001)(36756003)(36860700001)(82310400005)(336012)(16526019)(186003)(26005)(7696005)(5660300002)(2906002)(8936002)(508600001)(4326008)(356005)(81166007)(6916009)(86362001)(70586007)(70206006)(40460700003)(47076005)(54906003)(316002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:54:23.1772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9fcf25-9a1b-4cb9-60c7-08da194e2451
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1584
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4a204f7895878363ca8211f50ec610408c8c70aa upstream.

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

Note:
This patch has been modified from the upstream commit due to the conflict
caused by the commit 391503528257 ("KVM: x86: SVM: move avic definitions
from AMD's spec to svm.h")

Please apply this patch to the following kernel tree:
  * 4.14-stable
  * 4.9-stable
  * 4.19-stable
  * 5.4-stable
  * 5.10-stable
  * 5.15-stable
  * 5.16-stable

Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Fixes: 44a95dae1d22 ("KVM: x86: Detect and Initialize AVIC support")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-Id: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 7 +------
 arch/x86/kvm/svm/svm.h  | 2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 212af871ca74..be0bc06797e6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -943,15 +943,10 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1b460e539926..47e4fd75caa9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -508,7 +508,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-- 
2.17.1

