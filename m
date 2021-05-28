Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC26394125
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbhE1Kkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:40 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:41484 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236568AbhE1Kk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:27 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcdwq006243;
        Fri, 28 May 2021 10:38:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thqe8hkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOGcv5NoGVZcm40NzC6/62B1iCyNux20Lee/IoNYq7I5BgJ1yvh454CbV9RFk9LTdFGILzoJ+fYvNoGol3XsjFo8TpVx6WipTCs/ilu6Reanom3DHMMB5DJmyaP1EaYxlcyeCrmwsl0AlfoafmwntUUh3efDeFoIQDTI0/tj4TeMIQv4mYg4m1pTkUVoPJTZdzWfL+mxWq/98eVpn8XXZjUoLpTDIejAbpLnJXP9cIsj9lS+2knK3u00wr2/4hNyTsq+k2pPRV57jyBm6MhA/sP+r+63znhxWFnbTpir62sWb1H4d+gDII9T6I6SmooZy2WZET8LZOwCuZLVIHsx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtQ1QTu2Jgj28ues30pwS+GIgIKRZlo9rhQ2BbjyMfg=;
 b=cX08RufK5JLKjDVKSAoMM0VmjbCjG44kf+iQfhpHDZPexRS544zfnwmCBvVwMHJjnXRD2CXJxd4zTN8IAxPbm+9E676cYfdYk4tTsrjdZYt1mH6MU5GkARTzMiU0Ku46cTBylhZpkqzzWN48iowassb26gDqzNh9UHl82C2bs/xTZLwRhci11jpsFpPAF0Slz9Es3lnCxLBzXHf+Yp/PgNK1JWxKjQ8u90m9cnSwGrvF7lYno/yzrmudOyUXriKoy1dnYg0xYa0rhCBHQZZMr6icMdKSv7/boNOap2OUo/QeXaD/yYEcNtAxMr2cXEWL/JY3kI2i7ya908FRo0QXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtQ1QTu2Jgj28ues30pwS+GIgIKRZlo9rhQ2BbjyMfg=;
 b=G6sujwuebyDo0IYIhvIMpYDLI6OQKDJFgo3+Cc0s+rAhxFJ7yYz9Mo7PC5H5ISwLwez/RWsS9XfwcVgC43AkcE+PbUrJyuFVqKyFNEPWMR6FNFUmuRxi3WHO5eIsnNEbqIr1KJBDJ7Y17VTI7RIKokPI0WM8vggc5zjsrEZvnH4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:37 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:37 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 05/19] bpf: extend is_branch_taken to registers
