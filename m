Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DDD3934F0
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhE0RkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:18 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:39326 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234993AbhE0RkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:17 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHX824001042;
        Thu, 27 May 2021 17:38:29 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 38ss3vs2pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qm/0D8jtcS94B0eBwWtSknvTwpGF9FCXD3oG/TvkviKK9EqfK724zKXCd7OJ6Mp1lSXMr81Pp9sMoIvtkUAenJi544SwhOdzXfR7KRqjrQagfbX9z3UXvGA8VwfmPXYH3ZrdjawSr+Kafmu8rD5iOukRETFckqNxzV6AAnbBpRO6BcMnDz1YhTLOE7oQIOFVX09xk+2YcVGvDtN42q8E/m+xp3eAcvERpFpxoQcpRbdvoASOuiRtODuXvHIBXXV/kIZ2Nm/4lKbywpSZSE361zbL45MF0I2pZBZmZ52CSk9S9+dFXDFlEM9yHYF1jp1Z6SkHmRQmQIg6Y3jg8T1UwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As597d2iE9g0Vbbn1Aql6UOGayyPdCiCXtOknTT2X7g=;
 b=GZmyZ7cc/y15eGT+KiwDU68GeIpRF8FdwPVZjwTh+rcQx6L+zDU7giddmc4P8isFygQqqa+Gug/cFRvLFWiTQinEnKrqt+81sm04C6ASLacklUzT97HUenVoArG/M43gauONKs5BVJjKNmPHx9/Jd07XHj5P/imBSHWY3m4Prg+aZwvwxzA2pyrfgTSeDzotbQig9vXc4tRG0zRTURqQHXpzYJXioChNbdin4qfEo6+M2ZqQclEB7bUdo5ykn6qWS3CDOlFg4ZYC3BqLkK7PE6SyIZwswcAfYPiAnSZtsKLM1nLuu/AmlAZNtsTam6rF0pzTBfZ9KcwKZiXB3bB4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As597d2iE9g0Vbbn1Aql6UOGayyPdCiCXtOknTT2X7g=;
 b=iVTcUK3Gczg+qpd/htrViUhmdIAMvGtO+wzCtBjDmlehnduv2M9rw6bCohEkgEs/uB60HzHsrgMDulXbV839233wwnuVQI+pyRcBIg2Vl4O1PGm2iFUGeKMHEvDvPvSS8oE6Tzn63q6gMO0e4oZ4ayQZ0KXido0jC7Rvo+ZCICo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:28 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:28 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 04/12] selftests/bpf: add selftest part of "bpf: improve verifier branch analysis"
