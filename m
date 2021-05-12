Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC3237C70F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhELP6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:03 -0400
Received: from mail-dm3nam07on2078.outbound.protection.outlook.com ([40.107.95.78]:6112
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234835AbhELPwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:52:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWR/Pln6ANpwCnIecN2okJSpR11CqgYZcou/PbBSpbDPx7cDkJbekmxBDIPW/yS/Q90aJjqURKi1RL5uVR2skWsHzC9t5IhqQyZu+TiZKdewl/qQq482SpFK5s+elrOeRRaiQgAI/+I+fWbJyyy7HoFmGfyB3/6Fvq1FdLzI6Rg39DIXBQxdkNpplxU0i0ZdwL7HbzC5sOnSIQqWMkSTcyJcN56ouRIqy2PxJftWTQ8T1IE845fi87iK2I83tO/1hYOcHmSbE+ZG0CoXFHplV5iYep9jZHNfenMi1+pm1bXAYAoSjaRQoHReqxZi3SHOXfL88BR4vP+z03pyuir3mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG42O63txZfLjZKMzgtf8+WdtnayJK9FMB5iYylntD4=;
 b=ZYE4zPAy4b4OsiuI7nzjJyt+XyTtEwe/rKc9EKEU6VQhEv/VLHL/gLJsuPW/x9RTjXJfgeyq9FN6NvXXTjRkgU326ERROxokuotLZjPMQf24ktxZwSYWDV4WhDzGUqtdjvYvqjCmDDEm8IrGzfcvBGVgpZHpdtJQ7VwUKjNdUS5UTDS7c4JSFv9faxvFNf7Ou2XEE+XZ0LjNHSUKg5Dhycd4cf66FBecc6FswGkYQPpC+0YGhlsJl6dHrJKXlItrYjtO5tZlWKFZ//l/un6H4NpqA5h/fCQnJRE/0XuudJykt9eoiUhdChlRGS4Ukt5JH5shsyTwZoHW4npEtAgDUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG42O63txZfLjZKMzgtf8+WdtnayJK9FMB5iYylntD4=;
 b=sKGJGP5ZL61/UxeJFPdf+hX0Zouaun5aMBHeOUw1WkwU6OnK4ehsk3M2flIGqO4Frm3RcykS1lOPHbLGTqzLU1M6ZSy2WtyKOMJuGu1JhOMmXHN51ysSwCfsu1TKcBNBpHJt4bbDlEDRXJ9IBBDkn7AXD/C8ody2k2b1byeD410=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4603.namprd12.prod.outlook.com (2603:10b6:5:166::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Wed, 12 May 2021 15:51:32 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.025; Wed, 12 May
 2021 15:51:31 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     stable@vger.kernel.org
Subject: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
Date:   Wed, 12 May 2021 10:51:19 -0500
Message-Id: <34360e0da35a02fe7bb468b2eef3696baaf95723.1620834679.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0012.namprd06.prod.outlook.com
 (2603:10b6:803:2f::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0601CA0012.namprd06.prod.outlook.com (2603:10b6:803:2f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 15:51:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b18be9f-f0f5-4e87-4e0e-08d9155dd00e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4603:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4603315BBA2D346AC410EEBFEC529@DM6PR12MB4603.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDhEUsQyYKMkEaB7BluZqM5P8BHd8vt36p8moUcWxYpMqlspJEtdKdFo417KlD14h/r1os47L4rDFmf8qPzkCK8nlU2lC1Dwbh3dQ1ctfGsVAYz8P3JBjL7+N4cfbWMx7tNcVJgirV8U8aKPNOxaLuZWjzMAZhYgLjPjcOVHKEVM0/BCTOISu4afDD6L8YvZNXUISpWa/LdKVi8YcVViYrl1huFwKjlS8RLJ5BtbOH//QnG2Li3Nmcft6mVnzsobFjC3dJWbB9XIdHJEVQjkm9yStKBf5CF2JCH+wtLBOMEzj+xjp6kAP4xMKMvS+o/+6P8DP797EuslMffABeyResadXEbP3xbh7HiCENUnsMD/4q2YEl7fRHalwipRkdCeDjKMDqvPZD0Hk1rUnG8foWHpvjGN8hInPq7g+Le7zC9bCqVlW1PAr8XJtr3vYIiOfBthL/P+oN0Ys6DJ2bhP8zbDKA9In+JSmRJLRk5B8RRN1RXjnaul0dUKHuvL8fpJwUp+MTh9pgzLfnXwo2133MxxfCK3Fd5nbYx7sVzflXxt9U3EhXzGU2+wNmbd/PjTSDayV9G07XvnUFgEQ9J0cP9BMYzUxxsqXGstKcffAymYsZ3Axqg5zrEC7lNlgWYdkjfot749q0CE8UAk6Gzq7xPtQi8O7S+LTCBhf1uoDEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(6486002)(6916009)(8676002)(316002)(16526019)(478600001)(956004)(2906002)(186003)(52116002)(5660300002)(8936002)(26005)(2616005)(86362001)(38100700002)(38350700002)(36756003)(66556008)(6666004)(66476007)(66946007)(83380400001)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aEBOED7gpxUV0JNe8KYtpnAyBdO8JLltJikL+/z48zpzlsFnwjHZU1GogLeu?=
 =?us-ascii?Q?9Cg2o3Wcsb62v48Go9KzTlZg4bG+rYTPKcQIHGelhHkHANGdr7G+tRfCPO27?=
 =?us-ascii?Q?JQK+XkRAWYItT9kvNVV0ZHsedJmZSM7pvRL3xHhegZp0hz110NngiX403p99?=
 =?us-ascii?Q?66G/qBlEtg6jIJmispYrdRR9MpoTHo8CSSlmVr/+fj+PBTdttLcmcRbQSEhz?=
 =?us-ascii?Q?mUTYZzQeIuNbsw4VRv/nAw2z7Cu23t/56SwX7UfAX+NulbapUZPdIDlZxyY9?=
 =?us-ascii?Q?/z8znY4qINtFrGxy8BPyRzCiHBE6OpAUMM/oPHuxNbHPVx68jGniwbzM/DfY?=
 =?us-ascii?Q?W/5dD6o2L5NSxZoQx4zLCcPLTocj/aPdlsUUrnUWEyZnGcbRoK9FVaSPcBMO?=
 =?us-ascii?Q?M3jmJ4CzEAH6i8M316dgEts0INGuAdggZ49x+W8Ml1pSIgFBYmrZNLjDXmaW?=
 =?us-ascii?Q?qjLLQ7Dc+SWDKzZjMDURpUew7700yH7bNleR7VTL2o5Icc5LRwLMjfklJPjY?=
 =?us-ascii?Q?9N1sLHWg6r7T7gKpgqAT930cKTx++0xEJ+2J4WeEHQ1njCFgRfOEdg6/uJIA?=
 =?us-ascii?Q?s1tVds6uZzX1r3BFstvQLDPJM2rAwYVM5aiV8a2qGlUQMh+rTwbtVCKPlRdm?=
 =?us-ascii?Q?GqUncxdgziu+0jbKAj+GIUCbV3ndHYF8uGJDN6qcDGtWa3ZI842twFTFJCT0?=
 =?us-ascii?Q?iIkpIU7KK40HSTaO+6/AZjjv53ib3B6xzLD+Qw/Pe3OlhcY9xt7TDzC7JC03?=
 =?us-ascii?Q?DYmM9ysO8+MsuTAxVDmLrdRGtG2PLrKvlep1zHClp4Z1Ul8TjPDquKByghcq?=
 =?us-ascii?Q?4u+bE6t2nMxlvcaImDduLspWhwp9mfXbUxE1dBIBNAYmwrjXEbg8L9dSZfn6?=
 =?us-ascii?Q?bihOLUiyuwcG2KJiRFMXqswS1GCr5iGt9XzQslxZmaSleusCq/my8fjTfjok?=
 =?us-ascii?Q?LI3tbyGEzx1YhdU9+HZly+WrOrzGJYe8W/0+ZuWtcYo9339PrAxOa1xGB/pr?=
 =?us-ascii?Q?B9PEQH51UroJoNljekPNBVvm5W7CQ0K6hZZtcQi88mREhh5w5jAfZcEtxnCE?=
 =?us-ascii?Q?c8FBzAd6Es2C7p2nQ+9q77/JY8rb3AMlKXtFwuOMaFI7mxwNR5kNRFkZ/p+F?=
 =?us-ascii?Q?T/B0p/AdgD4+4/tz/YqHnrM2qIlXH/v37JYZwU/NM7qbZoIxdjmrHEsKJPyP?=
 =?us-ascii?Q?RLlgh+2mO8Bc8GSwoEQhGPfoIrLi4JbxMJBRFSuRnfs2mNbU2lMwOdMwRY2F?=
 =?us-ascii?Q?u3oLbBhwgINJwlslSrQGYxlW+AIKY7CYnywqp4behcDMy8P3ySpvE+Kq7cgv?=
 =?us-ascii?Q?7JrSBnfFlbXabaJJjF848xkT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b18be9f-f0f5-4e87-4e0e-08d9155dd00e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 15:51:31.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mz8nuUvHEPotHthUXodAnw1J/nYGO7rTl+tAe3W3+Z4dWKfiqeVEJ/AplFzUbuH6ygNXHRa0kRQFWvh6stV9QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4603
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a3ba26ecfb569f4aa3f867e80c02aa65f20aadad upstream.

Access to the GHCB is mainly in the VMGEXIT path and it is known that the
GHCB will be mapped. But there are two paths where it is possible the GHCB
might not be mapped.

The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
However, if a SIPI is performed without a corresponding AP Reset Hold,
then the GHCB might not be mapped (depending on the previous VMEXIT),
which will result in a NULL pointer dereference.

The svm_complete_emulated_msr() routine will update the GHCB to inform
the caller of a RDMSR/WRMSR operation about any errors. While it is likely
that the GHCB will be mapped in this situation, add a safe guard
in this path to be certain a NULL pointer dereference is not encountered.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Message-Id: <a5d3ebb600a91170fc88599d5a575452b3e31036.1617979121.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 arch/x86/kvm/svm/svm.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 874ea309279f..d6cf74d3b3b2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2104,5 +2104,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
+	if (!svm->ghcb)
+		return;
+
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..2b6e7874c491 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2809,7 +2809,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!sev_es_guest(svm->vcpu.kvm) || !err)
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
 		return kvm_complete_insn_gp(&svm->vcpu, err);
 
 	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
-- 
2.31.0

