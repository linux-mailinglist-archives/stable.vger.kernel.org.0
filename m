Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99821394139
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbhE1KlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:01 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:5792 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236637AbhE1Kkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:46 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcxOE010290;
        Fri, 28 May 2021 03:38:59 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icEKcumjfCf1csgKFhUdNjHujZ4FH1T+RJNaRBVsCLh+FV3txMpORr3zffCJU1dET62PIdLUeIPbRUxicr09eWrk0EF7m8vFxg9PrkBJMMrgzZkTCqprxixPOUR+aupgL86PBPE8XB1bpgMOKOMrgVIVtlHKWz4no7fAJTQEnvFr05ZQp66/Tm47ge9rQoAUWxjZQVJL4XHD887GhMR5BCYZNMjBL1ejunJMcXd42Rs0KvUAGQoaHYNAfOlPlLIzAxJA8/UILuRFkzn31n01L9nhpmyyv7wjWWFKhQNKFu3AOmlshjAv0tyX2Vt3bpqotFrph7fh6cpYnrZu+kxhVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xj1cjDvUrZa/thEZhLUbBuFV19Ok4kqY40AoXsE+k0s=;
 b=nqFRfqDpHpDOP0MEQi+kzo3GpQeqzgfu4kNd0BpmPCyjY6zQ0mPlPbqcJJJd3hsXz3EGl+1JaXyuJC80R+7aWM1fLTTRdAufKIi/K3MfuJhnltoxYMd7VJxxgITVKDFoe8Jd5U6dCiL3FFHikYQ9yDOy8graXET9LOcmWro/K3h+7qmtPJJfmhADaA6EkH3Hy44cWeIX7zUWooauIvwJH5zIpZMbySJUNPZc4+QrNB5RrXrfEccfaaYpfF4Yeh14kSWSrJF03yUclL+R4ir5ivim2kgGs0if4ki8xSd+VK6YGcmTn1GpJMHHgtI4UhWLcbSveM3zjceF7nAjwRsr5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xj1cjDvUrZa/thEZhLUbBuFV19Ok4kqY40AoXsE+k0s=;
 b=TB9ra72AaJqW1D9J3b68w+O0KL/c6zJl0fjw6k3j8jV5uOppBncfVIwrYrwcJw1Kske8Y2x+aazheBK6pkz4OWG0W7UxiEU+OORsHEH6u/U+KwoxKbjnt2Jv1HXy6L2TJLajdvL/sT7QdTRyU+upfquhy9pe8amuz0OitFOnJO8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:57 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 16/19] bpf: Fix leakage of uninitialized bpf stack under speculation