Date:   Thu, 27 May 2021 20:37:24 +0300
Message-Id: <20210527173732.20860-5-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98eab8e9-b78b-4c68-8e7a-08d921363ca2
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB216201AE97A7BB27EC9FD534FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:128;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7K9gXK5E7eKhdoWSGjth6qPYF9yqYqQAVXCbQHV1RjC27bgzqjzs0tiaXFqd2hvLFnhOvXAwc4OlSq9kDM9kahTxTK/jPp9eJfSCUddl9w7GDn2kVeHanwMICYL1H+Yx0YMTn8Zb/jeFXWmyxuu/My+2USya1S8WFCwcnP19GXD1JuixGLm2CSNBMtrYUkQ+2jDmzOF5MgTNC/dFFYT0zTS1e8ZbuvPgofCgYEwn0mZSr5n8e0+qxUXZoCGilUe7kKZsNCGP6FG8TtokFTVzN94rZmUly917+g0NxOOgRzu+SoGXDasZJ4KMlA2MDAfJaMNqv5S8loInYN3mC9uXBQfpMcUVhSsFgo4IJrfs2cbMBi3oGDvgX7ltC3tb5ByUWsAx2V89CYw5c/0b2vWzY34px4LE9oAW3urBfhzmDVQkm7JQcZ5Qta+SRJBXa18yrXn+6XYXrrC1fjcB12H/tw2CXmxOiU1tUTHMK6cRyoQdj215AO9/7cPuJjSwCb/DVH/3rJaRjRxY+4Z+B6v5eTt3VWf5Y4WNLmU2w61YeVYMnCOF802+qW+TC6SDtij1kV5rr4w1+S8Q7yWM3qD0aYiYbwAPe43R/e+HSo3EWgMEinYafgIb9afO9/Ikz61DET6b7Zro08ki3BHwNjH/CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DZMMyEvIAK8FedgW8EkNaLX/qEJtajoA6jzUHhu1X15p+14QEQ/dhaBHi88S?=
 =?us-ascii?Q?G4A7AJ2ZzHmgx8gils8j+9XfZdJ0I3YDJ6hGlIAUvmNsKJiB1jR2HOupnUQD?=
 =?us-ascii?Q?Uzo8bvRcW1vmbMHgTf4b0HX6PU+0AcldK9eyVo5RLN2kz943AxLszmesU6JL?=
 =?us-ascii?Q?WdFl30xU1sclsJqAqZxmRhzzd7xmRTgqAQQxsNfhvjRKc6u66wZTaMCaLq+E?=
 =?us-ascii?Q?a5j9v0dgj4ytUOfBUv7n66l5Mclms7Ggi0VTCOexH7G3yHcNWCKqCN0Ws3QG?=
 =?us-ascii?Q?q1mlXWR5UThR1DcCUuVN/9gD+AMvSzN+DCD2gZw3/U8fmEguIdhgHaFQI4VM?=
 =?us-ascii?Q?+cEbMBrGrHAv/KilCpyAe8xIGJO/rM2Cz6Gs8+8Bu2OzHwzJavMcBqXIuGyw?=
 =?us-ascii?Q?hi8yc6oajeUtKG40QxXefCDspADHR7v9EkoTp9srWJUe+rM518dExguG1U83?=
 =?us-ascii?Q?/cuqD9mMlvXF9fHmZqVTZUN1xATuoYvJI2J/11iXVax2FoMHo6JbX9LEMSVu?=
 =?us-ascii?Q?4jj2d0V2p7yYUJCO9TxnOBB3T0R8hv2nxNxShMxSGQ+jJBLjW6vC2mPnnlqv?=
 =?us-ascii?Q?Yy/zfvSFJRxrewu9JVrIgFwWJgi62t+uU39BPOzi36Hp1lzhHer6kLUUz0OP?=
 =?us-ascii?Q?TYZXwP8MIpSWyiL0kiBeIHVr3R7C//HSOOmBJaWvAV9Azap22q4igvzAdhqk?=
 =?us-ascii?Q?J8XOzlHATz9Fuqe3mouizz2dNT7mJtsDjlm5pLFBMcoiecoDN4Tx3NaOfUUG?=
 =?us-ascii?Q?+5jMpfv6LIfvPC204ke/u4hGs/PsgTCwNdKf5WtqzxRZ1LUupgcLS2W5BbAw?=
 =?us-ascii?Q?917Pq55JIq3V7uSzL9z15oW2Td+zXHVkTuxkJgiXMn5V8FRaPIOerRO8ItBe?=
 =?us-ascii?Q?JTBO0eovIFQtcXy0Nwn5C+0evfa9AoCf1kV0eoydDG2TsbWQ0xzYkpcN6EEN?=
 =?us-ascii?Q?W0Pax/nDgr7Nxm76efLB4Ch+mxuaQSWDr3cZpbYcRGhqwIJ7hkK8eeZMjRGR?=
 =?us-ascii?Q?8YCL5OmR+e0DiCzCkFNafaR1s17mjEOxzTPuYaMYspTAwaPK4wt+CcTyYenU?=
 =?us-ascii?Q?2V4atFLnwnEt7wfQUhugxzrcKQqjCAuDfGtR53GKhJiJIaQBa2cxu7kXS4cl?=
 =?us-ascii?Q?HH7S+dhVTmW8l2JexsHN6UX7TwIVnEIELKr7gPCkrnKpBoLJTOyKmqrRE83J?=
 =?us-ascii?Q?YQqtSbMFKXfciavRbATNeDjZFL5GfrVf6VxrOWpV+/ZcNS0hI1Q1WlPahNhI?=
 =?us-ascii?Q?I5RJyGSa1q7Li3DnsdOOBA7abTh6Bp2ehfUPZTpDE7e06F3s4AM217IuIFmF?=
 =?us-ascii?Q?UZp/+LhdAyegMirsOZG1HZ0m?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98eab8e9-b78b-4c68-8e7a-08d921363ca2
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:28.0402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvGylh5lrmc5AhtCGmWsJX+vAKf06HOdzAUKwpXDP5YLA76T9vLsIKOPF8lXHDCuAYA6+FW3dM39OiUeDAzlLWe5Us+57CX9yBZFwtjZeGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-GUID: mAG1R1LQIf12C2Rztbu7oo8LeGkHkk_u
X-Proofpoint-ORIG-GUID: mAG1R1LQIf12C2Rztbu7oo8LeGkHkk_u
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

