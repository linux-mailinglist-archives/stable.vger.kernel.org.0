Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE613934F9
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhE0Rk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:27 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:50078 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235348AbhE0Rk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:27 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHYLcq002811;
        Thu, 27 May 2021 17:38:38 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0a-0064b401.pphosted.com with ESMTP id 38ss3vs2pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfX0Ok1XDvVwH9V/7fmPgc5jqiQNjKqPzmfsGbDh/q+9h7Et5qqjnqn4i83uCH8V9HNEV6Vyk/QZw3/jvSe+enEyL+l+/Y/DazGFrYwNJUuLIc7nBxNQ76IECnyw1RZfSMmpQfZvaLX+kI5EBOb3cfKTuVatojU5qU4RA92VC/qY25Jbbw/vTWcHThm3reQE58KeJ4um9OKb82UKLCkNvqpXaIhU0AOq7g55nKkqCd9B/ueQhcI9FQvRb8aUXftBHN+51EW1EO+M7A62UfZo1NWHE5l/f59FAbE0YJLDLvOBNwA/nhps6JikjznZFHG7Q5AnFkU4BRSLm1jd7MrjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STqgmlW23g/TEhNuubyIzEAm9GPzKeA7DhGno33dz8w=;
 b=brTq2No6M7cv704rQ2YZCCEhQF+EbRnohYQODRSjcMWkSdE/A/MuCU/qqDq1ohqhPwTYZOFLCDnJWfUmJ/p4yZL+XB2Mq3VCRq55qh1VaTkpOuCm3+a7DmYxUCySjAgl4bdCxMWBgvskZfD5qnY/x3E8Qszw644HR5f36DSL47XZiXpMqGL1Ks6LJ9PlI5EWgA9+K32LeaM+Ruv6gU4mx3snKjeZSdEWAWxEOVaSu4dz6XQHs0RV1dhubbMR4zCL0UFd7aGLRGevGitcK0UFIolCmJ+B08NPt4CLNlZe8A2oqIwdQqWa+YQXUoY25702oEkW3DEEVyjLruG11jV1pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STqgmlW23g/TEhNuubyIzEAm9GPzKeA7DhGno33dz8w=;
 b=GBBm19l1DGogUXhWMktHYZhmgswW25TCAGP08k/UXv1Kf7upxqW0mMD/duVXsAQ1ucUzqg/c/LaTmfcz4+aWtqtKOzoqib1vB8tGFJkF1sUfzVpQiPrGLxSOW2r5B3XSvWYEU/MbGO29SFk3t08Jb2yAYJKOxqahdTKw3CYeI0Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:37 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:37 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 09/12] bpf: Refactor and streamline bounds check into helper
