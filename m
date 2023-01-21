Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2076762DD
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 03:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjAUCId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 21:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUCIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 21:08:32 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E5270C6B;
        Fri, 20 Jan 2023 18:08:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4BJb9DLk1O9H+P8pK9tVKGOkZqkU+uIZVmdd/0CAnmz37BpyTDoZ2vFPx0UaFbS5W9Xr/sEaf+cr/Mp5au1+REZQpDNvSUgivN0y6cGP9yH29RugHBwsOPIFT/K4bQ1eldRQzVRBpEqR+2EKmSGfcfe3TXi2BMjGZrQwiLyhXr93zP0G+g53WGb+l//A+8ETEXU/a0oBVDlRFW4vRPbZEFAc5AnBXrYRKUxLLY9mk0zFrZWFaziuvHqi1MluimlK1pVhUx4t1ZzGtBTs4mQ7VrqQz5JlqjEypx1jcIyhcN5MBmYhAB5mdy1Nb/4okQWOWPEUOjKJdRDayKdFjm/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UtdJPgEJRLGg3MP6pZGLNmQi8vyiG7Nt3n6OLlsZHw=;
 b=KVGlzu9VKcJisYyKSYgKm63EV1ulLiC984qXHwoBj59tPo3zLliiYqDM7xEGDOSKBxwaXWgnieC1hJyzCz1HhnvxvYBgYcxjucO4784zG7fCDv0rPizAqxnBjT3a+HPwh94YZCMYjK7eIad6KspFZEm1ZR/JTakCXdXJJyv7B2qTqw/OacOrkMsbWmXT8LKArNBR8fbvfsdaxzV6khsdyUNRcqwOT0pvWZBQUy3PuxRY8u/cV1s0NvjsEJpTCawlTDq1prRkvX1e+O+WzREbm3zNEKwrAaEvXC1aAQsBhZhqLTrjgFotZlVt+AGfBTNEXOas0iRwh/slrEueISabkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UtdJPgEJRLGg3MP6pZGLNmQi8vyiG7Nt3n6OLlsZHw=;
 b=WBtKKBWuBsOZbVS3EcLbElOQVz9gu+StUIGSWaAwIVRlfSbQm0vinb/RY+GVo1T8IlCuUO1rKMXat4y5drGCLOjfcYATT6o6mFhfDjPqFLFSRGx4AIuSl2DDHyeRCe7yiJJotPJ+saTnhZc9jPdIFg+oKFuu65hIiDklU6F4yOlFhuPGsYGIBW0tQiU25EeoUFUkXHV2tuZN5rVEXyswImXsYNJzHYspeAl+OLJsmhY+W3ymcahriaYJIBp1RpfdXlixukq92SVAzX55WvxKafQML9z1dnoReYO8uPIi0O7IZNaOlbt36DiuDUGEhdcDDgRzSXgglbydwmihQe2ktA==
Received: from DM6PR06CA0050.namprd06.prod.outlook.com (2603:10b6:5:54::27) by
 DM4PR12MB6134.namprd12.prod.outlook.com (2603:10b6:8:ad::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Sat, 21 Jan 2023 02:08:18 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::71) by DM6PR06CA0050.outlook.office365.com
 (2603:10b6:5:54::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 21 Jan 2023 02:08:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:11 -0800
Received: from dvt1-1.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:10 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <zhi.wang.linux@gmail.com>, <chao.gao@intel.com>,
        <shaoqin.huang@intel.com>, <vkuznets@redhat.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [RFC PATCH v6 1/6] KVM: x86: only allow exits disable before vCPUs created
Date:   Sat, 21 Jan 2023 02:07:33 +0000
Message-ID: <20230121020738.2973-2-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121020738.2973-1-kechenl@nvidia.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: 04657633-ff94-4129-b63f-08dafb545d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yz7meaWOs+2CszvNGBmb42ddWT5FTqpEN5ETV8BGkDsjKjL1urBekFnTez4cmlrdxYoD6UFXBL5iA0+ioj2arXoLjYj4JHVAWPFv74fZnl8C9gWQrMsNkL3VpaB3OHNaeWapb1WZIegrEM9fYgdu/RuH6j4kCn//xvaJUU0HS8dK/I8ZxRpEVZBIjhz0t3mgUp9Tm6F/ynJEmumi4okSSAwukkBBQgA4xw4rsi5pCfH9Iyd2OuEH4Sk053LIDV3yhLSsmZI0HNXBiDvMVhGzdZ7Zw9ybX3Btiv24+WUb3UMt0a8//4FoRbougs1ogkSBEU1xTHoqdjnQ+7Vi/FXyD2J0kuHqYmBbp+BD12mDOp3R0mKv/vJ1LBT/uGrlEzm6UGjrSY0aYacj5CwXNAFFGW9GyPJPkhJXQNt/ptEhyt2TeGq8WPJT32XuZuoeI/J0/tRywsv9VGqPHkR8qyUPBYo/A5shcBfs+vVnxIWE2TuiZ5AQn2HixOIuOuhdf4j1pGmaO2Q4A+7tjwQzS+3aAga5pAirh2QCDmVk2LE0d0aEnSTcGXVFsV1O/OSfV+OyvPzDRlBqYPSpJqYgTP7RfBkZMQ4rEeG7KiTolE0XH0jlp31E5m8aIv8QNmFRGwKwVLFC9LeAE6uyqADokLipuX+QwKlOhrdsAe++Ay4bkj+D2Gq/ju7vdVaHZmTOghmo/ml+TQ3ijd0NHYD97ryBUg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(8936002)(4326008)(8676002)(82310400005)(70206006)(70586007)(6666004)(83380400001)(478600001)(54906003)(26005)(2906002)(16526019)(186003)(110136005)(36756003)(7696005)(2616005)(316002)(41300700001)(40480700001)(82740400003)(36860700001)(40460700003)(86362001)(7636003)(1076003)(47076005)(336012)(356005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:08:18.4409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04657633-ff94-4129-b63f-08dafb545d35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Since VMX and SVM both would never update the control bits if exits
are disable after vCPUs are created, only allow setting exits
disable flag before vCPU creation.

Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")

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

