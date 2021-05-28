Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD039411E
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbhE1Kkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:36 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:38372 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236602AbhE1KkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:25 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcaDm011407;
        Fri, 28 May 2021 10:38:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh8nsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiX9t2uct68rotCQaX5BN3X8aesn5go75ATDRMDfcbgp+Fa4jAX0ZZW2Ijv7s7N5I98edIn0OfsJK/q7vg4Jsu6iGNrGnkXgCUFMIQj6oEBCWltoJKNO7Yofd3FiMguwtXwdkFt+5wWhj4kPh1cGvrQ+03KJ0GiolzfqeDe5K/xlDdQF6JXwppmV5T2JEPwFo0b/dMe/Z2u0F89p21y66A2ERfsMJ6Tqs+60KBZfiJOMs9yeaf/LVOpRbRFGjdFZglwRq7VeKibJq7hC2BidZY0m1BmrfuqlIW6DYi6iK6HygoY1P0o4g5AnwzcCRpqffL2MJb8pXpQ7RlV0K8gkfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As597d2iE9g0Vbbn1Aql6UOGayyPdCiCXtOknTT2X7g=;
 b=aMV0S9Yk9AyLBO9aM/NktE3bTD9fTC5DDYPFqfXpSIocX/yO8C1RAb5veAn46l+sbizCqYkXXu9Z6sschGDkhDPKRCofWi5h3ns7MjURcyyNldj1AcbiMhOUN5WWiDm/bYnLaPEfI/spn8CefZOi3e0H0UMnTXtfLu+Fy1NAZlBJmf2ZSmuOSB8owwSCwpEMUvgz5DNsnuOv6n+I6XQ8N7Uk1CTnJNEkLa+bPx0TOiGxsybMv+groEWjX0jL8wg82vpPG40xGe4rG8n+pLGEPQZcp1CAqPGDKhnjH7lWPXEMocr5S+BUJdyih9l/GvwfYKS/YvDRe703aJn16jJ7vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As597d2iE9g0Vbbn1Aql6UOGayyPdCiCXtOknTT2X7g=;
 b=o4tnwEwQFr/eb7oCZujzZxBMSPOJde1FfmgztY2oG5UACbmIMRpFDA1QY2vPh333zj9Kk48BOV6NN63/5X9o7Vk9GHWnTzGkTUDHkoidIe2nHQLA2Xv1LxjClTImHTcxgDlN1gzxxLYGyqU1FktgsYtAewyztgqFF4rJqdiwhpU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:35 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:35 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 04/19] selftests/bpf: add selftest part of "bpf: improve verifier branch analysis"
