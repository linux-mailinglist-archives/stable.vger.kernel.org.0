Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398DD39413B
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhE1KlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:02 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:9986 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236568AbhE1Kkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:51 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SATXsK032286;
        Fri, 28 May 2021 03:39:02 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thst8j2t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:39:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxnKhFvASJ7zlG5lmaO+ThaJpkVz+9XixTrEPprScfePXFSgY/ziZ3al0tkmkWSdRWteP7SF2ZzLAhQYJBXx9JnQcarOboxhR8oJnm6COerAqI4mXpHMhba29pYgiH86178d/9TgMIr0K4ieIvKAQkf2qSIOveeQ86oP7/y3nu8KIXN5xC46BV2P570B8CPXjpfTkWZHUG/BtUgNbGL8WQs3iWYAprz7SeOUvKfvnyqQztEIqaJPGojRewpfy/Rosq6F33zyOKh+73eq/wbANQ/UdiobHaeU1jyb8gG6CMFWd3cwXnf2UqJjjZG8s0n7b0jb9YXd+IV8HzyApMsFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHcFPuAMMDV/ZnIAKCylstHCQbbL55ePJfz0bj2KIqI=;
 b=Yf/bySR4KjetwRS1JNTm+J3Flx7Ps1A3vhYrFBE3Nb6v4oEnPNcwE3iBsN1q7Nfc7RwsH09hA/wo6WvPsikedVi0SE9MvvcxbEDNHhoMa58MjWw2keY6ntW8SwUEfqBv/8Mw2BTToR14JsqGsr2Zmg6oKmJV09yLeIs+TNOFqe66WFnNiCd0SZUnm6rpPJRAYUqCV6o2Q2v4HYQ3ksvPopOKPzD+AU9upcl4u2v2Jv+ICkQk3GRprFI5GSYXe45fHEofcvDsli5/iyG/jikAC+7moi+KCHJcVAnRdM7eQrtPiHvUgL7BGq3Y/puGu3cJsDeJDSIteva8ToiasznTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHcFPuAMMDV/ZnIAKCylstHCQbbL55ePJfz0bj2KIqI=;
 b=ibOiMl52a/YWmFBqKu5C7iUblbZXreHkD6C7cnXEzquFt8yfphvwGCFNQr7cJ2I16L5x+m1OEU2+ROgoUEtHQYyh+C8o9DCAfp+uU4Tl64dnPCOIi80ap6s3B2DVtQrsKH2Wx+2svxGkdZLgYZY7sBCnSKMaHu/TGAi1W+WKmMg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:39:01 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:39:00 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 18/19] bpf: Fix mask direction swap upon off reg sign change
