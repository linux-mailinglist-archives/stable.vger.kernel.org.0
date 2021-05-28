Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B46F394128
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhE1Kkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:40:41 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:45170 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236450AbhE1Kkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:31 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAbdBc005736;
        Fri, 28 May 2021 10:38:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thqe8hkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvWQV/rG5kq4Y2ZQVZqXN7+4sakh/JEPi16eUskN0NFC3335uTaeALuGCF5yr3VUAEAcn9Mdl1e3MGDlqyn53T+zSImF7tZMvf8shgk5aRAyk692WBPu7vXJGuuTvMzX4gQ9QGtCyrFu47PxI00pCWsO65qbeXSW+CX9CYSm1I6mp+i3AR/cmSROm1eTd7dVWqo1/e7ynK9SSP+lp3zHl2aQxoWIfXkEgoZRkjKB/suLo7AXp6wx39e3jPD7S32lOTUeqlQx26S4HbVyIJq0bZHbRkT5qEVLp4wlunBsEKzahJh8j3KNdoTS95tXDp8K+zxNJckq3oVpm16+xYVDVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4qT7noI1OEzVYrPoKVIu5aFwxO+xcd9frlrQtHDc0k=;
 b=U/yITiSAUrV7mGOJb8s0wrrLmUomn+zbYUKiuFi53mnOd6RayfRXD4UP4HqQ7qY3YIC01pEgQ9a6iiQa63vR3dJ9yS3N3ZSM4R2AJzlVQR4E1jMJWqHUo0yCsOEYeQ069LZ86PB4+oHO1jwgYlULxazH8QDYkkhMfLeefDr8NDOQglpoZGEJ+Igu99no6ZOTQ1xmXx2ZOmPwXMZi9GUD1arvFPvqmUUv1fK42epcX6/oKUQss36waIMBff9be5Ec7gn1szme81n/1IGSqxI2Uu4Swpx2mDAo5KT9s5tlUEb9IrLsXA1fXbWSuWNSJ+pbfgzT+GN2k77GFL58zYohpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4qT7noI1OEzVYrPoKVIu5aFwxO+xcd9frlrQtHDc0k=;
 b=IMJLu3AN/NEO6tkW/mpN9pAi9Kc1+JVGWmhHzhb3GR+gl5iMNa4OcyOrNAfFD6kkkc1afRJ0Uvlqdg+/sAlG0B6EdCHXB5hb8SYyQgzZC5XQyEQSmVwitPc6Fa0vrk4ZIomhpn/PoQVAFCvgho6VbJN3gLCi5EiDnvbhPzvXRU0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:40 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 07/19] bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test
