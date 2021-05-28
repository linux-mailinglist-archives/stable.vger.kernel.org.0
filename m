Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610D739412C
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhE1Kko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:44 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:51646 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236608AbhE1Kkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:37 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAclHu006603;
        Fri, 28 May 2021 10:38:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thqe8hkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1i9i9rqOriZdD2NpItcm0HMP3VUZO21LhDdcV0cNPIrNAVhnb+05AKEohLQXjZNgYcfyEUhO75OXaMmox+YpdGVPAVt6SzwS/K8Rwbych3UhZLSlnXHjJLrV3yvLavJBZZz3HaX1LTgQwiTkXVojMFByIyh87C6yVKrT1lkIESIOHl8zNS1gGfZY90SqT58okjVtVdstXAnggMAV7vldjbvGGyYTmx4hxswZyWEp70Ys0vnuqRrweA6gcy9LBLPZx3fr8tYijsUIPhoWLpiHhPIAwg6DD0hIyYoi1x32PZpjv0yFKD3IlT93tJscP7tJ+UtLW+B3u/EETCpDwhnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeHy7BDpf8VqCZ03gmsoKZm4AMG/N9rdMwBNZ6rocm4=;
 b=gYuyvUyF5QoIlRJbfcOO2m0s5iFfIoHzZYm7hP4VQzTiIu/VH2Fqgco/pJ1JW8JQa5inQzSwrvfQe2Wwm8xC2nnMYaLAzTFJYUKdnYd0Fm6lpjdwfqqtr9WsdHqP9pQCHAq26G/p/8crWFpv8eL/mjjzmDVFEJbs7uSKuDrQ+ISJpFfnAurBl1rnYyOxk71oR0WTHcNEWdy/5LUyr8IcAIHarmKc3eegJDyHQ87xHKhc+qzhC/n7ABiFw7Toa+QhDREj0/dxR/dLMdI/p8W8heC8reu/kFoETBZhnir4dinpwzQs79FaJpZO9dQJZMVXpF+5gws5xyGGkJ2bxcb0DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeHy7BDpf8VqCZ03gmsoKZm4AMG/N9rdMwBNZ6rocm4=;
 b=fIq7d2g8cM91qjGJfNQKCQ80gbLkf7ofnSEl1hjK3cW8qewRTARZmrsaXUuXaYoaOjGm0/FMKxWPUARmFtu0BqfkmetJWxEh9tgY/g0bftRUz9bTQbUE9vEVcSIB3JfDqk0yM73bIpQg3Dm7Rgcgq67ro46LDC2xpb6yvBMWZkQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:46 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:46 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 10/19] bpf: Rework ptr_limit into alu_limit and add common error path
