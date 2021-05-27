Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB113934F2
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhE0RkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:20 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:41520 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234993AbhE0RkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:19 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHYkAl026666;
        Thu, 27 May 2021 17:38:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmR0EfgvzIhP65p+/HMRafhrwrPp0seSQPrEnXk9UOItQbRAEaYa9Em68h1oYOt4GpGl9oS8e6YkcjL+XKE+zYvCGc+x6KfiEPG5aRmf5mOdfKtJuyZtdThtpL2mjBw8WJIiN/MyDerCAEvAQ/TeSP62rmTjnPs4nTAH0aYqmw0PtKJbTyY/xgQiq13PEotEmC0Zu7/6fJPdNHz7yRhn60k1NgD1n7uDj+3EyLpZlLnPWD0EjDRlkupj2kjb148RBltlciF/zwkwd3dNgBWRs0cciM4da9hme4JhMK0m194y8VK8pNpJPGzM1b+6DxLpA64ufwIdb4VkH3avZ35FsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oB7l4ohYEEKqe/xNDRSUxr5cBdViuvjOZRFNso6zMQ=;
 b=nktfbPBAWCT0rwHp8hyi+cYzoFrloQnYmqCs4nIIczOpWNDPIyoRZAJeViO0qRtH2t+JDEhHtae7tgcmIe+CbXEyxwjgJ7S6jyyfuZQYb8FTBoSRb6v+e4ajl++CSHuVzleg7+Z5zdjfxtLsXBQnciR3jCCDIVmv/m427QtTHLIv7JORRyq6zSPotpbWcZfB1sElcDMsvMCZ9SxCYNUrhYr66taF4Ggi37TP+Qa4OVLhyCdppUEO/NmGcv1M+yR7yINZOmLJGWM+h7vUQo8zUHYpw01Y8dMDcZbN35ApoovXbo+IwUAYZ67Pm/tXgsADRTmcSeK5E7MsE7+OAeM8bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oB7l4ohYEEKqe/xNDRSUxr5cBdViuvjOZRFNso6zMQ=;
 b=epuFlq+2CAlPn6DcL5KDTltpb863Fl39JLWhILlIdtJcAL7T5gQPEbFTbpDXvrt6wq0E5OZA5VgqoYv4E3LsSCzeYXh2uR9+V1fzB2fqOyy4V9h8rfbCG26kU70RPPyP3Ng3vXNyFPZtFgFmMR1vTSJEJEFh+rRAp8PQ2S63NhQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:30 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:30 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 05/12] bpf: Move off_reg into sanitize_ptr_alu
