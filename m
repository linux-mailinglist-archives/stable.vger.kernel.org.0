Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82583553FBF
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 02:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355434AbiFVAy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 20:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355474AbiFVAy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 20:54:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF01031350;
        Tue, 21 Jun 2022 17:54:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dw8fyVlon9qJopNjKAgtc4NrqgRF5tdu/WwEWHs57gdYzBzBllJYXSrDlr92KJG0DXNDOP8EEXq+8Ozlvq82VwGffHE1pwpeTBxS48C79rraYArsh7qaaDsG5vqZZz1Lr5d+OjozpdC59ynAD3qiatPF+/JNQ2TZOkx1Pwadt3QFkWkxcYYAro2wmMv70IQR8scHnoGieNqjQRF2VzBIhiHUhzPjVZKGeGA70xGciGz6UApmTJs15eEV/baOhoHs3WYrksFNTvLyf76D5a5bop8lYyrOKNztxiXnwb5OLvtrdTQT4JCapghUai3GoHkw3nT20417ecaERpxHPohoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4qcnsEzsReGXlF0v/p/wJHUhIkauYOL3i4UPcyj+9s=;
 b=bB8GiqCrg3wd3UP1Kj9kIgXJj052MhHG8iMKSQRAepaoFp4mYO7KyTN/rP+weZyfqWzxPkq/Tsy0Bv0QYfaY1KB32koJZx/1aLNbcBPWJCZEhfZq4JfjDC48w3l3hWv7QMyOX1rKW8QwnLqO8BaK/6X8TxCqirs6eFmcuJ7HfAV7S8cvzqDnfz9EzC6fyD5kRW9sZxONNCrgKAc3agZXTgiMLwF80Us6NZpkkZyV6sWCgMCNDuR99w1T+OT0+T5A0RHQD6bb8RVkBHyEy5HKxuy2I3YJ3eitvkcbUfBbKplpUndwGfVrnUqB7MhyteaQOhOoYPNy76SYbtkiw34w2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4qcnsEzsReGXlF0v/p/wJHUhIkauYOL3i4UPcyj+9s=;
 b=awyiPLF7OymjBX/YmrLk3KZhix279bCBP04WrdPqZS9w6Ip0Q0K0zR/icAi9TyGHVHEMFkYrdHh+8BPDwLxSsWqqKjm/IM/kF/1kPz20Qw+fAYJ0zjB17nsfXbCEtxUGp4lGRvj9pNDRKuZKbKP8EKHkGEoiRPcfBoDDKZuT9aRqChcVyqA/g5nNTVGdBGwtMZq6a9NUvGNdXUTRBYzu4hgsaJIFSnb1EheKwbPi6zKsswSkjGjeeGPm7eIWtId8IKpANJr0tbSb7a+djAP5sr0bHO/+RCub9aSxS3ftpCoe60JjJN819PBdBDZMh6mF80LxDnKw4scrC90i6/n9NQ==
Received: from MWHPR08CA0037.namprd08.prod.outlook.com (2603:10b6:300:c0::11)
 by BL1PR12MB5237.namprd12.prod.outlook.com (2603:10b6:208:30b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 22 Jun
 2022 00:54:52 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c0:cafe::50) by MWHPR08CA0037.outlook.office365.com
 (2603:10b6:300:c0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 22 Jun 2022 00:54:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Wed, 22 Jun 2022 00:54:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:54:51 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:54:50 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [RFC PATCH v4 1/7] KVM: x86: only allow exits disable before vCPUs created
Date:   Tue, 21 Jun 2022 17:49:18 -0700
Message-ID: <20220622004924.155191-2-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622004924.155191-1-kechenl@nvidia.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f9d780f-baed-4a95-8fde-08da53e9d0a1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5237:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5237F17F69DCAC8BB535DFB5CAB29@BL1PR12MB5237.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBOily90FaONk07azMdktj8MTPT5Ermf2pUAx/gLRkJd8/bccl4C2AXCMS3R52bpGd+jKEygzWcmOMylkEaCsm5HdSV2UNO1uKe2GbOP4XBbemHuTC09nyKDlC0jVy/Nnf7XTSE7dWGGhZlDeu+fODPl5IIe4CR4bbjiVRBuhZeQekE46Zna7zCkeAshFrnAt2OeyWwLukE4RBhifGmpRHI/cIH5CxyX4hp+5bj4r8tnnc7GUNnI6oFbd3orDCAns8wxfGIEYa+/2TvssZVUmD8BKDprZTS26qVDtDWE1WkMgmtVOm+A1JS+lMuq1Wyq7WzrHajxYI2ymORU+Non9I71MQiA7g2IN42jZyew5YWppvJO3V+96lJo0sY8HuB/63yV76D3MxwKlNaJfUOiKvOEbLDorPMr7fei0JNm4nu2acEcfiIDZGmG+UwZPm+PJ14zhCc/qH0e0kc2S5vCn2aMTuxY9Ne/lpJogMvROdZS6/FfP+LAxKMi+nN5DKzVa2i9iuGzSXR9ZQb9Z8VnutqXIRUWIeWPH8sboH/Cr0P10wYq9OeXJesSz9WVC7wSuaKNqfHArLv2LmPpS4AiyFifED/Mq57D2qv7xDFO/CPn80OPeDS8+3SngdDLeDg/W5nai5eLYJuDwLUXMYZuo04J1X0xyTaIJO3JcDmfqGqFHyU7UBr97c0LFRSG7IZvkwSe0GawBY9LZOoipiYWF7J33Kw9OS0cQWpWqalHEdlY2WIPcemZ4au8YXNprDtF
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(376002)(46966006)(40470700004)(36840700001)(4326008)(8936002)(41300700001)(26005)(6666004)(110136005)(82740400003)(54906003)(2906002)(40480700001)(82310400005)(86362001)(36860700001)(356005)(36756003)(47076005)(70586007)(5660300002)(1076003)(336012)(426003)(40460700003)(2616005)(478600001)(186003)(70206006)(81166007)(83380400001)(316002)(7696005)(8676002)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:54:51.7831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9d780f-baed-4a95-8fde-08da53e9d0a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5237
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index 11e00a46c610..d0d8749591a8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6933,6 +6933,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+          or if any vCPU has already been created
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 158b2e135efc..3ac6329e6d43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6006,6 +6006,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
+
 		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
 			kvm_can_mwait_in_guest())
 			kvm->arch.mwait_in_guest = true;
@@ -6016,6 +6020,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
 			kvm->arch.cstate_in_guest = true;
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.32.0