Date:   Fri, 28 May 2021 13:37:55 +0300
Message-Id: <20210528103810.22025-5-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 319b8b3f-000b-4fe4-c5ec-08d921c4bf02
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB20975FA5549C276120DC1307FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:128;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8FfozKeMyYcMqItKzDEBmIi81fuwip/zmEC3ukphjqZxM9az6gSFUja0ieGiud3PPg+O9Xp9mMH6wL9DQyOEuyFLYuJ1UfwNH3kntkFSJrmLFFi6wOYmpCh9Y6asevV05LxDrNNOh2D+/fqxZxH7jyHwEhbbhvpyWeD3GR/M6KY+kOFzzs0LbJTTfp/SQ2tQyHjU8AkcWtcTR0/o5W4mkDs9EONtNM9rTtrx4QaLxYhp4Mi8y8XHCGuBvFtAzz5K3YPQmxymafPPbeHL4HC3gIQIUJp6EK/Rd3cRyoSTceQVZXAbKwv0KyT/8lzCL8oymP08osXFEqeBN222oq9s9EWpLkasLOxrqwym5aTeaOkKvLrYFKHDolxQmwGko3qReahk29DJl4woB+WVBST/iOZNioHOVz+bx8ujB+IR/MEKtUS3bURFQUw7H7IeUeYcSD2Pvgx+e1x5M+n521Rh4D4ZFN4V8aDgts7qb3n6pf6AXtyd3V6V61eeYm+ruXSwE8H4JivJYZXz8eMdYDgWov4meoOhK130Y/T7EZaTLtDmgI3DiNyse7jCbX8ag+gqADbrHwn6NW6EcazILcnRlP2sA2quhPq6l/bbbUqLga5/OJjEov3Eu61hClnsWvjY8w0UInov+Yu26YKt3cQHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c7wSTcdFIvqiQH5M+bz+1QvA3IevSmxcwXynHqU3xf1cF9jPfNUNWpqYYDmR?=
 =?us-ascii?Q?7N98lnteXMnI99xYC3a02cvq5xc+7qrQ39In4iCJMU81cZEXYGZMGY2w5OfJ?=
 =?us-ascii?Q?yc/YNd6j4Pon8pmaQgAzCQOn7jKmsB52TYfmcyASE+bZwoLI/QLdWoyy16/K?=
 =?us-ascii?Q?W/86srnuFRbEOh4TAjkQ2WYnE+ih4RG8CoOjqRucwu/2MI63i9yJiN9HkW63?=
 =?us-ascii?Q?ijAWHF1xDOTZczdoiU7G+FOL6Q5iTNk0dq/z7iebUtUTw01nlBNM27ZMemnD?=
 =?us-ascii?Q?dKvYe2nU8wyQ8gUNxIj7kU9vEYjTuvaKC6hbU12frP93emnmF3Ao3dsMjo1o?=
 =?us-ascii?Q?hDEGcpR+LEsfv1coBGxcxdT+0E73w7E+aiGdOpNHcYa+/ECf/1AyMOptBdHk?=
 =?us-ascii?Q?seVdEWzx2MPZwKU4EBgaoqiPqfMVfnLvanUB0pkieINbkVbiWlVVF3HPCfrf?=
 =?us-ascii?Q?lSQ7OP950N+2AgTK16+c8/C0oHr6OzRd3RVdrgoi8PHzrz8FZapO4gYntm4q?=
 =?us-ascii?Q?+dN6AFcL94shNwiZSYqTkJY1M3QCGjDuuRlnGsVNrHrh9rITM7SaNpiJDpiH?=
 =?us-ascii?Q?29tj5K2J5j2tzqo8NdBt2nblwX3W2C6Bbh6I9kRKtdFXOwXGuOEaQKSlo/1E?=
 =?us-ascii?Q?JZnMiWWP2Zd9kIfWaIqYUwwQyoADPcwTHRO6kGWvQrif/SXthukLFQcD9PDP?=
 =?us-ascii?Q?bP6Sk0tg275SVE7cVBEkaUbt8Ska8Gb10w3xPKAhGrMj0eJpreG6ULIyZgHZ?=
 =?us-ascii?Q?A6ArMQoh27obIXx8P9TjdddQlmN7OVESQE//6mQjLfIARhUOHn7ZGvnV0hfp?=
 =?us-ascii?Q?y0HixHi1kYg6/Uc087G1sFyyrld+B8DaCgGIU1qhM1h+v87RCQvxXxBtDgmr?=
 =?us-ascii?Q?eziyvf8EEFARrgfvKGPRHH/BlXoFMbeFfcj+mJPhHUcbztW87rw6bnG7IH7S?=
 =?us-ascii?Q?4KB9jbjL1bD8Xot5HI0MG3b8o1Gp3g4MbfKidSrZbSTijO/sStPAiewyDYwu?=
 =?us-ascii?Q?uWyp1ZL5Lek8I5VVOVE8DQztaVMFrnc9zyKEv1/vsNUuFPFGAquYT4+pZDY5?=
 =?us-ascii?Q?g/R0DnC7nM7IAcAkVGnGYx289liB9Xm9WxxsRYozzz9IVtPvf9BcroBaZoAz?=
 =?us-ascii?Q?eA22sYHgr3dUjT9ICKxY89s4CS7MG0/uZoqrm+ZdUpIzLzGK7J+fMh4Q3v05?=
 =?us-ascii?Q?s2DBIiIaiid+6WffZSO4B5gm/uLjFN1Io7Cczb43QaBjnW6WcMPu7su5Dcgg?=
 =?us-ascii?Q?PTSUsHeao2UJdM8PPGM32JNCw0HmOvYizcwjoUiR6mslJzS9dVvLnS9g+Hqi?=
 =?us-ascii?Q?FqHbHfTMUIFEFhHlicdghvCq?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319b8b3f-000b-4fe4-c5ec-08d921c4bf02
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:35.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XjmhN/7EQ701GJp2o+TPkEjqtbi+C1MrU62yMHwiwAvpdgoT5jP3cLJnLY6sJSXpuxBOybh43i8wEr3oBnxXF1sqpiW8/ZsrECGW3fJc9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-ORIG-GUID: _H9OAHss6QuC05TukDQcoKft3obKMmjs
X-Proofpoint-GUID: _H9OAHss6QuC05TukDQcoKft3obKMmjs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280070
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport the missing selftest part of commit 7da6cd690c43 ("bpf: improve
verifier branch analysis") in order to fix the following test_verifier
failures:

...
Unexpected success to load!
0: (b7) r0 = 0
1: (75) if r0 s>= 0x0 goto pc+1
3: (95) exit
processed 3 insns (limit 131072), stack depth 0
Unexpected success to load!
0: (b7) r0 = 0
1: (75) if r0 s>= 0x0 goto pc+1
3: (95) exit
processed 3 insns (limit 131072), stack depth 0
...

The changesets apply with a minor context difference.

Fixes: 7da6cd690c43 ("bpf: improve verifier branch analysis")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index fdc093f29818..a34552aadc12 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -7867,7 +7867,7 @@ static struct bpf_test tests[] = {
 			BPF_JMP_IMM(BPF_JA, 0, 0, -7),
 		},
 		.fixup_map1 = { 4 },
-		.errstr = "R0 invalid mem access 'inv'",
+		.errstr = "unbounded min value",
 		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
@@ -9850,7 +9850,7 @@ static struct bpf_test tests[] = {
 		"check deducing bounds from const, 5",
 		.insns = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
-			BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 0, 1),
+			BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 1, 1),
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 			BPF_EXIT_INSN(),
 		},
-- 
2.17.1

