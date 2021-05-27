Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3286D3934F6
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhE0RkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:22 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:44036 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235115AbhE0RkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:21 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHXKjn026033;
        Thu, 27 May 2021 17:38:33 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9ZUQjAb0ih1hhGUQAUlVXsB/7LHu+YYyCoiGQaTJFu4zwi0gwso3+yXa5PFA/GhKYSDAp0effnbn6APwMZevFF6wEjoO4qOz8MDKIiLBrO3+WVwdtcEGvr7VoSMNmSi37qCvjsSS5PrbMGSz8NNP5WYbRCLMHMX+DA22pZ4c34dPKsVj15lP3yV54BawVEs8vCJ4PuZueaphpTORFn1brqSiwtsxhT6YcacsxPz77yMWORBV+riEAWjvsYn8q5udKboUBLbzH3oJtAAI+z7En9SO1gXuNcx2xlWBUfDcP60KJ3vdh2d+guASUAn/VUHxvkhw0xTpgu2PT+RrEHzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YH7N7ascT3mSxquf9afBJ3d6TXAPiM8v6/dUIgma1XA=;
 b=g2M2SRPi2wJAp3SBtAZkuSU/hNFodeQtxEx9sjubpAjIgmYJIa7cZQUvli9jAX3zTXf+HiyQojMZB0IS8k/HayaLRqMe4PxctvFOTI6tjUgxR8BfPsjen5gBerYq6Dq5Kcp3/P+d5tgVzXh67dHnZuCIXyTJtIhoZsfYijzOLeZl1ubE7kLpOstviC49/UTWBIZV6fpNVfF7FD8D+u2qMiHVfvXLWlyYzXc7L/Z401tVbj6bQgKsFgwTdzeVLO6AWmXdQckoUojuGNEMHR1FVfw7TzpYa0lAobnnc4sG+XSssD+lWoYzv2cBvkIjFR1cI4nVjlsoLASidlaBI/rm0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YH7N7ascT3mSxquf9afBJ3d6TXAPiM8v6/dUIgma1XA=;
 b=Q4QHiCpbULRVULJuv4oeyRhfXCVxVGvRahQHj1TQwvRIn4u+cAedce94zy/S8cSSwvHgG0jFv+Kmyib6AmWnLrviSGMYI2zNtINCZmpVNu3ivt+wT+sfXCRCMPYb4ZpBl9pJbTHtEmiYxxvk+C0dc1NcmoTSRyaw0ARpobtWu2U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:32 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:32 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 06/12] bpf: Ensure off_reg has no mixed signed bounds for all types
