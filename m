Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFA394145
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhE1KlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:17 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:32612 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236651AbhE1KlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:41:12 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SATXsJ032286;
        Fri, 28 May 2021 03:39:02 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thst8j2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:39:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX2/rExbN/QumdJ3G15lcy6HQ0wisxA7cZdTMKYh0GmYLtiT5cCOYn5qdj0c4Fcwbc9JXQy5ASV2mWgsX8ObT8MKJtCeCNhotCE7eF62b/vv0OSrjD5KI4Ao73BUQYs/o5SPsOSaIqRajqIBHs2vBSokL/t69IhDWeJ5aTQid3GTTDHZ5yULfLkqkZA4j09+lHxKSjZoToqPuE2fSbaKemYIQo5vZAUz6jZLxY5SXdqJlmBUJgbzfSLAPHQ7ga08Xd8totfIfACKkM7XeHdHUAWp1OR0tYaYk93NkOuNQxziPX73d9uQDDEe2V24xT5vXttBN/bzmK0Sx7OUoTMDhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiuFRIUj6RJW70Y2WGcacIcv6oPV9a1e/QtGGwcPjbQ=;
 b=Vm/vBKVNy3ATIMq2/61rXm2uhmCtwX8+9k+UG5t+5Y4tWpD6cEdt25Rg22GgbWwpKoL8C2wD8JkNQ2sfOFLMNGJSvO2YP7f8FtUUZfU5QDruTDj9oXWDYCnFsI+RdVXwnP7HEI7DSFl7dEu5c0j7UG5QAMTu3EQY+RTFuTday7dy/aoz9j5daidwJ7xhDVnflZBjS6/5w5wFuzJXpeMDzBZBQvbZIcPOti6CPnjnUfwEi5Hdc+nb1DlT93V5ZvhZp7XjmnZV2qSn8mIoFs43wCJ1WmQhXxyHdAy4zHkR7b16tmxcMuge1D319VASRpe0434CiBtuBa8c4xzVK9WUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiuFRIUj6RJW70Y2WGcacIcv6oPV9a1e/QtGGwcPjbQ=;
 b=G7kJid7ed+lx57BWgM77Lerw/P9RSllZZto6bSXeXe1j3rRP0r/zdOVcdc7ij0I6/DeiKjkXtykHGlCJLi0wrPmiB83KcHzxJcabhrJ7xoqwONHw+v54TC6GODFCsWOGQh+cb+dKk6Pg5mMkwW78OtI0+RcYXAZaD0Kw7m22JSk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:59 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 17/19] bpf: Wrap aux data inside bpf_sanitize_info container