Date:   Fri, 28 May 2021 13:38:01 +0300
Message-Id: <20210528103810.22025-11-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a29b8ad-0525-4c47-f891-08d921c4c585
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2097B1774FE30F4218F2FDB5FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gCt2mDGCYk/GtDydWZRjDzpevlq0IVxeycudx5G6RtwqIp3Z8LFEQs1sZKO5HHgkr41Xhho6FWg/7hkttctINQhGjwyIi7s4nJHt311CF1WiVbh2CWqsn4DbbVDbXsmc6zW5PaosI2H7YKHsk/HOxdm8nJx2xFrJ+DopFJF2fXnnnMXJM8suERhQgw8/ABvlWNYH8zLis071oa1BdrS/1WmgOWm+aNbm7gDCU+e//pGtVTURawUS2cIWfpcw8en7VO1X6HwM4WkK54efzNdGErMprEsk/IdQdG80CwidIyhq0pS2/UZG+FRKOly5R/7UEuS7sb6YvxurCDmUjm1jI+X1Y2N5e3FywxXbXWmM97iV/Y3dCGK2kiOr0INYa6sOx7jYtD8R1fWoNZltSsTICnNETHSLyXsvxd4A1jqrX71VsrMHqm/lFRgMKyn+cvZazcKmHzYxDVO+Owqe9VpMk88b3DSwqcp0HMwIEiRoivO2hdfEI4gpgo9uDSLC57EGxAVxOYPTB/NcGE9FeHKKQQy5AwE0GwAeyHQqcZs6CxMYnMJ/Haf3eGBPwSqsMiRSCuCh2y7C59NPazrZ9rs0Ip/M85jGffz23gy+yNDWa3Jlf93Ci8GkbE6fFRO4a3oAE/krknbvzPOn3C4E59w8Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IJXH/VQIJx5dwmoLl+BUrS39pXhWOKoFTZooWP/pM5BujXaypmPEVs8sZfd0?=
 =?us-ascii?Q?k8IqGwixA1kA8biZx3boYtLdarUMqojp2Ds+7ua9LtM83utq5pcqoD+5ps6F?=
 =?us-ascii?Q?LfJmk6RibPkE9IHkhpV7c/wgMmI3kd+Lxk3euDI9dP66KLkl76uq0XAJas5s?=
 =?us-ascii?Q?7pF6QCsxodFp1o3N0gMKd+35M3GC5pQZoj1gP4K4UepgF+N0cZkCxWFOY9Ef?=
 =?us-ascii?Q?PWMU7FlYO5fLGYDV0w3QfRXoK5ChpFs7AxX5JAlCnKwxsu6KOrW/6lrNYvlz?=
 =?us-ascii?Q?OwxzAAIhold+6eZ/S9GiVfbZdmMIHR9j6A0nWRjQYCsit0qCy/grfgUDrLR5?=
 =?us-ascii?Q?4UzrMsgWnFFYzuZbaiDmMyRwVHwj9it6aggAMhg9FiVlXYiYJr5pDVp46Ndp?=
 =?us-ascii?Q?nI7bTSOFVMTro4lCj0CDuuB4nq2mfc2W1sBLErMwvGomN1Z9BLz2B3C9hmQL?=
 =?us-ascii?Q?L1dA2LiBU8W2fQA281W9ybOR9KWaf4ckypaEiBlGBh60o8ntdKoe6ghJAKef?=
 =?us-ascii?Q?FbJl01Oi69mAd2Y8huSJ91DNOqRzwM5ffIbl9Q4lPC4pN8nDP0e9YpZUBSFm?=
 =?us-ascii?Q?tqbbwfEy7MJXtQwmmzxS5CvzcmdZQA0oKI/XsthLlOJeAgoq2CRFY23ZCInm?=
 =?us-ascii?Q?UoSRTL2S72zadCk8bI/bjBDp+h6yedhOVBIspnGt2d2jv1t6QNSDmr8l1JXs?=
 =?us-ascii?Q?HLp3znCy4vkJxTN+hcGkBekb0gK8Y3DCf1NZgSajW8q3o2M0/OurGetpfkCO?=
 =?us-ascii?Q?OH4KEjIbM5JxVgBM9Pvp/OFvV3xheSDqQDI4k89LocMswdkqVJ12AWPP1gku?=
 =?us-ascii?Q?vnAqgRayqhweXNYMPHgGZJAnKtBsDIKO1WZDnyAuJ8TccfVtbRKeKDNXlS0D?=
 =?us-ascii?Q?FEqQz4tuseiGrEuWWwYO34dZuKCv1ypG4B7nzFoz9Yw7UiKSBuI3s1EfXhW6?=
 =?us-ascii?Q?EfXsB2iqGrfAREVMicTDv0x9vHV8WFHU8p9ezDNY1LhS5Qx3oc7/TNWq1w9E?=
 =?us-ascii?Q?QyBraHRQiXzjmi07ZW5T6/I000oYceOv+uAdpCjTQ2Oc3JfoeBjuCCSlnjKp?=
 =?us-ascii?Q?ot3BnH1WIjN0gzZ8q0ZNl3U8nQKgzjjJCoLa8QBwcfCPdbMsiDxKYgah2NZT?=
 =?us-ascii?Q?H6nr+aaj0l51I82TO3lA/gI14uXn2VNcucowXxyfrbBhPJyupU9NWmLrq71Z?=
 =?us-ascii?Q?ZA7wwoATlfl642lps3CIM6/C4Jqtr6EM+otBRv24hpYi3f4FUQxpp1xBOepx?=
 =?us-ascii?Q?8Fw8npFVX1VfccQqgTyc4QvnyjeSTb+dUm4Mefnktc/6XcpF1ar/OGMg+rGP?=
 =?us-ascii?Q?cV8kPjPLjcnQf/fZnqYjdUhl?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a29b8ad-0525-4c47-f891-08d921c4c585
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:46.2363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7Q3lrv0q8b9ay/xMIEERwcdJ6kNxSz4ll1wIuRsc8cjA/TS2pCL5NaYVZntx99BVjO1/CbtmKirFtCPAQ9O1X1ozM1u714hd5SIhNlDVas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-GUID: wEKu88zW8MN5P3hm2_CsRrtjcDEfAx4M
X-Proofpoint-ORIG-GUID: wEKu88zW8MN5P3hm2_CsRrtjcDEfAx4M
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit b658bbb844e28f1862867f37e8ca11a8e2aa94a3 upstream.

Small refactor with no semantic changes in order to consolidate the max
ptr_limit boundary check.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cdef8c7769ef..adc833c6088f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2731,12 +2731,12 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 			      const struct bpf_reg_state *off_reg,
-			      u32 *ptr_limit, u8 opcode)
+			      u32 *alu_limit, u8 opcode)
 {
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off, max;
+	u32 off, max = 0, ptr_limit = 0;
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
@@ -2750,22 +2750,27 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 		max = MAX_BPF_STACK + mask_to_left;
 		off = ptr_reg->off + ptr_reg->var_off.value;
 		if (mask_to_left)
-			*ptr_limit = MAX_BPF_STACK + off;
+			ptr_limit = MAX_BPF_STACK + off;
 		else
-			*ptr_limit = -off - 1;
-		return *ptr_limit >= max ? -ERANGE : 0;
+			ptr_limit = -off - 1;
+		break;
 	case PTR_TO_MAP_VALUE:
 		max = ptr_reg->map_ptr->value_size;
 		if (mask_to_left) {
-			*ptr_limit = ptr_reg->umax_value + ptr_reg->off;
+			ptr_limit = ptr_reg->umax_value + ptr_reg->off;
 		} else {
 			off = ptr_reg->smin_value + ptr_reg->off;
-			*ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
+			ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
 		}
-		return *ptr_limit >= max ? -ERANGE : 0;
+		break;
 	default:
 		return -EINVAL;
 	}
+
+	if (ptr_limit >= max)
+		return -ERANGE;
+	*alu_limit = ptr_limit;
+	return 0;
 }
 
 static bool can_skip_alu_sanitation(const struct bpf_verifier_env *env,
-- 
2.17.1