Date:   Thu, 27 May 2021 20:37:25 +0300
Message-Id: <20210527173732.20860-6-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 690ab26b-8950-4f0a-1735-08d921363dc7
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB21621B1E8EE5A2AD4CC4F343FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7oiIc5ugzHGp4brIO2TGqI+X1TVTPzxRCv0WVpxb9FYUWJenCj5jdha6HD5PbVxIcBOpRYcMxLJi7S/73jJgQue4VX5ha8gEpm25B0PY0IKc1xg26zvbjiubXmhEueqPWUQuu7G89/exNIYRq7S1xYv3nxcSoAMQ5lC3TWEPbO5m4fAIjqb4XZm6iM+B1fKtiwo/WCJ8jJGJHCBLXsvhdAY9if2SUW35I8bwUijWsi8cVsYpkXANK8O7ygFYd6sA1MTfg5JvZYacntAqZt8sOnJbaWqy6jt+HUHUhaK1SwI+G+V+eQTouZ48EF7ygTT/3/V8CIm5V+UoE0+1otAivkW/MSKunOu1030dgu4LsVvl5vEucSVNOeQDBiq6CNQY5MQAYATGgjEB+pR7p9xQRF/GQst4fU4o+ExuscXyXqlo3tBlEsnL7JXLoTLIqkMRkNUbeVGnaHP4CqQu9t+8TMHSUk64NMpgvBk3dpdffzKrSXrwGiEchKfW2y561f++iybqfuoPofhs3phI/FPkHih9tbnpvxXSyTPiQ6iF6eT4J5sHdrjFYM1RFFFhqh/kiZEDrr4m/TxtPjc6/M0QZR8aBBUp+ROtRh9W3nR235sVAySGgcn/rA5+VO9L3uSuf4JH8qpC3W5oj/pfNyPvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ecWHeHFKwYBVP7TEqK0feUMrXHWziDkZqIXCLdfi+t78BqXDSoRwsQw1cOAO?=
 =?us-ascii?Q?KZXFwUHeaQs2x0wJCZzRnyDh4HON2gQ30E8A7btlaEl6Y9ckA0i3+/CCUrZe?=
 =?us-ascii?Q?ttfyrdmv4evZrKlXuX6d/ckjFHq33w6t5sLTHPndg7BV0Kg9OsPZJmsmjYst?=
 =?us-ascii?Q?+6wW06ywlJ41bEeJEppsRekBWfFaVA/U6BXTILuM2IuN7GDWxkFxpIVWvYGn?=
 =?us-ascii?Q?xaA3kw2z7ecNqYn+eLSAicp8FzeJnXblrFzLrXUHwzkEpzU1LV5FvLa8a6jA?=
 =?us-ascii?Q?4HMHpkzc1f//4WEdAPaR73WkYyOuzbnyznEup6nU55leSHwzG4q65EC0XbDi?=
 =?us-ascii?Q?SHaIzx1pYpJBianf6cnTM43AHdi9xloiy5pviuP6GkyaNzSUmMYjoXhghjk2?=
 =?us-ascii?Q?ZSz+4WM2J0DOGTL+FN59gKzcnm7vpL9k+ZOFDDC7mf5N2nBo7JgfXgbUtMnu?=
 =?us-ascii?Q?YG3LWjYpXOCDUPmyz96DFrFvCWFuqMj7Du0dKaIGS0z2KrW7h6118q3oFqK6?=
 =?us-ascii?Q?k44Xh9vpi+h0Ok90B5gw3kE3lcId8rO1Jy3Kp2F7F11cmsxmBm/nIygLsVkm?=
 =?us-ascii?Q?8yH99Rm6kadVVJRK0/xtY9ZWWwiRr9KxK6EHGUHyO0XPtv9gKHiwfR3wKPxj?=
 =?us-ascii?Q?6vdb65Vjnmr/mADKWtlaeT1Q6QuXbu3+ELcRHS5OivU9LDvjgeAboDSryLP7?=
 =?us-ascii?Q?Mv9DJevPoRYLQ9/TRTIZoW+x+u9cDPNCEUsUdlKXVKYW887zj2764kZ20WIY?=
 =?us-ascii?Q?8QB/8bDCzWetc+r55xfN3W1ys9ZvnzPajjKipcTNlwAyCQGQbPsLNZdiLk45?=
 =?us-ascii?Q?KIHvMPmfVEGTOVD2QdEx50Ogm+dWFc2qsyKRPgNKr2voj9+m8MSxubTDuasz?=
 =?us-ascii?Q?zFTVU56LSyzOj05cHFrNjlGrY2MM6qc01im3AgOBNPIgZnPmGTksX0vzNTIp?=
 =?us-ascii?Q?GVYerEk3SPqohhi6BU816SHvAaFvQuJFN1Pp+F3h4e3wz3DY8z+m37eO33Hi?=
 =?us-ascii?Q?yDTW25EZJjkvdafID/fjRSUtihcsZsSWxPjSVEYMa0+Y2DhOZrxOr6iylkYP?=
 =?us-ascii?Q?vAGnlfc3b3PmYND0gThewlOZKQKdEzrjHRh2mPpK6PKzQrdA/7Y3foUOovt8?=
 =?us-ascii?Q?xuTnnwYR1UgdjRLcbY+DL7L0jVBvbtGKlO/RKJmtLtd1DZPwliG33oYMf6aH?=
 =?us-ascii?Q?K17oTllXDTYnRA1UhcvAKrpRRqNcGtRTbq28qIQoviuVcZ6DkgAUB0CxZkFq?=
 =?us-ascii?Q?svvAP0ql6Qo7HmU/OmZ2bA2tW/+swXtq9oRUMqLcNwuFBDpVW5vPIFm0RCfv?=
 =?us-ascii?Q?CFKBNdOFwqKVhAiV8YokAT2O?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 690ab26b-8950-4f0a-1735-08d921363dc7
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:29.9893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VE9akwG6UMZYSJFWJCehRYa9Rcy7DWdfX74TVPhbT5S7Jrd0yb5qoSM1IcY0LiByRlP3v2nVh34j0jtfEKt6Y7xti8gUeyyQWwkwNzY86+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: 8ffxnmoa8rLNcIAsQ3rebppS1iwyfoR2
X-Proofpoint-GUID: 8ffxnmoa8rLNcIAsQ3rebppS1iwyfoR2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 6f55b2f2a1178856c19bbce2f71449926e731914 upstream.

Small refactor to drag off_reg into sanitize_ptr_alu(), so we later on can
use off_reg for generalizing some of the checks for all pointer types.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f49f84b71a6b..5e0646efac6d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2799,11 +2799,12 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
-			    struct bpf_reg_state *dst_reg,
-			    bool off_is_neg)
+			    const struct bpf_reg_state *off_reg,
+			    struct bpf_reg_state *dst_reg)
 {
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_insn_aux_data *aux = cur_aux(env);
+	bool off_is_neg = off_reg->smin_value < 0;
 	bool ptr_is_dst_reg = ptr_reg == dst_reg;
 	u8 opcode = BPF_OP(insn->code);
 	u32 alu_state, alu_limit;
@@ -2927,7 +2928,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 
 	switch (opcode) {
 	case BPF_ADD:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to add from different maps, paths, or prohibited types\n", dst);
 			return ret;
@@ -2982,7 +2983,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
+		ret = sanitize_ptr_alu(env, insn, ptr_reg, off_reg, dst_reg);
 		if (ret < 0) {
 			verbose(env, "R%d tried to sub from different maps, paths, or prohibited types\n", dst);
 			return ret;
-- 
2.17.1