Date:   Fri, 28 May 2021 13:37:56 +0300
Message-Id: <20210528103810.22025-6-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d3b1cf1-7c7c-404d-690a-08d921c4c01b
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB20971733116957434FC8D080FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oBAAvNiZLjKAaPU3Cbxn3vuY62SFjk8Gfsdt+3ggrdPQ5hsgC4QAzKtonwYOpm5o1LkC2IBbNLXLbRoTd6MKDqUpNBzhP2YQbemIcQXfuaHBbyECUDN44NWQaSDd+O4MXZxoQ+xgnlKt89zPXIx7CXLeVuUZoccuiym7v71TJMKCZCgv+R4+++4pmSIE07XBfC6etqnyEJD5p5YxKuX8m2rZZkbRp7A/hbU02AgmtOvlSLdrqWq4+qRD5+0D9LuQSnljJd6vyVBR7OG01ivtJ2xti/avBEfAtRqWs9Ig5e3Kps57Z//lqq1UuboTTT+lFu5Qor9QW89XJWj31RFHFht5OxFY6TazFp2c6ch1JbDplgqhJ2sMDT3htE+mv8JK3pMZGya93b0+2d3hBCNLGoiyjsmBS4JVYe4ONr+T4yOsx8GYRS0302HzlqQBjPA6QBFDvRdb0TxvJ4Cx1vxetrVTLYk1ZUU4YAlC7aC0yqSaRuJOF0SadybPFzY2/JRrKbtJoU132rGq9ZypjGrR/9PeT40xHXZbHPMMWRJdHNE1izBJnn12R/TNf7/qXsu2s29CZ5TbrvESl+oTnA6ByT5Abec7kVI1LZDtoHp5A/mepRWRZ0bF4f2eSCk+Mtx2UNV8sTHE+yoGyrUqODXU/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Xktn9Yy1cRWh+lTibqQSOg6tNLnWb1IsND+LZfdHskeNSd5eVAHPK6PDyTcD?=
 =?us-ascii?Q?U7Ccq2HUR8Z46TumMHunrWzDARORHys/HiiEUcbqhLO6j5KrcFpJhy0acqpm?=
 =?us-ascii?Q?glZA3pn5Ewa+fVtGOtuIaEP0Wg101cPnxNsNrQjEQs4gEu5n1gPAr7lvN1T+?=
 =?us-ascii?Q?ZHbG7XbChpvJEJQoHl8tSCP2CHhkyyBCUuyJoTT/0bawLwTRQcyQoPeEEm03?=
 =?us-ascii?Q?eyPkkjNmApf4CDuTqh4W8zfZV/wBvsoBKN4MIGYZxn0ohC215yhrnFNh0gus?=
 =?us-ascii?Q?dSI3ik1Mzure9SJtxfqiH1r7y38unW3x/LhL2AiSsuRlWZLkciBopAwkPnz2?=
 =?us-ascii?Q?WJNpkHN/vqgx+CmD6Xa9lY96K1JQxAa8JNdX8HV3k+DCz80NBLc/43PuAXtg?=
 =?us-ascii?Q?jWIiCyKqwhEF3hPsqbrF9vTMfej1r2NZOdeXF3oohnuXSjY9FM0xlLg/sjrz?=
 =?us-ascii?Q?0BZ+tjP9C1Zq5SI9pa9dtJ/mYYnpPS7FczqAjzWm6JkHKQdi2ZTv2wIJzX6M?=
 =?us-ascii?Q?/0z4Sl1nFZKCzbwxDozZcCIVIO7NZZ7Y7R5OjOGwe94WWseUdefJPQw8P39Q?=
 =?us-ascii?Q?ahF1tJlWLfosgwTJvtOPlR5Lq/9yzHRwGYP1IPSme8ZY0ZLV+VZyoBJh5ZYx?=
 =?us-ascii?Q?9QERAyhNJbG8hNNKtiFcDpwqUfiuju6SSlVW7tbz4jrIkChXJkf+rDcJw41g?=
 =?us-ascii?Q?FACIyPrLrohg44do1S/zuhbl08nXxNsC8CQp9xr+XlNErOMfYQM9fsfNOhEC?=
 =?us-ascii?Q?f/mGvz931+47uP3Z5CTNTsStH22VS/grMrRHfE1yBNFw/3U6d9UezmToo38o?=
 =?us-ascii?Q?i7EEo+ruApdhDiag8fMbM/2Dxs5mnRB5XaDA1ldfdQDB9OMirm5hcumiPjln?=
 =?us-ascii?Q?/5ADcBAcquNKWflYReClGbI5r2xhn5i3mzahZTXpHSD/tRLBPKTgUrzzHkXR?=
 =?us-ascii?Q?jTyJgkx23G5rlnqF4XqqnpAowEe4lZeuQoWSC1MgF7im7uH/qo2UPKASNwwp?=
 =?us-ascii?Q?siaY9KL0kTjricG/TWGRA5/kOEawKIzt08J0OlbeFWhkIjh95NloS3z+w3oB?=
 =?us-ascii?Q?lVHpZxBwl9l9BrYBOCXWiQ3Hbmg9mUANQH5BFylhDdx5niVtH73r+wW4cBqw?=
 =?us-ascii?Q?FXKaKdrEjlmMkv9lher7VFxc/VNkwxEkvkZ06gMgftTe3tSf64bc0HRd/snY?=
 =?us-ascii?Q?n4yBWShOVkvyv7N/s6YyKqLVsw3FIqSSVQrZGMIMhzbHxiUaXODDJ2J0LJgm?=
 =?us-ascii?Q?YZCTN1HfJSCeWYZA1ZaLaVt6hG12YBsb1XoKCbKWCH/Nv6z/BcHuCue3NaEP?=
 =?us-ascii?Q?OAXp3ue3DlTaICXjW7auIuVY?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3b1cf1-7c7c-404d-690a-08d921c4c01b
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:37.1513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lf0Ajmknof4xcWSNMIlzhtL/K4iT9gbCbvw3gElINj2ZwEyUwSdg5k9UzS7Jw+h+U7xcrGsQAFXiP4Fr8Fc7cBRkiP4lal1z9kygtlAe+3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-GUID: j4KYjalWt4WGF_cb7oNxLG6BnY51XqyE
X-Proofpoint-ORIG-GUID: j4KYjalWt4WGF_cb7oNxLG6BnY51XqyE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280070
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit fb8d251ee2a6bf4d7f4af5548e9c8f4fb5f90402 upstream