Date:   Fri, 28 May 2021 13:38:09 +0300
Message-Id: <20210528103810.22025-19-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38defe8e-fac4-4fbd-16d4-08d921c4ce2e
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB3780BAA580F9A5B7EF74E945FE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/W6HKkSNDynMkdtDuumF0RPZJQp4GblGZLaAUbtYn57Efr25iyUKAC0hrbGmm+usYIeIfyrWH61Qro0VV7GW+YijeCwoFjuIygNnQJbc/AEldiwv04+DWZDJfomQ/8oLqO3qRN544SdcX6ZdeYsrff0RetNjLmDTp/kpGQq3Vgb4vxBLsenFmjSpxAATwpetXZUxHKZKbD/VToO+lqA2rWj2WT44GO2rkzj3B/QrvBMM6ZrgBbqtT6M53beDjSLtJ+4N1T6h54A/AyVeZzaKiK36YTHbEslm0UPgukO3UIwaNatP3IVG1uuZ1hlqIpn0DWVJ8ELzsiIlFSXkPOHM3buOl5FMpK4amc7qelnMIaadbl5I8PgJYhGrZ81bm17+uGjlenVCFb4SnFVvZP6sb8MlV0fKLBxF/iedpqsdhXDtzw2plimRCRrs3hXog0qH2zmaqnCSjmnGYaYUgnrkbeymREiioEVfg40o440g36I30zZMNUPSY4PZluJ3m2dUurkHHN+LI1O0/u8jqkkKZhY2s+eQETQM3ph6Yq/KCIuS7KVzh2DuiZ/ni+CC2d/TC2fk4irpdKrWp1xO6703EtERom/56ZKAOrpBlbIeYdMVOw7TXaGTQWiuMhQVhXjJVc2E9Bd3IXo2fV1dX6epUcK9HJl7hDnBm9xwthR4ig=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+JSI8+q828x166Z8uSASK0cTw88EPwelutNeAvdg2v8wxlazldB5Jz3Ta/XI?=
 =?us-ascii?Q?3B3asaTmOaYTCo6hq6wYstcJCTEQaMRgeZR6YZKeZNQPPLPNiL6bfUYJajoq?=
 =?us-ascii?Q?FuFTwPYXFciuGAVvASQcMZ8Yc5XU7R4ma1QyLW0t6JXjjtxKJ1daf1dm37Pi?=
 =?us-ascii?Q?GADmiYh9ynabxo3T1SSe8O0QoLA2xpwRnF905ka3O3hl1msVNUTCMHlWXNNa?=
 =?us-ascii?Q?57BCw5vruMroo1dG1dCekKPHo3sSBiify9mZRUTFBxi2tmO7zoRX356rUptD?=
 =?us-ascii?Q?h6JPvq2DrxhNtVe2qFTU6NFvKTnBmEzFeur9JTG6wjnTOm3zwtEW6jaUzShg?=
 =?us-ascii?Q?BO7rEIQAc/PDYrj8iS4GrvvcEptjsuzv9mAgkKF+lDWWHREpkgWdOOrDmGtr?=
 =?us-ascii?Q?Vx0m+ST/VNWvDnr1ZlaFByGfrj6yunNynicT94U9dHOhr4d6312TlQalL1av?=
 =?us-ascii?Q?V33ks0fjMz2Cn5NGba3jYVRYRTKc2uOcPfdX/xTGlEZ00iePR5SYyuxWjO2S?=
 =?us-ascii?Q?A+OvBFjOmiFbsU6rTPGNjdQmEB08PN5Z/GYxSxsbIkXm6qklgm8YT3WcjAgz?=
 =?us-ascii?Q?CnmXQRhx8hzFRGYcr3KN8O/uiqIlG6OWA1AjjQnnAkkg1NrSZmVsM0Jp+qXM?=
 =?us-ascii?Q?vuvLhOXwtnzWQE94EEYfTATia2bfkSn8vTQCAlP8nIVoox64Y3uBDm86n2Ge?=
 =?us-ascii?Q?t3Q3ZXiIJ87OQFDVgJWyTAT7KWtPuonL4/Tge3CNsHsflRwYPPTAPdHArlUE?=
 =?us-ascii?Q?LuoxGSuo2tUO+Xepb2lzTM7NiI/iJL5tqCLpNu18sNZmntrFbORdfc6U6NGw?=
 =?us-ascii?Q?TNqCn+QtBZdbgGXglM7wGbMdOaeB5AUxAasoRty3i21cdz7OJhdjC4V3KUVF?=
 =?us-ascii?Q?OJ34xunu4J8KAemaXsOhlBsCk3zO6qrJpIdX/A+Cl1U9YOPrjdWcxKIU0h6f?=
 =?us-ascii?Q?WsSGxys1JcwHm15Kd/wnHzjlUhR6iheUgEY6ZyoMhCXklclsAQyCrTfYemp2?=
 =?us-ascii?Q?ZtZuzTbEWEuQ3pzheEdqQux5sTEgPuDxwCYEaoFabGNkMJkqMGTCeePPBjY7?=
 =?us-ascii?Q?UPC/8z/XrpdMuRKBAZ1gPbGf/ogoC5/V5BzT9fdLllDHIBoKb9j2+tkiqR/9?=
 =?us-ascii?Q?Xe46b1yv60MP+o2FoltLN4zj6ezbvpNwhvWQUV4Dzz2UeXk0BzvMMuUSviF5?=
 =?us-ascii?Q?+8dg66wDKKOz10ol7XFDQjTX6XyvtMRNWsytOXN6VggRYyw1YfWqabIwbDgO?=
 =?us-ascii?Q?VCct18+hqG+36VnluTLADjtPMnJ611iTYjFkZSL2CsnUZvq4a2KNP0r8nz+V?=
 =?us-ascii?Q?BB1bch9tGVD6OfNl7vWnAd1D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38defe8e-fac4-4fbd-16d4-08d921c4ce2e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:39:00.7668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QKEVgF+njCiwzAxLPR/5+zvsBQn5HFxofIbl7/xWrBI7IWIic9APpvuYGBQdDWakGyxiNFx4zQIuRt+G38kYNrsLODi/PadzTYDbQEVTjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: vXTqp03tjmmWQsR1MEaUnRNJqyZaTDNo
X-Proofpoint-GUID: vXTqp03tjmmWQsR1MEaUnRNJqyZaTDNo
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

commit bb01a1bba579b4b1c5566af24d95f1767859771e upstream

Masking direction as indicated via mask_to_left is considered to be
calculated once and then used to derive pointer limits. Thus, this
needs to be placed into bpf_sanitize_info instead so we can pass it
to sanitize_ptr_alu() call after the pointer move. Piotr noticed a
corner case where the off reg causes masking direction change which
then results in an incorrect final aux->alu_limit.

Fixes: 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask")
Reported-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0066ea8ecdaa..a235342507a8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2738,18 +2738,10 @@ enum {
 };
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
-			      const struct bpf_reg_state *off_reg,
-			      u32 *alu_limit, u8 opcode)
+			      u32 *alu_limit, bool mask_to_left)
 {
-	bool off_is_neg = off_reg->smin_value < 0;
-	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
-			    (opcode == BPF_SUB && !off_is_neg);
 	u32 max = 0, ptr_limit = 0;
 
-	if (!tnum_is_const(off_reg->var_off) &&
-	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
-		return REASON_BOUNDS;
-
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
@@ -2817,6 +2809,7 @@ static bool sanitize_needed(u8 opcode)
 
 struct bpf_sanitize_info {
 	struct bpf_insn_aux_data aux;
+	bool mask_to_left;
 };
 
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
@@ -2848,7 +2841,16 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	if (vstate->speculative)
 		goto do_sim;
 
-	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
+	if (!commit_window) {
+		if (!tnum_is_const(off_reg->var_off) &&
+		    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
+			return REASON_BOUNDS;
+
+		info->mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
+				     (opcode == BPF_SUB && !off_is_neg);
+	}
+
+	err = retrieve_ptr_limit(ptr_reg, &alu_limit, info->mask_to_left);
 	if (err < 0)
 		return err;
 
-- 
2.17.1

