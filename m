Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6E069F275
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 11:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjBVKGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 05:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjBVKGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 05:06:53 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C6B26CE5;
        Wed, 22 Feb 2023 02:06:50 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31M8s2IP007030;
        Wed, 22 Feb 2023 10:06:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ntpem3m8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 10:06:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV1+qC1MiDDr29wHrn1Otl+VLEST/qYM+GTVPyIVmwIawA24+zzwQhmUc58rFPSxn2u1nBhUcBXqoCVzTrZgO/ZUMCiNixkZ+MWhhPeRjaLBKhhhFDZHSZDxPmYN0u+XZLj14wAqcok9lZ8oP31KzL+PAYRoSrJRPvu2RgromKj2yzVZVH4OLG9JBYMmvD0jXSLFs7fq186//rrDGO9EJr1JOOPuIdDj26JInxBhLc2kVnbor8JmqvZZYBEiD2mWbWNe38MnNRXB6nbXd4ldJZxEXz0AOrskY+m+MGhZveLNLcasc1bKfjZrYtQ7TlkzG27f198QQLVYdNMaxx20Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZSNXVktUKAikwPv/svQ5Hluaa1S8AS66oqYtb63ppc=;
 b=GEjYZ6Fh9S4OT3bezU8xVgZuiob7CS414Qw0mFV1TUZgyRZeph0xQVBS+BZoFSAwjxjp5vC50b+Db8eYreCqizUoI6X6iM6ctX93yRdGzbJViHWNIvOnb0PPSsEvWxuboDHK5/+P3kder5xH0PdiwiH3FF8N+2pjhu9XfpQH9/a3J6xaMA22yRqyZoPN0KDHrHYMLGPJR+Lktn8QOzYXH987N/XRtoW3UFJU+XT3bz5vJNC2RiraevL8+2pTMo78ubgfk3Oi5Q/n30HSMy/HN1jSnNFLFhAWEZ2Fx31sCnEUx5UPYxPg38uKjZxNiGvG/v+iWOQKvweMdpU7RAC34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=eng.windriver.com; dkim=pass header.d=eng.windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 10:06:43 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::31f8:d3d4:2c0b:cec4%9]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 10:06:43 +0000