Date:   Fri, 28 May 2021 13:38:07 +0300
Message-Id: <20210528103810.22025-17-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210528103810.22025-1-ovidiu.panait@windriver.com>
References: <20210528103810.22025-1-ovidiu.panait@windriver.com>
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1PR0102CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::24) To BN6PR11MB1956.namprd11.prod.outlook.com
 (2603:10b6:404:104::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3482585-1184-4f32-fbb9-08d921c4cc03
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB3780F9944E6BE3B2B3684B41FE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvXVpHzSRtqIJ4ZVidMjn+BJ9L9my+rLT+DIdS9WTtEzAzmZhSVtT0IFSDZuxdTXbsnfpiB2BqsM4Ws76TJ7zxcx9pYrX9hx+qpuRpAJIUZJ7HLrI3j3GRZdM63W72525PuFuohKngQpMWGhgEaKsonP9KqGKSuJMEQIozdlhreIcpMkzOeT9tLR8ndDbO0qea7byXoPBNoewzKLoQlKULw0sAK60FF6Uy50jn9W1+9zoHtjLnNFgwpCrC3P9h5RmXzF072sfMTozkWqaQ+5QoUpg94gAXV4ALrIML3kTL+aLjL4Njl96XBY8jyXpD/pUF21KBENYY2KFBbiRzLFNoYrtjFQzytU1u94QxeRzY+SxLUjm0IkrCgTJP0Nux4hypjXXpm1fqRxLeqF9QnjapOgqhmuHnPqvehk167eqRg5ndaYBqELdoeUXiD9uujewq+Y0mU1VlStCvC3am5Xa83IDS9V4KzlXjE+7mdiXl0spO/0nbkbzNPlyMUo0VHc4fSWuj0IMeIV71J3RYOXhk/uYAeOZS2lQ/wGaK6OMVnsL6NM8hQn3sLD3YX1K4h7sc+vz+/xntytgzP2iAGgxcOyCstCLN2p+CKebN0WW7GGIfUXjnCJgZAIDQRE+8uS/l5J3ZMjjlkr4HnTQO+H/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vfD4yMIkO2VbT334RZ77OR5Wjq/i7/fPFlRb8FhULOOJsa0YdWs+HyCrolyY?=
 =?us-ascii?Q?qtgjzR/OGS3i8ZFRth6pVj33+U4anmST0qOVjcUoHxEzZWlG3svVreXWKT/l?=
 =?us-ascii?Q?g77dg3CgV8B4NzrYGCeIjwE9N3j7GMb0dVWUtdFPcPrgquWM9DLlm6vDk91M?=
 =?us-ascii?Q?gCs/z+YgbU4bBvHhdc5kt5wlYXK2icMjqNSCmRWXH55NBp6eCq5wAjxO4kTP?=
 =?us-ascii?Q?4gFEYezujDI7PlWlNAh1uPQGkdtcmGekoO2Kb5KAkngpxUlOYzUmqfqGW3dQ?=
 =?us-ascii?Q?hUmXB+wfGXaLhn0CjwVt93za9gfNZFaP2NIAs+ple7el0C467b5Bph1iequM?=
 =?us-ascii?Q?vXGW6vJHEsfBmG6gEnE404+gjr5LwBTD2SRpWNqma/8TkAGgIf7cj0tZKAmO?=
 =?us-ascii?Q?b1t7olhBZohCMUuCtHF7VXEDOC1D4dd00Im1SgljeTVtwyfMutzBzswQKY9E?=
 =?us-ascii?Q?0tl6OMxOCZHzl37Mfg8GwwYPxhG+ktnwSn03Fk23xYvxyEEdDQbL2NdZ0u94?=
 =?us-ascii?Q?Mei/YVRJVAgUn+4y6iUu/LSDVHlxNbAf8kWzE0ZR9cL6rWSIveJsbK7KniBe?=
 =?us-ascii?Q?EgVVoULnpbcHBlS8+pdB8gvTTJ/65F6sa13HdUYWj9VpW5hZUKaxOExLJMoD?=
 =?us-ascii?Q?9us5ZyPVO2Ggdnf9te6FXaS8lCLO/SUz5KlHZRv8lPMv6RDhy0wWpwUUhdym?=
 =?us-ascii?Q?5P81c0KA9O0tyMoPYoTxP3GqDnECaFYEyq0poGoWcwsduwbGcptPkKAcJNpG?=
 =?us-ascii?Q?oN5/xFi3NbaugCHSW50oYt7pL4yOjw+ceR78QKejdH00Iwqx1zKZwCs0F0O5?=
 =?us-ascii?Q?c0TKUfKrjkkefW46ffVx9qkoWE6QdpsdZkuKAccZ0TceOJGeb42gVx/CDdQF?=
 =?us-ascii?Q?I8S5PmP743N+NlnTo2dPz7zGI/BH5Roo+hdyMlIhUvGjTOPyEsjr8dZPKDzI?=
 =?us-ascii?Q?T0mf92zdaJ7p7nOtD9xdQq274MWmVXUJTyn9550bKcoZgUZZPA7CH4NKcVLE?=
 =?us-ascii?Q?4tzHP+rQW+yEWFm5M0WB00AO0Sw8BtOCwoc0x8pXUXvw5KTAyvCT1zGRscLs?=
 =?us-ascii?Q?38A00FfRBjo/v5CzdoLFDKsOmdbi8yKAE2HTAagnUb5G55ff/VdchhROfoRx?=
 =?us-ascii?Q?khyB8WNxsu4lNEYR+ZQaZTfVWH3FOJW+jKgv2QzLeCjc5HYk2cc6oXroZ3eI?=
 =?us-ascii?Q?JHBwLqlNj2NPhF3rwjeJ5fV36+Yd8Pif9PrfAXSi5pJvgCVbY4jaBK0U4Rni?=
 =?us-ascii?Q?tl5PWWxmXWWHmCJrkSTUQtg9ItjiqpmfuTyC2acV2hQzH7QaQV6cIE8lHgbs?=
 =?us-ascii?Q?2v2uNe1g9leZw+NOXvOANV0D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3482585-1184-4f32-fbb9-08d921c4cc03
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:57.1314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBdmzHcSrBCY+ferdpUyln+wmT9aovNzEbKTDzCisY0acAESTlUxKvgO9uM8fHhesD6+xFPv3cIDn7ugxRUds9eFjX9PcMtzAgdupzGAs3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: u1WdlvF8UQWKKX_00NOAdGTEt_Z6x457
X-Proofpoint-GUID: u1WdlvF8UQWKKX_00NOAdGTEt_Z6x457
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280070
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 801c6058d14a82179a7ee17a4b532cac6fad067f upstream.

The current implemented mechanisms to mitigate data disclosure under
speculation mainly address stack and map value oob access from the
speculative domain. However, Piotr discovered that uninitialized BPF
stack is not protected yet, and thus old data from the kernel stack,
potentially including addresses of kernel structures, could still be
extracted from that 512 bytes large window. The BPF stack is special
compared to map values since it's not zero initialized for every
program invocation, whereas map values /are/ zero initialized upon
their initial allocation and thus cannot leak any prior data in either
domain. In the non-speculative domain, the verifier ensures that every
stack slot read must have a prior stack slot write by the BPF program
to avoid such data leaking issue.

However, this is not enough: for example, when the pointer arithmetic
operation moves the stack pointer from the last valid stack offset to
the first valid offset, the sanitation logic allows for any intermediate
offsets during speculative execution, which could then be used to
extract any restricted stack content via side-channel.

Given for unprivileged stack pointer arithmetic the use of unknown
but bounded scalars is generally forbidden, we can simply turn the
register-based arithmetic operation into an immediate-based arithmetic
operation without the need for masking. This also gives the benefit
of reducing the needed instructions for the operation. Given after
the work in 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic
mask"), the aux->alu_limit already holds the final immediate value for
the offset register with the known scalar. Thus, a simple mov of the
immediate to AX register with using AX as the source for the original
instruction is sufficient and possible now in this case.

Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  5 +++--
 kernel/bpf/verifier.c        | 27 +++++++++++++++++----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 91393724e933..1c8517320ea6 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -144,10 +144,11 @@ struct bpf_verifier_state_list {
 };
 
 /* Possible states for alu_state member. */
-#define BPF_ALU_SANITIZE_SRC		1U
-#define BPF_ALU_SANITIZE_DST		2U
+#define BPF_ALU_SANITIZE_SRC		(1U << 0)
+#define BPF_ALU_SANITIZE_DST		(1U << 1)
 #define BPF_ALU_NEG_VALUE		(1U << 2)
 #define BPF_ALU_NON_POINTER		(1U << 3)
+#define BPF_ALU_IMMEDIATE		(1U << 4)
 #define BPF_ALU_SANITIZE		(BPF_ALU_SANITIZE_SRC | \
 					 BPF_ALU_SANITIZE_DST)
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 908251977bef..faae834aac49 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2825,6 +2825,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 {
 	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
+	bool off_is_imm = tnum_is_const(off_reg->var_off);
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
@@ -2855,6 +2856,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
 	} else {
 		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
+		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
 		alu_state |= ptr_is_dst_reg ?
 			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 	}
