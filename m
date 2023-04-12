Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDDD6DECD3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 09:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjDLHpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 03:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDLHpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 03:45:06 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8721705
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 00:45:04 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33C4pF0m027675;
        Wed, 12 Apr 2023 07:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=5KzVSevEHb7T3O02qIKd4UOIyzWEx/ZQa/T0DvvJm94=;
 b=Jyp/iwfQpHS3Bdj0wRc7pk5/XactxwnnYadfrWodZZzSKLUpV82N/Q8/gqNoa5HUIVou
 bZz4FtcWuJsjePVm/fPZYTury98NDcoL82RsDmVE2xdhd9JYywLsS3GqnDQ4nHZeNbSc
 Ms42TT3qb0ogFKJcz4RiclwQQuqpAPScs7xt6/s4h4dkCovoy6kRNjTQWBGECUq1Yxe9
 S2EGbAiXKbj+1CxCY/nNNQVB2J31bGxWYJvnO7W9dR93kc87x/efaHnODlDFoVKOISVJ
 mC0IK4H5lEpijWm+D7nhyc7/fVgCbfKkEbXS2my2HpDymExAV2UVhJda3aHLCCGWvQHn EQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3pty8b43fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Apr 2023 07:44:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esU3RtSIu+VRCF4XXzNgn2tpO4Whq99Yp3rMNlM/NjKfot7qE2E3S+lAlGRboWkx863v2Me9PP1ln2rdNKg2TbEhLTayasqe4CZ47m951CxTbot5k6XbYYbWVTZj4UwdlNhheWQAxrPkwtc0EuTKmAd8rWOCTPOxTTRxbFZsBML/KRYj1eg9Lx/fsIB/hwJjklar7aYh/syBwrV1jz8iiI1wkVgwz2ZvNZp9Nb2Lbt45jvUTZeHeGRWOpw0TQ3OrlfYBg3bYsc4a2UxbmeKGuL9P9oeJlFnqZvTauowfWT6ydU1WORXIsL/PKa+k83mb7S5YsMn2dviAF0gVPHJgTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KzVSevEHb7T3O02qIKd4UOIyzWEx/ZQa/T0DvvJm94=;
 b=OlNptScDgYxx1wlk6MW1eXXWP3L1QbhHuBcvZLSdYoFo8Dij9JFndc61MGYYwDRQPFNwznOWRvKJ03Gqd6KubkC6LWxGB81qP+/PlgaK72WZ5g03G4SdZI5Wsp/Q0NNYkKLik7l/c2EaSwCE4wEAzGmegfFk+CWHCBrz0kk2KW6TSTpXGh9LACK22wa8yi4Ed8v5mWyZVkkVaQhnfpDK+xw6CQg8GxiFSjvxO+WWqJMl3XczoGRjoKSt7DuYxPUm2rwp/Z+7MLu63Yp1L29I3VBky7D/xRO+dsmZuPnZ4wuI0JO1zedT0wRuMrhD1wAEP00kyaG/aKACgdI/8veO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SJ0PR11MB4941.namprd11.prod.outlook.com (2603:10b6:a03:2d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Wed, 12 Apr
 2023 07:44:54 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::60b2:e8cd:1927:54f3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::60b2:e8cd:1927:54f3%9]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 07:44:54 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/1] KVM: nVMX: add missing consistency checks for CR0 and CR4