From:   Ovidiu Panait <ovidiu.panait@eng.windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 6.1/5.15/5.10/5.4 1/1] KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS
Date:   Wed, 22 Feb 2023 12:06:25 +0200
Message-Id: <20230222100625.1409958-1-ovidiu.panait@eng.windriver.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR07CA0135.eurprd07.prod.outlook.com
 (2603:10a6:802:16::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|IA1PR11MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: e88baef9-bd78-4465-a078-08db14bc7f75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oBhzYAv7JAzDRH9EBK9Do6oIQB9yRQTFp++70Eesw4MkCv+jblEpvrWHxL5fQLJPFty1a+7ohl/0wT9Hanw8RtLrikbQmdghS+qqFkQfVElHwnX0XvpmQloE1AAG+ls1Cb7XdYFTWgUFsGnbfnbkypTT7Tsd9bzFHJbzlzah5yUO20ody/8lfHw7fUSLJiptSbuBDuFi440KrQycLFrjh8JtXDux/NJ7nfxGaUCc5Hec9oHFG7MkofhAM060N/H97/m4I33KAj1R1w+byJCCSMveLNSxJJ6nyxJOanm7/ZEgSSiYSMwbTrNsIZvns/zsqD4MkVd27qNyEf2FIBxMUGbd3MAmpMcmeRvVH7bG1qTZU8UQ3OkWkW7lGZZSMfLU0N2z6olZ3vqeRH34eMj14+M8dQ0khuUGsIm9UTEazZBtuR6x2RXesM+BKBTsmTOGOhjb5vTM6zuRXKPohlElBZ2eaIi4Pz5ybY5bVDQ2uyR1BlqOpmP24VVcfayNx2jbhLQO0fFXZR734f6ykUddjKTTNCXOsHdMhE+bI4oRy1Ff7mvFGz9h+t0V2Ex5/P0oSqsf0RlctDRQAGTkSHpGcSPS+kUI1o7n/cS1MiZ3wqIQ3c61X4I3gK3gSzE4Br4sd6937mxkqpkKTMR0jCY2kB22jdCrlzFZ1Mdzcy5t+MvfjbrmauU4NjQBrLSyWT0/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39850400004)(396003)(136003)(376002)(346002)(451199018)(83170400001)(2616005)(54906003)(6512007)(316002)(6666004)(4326008)(966005)(186003)(107886003)(6506007)(6486002)(1076003)(38350700002)(44832011)(52116002)(41300700001)(38100700002)(66946007)(66556008)(66476007)(8676002)(5660300002)(6916009)(2906002)(8936002)(26005)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iEAphLNYr3fwo4tpYWHpoNV+pG7Lw36366w0q5FixyhZAXDRB4G+e/0NR6HR?=
 =?us-ascii?Q?B9veinKrOOnJ5rWGNDmkOfirO/LRJjzb4u5Z0KqsXUtkplTjKGeTOH4/oybP?=
 =?us-ascii?Q?17BSV8k4ahTfjfc+Jn4Gtzf/Af6vSZHNcFc+K9mJ3FmG/ExnHxFRqnkcLJsH?=
 =?us-ascii?Q?L7VmikqfAWfuj2fkutagllur8RKfPyBmKyp3PyqRAPB0Nui/EAwJi2zBaEDY?=
 =?us-ascii?Q?hPDyfQ6q6+1JVM+INAEEaWHj1Rp62R2lzET1neseo4bVPNmSSA82f8EQe9MB?=
 =?us-ascii?Q?Hd6iKqq7hw8W7oMqD6H64bX5TIZIifn38mxwo89rA4HJo9D5SLma+F6Gy9wP?=
 =?us-ascii?Q?Wx2YvVVOoeiIduktLPFNRA3PO+oj35qwDW9HEcH0DHBrtSI5+AhMmnR1dvRN?=
 =?us-ascii?Q?GmfkQU201919T/KBSj/XcoPHGqIJ2lEjZdTiPkr7FOdp/clUZVN3Rly1I7TX?=
 =?us-ascii?Q?LU6KTwhKuk+lfh15yoxFiRpoIKcRc9/cAjTYBBTsLTtZC4wa2lVmSj/NdqiV?=
 =?us-ascii?Q?iBXp1XAjslL4m9YeWZ+33OLyqlh8KERMpbYtKTSC6qT0ICdB+BqmfCaN6zpA?=
 =?us-ascii?Q?8x7dmjlRa2s20wzNdjOZuSexPx7eu+1R5H6enfeHOC0Y6d69+CKBtWnheF/C?=
 =?us-ascii?Q?bbotMCZnhUeBuyi+DOSogKiCvVT3ijjFUzfB3D395lx9SyYLwhUNiD0h4nWW?=
 =?us-ascii?Q?e/4japlne+fISZHBRxQNyKtYVzT9liEaGYXB+VCzaVQURAqT1vlhQB6nz2Ry?=
 =?us-ascii?Q?GMjQAQ1nTqoHTQO/xkUHR5NdYx/cgRvAUilIKhLHDkCxHY1qXvy10XAMnW2k?=
 =?us-ascii?Q?SCYWqxgj0Gjszdp8kI09QCdKLL+jeGRxdjoGK0DKGVEYfL4TLOEiLyq/WIi/?=
 =?us-ascii?Q?JlCohG1yBMorlONY1imFChhEW5fZkx7tPc88mdX04s0J6AYNHiHE0Ov2zmYk?=
 =?us-ascii?Q?4FBsY6ywWEhffMzHXeSBLfLwKMSel93lfsDvLiYX5uKrBFzuN8cs2DKMnxB1?=
 =?us-ascii?Q?YtVeZGvlrKHioe3RtYAug8cAnEa9Xxt4OrRHr3PWsRjzVj7DiE8WJlsUgV5P?=
 =?us-ascii?Q?h/4AGJUUylyh02PEi4Kv9M8rtDzuX9TEYQkfjU3t55obgXVpYyRxk+PcdvoD?=
 =?us-ascii?Q?G0ynSZGRV/f3MEc2ZnpqCgiPcGdqBncRCHbEOJuM3rF0Nvt9jxjUrIw4DscV?=
 =?us-ascii?Q?OEfaqW6QjkBBPkpRubwG7Vf8PhyfdbYoW2y3NOKu39rMfywguGscOPLz4GIH?=
 =?us-ascii?Q?LG98+WmSWBqlc5DAZbdApPeetdpOFP/IkbVAFW9h6jQNjnAZrozgf8LuGgUM?=
 =?us-ascii?Q?6NuLnvvWfPhLFCrd9WncpVvAzUiPNz/VHs/jjLIvMwXgZaXFjKy8+YdRlur0?=
 =?us-ascii?Q?1XPCnq5lIWakJl41evgfgDSkOdyG+Yr5hoRZY1Nv1sClfBIQs1Zc8QLlP4g3?=
 =?us-ascii?Q?hRO4raxvNDUR2zaNbdmyI8rFl74z03cRAj/OZTAsK+FoGuWRay6DSo/Srl6r?=
 =?us-ascii?Q?KRjD2e4w2mkhRJ4SBfffSGhxPBp2st7pAxYD4T4KndsLtQpjdB89BQon2oad?=
 =?us-ascii?Q?XEmt6bcDPqFDJwfz1AzsUqAmyd+GZFswU0vu03/Sgnen5JOiWijQrq830ONI?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: eng.windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e88baef9-bd78-4465-a078-08db14bc7f75
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 10:06:42.9753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BDGKQABpk/VUZZx+G+VZ+pNTxd0ygfZb4Kk3Jf0KNQ/O1/im1VWiEBJc30+QerMorGrTiqGnV/V6Dp7WrIQ/Jyrs1hfcpxih4cPhYA6FMdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-Proofpoint-ORIG-GUID: 6H2DIP71EFR5wa1nkiWNqxZ0ny6Fcx83
X-Proofpoint-GUID: 6H2DIP71EFR5wa1nkiWNqxZ0ny6Fcx83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_05,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=643
 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220087
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit 2e7eab81425ad6c875f2ed47c0ce01e78afc38a5 upstream.