Date:   Thu, 27 May 2021 20:37:29 +0300
Message-Id: <20210527173732.20860-10-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af49e69d-64da-405b-0fe8-08d921364237
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162676FAC5DD7EC5BA12A26FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJjejAODikMBuotV6uDI6Gnb/TITJ4fd+P+nfsGnRJOtQF9jn33/6jdfbUe9XETiaDmNlPrOAMTCAkW5HzGtidTDN9++XBpnQFbslbwj0yxE0TLoZDheoYuI6mJULYSWNazgs5gq/qW6GYK7cJvNwmgPDA3T8SvZg/Pm7RxZOx7RwA2QOQFIil9dWViwr+eaFW2qUyG9RcH//VzvKx1uTgVU/nMatMnqvajXYm7MF2KDjuK5wpf7zRYWBQ9UdbrKt/B+AA8fr9vOuQr9/YfF4D8r1+U5auk6U/xksxhtUHZXCFve0AdzfSlmkzlM4OiwDnh8Z6zAqtZHya6SkpYChUDqVaQuPjkQ1YD6A3lEL1AGZe43+QFWMUCwUDLXd//+zTMnRlvo0XMXoWpS8lat6PRXSG45qJyIplQhdtduX+GTUmaHOTRr5zoUcLxBGtDDzlnfolY1IDwmvJTAJkZeCrS6mA0HEzmS7mptx1ZymCD3/v3tQF76iotjI0cSnzktKORnfRr9KiSUulyP3mKLqiOiD3TV8n6nucmGUgxvqCPY5ENcVfKpaiDZr//ZbeCTTAvXWl8E6r1CZhlnK68Q0ZMuxSvVppc2rt/ll2oHw8P//QKKnq75Ya5c+6Qe+2iBzYvTSNgsEAr/7rovyOWZ4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QCGxK3bSplCq0QWKkFxzbhiVG0nAYCP6n0aMEd57ftG9QziZcszftiADdIHC?=
 =?us-ascii?Q?vl4Rat56epZFzJBQ++eBU1QK2KyyxEU4cFUlCBzkOBedscklGI6wPzmolg8H?=
 =?us-ascii?Q?4wDG77RWcwmwcSUAl60aaqLe9go4gRnFg2H814E38n5PbOUNrHcl0IQADfKJ?=
 =?us-ascii?Q?WG7Ujr63ZFD5E6f6K6eufFa8xsAfxy4snTzWMDjasXQ6wYbd4RRmUUtL/uPT?=
 =?us-ascii?Q?A+A62v6B+zj6s3Bifit/pBxJhNPSkXIHYZsKOn/V5TyN/flJz4WDw+Zs243c?=
 =?us-ascii?Q?rOL6bF6nIOcM4u9pLQn0IfTkcuHwMJQrThxa4MZgA4TrWnOqNBwTuVaXW1RQ?=
 =?us-ascii?Q?bAtXYbhCAZ447iBs0Rf8gIg28mDLhbPfr6V6MMgpYJHrrr8WQnxNKzPvsGuX?=
 =?us-ascii?Q?x492BEb/2brvMU6tLKq3le8hiDLEzormRdoJ3vY9xrhqhrMTZGywI1XJvB2S?=
 =?us-ascii?Q?7wnfJO7cC0VP50sAwWwxUHlBLw6yvqAT8amFpdKcTqYuAGsw7D8ww5csd5ho?=
 =?us-ascii?Q?C1JOFYlq3s7EY42xhTamVFz/RC307G/papsHAV3a4sy0j06BEGA4j6blFW7z?=
 =?us-ascii?Q?dpqDJ72qKonLnsj2APcwdfFNp0UdwZYZP8Z3pwiIsLPA9rVdeBNtHJNoP7+4?=
 =?us-ascii?Q?85B2miFUMdM8eTqj1pHcpvB2sLDxeEZZVZ+hziGRLv5j9Vg1QFWncBJuAmpf?=
 =?us-ascii?Q?nvAM4iZDaWNiOEdi8zzMbFv+mMXiV8bJaWEFKpV+n//qrCo1a66A/clGHCxx?=
 =?us-ascii?Q?lZhhirEtnEIgHpHtn8uu+/stuYOyAphbQZKUyJQ6O6kX6Lx2eHO5hVGr/8nX?=
 =?us-ascii?Q?TiMBXtS4ruvGlYDW4C67fPJ1PIdPpZQue/2h7tWWGMVk4UOGxZ6FxeYK6q15?=
 =?us-ascii?Q?sZRlaQduwPl0VjsBvW7oamelxLbsEC9uCuF3Ljd70O4PfG1oT/5YocKDLBRH?=
 =?us-ascii?Q?aNz1FMU4XodvUxwoTESXtaYhd5huCdAyxO8vgVgfVo8SqKgUNUusOPwLplXA?=
 =?us-ascii?Q?y8MjyE28LxpchMSabYh90Y0Ya6DeWwtrZg7SQF1ZkWrHGXujZMBwKUQ8+z5u?=
 =?us-ascii?Q?cdmLAE3OSLG5i4EkF0jyfNvbn+ESdxj6UtLQBc6ZeSz13yCq74WvHBijfR9b?=
 =?us-ascii?Q?FEDGCA91T17v3eNyEXag4uZOSmcVqAl5/YhgHQ0c4m2Km6HWANJQ+BPug7zX?=
 =?us-ascii?Q?VagJ0/JZ00/1BT/O0I4VmS+4Tw5QyLqpk5+HK8eVYD7x1jCYfJZ+xcVT/vSJ?=
 =?us-ascii?Q?VjahXOTCm7jY4FOoxFrWz+DRAvWtyVA8PWLHUfOqhYzCm1wtB44UWDIy/U/x?=
 =?us-ascii?Q?mINGkuGtP1sgXvtT5s2dVAxP?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af49e69d-64da-405b-0fe8-08d921364237
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:37.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8i1yV+RnZvGHc1I7OgvKX9BZLOaixvgvEo5OPJO7nph373MZLFUgeC7rGN+hYjnrak0t6wlOPNFYMML3s3IshiP3aoRwJ2y+TRp1UcFj0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-GUID: CvaVxmqsTyCrXnt52HB-WW21O9IYWZOI
X-Proofpoint-ORIG-GUID: CvaVxmqsTyCrXnt52HB-WW21O9IYWZOI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_09:2021-05-27,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270113
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
index cb79307a3aa0..b2fe044dc6bb 100644
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

