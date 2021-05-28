Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F328F39412E
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhE1Kkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:47 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:62004 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236664AbhE1Kkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:39 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcorG015137;
        Fri, 28 May 2021 03:38:50 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thst8j2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdAesr/V578vQyuOWsmZdYaoNhfBmz7kttHxOYnBWDJuak6XQpzS9DHhQpGa3hs5lBi5tah6tj82uC4LqcgzZjtBO1mUb46prXnKPc2woYvQ9+Ga3lZ0fz7wo2AT9h+MhK0u5d6N6ZXItIe6C2MPV/CJTryA0nQi3+ARrRpnEBrdz5APa4USBrMlrlNH8PvGPoSfmFWt5C9NRISXAOUJEUPkoAVYFMEVgGxIba6t1PAyOdoOnF/6UBQQ8OWl9iKXNpPzIyDKKwoOf/eQy2ssiOP4TcY1TDFCpRwJaPQZlHzYMk0rSSYD5y4YKWtO05hQH0wmSxQ0qPL8ysPdIjtu9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBBCImEv718YD4m3c0xM0qcvMe1+QUQUk63881AhFI0=;
 b=Q43yj16fSiVt2//1PtHBF0eGY9zaUMiCV6ISmdK2/HOawB8wvnWn1V463sNYBxvCTgixrxIef0ayPZiUQHaVnT9hhoI31J6L+h+vwHsZFsPD4MpuVCssnan8xyEZv2RWe+e1L0BkpE4ymDsvqqYGsfSBU+VizyIFppGEn5oePDuPhQAQEkh4S7BU9QwUtlV08Ui/VNl8TV5lmrIOONYv+4fuHhdSjZHwnOLz20kZL2Ag9IReR7Wp1QsWRIKZO14ecuh8R6b41AOgDrXGJrdcezds05ZOnCxt7sYRergmWWSpIC9qFjcuVlKIQoy1d32iDsNX2ajR9e3fVp+T/t6WLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBBCImEv718YD4m3c0xM0qcvMe1+QUQUk63881AhFI0=;
 b=onqkcprsme6Zv18dTVLTLrTwjAVgiKejXLnVareumeX+IPKt3y1gOwogwWnIjjw0AmWrDDJn9Bq0n5pmdjPSZQK/RcJJrZrmZiG/DGiXanUrFMJJP+i7bSO+qX6AfGsqrEEHeP1nZ33yc3SWs8kZOG+XrzL9FzJj4gdOyMkTmuw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:48 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:48 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 11/19] bpf: Improve verifier error messages for users
