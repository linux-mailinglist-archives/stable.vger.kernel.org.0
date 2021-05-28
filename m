Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B2394130
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhE1Kk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:57 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:2948 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236486AbhE1Kko (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:44 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SActBG010271;
        Fri, 28 May 2021 03:38:55 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY3ynFpavXy4MCycyazpARc/v3A8GiOSzgTs2YoI4A3lkOH7A2iT19alLbmHTAK5YJnQVNodYuKJDb9ctBtqhdljZWXerd4k1IU9hoEeDs0YJWstjmzhJia1dJmN3oVfNFCpLDrSHEaSF667rcndDKN1kJeV2UMSR0gEuky1OFYUyuSSBWSLOm7Af755nqkifKVt70Ht4hUEw0i9A7Z9thKSWgPZGcjHDxCWRsM0xLuXXxnBYgeYbiRiryyncFS2k1XQWoy549hFmOPEq6S2RFGqjMS8uQY67gi0ivEwJ5cEAms7Uy+bSkLEtrIHnR3LchpW3BsyhaKgklf6y0NFMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6bcr47je2zNKmK0Gr9jLC9NZjzh7ZJ23C5ts7hRMic=;
 b=L99GT81TGZNKGcBx6zooDVWe/8X5H0PMeyRoU1HrJ7xQ+D8sIrBMH0Y2OtC/+3J5KJwJrk+EHd6B4Q/RbkfSk6z7Qn+cl0VdJWK3Y5P8cOeUvE82HOaI8fU/X6kuPj+KvBeNteKDLHRfKQA+MHitkUbUh9Ttobog8yZ637+N2mkPB9WB4N9hJuiJswOqwLni6SBvzmik3bGRg6byHLlaqgymW3CbZoN1EsUAPAgZDZ3HSV4fAkgcuQJqwx+AeWyF5fplKl/m1h1FMkD9ewbIWTLAf3NN5ewpj/G3Oxv2ajyglReuqpo5DVfJVWCDU4Ic2e6O4mGsN4HqyBXSn9UxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6bcr47je2zNKmK0Gr9jLC9NZjzh7ZJ23C5ts7hRMic=;
 b=TFHkAsXzuDhwAs9lLRonI6LYRLT69mef6xK+rIaQptAVQxypjYDVPBPOS3KahCXVWXHe2fTMx29SqnWDxx+MivgUe5LhcF8y/lFEfcWQbgFHj6/kSsVUIfjgFhZDkMs8U7bm0/u4mKwByo9sa/1y7yDfo2nWuMkmJjW6ZEkkJ/E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:50 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:50 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 12/19] bpf: Refactor and streamline bounds check into helper
