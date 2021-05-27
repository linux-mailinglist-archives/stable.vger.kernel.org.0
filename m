Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0766B3934FD
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 19:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhE0Rk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 13:40:28 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:51286 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235205AbhE0Rk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 13:40:27 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RHXKjo026033;
        Thu, 27 May 2021 17:38:40 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tfbh81c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:38:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id5uYFFpQZTGW/rFJXohPZj9XpQVBdwQE5fDYKPsc7LkRx3a1Wo+gJj7ifvEzcH/tNa1+Duq8r49o8chMeTKnhRUydu/kN4RDJiU3C4mCU0FxPp8ob7fDzKfGg3InxheQpIkjQDh0rGayaW6D9jRaALuVyAgFpyhTW3SgDtHU3xoJTvjYYodvjyJXVTXpyn9rgTCCFFBJk0b3X8gBkiT4P6i/PIun0GCd8BByFTTlhk9+yziZ4JrnvGVa51TVhytU8KvkY0M626RKB/OQk7zhpbwMRxSPQavhXFj6j7jL636PbkwwwU6+n7uaniRB+vS5t6rzbUdvLcsbNoH8cqRlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzc8ObJq7UT9mk7FcG3+fq8wMBJaNFS1e3YxgwukvnA=;
 b=Wc9iNpc7UKlmxL5mdf4H6vfJ6OwJ2A6L3Q/Mw5sp2LsBu/nwDnVv0JhB6gwKXPzwuH69JAiotaaRyq7MtSzeyt5m54vbM9/bNPLzXWnQPPGup6xDcPZCqfGgi8W0L4Xe4odIZ8JPDwT6zF6SUT/NDLDpuUpnrEFZI+eM1+uqhKzeMKsGsHXcCHuZDkGSjTwbBlD2Sc4sagF8WGi6t3mEVaa0FfaGfwW+nL7/a2c7bO3Esl4j12wbgR1QWgQ9EOHlLkK2He9ErR6OJypHjrylVjJzc/IUApT9j509FtqKdWwdAblnvie6amovn8/FYaji+f/1XyXmAzIfV1+sMxKGFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzc8ObJq7UT9mk7FcG3+fq8wMBJaNFS1e3YxgwukvnA=;
 b=Y0AIjyuzwGvoNSl7KJUnbW//tGbn4ndPaDEZ5DsIA05VyHwfM2qF9cFnGPjAPIszlcjn+W65lCXSBJ8Y6nVa0BuFBlZLfjASOEdaeDfZibTy+ZVx7Vmez+ixxW7ewUkIOCn5drDjxHQajsSRKHwihRL9cqb3drF62rsq/FLphDk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2162.namprd11.prod.outlook.com (2603:10b6:405:50::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Thu, 27 May
 2021 17:38:39 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Thu, 27 May 2021
 17:38:39 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH 4.19 10/12] bpf: Move sanitize_val_alu out of op switch
