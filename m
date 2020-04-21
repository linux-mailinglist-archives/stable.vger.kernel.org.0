Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832ED1B1C1F
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 04:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgDUCqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 22:46:51 -0400
Received: from mail-bn8nam12on2127.outbound.protection.outlook.com ([40.107.237.127]:34656
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbgDUCqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 22:46:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abeYJGsM+utPKI8iw0GDe3r5ahdpkuz1alUMRNzN93J1xteEt8XppZejVhIQBCBqJR13rbfgJkTzctPb385WtOfwB5ligCkLDk1nm1Ckb39dpyrG9/uJqxFJbZFFSi7qJ9+fm8qQ5jWzYRuVo1Lpe+o+uAEWdX6H0fJ8+b6qIEI/HyKFL/n2EMLKrnGkJ6QUlpRYfz0PW322V9PFRcyM17nLs+ZmAtgJN4bdGZtJ+t9klRSKVlJfddiX5JN+dUO84Rsu69E77QjTQweozJms3dtTlzZigzkWCqPdpUdo7Wzcby6mDfIuKsHyWwNY/Z7695zKZ8EJIJ+ne9iz4WCu9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqNXyOpGEAJCjgz58vujO/U76dzfvDo+qXGHOISkhzQ=;
 b=b8qUyDVLBZxuL187dLtebxV6GtoLvkuDpIILbDdroka7QbFEor0dJaikgJQ4I6HqBVKLIQo8o4TapI7Fe2cvII9UoparvaA9v7G+UoQGMZox2oXnqDf8ktrMLJKDJyFvw1Sfb1xxLOJNwFDnZoWqizgMjIdbM27bivODo7j+ys+o0FB73uP6srC+7GJD898OhJJc2zf84lfYQVsj7We6byWN4BAim9wKRGOE/sG79c/xGKUw+khYXKlrEzIFvRUNM9e3ugWPSwJEPH5yokxraGMEPSmhnBhf0EmWsLpkWzQUlwZbj52nBxohwMPtRrlozH9BzAnK/8PQUTa8MDc+0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqNXyOpGEAJCjgz58vujO/U76dzfvDo+qXGHOISkhzQ=;
 b=GEXiuNt3L8pbozyiia8ZKIW7ugZCZrh2Vf0NQgPMOuTKow4gMeINXz1xu4uoQRkcc14V4TogVgzwdE5loj3Dry4G6qD1S0Syg15QAO4iycc0aOlOjtRCoh/2cS3LelDWKL5qCHBFTH/nijgBme5otpwM//7kSaDArBjRQUOcxRc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN6PR21MB0161.namprd21.prod.outlook.com (2603:10b6:404:94::7)
 by BN6PR21MB0785.namprd21.prod.outlook.com (2603:10b6:404:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Tue, 21 Apr
 2020 02:46:47 +0000
Received: from BN6PR21MB0161.namprd21.prod.outlook.com
 ([fe80::171:e82f:b9f2:3a68]) by BN6PR21MB0161.namprd21.prod.outlook.com
 ([fe80::171:e82f:b9f2:3a68%13]) with mapi id 15.20.2958.001; Tue, 21 Apr 2020
 02:46:47 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bp@alien8.de, haiyangz@microsoft.com, hpa@zytor.com,
        kys@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        sthemmin@microsoft.com, tglx@linutronix.de, x86@kernel.org,
        mikelley@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH v2] x86/hyperv: Suspend/resume the VP assist page for hibernation
Date:   Mon, 20 Apr 2020 19:46:11 -0700
Message-Id: <1587437171-2472-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:104:6::13) To BN6PR21MB0161.namprd21.prod.outlook.com
 (2603:10b6:404:94::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0087.namprd04.prod.outlook.com (2603:10b6:104:6::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Tue, 21 Apr 2020 02:46:45 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7eb1d09d-2ea3-4fc6-f709-08d7e59e3bb3
X-MS-TrafficTypeDiagnostic: BN6PR21MB0785:|BN6PR21MB0785:|BN6PR21MB0785:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB07853E10DBE631B1CD218455BFD50@BN6PR21MB0785.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0161.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(2616005)(82960400001)(66476007)(7416002)(6506007)(6512007)(52116002)(5660300002)(66556008)(316002)(4326008)(6486002)(956004)(26005)(36756003)(66946007)(2906002)(82950400001)(16526019)(86362001)(10290500003)(186003)(478600001)(6666004)(8936002)(15650500001)(8676002)(3450700001)(81156014)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wVhpPWhbd1LYFJ11aMC2DxakP9BDVL4D6QkbxHIaNTI5ZOc9yP3OaCORw2zhZyX4B4lnFBHw5MOFAESFI9Xy2NpdbH82xBFauwD1cXSWhEJgggVfJYRTRdPUBGb4cUnZRgXpD0liG7+6ubHtPxefDpZ/WxqNrjuWgCdeNT9x0RQAOfGm5QXAR61bD59z1CMVJuFt5Jqd0RUf0JUuRBjtxa3PTT+CYk+J7fuFrN5QT+kEPX8jq1w0B3tc97E5uAwhLPcSVeRyVr/U/ultnRPw9+PHGObGW5qr2m26LzHxjbuGXPq+BOCl5oKXV1Ct7onbZfGD/zsSrIOoi9zMonphgTIEdWgzV+lRKgj6wxQaWqwXcHMwiXTMZ3jYniqA5EVLenF0G3glHkMMMGjkKOwgldoKyKy3SYMBawk/yKJKswMHEfBGGHhSGLRnDbI8Gk2Ys2M6CmECPudWe+TJjc/vgZB5VnDmV4fsSs8OUY+Jhuo=
X-MS-Exchange-AntiSpam-MessageData: 4YX/qa2OCGITgN6yDM9jbgTxpnya/E8C2fRCHBtJw+rLNxuKzw775oX1OOKpOXtiNgDjlQjvYmeB5owW5rjuct8Pn3ECcQVad6Jb3CVRfLuFWOxxHuG8AinSR22T2MKKA3u3iPXZ9I59L1M9TFp3zgnh3TQMUrgmwTi8dDVN2S7akUKUQJdwwySEn3AuyaYZe+xFcIsH7gC4Xgw+NqOUWtWuiOc0xC5VYsIWwj8Ipo6wpCsWRFlQALE+U5bCaGNA9OdbUad3Lu+zDrNovKUQH63xNOaC6HLR83f1QiYPgPxx24Ux+kj2gZtHfVdn9Vj61JliUjFqwjB/4GziD4ba2gUCi9I0ZoDoeCsfvtbwMFpmiBjZU0pLXUSPWZt1AkoIvVdvFzne4HRM3wbPQJZKphNc9JuDuMhZlARH3Ve/Y0akaOUE9XxnBISbLckOz7Ue6HrEjsvI8bzIxMBUCovz2uA+f3E/9PIP6kxZAbfNGYxP0Ri+ZjUydRID845ur9x7BC4hj4VvzUaKpro0NV8irYHCPEotrqNVju7Y30tPUsKYP8jW+q44HXaxrw6+aFvD6k9GAlGxqKXbknFHsvVsi60ZOcRBl48DjwFNFvyo8IaClGPHJ1wNTrE4u+oSq3Pn2qqZNgqou02SoUwD3mloMJcWLTaELQZ7Ee7IxEjCTDHk/nZqJYhE+sbjZC2QUqaJAarIM7AksJoS/b/oQtj0/AiGFVPhhG7FlSU7Ai7k+0AgBwzRZtIUvft46sUmzTZ0lbp64hH5fCtDhjjuLlRRVg5oYtDpU5XBpj+yECEQ7Lo=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb1d09d-2ea3-4fc6-f709-08d7e59e3bb3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 02:46:47.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbDVGi9ThEtL5AQpe5zy7FocISfUTx/e+Sd53c8Pk0Xk+anlvO0UFixU4rRQmYHPZ5DuU7Bre6UUqAw8kUe7sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0785
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unlike the other CPUs, CPU0 is never offlined during hibernation, so in the
resume path, the "new" kernel's VP assist page is not suspended (i.e. not
disabled), and later when we jump to the "old" kernel, the page is not
properly re-enabled for CPU0 with the allocated page from the old kernel.

So far, the VP assist page is used by hv_apic_eoi_write(), and is also
used in the case of nested virtualization (running KVM atop Hyper-V).

For hv_apic_eoi_write(), when the page is not properly re-enabled,
hvp->apic_assist is always 0, so the HV_X64_MSR_EOI MSR is always written.
This is not ideal with respect to performance, but Hyper-V can still
correctly handle this according to the Hyper-V spec; nevertheless, Linux
still must update the Hyper-V hypervisor with the correct VP assist page
to prevent Hyper-V from writing to the stale page, which causes guest
memory corruption and consequently may have caused the hangs and triple
faults seen during non-boot CPUs resume.

Fix the issue by calling hv_cpu_die()/hv_cpu_init() in the syscore ops.
Without the fix, hibernation can fail at a rate of 1/300 ~ 1/500.
With the fix, hibernation can pass a long-haul test of 2000 runs.

In the case of nested virtualization, disabling/reenabling the assist
page upon hibernation may be unsafe if there are active L2 guests.
It looks KVM should be enhanced to abort the hibernation request if
there is any active L2 guest.

Fixes: 05bd330a7fd8 ("x86/hyperv: Suspend/resume the hypercall page for hibernation")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2:
    Used alloc_page(irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL) [Wei Liu]

    Improved the changelog per comments from Wei Liu and Vitaly Kuznetsov.

 arch/x86/hyperv/hv_init.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b0da5320bcff..a151ec7feb4b 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -72,7 +72,8 @@ static int hv_cpu_init(unsigned int cpu)
 	struct page *pg;
 
 	input_arg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
-	pg = alloc_page(GFP_KERNEL);
+	/* hv_cpu_init() can be called with IRQs disabled from hv_resume() */
+	pg = alloc_page(irqs_disabled() ? GFP_ATOMIC : GFP_KERNEL);
 	if (unlikely(!pg))
 		return -ENOMEM;
 	*input_arg = page_address(pg);
@@ -253,6 +254,7 @@ static int __init hv_pci_init(void)
 static int hv_suspend(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
+	int ret;
 
 	/*
 	 * Reset the hypercall page as it is going to be invalidated
@@ -269,12 +271,17 @@ static int hv_suspend(void)
 	hypercall_msr.enable = 0;
 	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
-	return 0;
+	ret = hv_cpu_die(0);
+	return ret;
 }
 
 static void hv_resume(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
+	int ret;
+
+	ret = hv_cpu_init(0);
+	WARN_ON(ret);
 
 	/* Re-enable the hypercall page */
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
@@ -287,6 +294,7 @@ static void hv_resume(void)
 	hv_hypercall_pg_saved = NULL;
 }
 
+/* Note: when the ops are called, only CPU0 is online and IRQs are disabled. */
 static struct syscore_ops hv_syscore_ops = {
 	.suspend	= hv_suspend,
 	.resume		= hv_resume,
-- 
2.19.1

