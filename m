Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624EF3934F7
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhE0RkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:25 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:47866 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235205AbhE0RkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:24 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHY8ni002761;
        Thu, 27 May 2021 17:38:37 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 38ss3vs2pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUBNpwgYsmtd8o0/Wj0XPOHjAh2BKXUOUYZIiT7Im6wTl924ragRlY1HPNIAazWprA/yqVqd+kBboxsz7F3qQpcArwLgSMrTgE1rH0WqVSE6m/IP8nqs05G/gUT9aOAvgjRbJGoNEzI91aIkyCeu6eagkMlcvnkV00tGEfnmZZ+8n7GdfN1vZMysU7EkDWXDUsdNsmN+eBQP9ONUu8Wi5CgcowscAnU5W4TAYCb3NQPgN06p4q0QS1PG/UuR0eo6f6sPSYDHKmUH+MeoOCI4WgzVL9QpLAcncNXz9m+W2qMkux/7SpKn5RXj6rTMvfR5mcHtjLDv1gEvkRMtAHVXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RveukoBfxcDM3x2lN7ZXhJ/4S4Np9t34jHuB27wE/ww=;
 b=LtgpmKtldFo1VKVOxu9XG4CsdEG2PWgE+voM+MphbHWH1v3SsF58VDATGiw7y+ai14/ejl2ft69ojfEAiGermmTYpJyV33gW/Uk5ARtICi3AMUd3DCp3MxSxLkqN9YoiVv/Pi62c8eAIIgr7gQHkutMADLHLTackP97/sPf0qly76zRcOJdC/YEDNZ5NBLBDRTEHG4XAK7Us2Fal2wMRlz63lDmbEV/z9GtCQKVfuYK7OtYSd+xb6/vvHW/vV5sycfMdZvOqWBuIQk/rvJ7I+7wGvJqUP4ikjBwmEUcEeJP2m4Rqzvt+zuRfAXDvKC9Twk+3G+x18twLMmyehrI7hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RveukoBfxcDM3x2lN7ZXhJ/4S4Np9t34jHuB27wE/ww=;
 b=kZRpRqK0Lof9QfF1m4c3RxVNXWNqppoedQGHjZKtSU9v0IKMkUVw+A9z3SRU+XFrVM61qrmVzQe1rkXnvI7cCJXB1XN+7e7ivJwjCfgCJyh7WWVqK44RJTKNzWwQKLwfWIiDYW1/MoATs6aEtIfKRhtN/q5Pn+EFPRaDDWW7X2M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:35 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:35 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 08/12] bpf: Improve verifier error messages for users