Date:   Thu, 27 May 2021 20:37:30 +0300
Message-Id: <20210527173732.20860-11-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:802:2a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 17:38:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2a438cd-b949-4fdd-c8d2-08d92136434e
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2162:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2162CAFD63399B22BC83DF46FE239@BN6PR1101MB2162.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:241;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReRjI6WuLo8IiS8QKlpNOt7qbOvXkbj4J3tKssmYUsISXeW/BRnJjiyZ3fpGoNm8hHSBbwIALgXCEQ8bWUSKQuw2DaEqe2On9omK15iMFVrxI5c2nt5qydw4zUIJUNdhmqR77VA32nqVisq4Fdgc1O+oCv9ggpwXpL4T35jPa8xd393+Kmg2tHQLi7cSCrkZgX5NybwWUIOW2LkMTZWaHNBjNOyqJp26IM6gdM4/c64NDazpDQmTrV2SX5VPuSu+dvj5V7RqCK0VcoyT44mz9Hp98D9/U7R9iIW3j9vwjH/37UO8D7ECXYUmJGbTO8HtbW4+/mr3zvjDvVe0QR4z0o2EjgQVduF3Sj6+CAe9f/sZaL5E75sivgiU3ub1Wpo0JvX0PrBwRatWofNIhTjkhsQXWiHW72Gkz2nJ6czHeO/QKaW0Bm6HikJ/v58b8CgpQLRmKK3WUhl5/HdmLlYh5dIeS0FqV7VCXdpXyIfVVaXnPxT/RR1ewUVvbG7G1K9KXi/0kWUKQpSfLJDjf7/b8T/tbGDLKbyl8I7nSHSggfwFzMH6h4hL8X2ayL1qzPcdqUpf2X16kVFTbfT8kHHDboIfwkvQfyOztxIKqMoiwqhNX4dV9OrGQLXrApVVy7R8U9gYIrN/CIWSV4Fob3cYYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(136003)(396003)(346002)(66556008)(86362001)(8676002)(36756003)(6916009)(26005)(83380400001)(4326008)(5660300002)(316002)(8936002)(6666004)(66476007)(52116002)(6506007)(6512007)(478600001)(956004)(38350700002)(2616005)(66946007)(6486002)(186003)(44832011)(1076003)(38100700002)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Kqfz/DCqzffpw2KU509feXW7ZYmzI5QALsvJTZbsDbRKtm1OFQd3mLZieKxO?=
 =?us-ascii?Q?BNNIXsheLVI4PdIBig/0tSRKqeNufDdWx1JdLo2ZtFgxo3QUcu+46TKGQmvR?=
 =?us-ascii?Q?u4Xb/DvL47jzTFVk3+7lUOudnlRDrw//njTzO1DojWph4Dd56kZpanbbd2mn?=
 =?us-ascii?Q?8hCD4GjNa/kKBvqFUxE5mqXpnxdI7zXRWHkPxVzy6A0fiZrt4phsJe0lNgXS?=
 =?us-ascii?Q?mbq8vnRYl1bgapdMm1Eg/pU9o3JQ03DPpmLlIAnYaCPrcgPtjmi/A1gjVPHY?=
 =?us-ascii?Q?8nIBheHpz0tLcuLHM33L9+F0ViTLaMBGtiPejL0Lv7Bh9H1hozII8GULI+aa?=
 =?us-ascii?Q?/ETukOYdnbL+rkvkoyGeYSxnebJAslKDZBe08QhkDi/ODXDJS4M/hsi9WM0j?=
 =?us-ascii?Q?cuxlgq0eGnEVv9h3lvBYbPzfEZK9hM+cad+7gYIMhD6HtcZAg5c4JvqUA6ts?=
 =?us-ascii?Q?aX8BnafgzbaFOG6hc5A+eCyYu1xjeU6zJwG9HMiPLt/DvGo8F99GIDeuoTbZ?=
 =?us-ascii?Q?Wu4Z0XunZCoLhaPgQ2VZHEiDMoQTSF2/O5FhBkqRX920hubsPyKIk8HQs2Xk?=
 =?us-ascii?Q?thOYtjFF1a9Rzy07L9YPCY3ejJS6Qy4gdJlLIduVSKthQLri87SIK4mvnPSk?=
 =?us-ascii?Q?FD32ln370UYaoTlguwhCRwIjxsLDahnlLewHtnz5jzXfu8+1Va+YVl9A6BSc?=
 =?us-ascii?Q?FLAH//cuP12VYsI55jVx2bSWs3Nw/gptR1TMkSU3M4gSppKYklCWW9aF4DuQ?=
 =?us-ascii?Q?HWgQuNdNvbkotUK5m2hTSVlJHtAmGmiHDvZqPSWDqLtkPT9QzTsnIVhpDgAx?=
 =?us-ascii?Q?vCDBp0koZk1yzwwatl3j2hL0xMQIrPwPrGab69pSLvYq2/cORpj8aM+nnrBK?=
 =?us-ascii?Q?D11lsi/FdUX57W2S5fo9B18yF+8DKO1tf91Lra5bwZHafIP2dAoB6LUYQI8y?=
 =?us-ascii?Q?zcXwwYS6/qugAqnzy+vXWe5drEQCjBMCDW8NcWsQs8FJNTW15kp7eMo7Ngtm?=
 =?us-ascii?Q?s6CPnpQpJHry6Q/rHagM3W0n+hl1/VUAmOu80JqwmR2hs4P5J1DxKetzJ5ws?=
 =?us-ascii?Q?/OFHp6nt76r3R73ce3zX73JxG4MLrLCdy70fTBviB/vnncIStFy0rhZ05cDc?=
 =?us-ascii?Q?MQKoJa4F9tCGm1tzKZOLYio0Nm2YTBGrFDvUQdJq5SQS1TTESjiUyqgIn2PH?=
 =?us-ascii?Q?SQ485BGV0Seo7h7wex1jHdImgJAMSQ2JaGGmJZjGjIPBQqDZjRhHlWD9aqem?=
 =?us-ascii?Q?lr7WK2DhtXEkL3D2Q3FbNISh6JFKeW7OvC6Mg3TsdVaTqe/jeS0GWy4Bvdsj?=
 =?us-ascii?Q?rhE1UJlGfdQnvkGsW479rIpd?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a438cd-b949-4fdd-c8d2-08d92136434e
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 17:38:39.2752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIpxG2T62btsXJbEEU/QjmIrP3H36sqQRKFGid/I5r0NHtnlcAWvXhRd0KR8+kzFhuVn2+dVFHXcK8p6PEMSmeko/R+Ym4QaqIquQn0I2R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2162
X-Proofpoint-ORIG-GUID: DN7gD9oopEmdUietyXSPGij-F9fqUkKt
X-Proofpoint-GUID: DN7gD9oopEmdUietyXSPGij-F9fqUkKt
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

commit f528819334881fd622fdadeddb3f7edaed8b7c9b upstream.

Add a small sanitize_needed() helper function and move sanitize_val_alu()
out of the main opcode switch. In upcoming work, we'll move sanitize_ptr_alu()
as well out of its opcode switch so this helps to streamline both.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backported to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b2fe044dc6bb..1c1736851581 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2815,6 +2815,11 @@ static int sanitize_val_alu(struct bpf_verifier_env *env,
 	return update_alu_sanitation_state(aux, BPF_ALU_NON_POINTER, 0);
 }
 
+static bool sanitize_needed(u8 opcode)
+{
+	return opcode == BPF_ADD || opcode == BPF_SUB;
+}
+
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 			    struct bpf_insn *insn,
 			    const struct bpf_reg_state *ptr_reg,
@@ -3207,11 +3212,14 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		return 0;
 	}
 
-	switch (opcode) {
-	case BPF_ADD:
+	if (sanitize_needed(opcode)) {
 		ret = sanitize_val_alu(env, insn);
 		if (ret < 0)
 			return sanitize_err(env, insn, ret, NULL, NULL);
+	}
+
+	switch (opcode) {
+	case BPF_ADD:
 		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
 		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
 			dst_reg->smin_value = S64_MIN;
@@ -3231,9 +3239,6 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg.var_off);
 		break;
 	case BPF_SUB:
-		ret = sanitize_val_alu(env, insn);
-		if (ret < 0)
-			return sanitize_err(env, insn, ret, NULL, NULL);
 		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
 		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
 			/* Overflow possible, we know nothing */
-- 
2.17.1