Date:   Fri, 28 May 2021 13:37:58 +0300
Message-Id: <20210528103810.22025-8-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee65c974-4dc7-4953-99d9-08d921c4c244
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2097157BB5E68B539EA5D338FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DL3QqXRIOBOjKgRfFQr/j3DXQsPaylcpCsX9dWQ3+okTaaf5diH93VRFW53Z4nrS+MEQzrEsdWecs/BG+zRv/aaWqlCyFXzOek19UjOQgXa1B4JrRLjUsdb0IdErSctmOpz55LZFYiPvoRHO1ZaRHFHzWLZ6aO+1De+eVNP/eBV+b8wehgeVcjYGZDBHW7qDaeF4mArjf6Ie2/BTw69VKLhhU7wIo7Rnou/s0v1rfSOluE4NlPA6flyJbSVdmcDY5Ij9AMWQCEln4N/s6tM/iL2hOYDo8kOqgteK0z4oNNmi3P6e1ybxNk6xjRHSNfVs6QuY7TWgsN/t6tYF5YxAHv6Fon5r9H2qeAi2Dow4fbb5ivisuXA7epPeQIiKCAS3aqV9oi9+cfjB4DQCsuFA0ZGq0RLVRAl+96oW2dWIrD/8BPjWoOc25NabxhjF9F9+8c+9Z205iipv9XZDU3a7aMp+IrpK9qyog1lwNoUZvfI1do6XlDpPUpgbqAyyxypXzD+J8JuKnSnXaFT8ARmmvnXb38Dw/HoYL9BWJrA/SU/LfOE9FlJGnHzaPm/NvWoRdhI+C1LR+Hj1AnqG/wB+KlGIzNIHuH8Q+SWl5mmp18NgVuFhrhG+sPmnY+BEIxlKchglOssdWkTWCNjd7AV1Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dCcetdvs0UMkRq6ZL3Yal128xuWdSNij4uphe4v+m5ZYdUXV8lwVn61n0mZy?=
 =?us-ascii?Q?N+URBEnuvxIoK4xBA65oTN0l2N0qZkloLaxPloGYpvf+tn72fxatdz+bcQu4?=
 =?us-ascii?Q?J7EypcDyOmo5OyPgv9g0SccC4AZb6L8Vtku0JiwbobwHLtFtIbsfm23jW7xd?=
 =?us-ascii?Q?Y8Vmu0J6hT+P4BXdo+QI5fGeYpi+YofrSogCCBaXXnTYIz2BnlTDWwJvlOWv?=
 =?us-ascii?Q?a6tkrkSDladX+032GAy1QKi1CRORCY8uWPoq6idFof3JejNWo+/nQTCjpweJ?=
 =?us-ascii?Q?Eu0uysUqk1NDo8JE0Nc14rrNRRhXEHDOBAKHoWbc9+7QmBy/fdC55asH8abA?=
 =?us-ascii?Q?ZBcOBsptHPMwI6jVtUZdLwpLcK0bVZvJIjyfFK2isB3PsBU7pSAetTnzEbJj?=
 =?us-ascii?Q?H3mUQBZOkOjsK3ou1fwbJlhTqk3INdFLcGlJzFnC7y4+MGU0guoo/RWYNuF4?=
 =?us-ascii?Q?4bwEzg92imcIpU1y3QRXWkyO/GQ7c/D+6pmRykmulViA5o4+mHpdhlusozaR?=
 =?us-ascii?Q?h5H6cpX3Pr/VWmW8jV4YSaQNxFyKwChgufy6ZpuEHhEdI73324YeogsucI73?=
 =?us-ascii?Q?TQ+lxnw2y7toEmOsaUlDaf/nnn35SpkheFZLq+OvK72X7gSSDZVuTEcThrFa?=
 =?us-ascii?Q?g1LJ7J13qi+asE4cJ/Q1pUXPa57QbqgCz7sri1tXUqp9mBnU9WgLmtjiySAq?=
 =?us-ascii?Q?VmEDzPxFt1Jflqal3ouuOFkFUMkVf7DX3MgZPd0zlfKJVEZeqS+AnbST2JFO?=
 =?us-ascii?Q?nzYEuxRQGr0kyehJHon2tmg3VkyWgMz0Xu7DRosu3rjQtVvoWzl6BO4YBEut?=
 =?us-ascii?Q?nHlRR9cf7fxoBUKXdcZ2++MU9I9WO1HFZ5c2kYk8R4CNTNcYMSbQ2udKvsS7?=
 =?us-ascii?Q?U0krIUiOMmTw9Tzp0F0pY+fgtIBmqbZ3YgTkHKphNC8U1iiRINJD+k+XsLSj?=
 =?us-ascii?Q?ZGX2/Xsa4/dRqIG3f6YHYj/Fqk1XhAj4OfgQxMdyEHvR2Jh8Sutq2cZW6ARH?=
 =?us-ascii?Q?AL78Ss7fe/PNAJubXIkWzw/eGY0c8ucJhSKJp1uWupv5T7NmHtq0wTOwzM1Z?=
 =?us-ascii?Q?VsO/Gr4M2BX1OC3VIq8saLLe+9bZUfc/Oh/O02vsUMeOjPwTJTaqzFencibS?=
 =?us-ascii?Q?vdkuPQwKkuDtSlhVR2/l2YMiI9RGCE4OCJ3VW5bUAeEhT4VJfFRpwLCKilml?=
 =?us-ascii?Q?o9MHRVBnuesH000/6tB3iYoGwcQoluFhey+p7Im7K3PssQNcoz+V5ycFD07+?=
 =?us-ascii?Q?YyT5GJNRcni3Cwca0v+kzdwr2kbmLrZM/grrxQmzobaYKban+ZnJ387VNZIl?=
 =?us-ascii?Q?WAgqXWHHNnAURlDZif/bHGdA?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee65c974-4dc7-4953-99d9-08d921c4c244
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:40.8137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpQ5g6jfWTZSi38Yx3mZQpMxurt0hHTG+m6VjGaw+rZwA6vGF1aXuoW1Ci9m3c2eNU/dqAlylu696iiEN0Lj7QVd2S+FB20DI/rkxUWauQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-GUID: Lv_AH_yUjLJCKly_YXy67wNi9YBbd1T0
X-Proofpoint-ORIG-GUID: Lv_AH_yUjLJCKly_YXy67wNi9YBbd1T0
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

[ no upstream commit ]

Switch the comparison, so that is_branch_taken() will recognize that below
branch is never taken:

  [...]
  17: [...] R1_w=inv0 [...] R8_w=inv(id=0,smin_value=-2147483648,smax_value=-1,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) [...]
  17: (67) r8 <<= 32
  18: [...] R8_w=inv(id=0,smax_value=-4294967296,umin_value=9223372036854775808,umax_value=18446744069414584320,var_off=(0x8000000000000000; 0x7fffffff00000000)) [...]
  18: (c7) r8 s>>= 32
  19: [...] R8_w=inv(id=0,smin_value=-2147483648,smax_value=-1,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) [...]
  19: (6d) if r1 s> r8 goto pc+16
  [...] R1_w=inv0 [...] R8_w=inv(id=0,smin_value=-2147483648,smax_value=-1,umin_value=18446744071562067968,var_off=(0xffffffff80000000; 0x7fffffff)) [...]
  [...]

Currently we check for is_branch_taken() only if either K is source, or source
is a scalar value that is const. For upstream it would be good to extend this
properly to check whether dst is const and src not.

For the sake of the test_verifier, it is probably not needed here:

  # ./test_verifier 101
  #101/p bpf_get_stack return R0 within range OK
  Summary: 1 PASSED, 0 SKIPPED, 0 FAILED

I haven't seen this issue in test_progs* though, they are passing fine:

  # ./test_progs-no_alu32 -t get_stack
  Switching to flavor 'no_alu32' subdirectory...
  #20 get_stack_raw_tp:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

  # ./test_progs -t get_stack
  #20 get_stack_raw_tp:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index da985a5e7cc5..662d6acaaab0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -12263,7 +12263,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_REG(BPF_REG_8, BPF_REG_0),
 			BPF_ALU64_IMM(BPF_LSH, BPF_REG_8, 32),
 			BPF_ALU64_IMM(BPF_ARSH, BPF_REG_8, 32),
-			BPF_JMP_REG(BPF_JSGT, BPF_REG_1, BPF_REG_8, 16),
+			BPF_JMP_REG(BPF_JSLT, BPF_REG_8, BPF_REG_1, 16),
 			BPF_ALU64_REG(BPF_SUB, BPF_REG_9, BPF_REG_8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_7),
 			BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_8),
-- 
2.17.1