Date:   Thu, 27 May 2021 20:37:28 +0300
Message-Id: <20210527173732.20860-9-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210527173732.20860-1-ovidiu.panait@windriver.com>
References: <20210527173732.20860-1-ovidiu.panait@windriver.com>
Content-Type: text/plain
X-Originating-IP: [46.97.150.20]
X-ClientProxiedBy: VI1P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::26) To BN6PR11MB1956.namprd11.prod.outlook.com
 (2603:10b6:404:104::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d570ecb-4243-4e8f-baca-08d92136411e
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB216232E99D909AFCC4577BAFFE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pm+E1EK+wQbpBGlvZI24E0BE1oGdaiylzmGJpGgFO9CCMCaJTbbEx/mcf0IIylx8n84/JBF2iX1wtER6voe6TcktJpIpqZ2jVXlhSwv93+O6nAU6vw8wGB9NND27h4/pl5EpoAvDGW06YiyNJM5g7PBo1gbqoj2Bke5BhfnJ9Cz11aswYALUOUfSHPOH7JPfHYb4j2SACkGLaSdsG3qFM9dvNlseg30SR92ARlKKPiXzquiukiRnAU5pFBcz9QtDteVZzXbGwSNsUFqnlpllvH6dKVfIhbu4M59VkSl7vuSf71yogmFIOJS2DLg+EKRhAoZnYHmMJf43QwQltsr+0jBwI3rdVwBCWh1/pZ2T99sctOo3L3wFzK2Lwc3sgtUEj5lFPRFgAStx0nL+pt3gvFfVZqlxX9uF++xYOgNaobHbF16X32fsAnRKYFVnWZKj+AL9yXu8H6hn1Z6INf+8CToxuKmF/jgP+UcVxmMAlRZ8ELTotUccIVyLaxdmKd/8qtwxo57tPECSQzZOh4GiwoxUbn5Om04A6HC3EwGrBQDJQvLZyW/jX0BQ8ZPoDl1MM78PrBVIMLOwSF31aei4x0a6NpgwKTS4x8+wjZ1HRNqzoM1jb2IyFT29pNWkJeSzUqdyuvBBLgm8PtGxj3gsluSPqC+QTfOgUWXPzQ9yYUInWv5qTD1o1+pn5swc4qxJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(15650500001)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002)(19860200003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y9QCMkULEbH7w1ahzeATVk8jHOqbp1YofeI4vpFvgxzJ8NAss8TDi8Pmgwj7?=
 =?us-ascii?Q?RW/MU+IyFq5GAYhLfp14AGQwN86YjWS72l59sDHTZ4RvJn6mUG+WeSs1rdUE?=
 =?us-ascii?Q?O2uy/zxTYdp/mtPunfL9r5bAI6nZgCkj6fi9PfA0G26C3pdB7lyUu8aUO5SA?=
 =?us-ascii?Q?l7IhUC4AG3XPlgokm2bF9BjE+wonFvGLngZ0cr29uKbNZTDOyQCjjm3VeWS1?=
 =?us-ascii?Q?h33NkWne7sYYM3PMS3vU3qLGPVS5Bz2DjVQR0WFqIqU8ApDqi68Elkkxs5kj?=
 =?us-ascii?Q?Gb9upu6UGtjQL0kOEGIKvbQFphvgmMVziH751ONQX9YkHaHaBT0uJKLyX8tz?=
 =?us-ascii?Q?LXkJtqe2MLdI6NDhy+N6EssSgiEnLp+dEtpwes7s78ps0dqq7h/xzdFn9tGw?=
 =?us-ascii?Q?brn5ze1SbLutI0myEAcqv8EEw6Q/yOwtm54Dik/H9OgIBB0VSej3Zv3CFRdC?=
 =?us-ascii?Q?1amEXMpq5xFogq5xQs3vQhEkOwL6IFApHyClCExfrA8Cj7F5WnmtpK4yyPWL?=
 =?us-ascii?Q?3r08rz+xzhL5w8lsG7kAgjwMl6ELDuNn7Pb3qplcQw+CFOzRIDiLnf5GRb/L?=
 =?us-ascii?Q?74FJwc+/ov7W7uks5dIHtsYjfcv6n4mDCwQSvqpS2iFhT1/6KU600jXqrkSV?=
 =?us-ascii?Q?x7SXk+YAz1AcNjZ8qm01bk7WXV0SMjjxxxOq57/4mS2FEhOud4dCQiQtM+VF?=
 =?us-ascii?Q?PnCks/7nYm5DoY3m5/4i4A3gv049ntMiZb/t537swkwRXBmBFBqykTw33hWB?=
 =?us-ascii?Q?MfHnwlpaBa4KILKJBJ6k0/9MqOtGuJ6Ci/myTsbcKce45TOY8cE3CL2aO31K?=
 =?us-ascii?Q?hQQXQrdAtTfnmAdFcFNZcCIn/1vxoip+NS7DlRuac5vNeSa2KLvAgm3lQA/v?=
 =?us-ascii?Q?ou86WY2ajsaiHARJ70RBKRsAmcaEa43JKoVZgSa9atjoD64dZh3Ww5vRhhaX?=
 =?us-ascii?Q?9yw6UQoWxy94cXMt/A8iJ8he3gOEGrEW3r7iKS4fqXK6qi4v2eTSDrFtj0a8?=
 =?us-ascii?Q?8fq4N7KipoBPtGJ3ww9p5dhkpyitl09BB09pp1jJmubbkb1zibR3WwWrb0qi?=
 =?us-ascii?Q?Nztnu+q5MxQf1alWFU6uNMkQb0ZFHHxP74kuVjxfxq0wEGh8/L9Ywo0RQ3tY?=
 =?us-ascii?Q?N84i+SaYrJhwEHqmfDTXtWOqtS6+rdUzPduDZ6W/ZePeXHvROcwHaso3pe51?=
 =?us-ascii?Q?fpME3ylBOssnT3OHgeZZ/HNkyJwel6TEGa0LEb658SlW3F1jeYPrd6WNP2XC?=
 =?us-ascii?Q?/kD0Jnj3/5Vn5JbD9NrVzg3tMyn/sObEsBWfq0a+ylTg6SJ1YMM4GRIWy4rF?=
 =?us-ascii?Q?iA8n7ZDktVTZRg58PdiiOe1z?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d570ecb-4243-4e8f-baca-08d92136411e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:35.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bDpgksHdq19kVE09HkXpT8tp5PNQ/PTcQzMBmyVodtzt8bcIKVOuAhBRgx9g13ocs7WHrnh2/pMYTCGDVfrY7m1T84TGf5SFmzkz1JP+KA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-GUID: p7gbY4__4dMuFavBt5XG8DMEqGGA1gp6
X-Proofpoint-ORIG-GUID: p7gbY4__4dMuFavBt5XG8DMEqGGA1gp6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=955 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270113
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
index 12db86ebede9..cb79307a3aa0 100644
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