Date:   Fri, 28 May 2021 13:38:08 +0300
Message-Id: <20210528103810.22025-18-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52b4494f-590e-4dac-6ae7-08d921c4cd19
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB3780775476CFF75CD1F15984FE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3e2NHoOGrn+Tt4pCjjrkWQhn7SCRl+HAucdHhhtLFEZX0+XCYKBe7Pt9dTjzY5CMGzw05sbe2N4BD6sFlOnMBS94ID/IijTSoP6NfqlTyCaGTazCMsXdVbcg3AwQp+KeUYMnBHkLw9SFwLTCmU4MOYnxp06p08iJtL4TylMbPlEeh4K9+N0KFfGDnO7kccsugxafvQEZL9M8HZ+NnH7sgKCHCYttEEND3od9r8Cqi2EKxZF1lFmJkWytGI1o8dr3ybX6ZwYfGrkALX8J1aTqB4d9Xni6hQpaxTnQ3F1U8aQucO/TJ0WyYU14vqxqjdKsHvf0HqvEeU2nKY1EKpG9aLi2L53brHtumFEue9+kme7bvTVujkEEPnW9kWiThKk9YQ4hlYEYY4Al5B0E2Jn7n4KJFFBimxZ4SKD8zhDzLU5LmnKQpJpXfYJN9svshqdkv4/GdUjuSY7BblFxDvXFYMa3GAR+oSpCGmjdrgLKlH5QCijQkNsnp5ZUmxetwG8HqbqfnLykJB1zzr+Y8RytafTdIAQO0dA2nr3AKYkK0hDBr7vbwz+E9D7FjBTaLvoAxtc8NsdRC26KUmFtcAwhaZdsjwVMEV6UYwN8oiBXwNL1t9SvTAdoPmaPKIFe1uTIaRe5x/r/8+tHfeUwSE9uhFRd8kNFZBaPVzzuVH2im/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HhB3RE2TRAg6JGFiu9qn53xj1kvWQCKJ7OVzaGeWn+b+ULKfaCQMweRkxPh4?=
 =?us-ascii?Q?vcTVrewDbdn4MvqVgpFI7YJYG9fEb/F/R2lYAyiZwM+hooUrR4i4weTTosRX?=
 =?us-ascii?Q?XJd3Aosw5GphrYVILX40NggkbZAq1L+zUjBB6JgfCB4muvr25Ny+RLXygdm7?=
 =?us-ascii?Q?cIqOTdK6/K87DgtBC6cAMztNKkMuAIhjlim+rjPp/tm5CU9R2QxV8OT8P7An?=
 =?us-ascii?Q?MRxAy2omWR0cr760HhaIwy0RA0rAmrasktQhr3OGw/bxXHOR1/IWkY70wJD6?=
 =?us-ascii?Q?m4eSGe+NGquPE9tKc0/B9NNRCUBYKB1CBSxNtbLfi6XdvVS6Ls6FAJ07OrJc?=
 =?us-ascii?Q?pqieCHXALd5yXQG2TOAdokrWRTRBByy0HZojzOz1lvwFFbJ3tJVAaZT5snYm?=
 =?us-ascii?Q?SmxPG0VdhPL3a7uaDa96BxpRmgWTK2zddXVKWFngt73z/nLIr2halUKa2i03?=
 =?us-ascii?Q?/fUcSsaQILAE738v4NHfu+rP4SQ5Q2kyojnXJ0v/wCeF8Z58KeUITkOa/P8L?=
 =?us-ascii?Q?d2NL3d4A6qeYycxh+QVLGZPAjTg3ip3BKcJeOyc+sAtsFIsYBdShyj9w6aHg?=
 =?us-ascii?Q?1duShVAeZYS9UEum1Wig4qKjIo46SAD91Qso2yjUPVIJ7Ncc+udth5lpNOws?=
 =?us-ascii?Q?YQDQwTz4tHIO/dk2suDELOsB1J9DRLfGcrqFbOaa3ZkUF9JStjgxPbeFYIiM?=
 =?us-ascii?Q?lyUbZ5p6WY944QHA+iipwVIpyPJy4m+urijOK4PubRQTskb9mvwnzPY2YCAz?=
 =?us-ascii?Q?W+0c8xIRE5HfxsscFYXSjxLRc9JA/gVcU5iZMl1jzjmIvf4ICUP2Ja0DiCKK?=
 =?us-ascii?Q?sWmJLfjBJNGY3t06DmvVGrhM66fXfvDyhazo8h2fM+1PTzBi1xiVl4AntZ+b?=
 =?us-ascii?Q?OVdm6M7XWDt0okmWUlMcOgmtJ7EOhOd2qT5eAA5E9R+z2u1T/Ha/yr7JUAx3?=
 =?us-ascii?Q?fYMBtAOgIBuWpn37jwQX17fr5+L2+suaupKAbYADpvGYRP/40sbxcIZUE/0/?=
 =?us-ascii?Q?6m75wpg1DBPDS6fCdGuj+HTU5AyaWZfAPTM6WoDHVZ9kMhKyrp5t0bZwZ6kE?=
 =?us-ascii?Q?tlf/Zaot/X7VftTjGaWBG9f7zYqym+Y0GT+qlAlj61Jw7vouJERmCtYAJnDp?=
 =?us-ascii?Q?meN60pE/XnPdRTyZ8pqVAaBhrVjFlpNWCsBOSPyhvZ5plXg6B4V+KdgIZbjf?=
 =?us-ascii?Q?oXAT/wH5IqOFo5wDRVzwzsg06cRlzzRwKgFwJZWNQg3YYuOJ6Vj0iR9E80h0?=
 =?us-ascii?Q?nELUlI2v/BvX4tCL0642A0+MyKO8tIDUzG47UB4dWKTmEhXfOfvpO5IH2LwQ?=
 =?us-ascii?Q?myYsghotuevr4qFvNaw22QWB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b4494f-590e-4dac-6ae7-08d921c4cd19
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:58.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPIsHEdRtVYoHY4LGNiX7kBw/8Iq5df/FZCjtyXo53KInrj8LCLYKsflLzSU/SxK2k7M3mbdouuJJnZLQL7i2bkq1EmkR7WF/AnraLZS50M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: SygMTX4Y6oIvlwvKAp8HyMsSUGVxSotJ
X-Proofpoint-GUID: SygMTX4Y6oIvlwvKAp8HyMsSUGVxSotJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 3d0220f6861d713213b015b582e9f21e5b28d2e0 upstream

Add a container structure struct bpf_sanitize_info which holds
the current aux info, and update call-sites to sanitize_ptr_alu()
to pass it in. This is needed for passing in additional state
later on.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index faae834aac49..0066ea8ecdaa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2815,15 +2815,19 @@ static bool sanitize_needed(u8 opcode)
 	return opcode == BPF_ADD || opcode == BPF_SUB;
 }
 
+struct bpf_sanitize_info {
+	struct bpf_insn_aux_data aux;
+};
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
 			    const struct bpf_reg_state *off_reg,
 			    struct bpf_reg_state *dst_reg,
-			    struct bpf_insn_aux_data *tmp_aux,
+			    struct bpf_sanitize_info *info,
 			    const bool commit_window)
 {
-	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : tmp_aux;
+	struct bpf_insn_aux_data *aux = commit_window ? cur_aux(env) : &info->aux;
 	struct bpf_verifier_state *vstate = env->cur_state;
 	bool off_is_imm = tnum_is_const(off_reg->var_off);
 	bool off_is_neg = off_reg->smin_value < 0;
@@ -2852,8 +2856,8 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		/* In commit phase we narrow the masking window based on
 		 * the observed pointer move after the simulated operation.
 		 */
-		alu_state = tmp_aux->alu_state;
-		alu_limit = abs(tmp_aux->alu_limit - alu_limit);
+		alu_state = info->aux.alu_state;
+		alu_limit = abs(info->aux.alu_limit - alu_limit);
 	} else {
 		alu_state  = off_is_neg ? BPF_ALU_NEG_VALUE : 0;
 		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
@@ -2983,7 +2987,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	struct bpf_insn_aux_data tmp_aux = {};
+	struct bpf_sanitize_info info = {};
 	u8 opcode = BPF_OP(insn->code);
 	u32 dst = insn->dst_reg;
 	int ret;
@@ -3035,7 +3039,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg,
-				       &tmp_aux, false);
+				       &info, false);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}
@@ -3176,7 +3180,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
 	if (sanitize_needed(opcode)) {
 		ret = sanitize_ptr_alu(env, insn, dst_reg, off_reg, dst_reg,
-				       &tmp_aux, true);
+				       &info, true);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, off_reg, dst_reg);
 	}
-- 
2.17.1

