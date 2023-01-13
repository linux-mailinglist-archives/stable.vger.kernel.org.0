Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B3366A58D
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 23:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjAMWCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 17:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjAMWCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 17:02:03 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECE56C06B;
        Fri, 13 Jan 2023 14:02:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAqROyt20HvJUNWqK0HUpWJ+rLS9VdhUdtqUHTIStyIbdb5544Xzb2Bayg0YmXXSv16jWcU1p3C+w3YGO0003t/hju3ER2Ti0P1FAvmE/wQ2Oxt7q61/AXqSS6OJ0UjcaMg7txfybVujnpU83Pa2LDITOS3KJeIGP9/F81cXoLQ37LeojXdQynwNoSfv7jSe0J4aTUl229OKRrnyj0ke+at+eheVOaFVkv+TG7VNL48KUuZERPODDfvj+TkPMFcQUZCeHB2TG9SbW/UmAr2BIqapJBfs9TPh3fJ5J3v5LREyvEOvycB6HX35TTR4cxG8Wt4UQBhgWS9hx9qQhZg3+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+sk5rrMO/llRPsazlOXAoiWlkhec7l5GhOumZ697aSE=;
 b=IuwYdDQakQYfRKpxcwUn1SXivjplooX805VsDAWMbAAvRbI5cLLlqe47VxAmuiBol8g2WIxevrE55wPRLvrBIwJ8+JZ5fMepQuQh+s61uA2i3ZTj0XGl0FBqWEyL9Y5TD3E0Y/bbLjJvDIWRd2udGrZeZV88kd/hvvj5mqT4Z+gSQ7uTkgMA5sXGbC99VOASnxjjbvi7ZkYq4BDOJ3B2rTAUUn8Dl3RA2Vt1mNBORwBQvUTMkHHc27c/FyA7jfHDzS+QEzb8OlVEN6dU2pnkaDv+bmqcfm6FicYsBVDtf9mxUBvfQQ88VJf6xJjjiMcjEGCDzkb9xKfRLwaZKaGXtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sk5rrMO/llRPsazlOXAoiWlkhec7l5GhOumZ697aSE=;
 b=pOB7Od80VCnWGJCHYw5qwxxltvKxfZTvTUF/zBBEvfbGNKcjSPo43/XF45UZByfN5HiF4w79LV0hsuIr3WWm6/Hvx0vtLFnl1p8knehAFVrmTAiEcdqB7u5wfHDqJy/kKSKglA4vD2sbMqRw+S8NsXWIxQhcV3D2MIBUN5G9+OHjO2+2N1XXFeaP0RVUj30WylaJg8Xxpo1docBXQycy+SsXxPvapiOM1drF35xApkQ8bO3fqQKRu37OsgDeUIz27EI8b5F5nh0Xrj8oYoe/3wY3iTYRoVlW2l/Xl97rfJ/TC/h7lDYKB4iPhEKXA45bCd2C0hixUo8riFIfnhOm5g==
Received: from MW4PR04CA0054.namprd04.prod.outlook.com (2603:10b6:303:6a::29)
 by MW3PR12MB4345.namprd12.prod.outlook.com (2603:10b6:303:59::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 22:01:58 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::1e) by MW4PR04CA0054.outlook.office365.com
 (2603:10b6:303:6a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 22:01:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:01:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:49 -0800
Received: from dvt1-1.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:49 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [RFC PATCH v5 1/6] KVM: x86: only allow exits disable before vCPUs created
Date:   Fri, 13 Jan 2023 22:01:09 +0000
Message-ID: <20230113220114.2437-2-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113220114.2437-1-kechenl@nvidia.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT009:EE_|MW3PR12MB4345:EE_
X-MS-Office365-Filtering-Correlation-Id: febc1451-96fb-4f9f-553e-08daf5b1cae2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1Qjdr9x9djLI0NXWbs/p2ECWEuHn96+l84VO5oiQyu2Ka8xaU5BQ8iBoXiaKPRKy/oOQcNWi9DBaAP3Au7AoJtSMFfw46YoTilu9HhHu+KEw2ZY++QIPtob7ileLyyGrp6Y98GScNBI/DZUvTgZ13Iynw52vzEhYhH4lytp6B2yFMNW4+Sx+vzADfKiiwQ6q+BH+/zUjERnmDT+HXeXiHf0c1iMq8fQOVcAlmNJAA8bKeB4F8YRfRtBkqjw5C+U7I/l38TuhbbZvAF4GlVxixAhQ/AjHSepUQs5wYaR9OUyuW0Qw9dJLLOL9mfLXch+b/a657qZ+vK/w4DN1OHVtLRC0tb2eqU5n9nCzn3eCrMougQEQb6iWZDkKa8CXR5JU7GlvWlK66qvn4LYVrYATBDkkldEcuvw3QEPuiBTrbwMJcSupzyc/E9GPPzVQkFn4NQJy7gPbVlGud+iaNoEB/0IGQW6QPQEdeRLhf0qw+umH1wKdwePi1iX3bcuZT3UNVdyy+fWPMuQvvy09ExBS92cR/mxY+JkptENtnBgwPTIII2vc/72a7KtSWn5zlGsEjmgt6mANTSuwVp08iZi/3NKI2QbZRbHsywOCNux9PaHMrc9v2pOegOZJ5Oohk4gJRJ4I0m1zJBgqICUFwCfYNPpmovBfoMkj8Ht3EfVumHv+UaS4e9IhPExh/GsvHASVAE2siwPgNL3cdzlhOequg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(82310400005)(26005)(36756003)(6666004)(16526019)(186003)(7696005)(82740400003)(356005)(7636003)(478600001)(86362001)(40480700001)(40460700003)(83380400001)(2616005)(47076005)(1076003)(36860700001)(336012)(426003)(5660300002)(8936002)(316002)(4326008)(70206006)(70586007)(2906002)(8676002)(110136005)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:01:58.7256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: febc1451-96fb-4f9f-553e-08daf5b1cae2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4345
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Since VMX and SVM both would never update the control bits if exits
are disable after vCPUs are created, only allow setting exits
disable flag before vCPU creation.

Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
intercepts")

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
Cc: stable@vger.kernel.org
---
 Documentation/virt/kvm/api.rst | 1 +
 arch/x86/kvm/x86.c             | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b57..fb0fcc566d5a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7087,6 +7087,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+          or if any vCPU has already been created
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..c8ae9c4f9f08 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6227,6 +6227,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
+
 		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
 			kvm_can_mwait_in_guest())
 			kvm->arch.mwait_in_guest = true;
@@ -6237,6 +6241,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
 			kvm->arch.cstate_in_guest = true;
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.34.1