Date:   Fri, 28 May 2021 13:38:03 +0300
Message-Id: <20210528103810.22025-13-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e7590e5-ddd5-4301-afd7-08d921c4c7b0
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB378002E437E880D725F2CDFDFE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcZKHNhnCsMNMPEnp7sMLvV1SZRX73MRcvMWYMoI9kZsdi13WFr+Ow2N06cwxZYxBEmhVvudZUblUccz1deDW0uJ/b8tUO42mPNzKQZzxsRS8iBGNHzGbWkV7occwWxSouesanAkythCwwYZoYyEv6hew+O+EiIdywW3t0D++117+oqWKWhPaXFyXEu9RjeQu/Cgv7SUK+QWA5m3z+KaCRzeSM8RJfUCBIQm8m5Gy6iomQ9Gc8JcGVRwKWwcqlCFSGS0ZuCFEzHHotzFHr4sH0wkqg3E6T6oqRthq4xzJ68mVQejNXcrgs4n/MWI5nn23fC84twTM4+dNKzIywHqn7Fu15VbeBwLxj9EtvG2nw1/q70DGq7aiVA5mSjobbvhqhXb4DQz7U67QtJW4pxbmh8dCh+nUh/NwMuazF2IgqsK2z+awEhGFWBx9gsPYUoE1b3DmhNLg1PElbJ2HtRFrUV4UZDx50qPqMXjp8UEtEsAE/mbkPzOgOrmU4liuNV4TF7EOygEgwKmdAGiaFdBSFSAbj2kfPGO500jzIisrraajm/CyZYWE9JVnUXtpZb5DRP8A5UefWNCh5Y36JENoH8ksMD1JjIs/EOa1xigQttlfVA5rTmX4K4Bc9hILUg+Zrq6ezd4E/EvhdWRKImugVVAXy0608P1ehRAbYFMQhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TLo2CxyrIWsvQ1xhhyJFtdFJW7apIGtqTkI95f8LJZhEVtcF85ljmer/Qrrn?=
 =?us-ascii?Q?1j7r7ZaescNqk7iiz1vvoR0IRH4L7N/FWTEexuatT1gtQA2iuksN0f4POU1t?=
 =?us-ascii?Q?9EAnKhjILNirN94pm2r9AdxsHUKre5sXQvjCBr9lOj6UDIyKxlUatXsD2tKk?=
 =?us-ascii?Q?mZo3PCDPRhXEY8/ZoNglMclPQ/wbGQ6zr3CCnQ/Pi261nS35SSmT/4Kp3x/i?=
 =?us-ascii?Q?771wQgTLcAo+TymA82Ojkf3gPCfG5xWFDQs0kDwE6hEha2NeKxQQEiIORvGV?=
 =?us-ascii?Q?0REOK/xQKgCapC91jqWk6n4BOLCAF6gRtbJyTay3oSGMFdiur+tG3AfDh/5M?=
 =?us-ascii?Q?F/8J5+6nipnKWfZyy/ibBDdU0wJH3lAhmdcmplGko6wzdH+QRWrDzmmUOz9E?=
 =?us-ascii?Q?0rejn85+pKthjTIMAJf+Qf5OCyQkAstu2eJdmw70pk3dyr9pqItTsIQ3z2mT?=
 =?us-ascii?Q?aju+AAGsvHP2Lpc9ZICUrVSRxywUJoQu8qPqFGzE721vqJIjnnenkwbzG1sq?=
 =?us-ascii?Q?3xGdJkDO02W2SDdaBFFBx2xsenMUtATYLhFNSf4UUatUozUF4czCU77JsCxU?=
 =?us-ascii?Q?CdRt3vUVVVuwij1uqYuZHbBvUX4R4FdIQ/dafTfEiZMqbKiob2ke2265HEY5?=
 =?us-ascii?Q?P+xirvi2YNvyOJa/qtht8cN0MBlVI46WgyX37XILIpxCmYqHQcZyJI/jF+yM?=
 =?us-ascii?Q?DRXFkN2hkx6sBe621raJIEyaEGZmt4gcGisAw4s7cgoprvEYDOwdv3elQX5c?=
 =?us-ascii?Q?m0BzFL3kzJNQeGTm6nnPh++2L7Pcd5FcHiDZRaQmExU1pmeEIc1AEw4gciqu?=
 =?us-ascii?Q?crj100svhoCQE8JUzpGtEVMwFoW4v5fD96pxGubvQiqUPq6OhQcTS55I/dTE?=
 =?us-ascii?Q?i8KMlr6+vrWH8V7goXLuObJDeqV/ot1KMLVhJE7llvFUI9t7K9nsOZ+Fqqza?=
 =?us-ascii?Q?kD7SQqx/kkYBVb3/1pWQexxpzaAUkoMk3zSvZsyJAr/6oCEFSUMiY9+istFK?=
 =?us-ascii?Q?g7CIdjAR0CX3q9hUR127YCKe2bcz6anduvnY6HMITydVwOYa4/d2OhOrFOSt?=
 =?us-ascii?Q?DpePQB84cpFg271pLiECpq05jWy+L3TKgC95+s5MVLgo++02u7W6ftIJ2d1C?=
 =?us-ascii?Q?aXzm0SKOFZp5zfjpGYy7GWdBy4VP6fIKTdMj/gHiIB34fsk6dq8iHY9NZq6v?=
 =?us-ascii?Q?xdCk3i0ch+n7VqOYHBgxeG6lGIRTaKglgoPgU44HanZOa8bsGAus+CNsL5VB?=
 =?us-ascii?Q?vi/PDiYkLdzc0jk4ZC70lXeRzgd5OZSPf3mx/hoipmW5cmpJjoO5VkesJbec?=
 =?us-ascii?Q?qETC/x5dgmcFALFnpnlTXIFw?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7590e5-ddd5-4301-afd7-08d921c4c7b0
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:49.8827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhqamnHG02gJsQkTb3jn8UBWLxwtABfLXSzXgjhAzFOeDAAhMrZWlqBLJIbjKFwUURDVlakO3FXBOEJxu9z3i+r6ELDLS3oDHbNZ7gD91kI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: 9ybN2gC79kj_2ZF3Y2HWAo6WcBdmbgoZ
X-Proofpoint-GUID: 9ybN2gC79kj_2ZF3Y2HWAo6WcBdmbgoZ
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

commit 073815b756c51ba9d8384d924c5d1c03ca3d1ae4 upstream.

Move the bounds check in adjust_ptr_min_max_vals() into a small helper named
sanitize_check_bounds() in order to simplify the former a bit.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 54 +++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 473b59126f61..faa2a4c3467d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2911,6 +2911,41 @@ static int sanitize_err(struct bpf_verifier_env *env,
 	return -EACCES;
 }
 
+static int sanitize_check_bounds(struct bpf_verifier_env *env,
+				 const struct bpf_insn *insn,
+				 const struct bpf_reg_state *dst_reg)
+{
+	u32 dst = insn->dst_reg;
+
+	/* For unprivileged we require that resulting offset must be in bounds
+	 * in order to be able to sanitize access later on.
+	 */
+	if (env->allow_ptr_leaks)
+		return 0;
+
+	switch (dst_reg->type) {
+	case PTR_TO_STACK:
+		if (check_stack_access(env, dst_reg, dst_reg->off +
+				       dst_reg->var_off.value, 1)) {
+			verbose(env, "R%d stack pointer arithmetic goes out of range, "
+				"prohibited for !root\n", dst);
+			return -EACCES;
+		}
+		break;
+	case PTR_TO_MAP_VALUE:
+		if (check_map_access(env, dst, dst_reg->off, 1, false)) {
+			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
+				"prohibited for !root\n", dst);
+			return -EACCES;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
  * Caller should also handle BPF_MOV case separately.
  * If we return -EACCES, caller may want to try again treating pointer as a
@@ -3118,23 +3153,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 
-	/* For unprivileged we require that resulting offset must be in bounds
-	 * in order to be able to sanitize access later on.
-	 */
-	if (!env->allow_ptr_leaks) {
-		if (dst_reg->type == PTR_TO_MAP_VALUE &&
-		    check_map_access(env, dst, dst_reg->off, 1, false)) {
-			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		} else if (dst_reg->type == PTR_TO_STACK &&
-			   check_stack_access(env, dst_reg, dst_reg->off +
-					      dst_reg->var_off.value, 1)) {
-			verbose(env, "R%d stack pointer arithmetic goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		}
-	}
+	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
+		return -EACCES;
 
 	return 0;
 }
-- 
2.17.1

