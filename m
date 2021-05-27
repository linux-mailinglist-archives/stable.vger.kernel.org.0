Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0213934F4
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhE0RkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:21 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:43416 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234993AbhE0RkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:21 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHYLcp002811;
        Thu, 27 May 2021 17:38:35 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 38ss3vs2pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huWDhGyT+M1BbUSig4sasnjaKdWAqtNhly9c7rt5v1s88DL4//8pn2hI+a9hkwl+AavluBxKOR3d3K0RZR2tOCrRH13ImkvRavYhm4YNDHzPNxTyYfpa7ZhoNwA7khViJnl1JAdJrUyzV6YTXoAkOkCT+sXOc6WKfhrifEEH4C4bmbxzmqm84PONOFMEeW+bptBubI8OPOG3g4sPGb6zkM7jr2vTcRIWwplTwRe47BJpvw/wcmm7/Ea1OGTGtqNYrR3rvw9hkcoUcDi4ocVPxKjjPHyLSoSTUJ7cD1IIuhSoElhkjVg1sGwzXg5C4Mq26HSbqLp5k52vaEkxQJI6ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6z1PdUgU1fapwbrqA9OmI9Fv9O7dDsi+A9ru3voJ+s=;
 b=l07iqtYblYSOSBC2hPzPY0oiDJgxSkDH4KnnY0eR4o+u1qdu18Q7MAJ8gF1+iS/b68TiyowVx87ocnzeiwROhWThzy6gHcYduJaIjofyZoAD4YIz8pnBwWcDyqu9Q7h3NpG9vnNe+uVwnPvlP2SB/Vfvvbj/AB//1qfGm4erYERG7ayTTDYwVZCXqYl+44ZDyaoMiDNr6FNts3hvSX7Cbu0Rt5+8V13PYhrduoVbZp1nwPhjN805nv6cKxGtum8ON6P6DmG9n8p/AmWdAq8bC5yvoScrGr33hkbL7eZSxO5aPJc2PCysKAGzSijVUc7mpa1sabMnNkiAc+3sb0KHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6z1PdUgU1fapwbrqA9OmI9Fv9O7dDsi+A9ru3voJ+s=;
 b=UAFTujr6+qGL/RR0iTs+G0g596tbilHd/zTKlkEpwOUa5r/GRZNOYGosK2FOPXiHVsaa1rjo23jr5S7MLIO3bM8zu1kDCaqMXLqyZBjprt09PGeWxbefChaNBCYt49yXNvwOpS+ZIAFZoqiqV5ECIQOmjfm93+ifGRRLl6z+ZI0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:33 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:33 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 07/12] bpf: Rework ptr_limit into alu_limit and add common error path
