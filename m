Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D861DED50
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgEVQdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 12:33:03 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:47456
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730031AbgEVQdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 12:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO3WlcQUgEXP+Zybk5jBdzIBBpRv0QHPCqRKYKrMB5yAAhn/93hhb3IoOaDGRWZP46qH4sXVQarDKkNDzfTsyC6U/mZ+MeiJdvM+1j4mgtiUCOkbVeJrJxjY/6Qw7hv5CoS1CcVnnkJSWSD6qISpaSLPbGw7a1LXuQHr6EXHIVV2qUj+Xs74ssO4k5u/YlrmgvXhN2YzCQXeEMnltbyrrzNCFyBksh9OYSwTvTIbt9biUkEf3PcpUICGvhc1/B9rgLGHXtD6pzjiFAbiDESEcN499S8FKJmKy2U/P5aerxN8AegqeS9eW9bOFl1PUYdXcJ1rlK3ntTBFhnQKsJwuyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXU7h/0RNXm1sb70l2WU2N9hVmCYNfDmauZJI4fYCEc=;
 b=doBWJTdp9IalmMES5XHULfhbfNfuZYEhZF+1+G6aBz3dBwPOF07DZ24awU/P/XcEqrDELBD7lLfk46dRdZW4Uwf5CysYp9DsIiPSMDQi9CbkGp+dkxtDRb4YunZUTUifYVywg103WT5TRAKAIhxN8B2hhhF8mspmV4W44WUaT4hi8nK78zAExe7C4uY2mtVO8Lz++i4njR3lkCiEcDLKpV/SnpjAXKXErU2THMq+zWJna2t5h/M89Fs0XKkGpc6ye2+rAX3XZY8598ON8M79M0Pd8IfBFRDtWYpXVElXbO/czNCsm/zNixatXoNOLKQ708WTXV+cOqeDa3PHPQ+BrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXU7h/0RNXm1sb70l2WU2N9hVmCYNfDmauZJI4fYCEc=;
 b=djaBFkywiOGUH0svx0wofWyV9jvToFHRnC57MAS2gYSaAIzKtFyIBsHNb32jPTs0aGKVx/7I4LjYNrIV3OIggcv3nfUvAVMzY67LgGyfG3rOM3YyHlxjDSPqngPP8GpMxNATOrbXNtOkAA9Fq8/0ov+MxvIdwrEODvTBfW0kDKs=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Fri, 22 May
 2020 16:32:54 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3021.027; Fri, 22 May 2020
 16:32:54 +0000
Subject: [PATCH 5.4] KVM: x86: Fix pkru save/restore when guest CR4.PKE=0,
 move it to x86.c
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, stable@vger.kernel.org
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 22 May 2020 11:32:49 -0500
Message-ID: <159016509437.3131.17229420966309596602.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:5:134::42) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM6PR13CA0065.namprd13.prod.outlook.com (2603:10b6:5:134::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.9 via Frontend Transport; Fri, 22 May 2020 16:32:50 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 33e0d2c9-1994-4c9a-9ac1-08d7fe6dc6c2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366DCE6A9337E7F1D4AC31595B40@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wyp04LGzt/v+ReVTpUAT2app6aQDr8LnOWqotDMdHARQ9DbLh4XusPCWlmaBX2Oean/ll/+LMsl4C/1/o52T0W3W22/6r9Dh095UCKH5BLUzS92mDCGGMqOeTzPWePqNbYa2UXUL/0gotrBi30/h7LaF7+QQOXdaQ/RIrqMFMApVZO7WOufGoyZx08/AW5fzKVPe0U21wgDAGEmra08uOAaNumca947KttzYEEwHnw3j43Vfur04FIJlND55PZCt3ySTwRW/mdIBRdpGm+zpDq+0iP7e6l+q7DyQMC6E6tb2HldyC+t0g9Mgh9hK3Aai
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(2906002)(86362001)(316002)(5660300002)(7696005)(52116002)(478600001)(26005)(186003)(16526019)(44832011)(956004)(8936002)(7406005)(7416002)(103116003)(8676002)(66556008)(4326008)(66946007)(66476007)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vJCxThuWP/3c1zkz/nezUhfsPVxx+LSaZeciTUXOEJNGiJSFkEOMAwc7ZZYDPqcGL75bYpBlJhoHUG4y+Po6cgEXXlcfJMVTV7h72gVkUEnQWJq7SJBKDaDSkqy1gOb/yxKdb+d8lGfV0Tnl2GtNlZ1AY9JtzFbhbgYgLkM4Blaxpf98cnW0ySjTxt2WadNunM+QsFFq8t90GcGCC/G/RDWQTJbM6T2NQZWwQM6CXIMwVtAL1zPtfI/I+LhR/8vYw5OiY2mOWCy4c8Z7Q7M0pPvWqAocYZxyrs1Znv1OkiBsrBp02gKeiHNg97Ahp3AKCdZ7Ttx7BrQH/oWaCOqNqe5qzeRN4lSQy8vM5hV3sDy2UcOJsKv1WqSd36wzVXzp/c6NgKnKrJKNxjptutvToRJIQIilKOX8BfPQqdIdo77vhR8Di2moaXi6+B0Fl575yAPWr4Y08jmOBaFhRBm2enccoohuBv5GUXW+YovHmkQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e0d2c9-1994-4c9a-9ac1-08d7fe6dc6c2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 16:32:54.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L46eZjuPr2z0hr7XyaY1PW2rY7HJEz13dN77eK6DwXjw1urKafu5FDX/d3khCTqQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Backported upstream commit 37486135d3a7b03acc7755b63627a130437f066a]

Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
resource isn't. It can be read with XSAVE and written with XRSTOR.
So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
the guest can read the host value.

In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
potentially use XRSTOR to change the host PKRU value.

While at it, move pkru state save/restore to common code and the
host_pkru field to kvm_vcpu_arch.  This will let SVM support protection keys.

Cc: stable@vger.kernel.org
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx/vmx.c          |   18 ------------------
 arch/x86/kvm/x86.c              |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fc61483919a..e204c43ed4b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -550,6 +550,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
 	unsigned long cr8;
+	u32 host_pkru;
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04a8212704c1..728758880cb6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1384,7 +1384,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
-	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
@@ -6541,11 +6540,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_guest_xcr0(vcpu);
 
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
-	    vcpu->arch.pkru != vmx->host_pkru)
-		__write_pkru(vcpu->arch.pkru);
-
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
@@ -6634,18 +6628,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_exit(vmx);
 
-	/*
-	 * eager fpu is enabled if PKEY is supported and CR4 is switched
-	 * back on host, so it is safe to read guest PKRU from current
-	 * XSAVE.
-	 */
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
-		vcpu->arch.pkru = rdpkru();
-		if (vcpu->arch.pkru != vmx->host_pkru)
-			__write_pkru(vmx->host_pkru);
-	}
-
 	kvm_put_guest_xcr0(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d530521f11d..502a23313e7b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -821,11 +821,25 @@ void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 		vcpu->guest_xcr0_loaded = 1;
 	}
+
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
+	    vcpu->arch.pkru != vcpu->arch.host_pkru)
+		__write_pkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
 
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 {
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+		vcpu->arch.pkru = rdpkru();
+		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
+			__write_pkru(vcpu->arch.host_pkru);
+	}
+
 	if (vcpu->guest_xcr0_loaded) {
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
@@ -3437,6 +3451,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();