This patch extends is_branch_taken() logic from JMP+K instructions
to JMP+X instructions.
Conditional branches are often done when src and dst registers
contain known scalars. In such case the verifier can follow
the branch that is going to be taken when program executes.
That speeds up the verification and is essential feature to support
bounded loops.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: drop is_jmp32 parameter from is_branch_taken() calls and
     adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f49f84b71a6b..275c1078d80b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4127,8 +4127,9 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	struct bpf_verifier_state *this_branch = env->cur_state;
 	struct bpf_verifier_state *other_branch;
 	struct bpf_reg_state *regs = this_branch->frame[this_branch->curframe]->regs;
-	struct bpf_reg_state *dst_reg, *other_branch_regs;
+	struct bpf_reg_state *dst_reg, *other_branch_regs, *src_reg = NULL;
 	u8 opcode = BPF_OP(insn->code);
+	int pred = -1;
 	int err;
 
 	if (opcode > BPF_JSLE) {
@@ -4152,6 +4153,7 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				insn->src_reg);
 			return -EACCES;
 		}
+		src_reg = &regs[insn->src_reg];
 	} else {
 		if (insn->src_reg != BPF_REG_0) {
 			verbose(env, "BPF_JMP uses reserved fields\n");
@@ -4166,19 +4168,21 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 
 	dst_reg = &regs[insn->dst_reg];
 
-	if (BPF_SRC(insn->code) == BPF_K) {
-		int pred = is_branch_taken(dst_reg, insn->imm, opcode);
-
-		if (pred == 1) {
-			 /* only follow the goto, ignore fall-through */
-			*insn_idx += insn->off;
-			return 0;
-		} else if (pred == 0) {
-			/* only follow fall-through branch, since
-			 * that's where the program will go
-			 */
-			return 0;
-		}
+	if (BPF_SRC(insn->code) == BPF_K)
+		pred = is_branch_taken(dst_reg, insn->imm, opcode);
+	else if (src_reg->type == SCALAR_VALUE &&
+		 tnum_is_const(src_reg->var_off))
+		pred = is_branch_taken(dst_reg, src_reg->var_off.value,
+				       opcode);
+	if (pred == 1) {
+		/* only follow the goto, ignore fall-through */
+		*insn_idx += insn->off;
+		return 0;
+	} else if (pred == 0) {
+		/* only follow fall-through branch, since
+		 * that's where the program will go
+		 */
+		return 0;
 	}
 
 	other_branch = push_stack(env, *insn_idx + insn->off + 1, *insn_idx,
-- 
2.17.1