@@ -6172,7 +6174,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			const u8 code_sub = BPF_ALU64 | BPF_SUB | BPF_X;
 			struct bpf_insn insn_buf[16];
 			struct bpf_insn *patch = &insn_buf[0];
-			bool issrc, isneg;
+			bool issrc, isneg, isimm;
 			u32 off_reg;
 
 			aux = &env->insn_aux_data[i + delta];
@@ -6183,16 +6185,21 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			isneg = aux->alu_state & BPF_ALU_NEG_VALUE;
 			issrc = (aux->alu_state & BPF_ALU_SANITIZE) ==
 				BPF_ALU_SANITIZE_SRC;
+			isimm = aux->alu_state & BPF_ALU_IMMEDIATE;
 
 			off_reg = issrc ? insn->src_reg : insn->dst_reg;
-			if (isneg)
-				*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
-			*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
-			*patch++ = BPF_ALU64_REG(BPF_SUB, BPF_REG_AX, off_reg);
-			*patch++ = BPF_ALU64_REG(BPF_OR, BPF_REG_AX, off_reg);
-			*patch++ = BPF_ALU64_IMM(BPF_NEG, BPF_REG_AX, 0);
-			*patch++ = BPF_ALU64_IMM(BPF_ARSH, BPF_REG_AX, 63);
-			*patch++ = BPF_ALU64_REG(BPF_AND, BPF_REG_AX, off_reg);
+			if (isimm) {
+				*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
+			} else {
+				if (isneg)
+					*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
+				*patch++ = BPF_MOV32_IMM(BPF_REG_AX, aux->alu_limit);
+				*patch++ = BPF_ALU64_REG(BPF_SUB, BPF_REG_AX, off_reg);
+				*patch++ = BPF_ALU64_REG(BPF_OR, BPF_REG_AX, off_reg);
+				*patch++ = BPF_ALU64_IMM(BPF_NEG, BPF_REG_AX, 0);
+				*patch++ = BPF_ALU64_IMM(BPF_ARSH, BPF_REG_AX, 63);
+				*patch++ = BPF_ALU64_REG(BPF_AND, BPF_REG_AX, off_reg);
+			}
 			if (!issrc)
 				*patch++ = BPF_MOV64_REG(insn->dst_reg, insn->src_reg);
 			insn->src_reg = BPF_REG_AX;
@@ -6200,7 +6207,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 				insn->code = insn->code == code_add ?
 					     code_sub : code_add;
 			*patch++ = *insn;
-			if (issrc && isneg)
+			if (issrc && isneg && !isimm)
 				*patch++ = BPF_ALU64_IMM(BPF_MUL, off_reg, -1);
 			cnt = patch - insn_buf;
 
-- 
2.17.1