Date:   Wed, 12 Apr 2023 10:44:35 +0300
Message-Id: <20230412074435.2093208-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0064.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SJ0PR11MB4941:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c54ea3b-a59f-4b8c-e6c9-08db3b29cdec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utruGb2ogZCVfwEfcvZzyVE3KIADANRgJqiCy/S1YjsdArvHiIsZ60E3tTTDnEfKax+7C8XpTcWAIOr7I7pujiG66BCBmaFiGuEP/g7xDH82/mKf7TKflACLPin4QPkX+ySk+1e1e9T2yZEwwLtuM+VoS6sNp+jmu5KJhCdqOk6m5TXWVVqXNaKgwaCH/LOYxm41EjJoT/o2lPPcfG1Y1XkBMbJv3kkXixcAcQ7bkKpvNrzF8IyVgpI/M3/TAcYrQE5i8//fBlajbWjoDkK1jNwC3ryKiSYHUsgUnGX5FTq2wxWMdZRuV1JycoHUfijt12oHSFr2oR8sTrlWO8b3W7FSfyeoEgwzzQ83iPHcLkdIpUPY5H5JL3PX3toPP0SSOeVMYdWIA/VugW/2UNoGrC7YKlci/DSXDGoQbmXw/eioHZY6/pqbB4EX66B5eHo9NyyMW0GrHHL731GYtXrlgbp6nVHriY85hkYxitiL5CmzTe7dpfRnfvE+3oewT2mFWq0f6R8thPe1aZoIPxrM12MpP2Jp+8AVKyCv8ztko0Br0qpZT+UU3lqC8VQ+vtj8lZYVYeGOsI9891WWcEfnxPwUwfLeFURHhNX5ekwzzntCU28YlXiMscsSazeZWIJk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(451199021)(66476007)(36756003)(38100700002)(38350700002)(44832011)(2906002)(5660300002)(8676002)(8936002)(86362001)(4326008)(41300700001)(66556008)(66946007)(2616005)(6916009)(83380400001)(316002)(1076003)(26005)(54906003)(6506007)(52116002)(6486002)(107886003)(6512007)(6666004)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZrGLAAs1NmCbGWFI+PDnJwRCnrV6Fr6z8C+p6F6LWVLgZIxmRj77u54cYcaG?=
 =?us-ascii?Q?XJj5UIkyRU2IRTMnlt8cJ9lGOsK4eXhQACNYGPcxmBMV/AtDmFn5QCSQDQ8j?=
 =?us-ascii?Q?Zp7C3owat1EHT1UgZSdwf4EIbbqJ9Px9B8OASGls9r6GEVr+bb95Gnz8YJzs?=
 =?us-ascii?Q?87I9tv3r2WVAXB2SwTz6W5mAxYWQfONCP2SK6mll1XBLPP0IhE6aV753CswL?=
 =?us-ascii?Q?cNZ4ODvkniHa7XgsNA2fGMQZ6T82ONPNMGItN8O1Ddaq/6/ZyMtY7CiBKaCH?=
 =?us-ascii?Q?SEQCjEVb6GOJkRHZ432irQnp+sd8R72UM1nKRYb08dxnYaFSFuVy0xYVODHS?=
 =?us-ascii?Q?QwwF4W/be8OS4ZCgZJR7xDapzMeFHvIkVCBaLmxj9Vx+OI84WoRx1ScbS5dM?=
 =?us-ascii?Q?KfOgvRt3dQYMvVNrkHOV2QyaBy4Wnb4wq16xynkU24qZWBUsgzIiM2gqsu3d?=
 =?us-ascii?Q?2u06KdCf5drBLwzs5HSKkwnnmyrFAauszJ8luPN2Z8hfJRY2S6w3CvscJ8D8?=
 =?us-ascii?Q?ng5GSskAxFkxRHBOq564N6s7OxdLvGswr31xWI99gLs5hmcUPGO6JEeDcwNG?=
 =?us-ascii?Q?SsEQSEB6AkRdLAXUpj/nTCbgA7utQn1GpWw2IGpLd0qU/YE7ZSFtRXrWDivu?=
 =?us-ascii?Q?L9+VuvRBERA46vq1FiKXRX9fmZZCG7mi//hgmx70k8r4r+el2fNfN4lqrReX?=
 =?us-ascii?Q?7PZO76sLGVSZcPtFm/i3zrzYuyRD4XVgu6lL+Gq7IeqFvYqE0G6gIcJpFGRU?=
 =?us-ascii?Q?DF+DG6f2+ydxliY0w2mn/RMairPrv0pU5uUhJ7z8iMHNMfUFgs9KT48TzgYJ?=
 =?us-ascii?Q?hj8tjlIt5ArjeFedOv2WYg4m6d63WxHteXIcW1fGO9M+DUeel5RoPXV/LncV?=
 =?us-ascii?Q?DnW58egoCvVEmhKSuBTkq2/IzBN55Xcv3lUJenj8d8t+e/hnDSEubZBZ5BKn?=
 =?us-ascii?Q?4NZrEjU5tm0m4ZrPqRMgQ0ZOzTUu+ECnV6EMaLchSeTutCFeHOMv/6lbhJsw?=
 =?us-ascii?Q?CVr+th8omC1YYdRZP+NOKbaLTWkbw1YT5pTJaPwVATejFCRl3+Igo7HGo4vR?=
 =?us-ascii?Q?/GN34czYEWmsxBtRcMYBSoszoVXZntEm6fvJLDafoMXbwv1pcqv4xpAY1mNr?=
 =?us-ascii?Q?NeAQ6QIYiTAaMnuupoMRxN6ZK6FMkeb0ApeFAM0FPDeVMfAs7tNT/YrvAV3G?=
 =?us-ascii?Q?TyjfjKWDT1ZcrT9U1Vw9xBKCdK84pdnYflLGMLMJlzOtWs2nZNsuacRZ6mZS?=
 =?us-ascii?Q?yhzDhbnB7mrc+vuBWX3bN0krnShFEmZBI4IixUjrbkPuvE20l5Eq7taTVS3p?=
 =?us-ascii?Q?5M97y8PyS97IE7rtfomuabUuYFi/iuC0FmKUpYMZ6EHpRHI8egLHAJYZjvo8?=
 =?us-ascii?Q?4vhVH/fqicnxbgDgIkiMTigc7GWzz71WGMja2v7+VlbTb6bGf9PcydcdRpRc?=
 =?us-ascii?Q?RJagUJf/kOhWmsz9BVJLVkO9FFZcyiFwSp8Fr2kYdzSe67m2ZaJuIYNYvmVt?=
 =?us-ascii?Q?5356o6Rk8XaBmkMSe0B5jbD89OJamdJ20FJfc+utLvTyCxWLsIbq1DategL8?=
 =?us-ascii?Q?bToFYkX0fhTdCt4xNgbJ4ikQqt8ZPGWZ97Myc9tkZI7AJChk0IUwGEFK3/Ng?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c54ea3b-a59f-4b8c-e6c9-08db3b29cdec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 07:44:54.2572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BfQSGaKTpoAQyPms0yNjfKUcvkSDw4m0r8PGzgEEuFl8q1M9KtWEL9taOWAO3b1lZGaaNQvpPtjz9HBOGVWQzEiE9otmLkxMa3zLvF8ZcHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4941