Date:   Thu, 27 May 2021 20:37:26 +0300
Message-Id: <20210527173732.20860-7-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71bca934-4c93-47a5-7d9f-08d921363ee0
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162620B470CC784F94D3B41FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+5amRRD+wJAMEvwxxclOCrT90U8Zess3ib8XxUCZ7Fce4ytfEbIKo5sEjDBP7YWw0UKPp1v4CeotPouirhHnubQcq4DA3QdnK+wVqELsCop5j2uVEr8NKvobDISSawNtmuz2tVxzVrcI2g/IRLf+ejOJFoJ/uZpSKqR3suMnyeDMA6R3nPdgQSmWhoi/pWdoPQeJzeoqI8BKGWfDWIU2PHlV62Hr/o5bvny18q9h0Od7kMsljlGBNec6ZbE5prbsphLIyka1zPV3sD+PSaNPJNvlcLpINQGsJ3tIMbssSeLBO5SQzUxTloqbJeKWy/6OYv+NBcSM4fAl/BJ+/oOhJqp8//Yzkswes2VGmcdj9n3GHyMW4aUYlHiniTy9ZcOHfcZjf0aA95QT+rPvYt6eChyHupLzMrzBSO5mFcPuM54gAJ7cdBxVr24GOkL22+cwm86801LuqtqWhsoI5qJkLJGKTeTy6W0FwP/ZMrEZyyVXnVvGvsZNHbCaNar3SzGKb1wDonq0zQ21CehTH2dikNpdESdru89r3EIwDqDHPG8gS8ZMIw+PxDDaZ/rqhAdurTM4ad6MgmNm2tnE13mISBG4H6d7TkpwxccN2N+Fq9GC9S/yrwn+N9YuBlBSX6EmOQAYI4EGrDMzzCb0bNEQYLnuR7YAzoruP+kGzgShDI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a/Q20X8PQJIHlJqt9ViIsI01Hs9KSXydeLBqh1BsikbiymEnWJxX+9eVgMox?=
 =?us-ascii?Q?6xKf/N46cDaB/HxmzM7Z5o9vVxEBi7y9N0H/SGR8fXJqplSv095ExLW2wSHZ?=
 =?us-ascii?Q?jgTypjCeBDNjvVxljSmMWmnOYxQ7IzaBWfb/84cokTu9pr00j58Xmsvj54XS?=
 =?us-ascii?Q?lOGeqeFN2VKunV7524127Ck/R7Qf0qi3F4B+zxE8lBippcbD4SrZy1+V8dr0?=
 =?us-ascii?Q?aq+k1MxL3UJFOni+qhwIxvKDUySaXTVWSKDMXB8rNtEdQ21r3BDoRRohpdZm?=
 =?us-ascii?Q?xoNomEf3YjrIbQ+tWrNkyHGJ3Lm/amRTp2xRpWBEaxt7tgS/1zkocz9qIytS?=
 =?us-ascii?Q?rSVhsYtMWiumSbvU3wr810VXDKjg9Bqja5mAWM1ciala9HcIfcwTOd/I0rTw?=
 =?us-ascii?Q?fr/i27SKOx9/47wT/sigsAUvGqgPBfTzhZTb9mxGJZmVeCfsUE4b34l5nh6P?=
 =?us-ascii?Q?amxDn/TanDV6Kkc/EBgZovyNDn429rc0Wdh25LhbSSpkZoRCxLOrVmyrucng?=
 =?us-ascii?Q?UviGJBntTSwflL34Aatt+QSxo+v78VWAdAT5MXWf/BOJPgKPDrCUHNunB+eN?=
 =?us-ascii?Q?/yxiK7FYuHgZcpJVOm/Be8PT9fzxe3GrzbHhv3vjZQxIWlTywHktHoU05KmG?=
 =?us-ascii?Q?xukk11L5h/AvSriGqCI5gVIquXDRsUmb+jCySrdAFkVm5i7zhFUEE5QzNBqG?=
 =?us-ascii?Q?a6UFAc9sUkSGWx2bPGv/Sae/f/R/Xa5KBIbn4i9qXvUyb4ym4ye5XdRzuh74?=
 =?us-ascii?Q?NRfurvvoNP4abZDegQ6DwVIFveUpYMxai8L9YSWYht13xThhY7GJ/wzct3J0?=
 =?us-ascii?Q?Xs48p1kCyjfUGC2q7xZ+cP9Yd4GyrRW1M2dSu+4ORxgxep6kGVjB7p+7W1uv?=
 =?us-ascii?Q?VMO1WbhyK+K2xmpcDmxDnyNq/LPJ0sAybdLnUwU5WsSREzrU2DFyjwzPThft?=
 =?us-ascii?Q?I/hKQkCixgyyvNugYjKGmEq/4c9mR2AaFetG5EXAnuVYBbuylXKemZm+A6rh?=
 =?us-ascii?Q?p4IPLI04z7/O35CBWlrtc77dQrK2TnfpvepYrARIQKUbOvKkDWlTr7N+/X7N?=
 =?us-ascii?Q?3Nf18rieGCX4IW7AaDIwWW8RmSJDXvm+7HoQXVszvyDZXpn1jdGI4H1bEs3R?=
 =?us-ascii?Q?2gpK70BM+C81/X70KvuaRVawo/rGPrHsEkSklQMcshZq54ClglosCb/BV3RQ?=
 =?us-ascii?Q?Fk6PT+Qlv4G4VkLw8IszEQIZuMfQL6UVAAVhbAqIQbNd3yAjyVsKUbPbVRlA?=
 =?us-ascii?Q?41x4yK58293+9hiRqzxXWDJe8SqSMJwOAUhFBVL4DWEG7x4HW1yrT8asmbit?=
 =?us-ascii?Q?6APQuceECGEZNM/9NUCEm9fA?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71bca934-4c93-47a5-7d9f-08d921363ee0
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:31.8425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SEh20vdv8JAVpiKneiMuvM85Y7UZEgoxclFSwMXeQrykgYVbpvbQhtFqnpyuSdK6xCn/pVwmUH4rp+q9s7H9KagpnHdpcRgUAtRa0ccBMBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: S_bThrzegktHAeL9yEs_uxn7gBUnOFJy
X-Proofpoint-GUID: S_bThrzegktHAeL9yEs_uxn7gBUnOFJy
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

commit 24c109bb1537c12c02aeed2d51a347b4d6a9b76e upstream.

The mixed signed bounds check really belongs into retrieve_ptr_limit()
instead of outside of it in adjust_ptr_min_max_vals(). The reason is
that this check is not tied to PTR_TO_MAP_VALUE only, but to all pointer
types that we handle in retrieve_ptr_limit() and given errors from the latter
propagate back to adjust_ptr_min_max_vals() and lead to rejection of the
program, it's a better place to reside to avoid anything slipping through
for future types. The reason why we must reject such off_reg is that we
otherwise would not be able to derive a mask, see details in 9d7eceede769
("bpf: restrict unknown scalars of mixed signed bounds for unprivileged").

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5e0646efac6d..b260bcc7215f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2730,12 +2730,18 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 }
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
-			      u32 *ptr_limit, u8 opcode, bool off_is_neg)
+			      const struct bpf_reg_state *off_reg,
+			      u32 *ptr_limit, u8 opcode)
 {
+	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
 	u32 off, max;
 
+	if (!tnum_is_const(off_reg->var_off) &&
+	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
+		return -EACCES;
+
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
@@ -2826,7 +2832,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
@@ -2871,8 +2877,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	u32 dst = insn->dst_reg, src = insn->src_reg;
 	u8 opcode = BPF_OP(insn->code);
+	u32 dst = insn->dst_reg;
 	int ret;
 
 	dst_reg = &regs[dst];
@@ -2909,12 +2915,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst);
 		return -EACCES;
 	}
-	if (ptr_reg->type == PTR_TO_MAP_VALUE &&
-	    !env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-		verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-			off_reg == dst_reg ? dst : src);
-		return -EACCES;
-	}
 
 	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
 	 * The id may be overwritten later if we create a new variable offset.
-- 
2.17.1