Date:   Fri, 28 May 2021 13:38:02 +0300
Message-Id: <20210528103810.22025-12-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24cd3853-2cd7-4680-33c7-08d921c4c698
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB209789C471FFB34F18F45D92FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OmuZtT7DCn+BE7lI+JUbp7UjOZFi5FRXORl6CvWqpN1wajcwXoAnxYM+erxfjxsiwQom6Phfh/8K3gBpiNUxjHhNsC1VIS497vEpm/Zpcv4qt+Bhk6bJEQXvNLrC1500qaOw9GrEBw71mquzCMj+25s5mUB4k/VKpQZPRPbL73CCoeFHo+I7a7bq1LGhRz0KhGVUCK0KO3jesw+k6UtuzFXe46F0b5C81sQSwOHkaO/mgTUt4ZLvzOF+I9Zsf2KoTfltOJt9b7rYQlZqGpn+w/rCIh+ZdYsC6KvP9CpQkCk/8YP5PAKLMw8TezH1JY2S0RhMUYpMEpqU05wns49b5kRzTSxoR+iOAlsuTNXOJqMieWSOpdkwOIAw4/s05ggnN3D4s1O4BQaK+ltzLud2JohOKglzwgm1LpJrAQx41CgdQfXOmEtn6x7NFxCl8cvHBin7Hds0qBjRfS/K7wXmWwMEheFT/J7G0Ityq0ZV97a2Z+y/dFUTU4ZnU7Q3rgdYc05iqOFQmEmPSBArVpNaiX3CIteCcaEOkiJnf/IggoagOWGTEvniTCcWew0qNyDwLcMKYuyrhhnutBxP4pP7PVNugndeZ99m2c6DV+5IFQMos39WGqo/K3fEVQgemqZWeJpgwKbfj7xX0GKd/A3Fxa5USeFT7DyjH+myrxwILe5JIOfsBGgLuzabdcnQjGW4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(15650500001)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001)(19860200003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7Z/wfJYRww+ntAaQbxqOeCNHUyfQ7DaFREUCIVc/rM7aqW8+vm9hM2dCFOIs?=
 =?us-ascii?Q?vm3VIm7TfPdEBzWnuie2RcVDRZUfp8wo5Iemix5CftvD0PcnO49JutgkfqP4?=
 =?us-ascii?Q?ln1dwAQWj4kuvlv09beqHoW9bJnxfI9im+3SPf+KJ1KkJimNZTH0eky3qEv7?=
 =?us-ascii?Q?1cXWaCRQ0JjeQyfVAE/mpPLKEEaz3265dX0fHNPfiHGm+oAsR4o6Jeccn8ua?=
 =?us-ascii?Q?nBqnLPIBXgn+JfbACtJjjAjsxwRzL7lbnkCZodtckGXhpfx1fCyBVRvkz7/e?=
 =?us-ascii?Q?8C0moymYlVj2QgSaySnApUzhTDj3cuV8mJlulfLpBLaHpkuqY3Y2citCSNyO?=
 =?us-ascii?Q?c2QaUsbhS0szMuggpksKU//j6nL2Y0d0PaO3WwcPee1/+GPHHlJ4W5m0rOjF?=
 =?us-ascii?Q?YVSnWBU/zzEYB6s4OuPN6htD7H9Wgr545d2hhZkzRTRNr14WsKPKkj1JK5cp?=
 =?us-ascii?Q?VgJuZbt0Msq9BawhaHKgAeyiHY+Jbcve0yGdLLg1BJB06sigsluxs1J7mHwn?=
 =?us-ascii?Q?6ViyyOFlO3ss7gROBkLvGRs5TsMC0sNtPAoe67YNZRV6HKzsIZC0WP1LuRQK?=
 =?us-ascii?Q?y75ODAQtEt830w8ZUhutnB2m+/y06wrED9yCXIY/c5SRWE2RCop7iEQCETVs?=
 =?us-ascii?Q?Jj+Q+WRzX3TQBYXJ/0g3dw0AVSIn6J7/Vyjez9R1RLU2IpG1Bd3GcJf7/eKX?=
 =?us-ascii?Q?JEUbr8nfUVSRr+GOKsQyOd22Rr7D59Q9kMOVq5yJT1TyCgo/SFuUbL1sMqGj?=
 =?us-ascii?Q?ZXqMSmZ5CV7s29LDOtGY+d0XS9bt8BGYDDxqaZIvEZyn1H7jTrvVxQAytvuK?=
 =?us-ascii?Q?ZArRG2fUFRlgw0ovZcMA1oqgfzEb4bUipps+McPoaYfv3V0Db5BpXqOjASlt?=
 =?us-ascii?Q?zV5+IFJE9EGLKJWyX2Sn/uaf60Iy8TD3iBOD+zjHHSSjdxbjVHi7wSB0kULQ?=
 =?us-ascii?Q?VMzN1kDympKXcsmgsCZ60Pkg/UQNz9AFsQd0lF7rbfB205jLNoR8SBQGp2Qx?=
 =?us-ascii?Q?CrNb2GCUWa3nSAwmwVkGI99kk4ZNf3o1JGIKrSP1oBMSrvAZSOvVeGigtaAW?=
 =?us-ascii?Q?9bsQjmDgvVlVPBpYKqi6CeSAPJovwme8LTazcOWaRns9O7AYU7tnM/SMgPYp?=
 =?us-ascii?Q?50scjCt2t7+mLIc7zcmiKJ3Ezn52pUaOWk0s+ffbyIxDfXdTGmc60/zNjms3?=
 =?us-ascii?Q?bIptmf9EgLVYkJQwDBth5rDxyHbParBgItoZnYok3hZaWyQMowBfeafvfKXB?=
 =?us-ascii?Q?B5trOdVA61qPndc+m/xawUDrkTkNTpJac/MbjndWLhp11KXRmLOEq/dsLPiW?=
 =?us-ascii?Q?VxuVoJrafOy9Uo1SxEIeHBi2?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cd3853-2cd7-4680-33c7-08d921c4c698
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:48.0315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/Tbq8Bn3bJHARWTRmU24ramHV7oCnqDTydkuKMqeORcswA9slw6Itzl+tWiVOCtqio3eh6CP2XIR3NcwoRwY+GDuQ4t+K6ax8lG1OIRqj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: pZryBQlNDrSj3iSyRecno_7X2cybZesp
X-Proofpoint-GUID: pZryBQlNDrSj3iSyRecno_7X2cybZesp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=930
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280069
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a6aaece00a57fa6f22575364b3903dfbccf5345d upstream

Consolidate all error handling and provide more user-friendly error messages
from sanitize_ptr_alu() and sanitize_val_alu().

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 84 +++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index adc833c6088f..473b59126f61 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2729,6 +2729,14 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 	return &env->insn_aux_data[env->insn_idx];
 }
 
