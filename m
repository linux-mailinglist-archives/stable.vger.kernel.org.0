Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81ECC39413C
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhE1KlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:04 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:12114 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236450AbhE1Kkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:53 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAd1uW010300;
        Fri, 28 May 2021 03:39:04 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:39:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZpxWxW8S72PPNzoz9Vr3tC83TcVCQOqb/PiNAX3f+qcfmh9xHHkezaC0w1LUz41ZNgC56o1KSfzybYbh71A2hv18/DyoPHmAt2CN2uOl7iHx/M3hsuJcskyN2YFb2El2O4IlcT16jQ7PdIcYD7BplGrORbUAC2jBTXfTxAVmEYds3uJdvaiWLyFA6LaEGyrvxKKHqYD8YT/4qp+HQ7M9RWTMcg/9nUNjJzLQqbQNirXGbW7t57Ctk72+eoHJB312YdBQ8H/DzJaDIsGrjlZSif5eG1ACbcu4VkXNsSgzWGDYAo6JHYIaPFA4/490wjHlNQ1WWjlbh1C6m5BGMLbPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOl+lHLy98Br7UV7Ug+ZZ99sQZJwF4suLij5peopURo=;
 b=lrORWlgmt0P/XfcnLkb+ufVdMj8wm3D8icEw4qK6JrgL+WOEhiRdZZJFFQ55ahNaDUNo2PCXthS/l6gJAQrTtd9yKpmLXkUL0fmLPNBtK0lemyTvCmhVamEaSMydc5vbwz+TeBs676oKWVnExHgfEYPfE34ZP6bwh9ZgQ43MhhU+MClj0CxoWHfWXplomdfjyIbLboQOb9GzTQoYRA0j8IkYpKxcUWj+yN499JpgYDuCErLpfAvTZIldnr0w+9Il3AafKpqo2vlkq6Of4zdv03jCP6YNonZj0I1bsmN0ItnKlhLrDU5JSFLCQMlsipph2lDMvyEACRP74lLUSX64IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOl+lHLy98Br7UV7Ug+ZZ99sQZJwF4suLij5peopURo=;
 b=hru7Yf06xB+r0WXVdAVZT4kljO+0h5ELUj4MYb1Rl1DSuy0Ix7aY02GwNeah3SCcx5Gk+s1aeRmGPfj0yeonDQ8iX1TBZtTZpJvUlamTqJnzSzHuiW3jhf4yeVc6ugQddVbqKdWZjjtaZq/VBvJedhwiiXtpfCGZkHQWtJGrxw8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:39:02 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:39:02 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 19/19] bpf: No need to simulate speculative domain for immediates