According to Intel's document on Indirect Branch Restricted
Speculation, "Enabling IBRS does not prevent software from controlling
the predicted targets of indirect branches of unrelated software
executed later at the same predictor mode (for example, between two
different user applications, or two different virtual machines). Such
isolation can be ensured through use of the Indirect Branch Predictor
Barrier (IBPB) command." This applies to both basic and enhanced IBRS.

Since L1 and L2 VMs share hardware predictor modes (guest-user and
guest-kernel), hardware IBRS is not sufficient to virtualize
IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
hardware IBRS is actually sufficient in practice, even though it isn't
sufficient architecturally.)

For virtual CPUs that support IBRS, add an indirect branch prediction
barrier on emulated VM-exit, to ensure that the predicted targets of
indirect branches executed in L1 cannot be controlled by software that
was executed in L2.

Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
perform the IBPB at emulated VM-exit regardless of the current
IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
clear at emulated VM-exit.

This is CVE-2022-2196.

Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20221019213620.1953281-3-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c    |  6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cdebeceedbd0..f3c136548af6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4617,6 +4617,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
+	 * branch predictors when transitioning from L2 to L1, as L1 expects
+	 * hardware (KVM in this case) to provide separate predictor modes.
+	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
+	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
+	 * separate modes for L2 vs L1.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0718658268fe..c849173b60c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1332,8 +1332,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		/*
 		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * the active VMCS within a vCPU, unless IBRS is advertised to
+		 * the vCPU.  To minimize the number of IBPBs executed, KVM
+		 * performs IBPB on nested VM-Exit (a single nested transition
+		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
-- 
2.39.1