Date:   Thu, 27 May 2021 20:37:27 +0300
Message-Id: <20210527173732.20860-8-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f045a226-a667-47f8-775e-08d921363ffe
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB216223AB27CA9E0BD768CE50FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yMt4/j9x7vrgGo7eska7PCdCmD021pTMBR670SIm6+SZVd1rKeMgaZH5Cc4L9LhDHQ+e7ZWW8iUI38/wfwpIwlwzPPok8kygINSAAQT4P3bB4pf7Yl5Wrrz9V/z43p7XrYU4DJPTuiNKaAzbeqyhcwvCL7xfCd2vxIYq9W+y3iB91MON/+WuxBgSe07/dCQ1RMEp8R8hsvzCI42q/HStFOsx65NIiPrdu953mAQP70eD58RJCNbbrcWIuw/oGV4eue5he6/r5fka437WRV9kdCWJK5CPIlTAOvLK0C/2xIRb5uHEItBeFYCbWbTHaOphcs9kvPAkYZMjH3HG0Cf/t4BR9PzK1988RjrtJFDrzT0wZvZBxx8UHRtKiD1gkIzrMi2WAftR1UKozfw9hROXtS6cs7/V0MFMnou40tJ4epHlPVMr546GVGwG7UNetjbD6SKv9tEZJ1wvecqAnpHJfDqGKtgMRcH6kIszfIZKDBXk4QdRDj2G9FNDNIqmmSuKVZXYONx/TONhIYLDfbDoFOGHt1JK5fAHwntzT+z+E7n26sV2+t/+vbj82IdQe3PtXqONWK/Z7N1qHyIAUluwytzMC56ksv/Um1twSBLyo8T307nfLf/7ZINl45+ImdNW+smzOCPq12gT+ZxdZzbmUYCbOdZVonFEr1aB9+En8Ig=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7OTxyEkD8ZXuXlRjTUFsHCbbtCuBWC83FF9YqSvxWQV1Rp7HSwFVSzRKKZFf?=
 =?us-ascii?Q?cvIDWI6auwd25x0jUDpoT0PoLLWGd8LQg63J5Umw0tIjK7LN7MRXYboNX8nG?=
 =?us-ascii?Q?8MuyQKoDddf5mYd9xg6RvXksAv1jDmwWhV/60mbrKnxIoLhKHei6UQ5xIucb?=
 =?us-ascii?Q?AATjucH7TZb4Qbo5CWu/Lrxi2qHuLG4Nu2/cHIdPAmxp7tXyM+4B2j5aItGc?=
 =?us-ascii?Q?JJC/062QKDTQZtfKI2A+FRV+lvzvdBnNWETtO+fOcAn+oqSf32+6+yphjerB?=
 =?us-ascii?Q?fKkuK0rrT0G0qaicvIM6a19WsffYuMlnwW7EwvFnJrwdNOYeBQIwlKOGk6WC?=
 =?us-ascii?Q?6bI+bPa6qKzWwXCtLCXa9wUeBqcWUzUz0T9Z9Lb2ITtjLZyB4u2vt9Dg+zpc?=
 =?us-ascii?Q?+00GzYNTDQyaoXLKR8oyBiGS1o9O2cvRhDVkAbN0WzqmXMjoCQePbIqK5ISt?=
 =?us-ascii?Q?aYKNuDckK4kg1S1TqzDOdVZqGNGOhxl2rZmFxOV38Hwp8u0ATmz5Wo6QvIJq?=
 =?us-ascii?Q?nbC5hR8Rz/kZmVIdefzaB+PA8dlFtgkjjxB0c9iUjgM3zHxZtqA1Qdmzg/RY?=
 =?us-ascii?Q?6MyFbTmLxOo7PVDBv/xKIpY2Fe2R8gOcpu3u0JMPXNbPKUuz9tcjnDzOpAtX?=
 =?us-ascii?Q?JMxJ2/ev6LeGbJQnFlLIcvW1EHHNxq7dtV5ZqLZIhTrN4qRnewDL5J5qqGFG?=
 =?us-ascii?Q?XjUy/ReRWVKCI1dORUAWQNdZgsK5AWzukX+l+zhe1HjO7v0TUD9gAwr8N6Vu?=
 =?us-ascii?Q?jZWhREGTV3s3MszE1+HDKrfRaMM9UTvGJ2wuTFoCauyHxQn47qhGZdDu2QE/?=
 =?us-ascii?Q?05zcF4/3z20emIoBGz1FwiDfDnK2oEpt57+9AAHNSI9ZfY7dBgnIk7ZASnig?=
 =?us-ascii?Q?e9uxuG2ghfES4wVWEW1u9WyOdSwUtCK/98g2Uf8OsIu0ph3q5DPcc9sFLYdb?=
 =?us-ascii?Q?RPwhjuEeh+22SmQqt1mC/+G5m3EULR4npdvuYNqILvSXdChKglsor9lJMzEV?=
 =?us-ascii?Q?o5rcvIv/oREjiBA8Goug3uuBqTodYnKQYqhYK2iNFToxh6qiOwQy5zwpp10U?=
 =?us-ascii?Q?IWdITvHmhCefMpX8rqSoiqOWnzbvypgWoXPfwlPPI+uOy1nN9VRE5IB/kfi9?=
 =?us-ascii?Q?7wQfno+Wg7VpQ4dkR6uOnjNVSkNvj72JpRlmN8rLNKFNzbaAFYgvcUUX0hFx?=
 =?us-ascii?Q?8jxk6mnw1RfOOztXhHFa1nrjzBbuhit/eQ3ROYoAJlj88jKCbDSub9hGH6JO?=
 =?us-ascii?Q?TNC3o3LknDo4Yt1WgUG/o+cCUIJlIosCHrwCGJyJwCnfpPyyx5OHHYz9mJxI?=
 =?us-ascii?Q?Do/58VCVkk9VzGhIKqK3huzk?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f045a226-a667-47f8-775e-08d921363ffe
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:33.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWYuzI+cs7mKj51W/P5oVeapu9VwddOzIklwNv5VzP24be8Daxbm6CvVDo2oDr4pl9Wf90iVXuoWzkSHJA3CTO6G77Kdvy1zPgGfEdvJBPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-GUID: ClX34uu-vsxIyoavFGCIGer84uRGtVvH
X-Proofpoint-ORIG-GUID: ClX34uu-vsxIyoavFGCIGer84uRGtVvH
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
index b260bcc7215f..12db86ebede9 100644
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