Date:   Fri, 28 May 2021 13:38:10 +0300
Message-Id: <20210528103810.22025-20-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:39:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20ded05a-cd7b-4f3f-6352-08d921c4cf41
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB37800F9F6DD6D458A6339408FE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /rCC0/JQKDjPwapJwAzPpprt0W62rkhFJiy0sbQbwbW7KwZheduMGkjE9RmqbosLhYl+zIMEcYHaPebXGCGtLtY2PqzNL4SETjYjvTAq51+yXJezmy32aRBtS5sJzBSb4F9k0iYN0kaslFs/7VDlgjIJPaWdiSvtP6KBgRLSIa96/os2rknWFo8NtrK9xZkYgozfFNyiK5yw06UKbOiUthW/Bo9jF+lWO93fdkii6dxGQ/thf3pIh0hZMzf4Pa6IVW5ZC1aqB1TrOtXm+jO/ngFN/lX+mycYHakH1D3t2ifGXXMGfXvIsAq9Uc1xnmSV5yTVJ0BzoiT+us2iXvuAw7hAzi3nNoT1JMaYobRB/ciXGHLBMGtbJD3Szadt/B3LwpMjjKqCwAY8bx4F2dsA7BxI4MtDIYtDjDZCIEQSZfSHRyefeZ3D0MuLGAZ4OzWlni9CqE1JuRGeKGxY62CBnhV5PKjBWVCLybuoMz27mTiFvARPUcaa43leyM2CU1igK34HvkuRVrn7I2SqSGE5hW1cEY9yHQGLic1d6WfiJFZgGQJelwk9aQz+XvZUq9MbVnViLTTOQ7RrO4iKUTCJokTZ+ki3xTeIKu8B1B2YhNrVl+hYo2bgSGst3Wf+8qgpU4/0/gCCDMaMIrVtq2FDgbSJl8GrFXpzMxnME5hhM6WWj+iZUCrepH08iUnHd0N5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003)(14773001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nlw2s0jGLQ7tq+Z4MLyRj5UeAHKQ0yn962eUkSOwuXAWWqaV3eQYgxgap++Q?=
 =?us-ascii?Q?Fu5djZJnhIMNYwX/ZUMBu5AlVnTa3BRCLhqbPNwQIULLQkvM1xh5sL2khEsS?=
 =?us-ascii?Q?frGO2OhFozDkCQp2r+l/Y2st/GgOfcx4vj7r+RvAZNDlCNnaGCbgj1p5maQp?=
 =?us-ascii?Q?mBlXkYU5nVqRQ2CKh3axr8H2k7omhZOEKkaWrx1ynnj3cd0UX0vwT/hzE+p9?=
 =?us-ascii?Q?ne2bAGb3AQUAKelNDOM8EGlV3YEjk9XH+0tLBeyrAnKjuODj82LIXgaX6zhd?=
 =?us-ascii?Q?2OhTzAu/TWBL1/Qu9aSmBfowquaDX+VLcB87uQcemxGv2TYsT6uNEw8EBywf?=
 =?us-ascii?Q?sEhDJ7+A9LLsmBtt4GffR3AJ6wmXxctkebyNoK83ZtO4xWdNdW6ACE6a89rq?=
 =?us-ascii?Q?HZIHhd2hEgfgfqwpBI8cXBy7lYj6KvraOyz/qXgzssOl9pVh5kC57exhiscn?=
 =?us-ascii?Q?BH8u/L+emOzs0MAEAIzq0CWWGmgFGoF/NrUvrB6uZwrK1mHjdr6J1Jsyiudx?=
 =?us-ascii?Q?R81XOkGLqTnicSw0AxC1n4j1MYnGVzSRQHjs0SoxlhQ3g4gh92jtkOi1tss8?=
 =?us-ascii?Q?JR4DIo2KgXvnl4OEGGbO6sF7EWCgS4DeFO8Uno3KYer8crXXAa0ZTtKIhGoA?=
 =?us-ascii?Q?gH/YsNgQ+KBs6tiqm2cn9fJjFHAMooHT/SW1kFZnEKEW+elhREBBzmGF1V6w?=
 =?us-ascii?Q?TRge5ZbmqPTSZOEWMoE55BFTMMc9AlbmZVvbu6HkRXstxjwYh+POVng42vgL?=
 =?us-ascii?Q?oX0nWa2tY2NRl6rEwSJoqCIBRLIUjZ7WaObAQJS8Z7mE5X/PGI9W6Td74ulx?=
 =?us-ascii?Q?/93ehBUg/Nym6AVpsT8Kw+oIGgsiYXMpRKIEmUJciR+Ic1Z+FU9O3g1m8oua?=
 =?us-ascii?Q?1idF8JkmpcFCMV7aB1CfeCI7TPcF8oMoqKK4hfQdL4rZojR6dNtqBTbVFL81?=
 =?us-ascii?Q?0cpB8l6cFfOD85r2wdnqrkJkTvaHHzP4GiycgTQKgXundwL5yMpkDBgjs+ZB?=
 =?us-ascii?Q?rmAN8HW3hCBUAo7hdzk5uvU++ZvZQwQrVJXYCdAnZn89bZOLdnUGxT+37k41?=
 =?us-ascii?Q?lwN8DMbCr7DlsewDCUx+aYZTS8uKHiVwA9ZnaiaQvv/YMj56mV3C+Swt1aI5?=
 =?us-ascii?Q?87MPEJXMGP6zfWFUjA7Kz+qXvp3LsJaED5rOEh0Xv7q/LYda6vqC+YrIVx87?=
 =?us-ascii?Q?KkTtcQzpiSxU/Xl1c6FeIGDSFQjkM3F/LmYmemflGvxg848p+V3/9rCXhtt7?=
 =?us-ascii?Q?4LUKVmi6w2638R1QStRpZPAUfAgDRvGMnADToIZ63A35aKWB95Q/HiMrP1yB?=
 =?us-ascii?Q?xEKg/mAxGUVh6lCV3Zjd6gaA?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ded05a-cd7b-4f3f-6352-08d921c4cf41
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:39:02.5790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIILU6r8LO9fZ1+xCW3Oa9hjtCkyko4QynKlA99QCSy7j+kop6Spl6+FntUNLzbzgmBZOxUmYX3fGRLjdGmD/BTeDLgOt4c/LJDwzy1tP38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: fvr5HchqpR_HIgr3TXWiJ1inHUiUlSc4
X-Proofpoint-GUID: fvr5HchqpR_HIgr3TXWiJ1inHUiUlSc4
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

commit a7036191277f9fa68d92f2071ddc38c09b1e5ee5 upstream

In 801c6058d14a ("bpf: Fix leakage of uninitialized bpf stack under
speculation") we replaced masking logic with direct loads of immediates
if the register is a known constant. Given in this case we do not apply
any masking, there is also no reason for the operation to be truncated
under the speculative domain.

Therefore, there is also zero reason for the verifier to branch-off and
simulate this case, it only needs to do it for unknown but bounded scalars.
As a side-effect, this also enables few test cases that were previously
rejected due to simulation under zero truncation.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a235342507a8..1f4c88ce58de 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2874,8 +2874,12 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	/* If we're in commit phase, we're done here given we already
 	 * pushed the truncated dst_reg into the speculative verification
 	 * stack.
+	 *
+	 * Also, when register is a known constant, we rewrite register-based
+	 * operation to immediate-based, and thus do not need masking (and as
+	 * a consequence, do not need to simulate the zero-truncation either).
 	 */
-	if (commit_window)
+	if (commit_window || off_is_imm)
 		return 0;
 
 	/* Simulate and find potential out-of-bounds access under
-- 
2.17.1