+enum {
+	REASON_BOUNDS	= -1,
+	REASON_TYPE	= -2,
+	REASON_PATHS	= -3,
+	REASON_LIMIT	= -4,
+	REASON_STACK	= -5,
+};
+
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 			      const struct bpf_reg_state *off_reg,
 			      u32 *alu_limit, u8 opcode)
@@ -2740,7 +2748,7 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return -EACCES;
+		return REASON_BOUNDS;
 
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
@@ -2764,11 +2772,11 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 		}
 		break;
 	default:
-		return -EINVAL;
+		return REASON_TYPE;
 	}
 
 	if (ptr_limit >= max)
-		return -ERANGE;
+		return REASON_LIMIT;
 	*alu_limit = ptr_limit;
 	return 0;
 }
@@ -2788,7 +2796,7 @@ static int update_alu_sanitation_state(struct bpf_insn_aux_data *aux,
 	if (aux->alu_state &&
 	    (aux->alu_state != alu_state ||
 	     aux->alu_limit != alu_limit))
-		return -EACCES;
+		return REASON_PATHS;
 
 	/* Corresponding fixup done in fixup_bpf_calls(). */
 	aux->alu_state = alu_state;
@@ -2861,7 +2869,46 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	ret = push_stack(env, env->insn_idx + 1, env->insn_idx, true);
 	if (!ptr_is_dst_reg && ret)
 		*dst_reg = tmp;
-	return !ret ? -EFAULT : 0;
+	return !ret ? REASON_STACK : 0;
+}
+
+static int sanitize_err(struct bpf_verifier_env *env,
+			const struct bpf_insn *insn, int reason,
+			const struct bpf_reg_state *off_reg,
+			const struct bpf_reg_state *dst_reg)
+{
+	static const char *err = "pointer arithmetic with it prohibited for !root";
+	const char *op = BPF_OP(insn->code) == BPF_ADD ? "add" : "sub";
+	u32 dst = insn->dst_reg, src = insn->src_reg;
+
+	switch (reason) {
+	case REASON_BOUNDS:
+		verbose(env, "R%d has unknown scalar with mixed signed bounds, %s\n",
+			off_reg == dst_reg ? dst : src, err);
+		break;
+	case REASON_TYPE:
+		verbose(env, "R%d has pointer with unsupported alu operation, %s\n",
+			off_reg == dst_reg ? src : dst, err);
+		break;
+	case REASON_PATHS:
+		verbose(env, "R%d tried to %s from different maps, paths or scalars, %s\n",
+			dst, op, err);
+		break;
+	case REASON_LIMIT:
+		verbose(env, "R%d tried to %s beyond pointer bounds, %s\n",
+			dst, op, err);
+		break;
+	case REASON_STACK:
+		verbose(env, "R%d could not be pushed for speculative verification, %s\n",
+			dst, err);
+		break;
+	default:
+		verbose(env, "verifier internal error: unknown reason (%d)\n",
+			reason);
+		break;
+	}
+
+	return -EACCES;
 }
 
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
@@ -2934,10 +2981,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0) {
-			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+
 		/* We can take a fixed offset as long as it doesn't overflow
 		 * the s32 'off' field
 		 */
@@ -2989,10 +3035,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		break;
 	case BPF_SUB:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
-		if (ret < 0) {
-			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, off_reg, dst_reg);
+
 		if (dst_reg == off_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
@@ -3109,7 +3154,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	s64 smin_val, smax_val;
 	u64 umin_val, umax_val;
 	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
-	u32 dst = insn->dst_reg;
 	int ret;
 
 	if (insn_bitness == 32) {
@@ -3146,10 +3190,8 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_val_alu(env, insn);
-		if (ret < 0) {
-			verbose(env, "R%d tried to add from different pointers or scalars\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
 		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
 			dst_reg->smin_value = S64_MIN;
@@ -3170,10 +3212,8 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		break;
 	case BPF_SUB:
 		ret = sanitize_val_alu(env, insn);
-		if (ret < 0) {
-			verbose(env, "R%d tried to sub from different pointers or scalars\n", dst);
-			return ret;
-		}
+		if (ret < 0)
+			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
 		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
 			/* Overflow possible, we know nothing */
-- 
2.17.1