X-Proofpoint-ORIG-GUID: E-5hWVgl6CdgU9Dzcor_qggOLZFxCDuH
X-Proofpoint-GUID: E-5hWVgl6CdgU9Dzcor_qggOLZFxCDuH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_02,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 mlxlogscore=734
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 112e66017bff7f2837030f34c2bc19501e9212d5 upstream.

The effective values of the guest CR0 and CR4 registers may differ from
those included in the VMCS12.  In particular, disabling EPT forces
CR4.PAE=1 and disabling unrestricted guest mode forces CR0.PG=CR0.PE=1.

Therefore, checks on these bits cannot be delegated to the processor
and must be performed by KVM.

Reported-by: Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: drop CC() macro calls, as tracing is not implemented in 4.19]
[OP: adjust "return -EINVAL" -> "return 1" to match current return logic]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ec821a5d131a..265e70b0eb79 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -12752,7 +12752,7 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 static int check_vmentry_postreqs(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 				  u32 *exit_qual)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*exit_qual = ENTRY_FAIL_DEFAULT;
 
@@ -12765,6 +12765,13 @@ static int check_vmentry_postreqs(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		return 1;
 	}
 
+	if ((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG)
+		return 1;
+
+	if ((ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
+	    (ia32e && !(vmcs12->guest_cr0 & X86_CR0_PG)))
+		return 1;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -12776,7 +12783,6 @@ static int check_vmentry_postreqs(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer) ||
 		    ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA) ||
 		    ((vmcs12->guest_cr0 & X86_CR0_PG) &&
-- 
2.39.1

