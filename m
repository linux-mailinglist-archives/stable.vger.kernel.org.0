Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD02F39413F
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbhE1KlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:05 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:7230 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236613AbhE1Kk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:57 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SAcdwr006243;
        Fri, 28 May 2021 10:38:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-0064b401.pphosted.com with ESMTP id 38thqe8hke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 10:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id9T0hCL943tDZ4M9hGNX9FGulVvV0zSiuKNsXro7lZuJrWtubUq7Iyw8PLyclih9m/4+yDoGxFVD3nbijs2SiyWbrqxT2d+IwggR9PBH3kcaf/ZNCeVaN948fYcwyNay4L0xU+okGY9Dy+ON6sr7arnwoB2uEkEPUFptaRvxAI6zSnUcRyzIfTWtkuOUrc/HgGxH7UmmlAqsrSq7AP5bgQ4yNph+KoZiZvDc08tKUVDloP5SDHqJ7kRD3mG5dwDxkthA40ue7xbNZBmd7eT/JwnLs9xO9EOZVmPBr7Jro3ibbjO4LIcqdBaFeVuX+8xe5PCl+yE/RbYo/E42SqAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqG9SAr//t02oAGFy3zm9t8VGjOb4sHhPCyfH4uNOcw=;
 b=Q0xURDPiUgf1sBn23ELL9rNFgpJtEwm63bca4mMJP3ZpBUFpI2iSaEjSxAB64d0bxRnaOQBl/mUJdoWGb+kJCLbGtKVOSXY7ZD/FlkMPAEWG9ZplaRdI4KQGnHEy58jaYPze13pZmteZEFDHxLhuErEPX7V1Hu6Xycvyi+ity+zBrnClqjBwPRfs15Qn0mdbrThl6jHVuf6i8ahJ7aEbo+fV48yOyuscsRQHC+4HJcLCjytrLrpvmkTAJr16vrlRisGZIOmFKwi3pmp6jbCCiNpSvyJGZVm1PTe/jVhrc7F3Z3FnHgM/1lH0y2eVSollf3WTLZ3x0w9LDIg/0MkUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqG9SAr//t02oAGFy3zm9t8VGjOb4sHhPCyfH4uNOcw=;
 b=P/vC316tYx55uDokKGY+drdGlTaZ51AXpwUXH5BD6XSdjBJ1uBmhRFqZK+hLB8yDtOD4vIais7ZmKZRFfRnnCEQ0t0lx44rmAZUVKnFzPdWgXAudWMhKRVtIQLIn/M3FNRfe3XVx4mH7Zj06eSWGar+b4VmcbL0fvVGW1JYiLco=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN6PR1101MB2097.namprd11.prod.outlook.com (2603:10b6:405:50::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:44 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:44 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 09/19] bpf: Ensure off_reg has no mixed signed bounds for all types
Date:   Fri, 28 May 2021 13:38:00 +0300
Message-Id: <20210528103810.22025-10-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 326fdbf8-d4d9-4553-0fe5-08d921c4c472
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2097:
X-Microsoft-Antispam-PRVS: <BN6PR1101MB209767F177671C8D116554C4FE229@BN6PR1101MB2097.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VCKZ6VbIglfz7vDijp985i7jus01sSKSIJknjeC6YeV7VVAsMisShuKVc1tl+dd14cDC3bvd0uLRFGx406HfEjoAc08fEu4sdEW+vtMd1j8rJyaSTXvMTrGAB46VC/ndSPKcWlm12OKEfvU5lbld/ss0OD4iuESaO3OEiI6AjojMw+SCjnsV+FAvL6l3/qgDDKUSQ0shKoDf1/U4yqNokmkXmMtfXlzU0QZiXGUDrC1H9tiuCNm4XNLpyU7eYLcyuua0AshbFhMh1mJfKyxUYC3oTnVXnPWzyrdMtcf2RH3fHjRjih61k4xlOAy/Hi1N062aGpx+z8pJHZ95EyAvU26OQz/iF7f/D9j8FE5kPrL0ZHgrzFVvEwBBqNDuBpAyVzurLdn8hEv0Nwi6jrqVb/iP3nlnMncAp2Bd/6a01FZaEJN/9Q827ypvdQ5I7w69pT2E0afsFg1shCzxDbl2opWmuzL0CsvQF7LA/ZXvZVigiH4Wr89tAEkOR36/B3IeFEUfHKDXACoCaFPz+JpfF/+JfQBJaN/nTp9PaNaFj02QBgiwNz3oWvgbA1IUjL4MYyeg7y46jGkn+XV50qaBafzJ9ClV4z2ucqMy2l/EE6SvpUCxOy0eLeO1BGgg7oZUK/KFSq3tt48xvYHU35Olfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39840400004)(366004)(346002)(86362001)(478600001)(2906002)(6666004)(38350700002)(38100700002)(4326008)(6512007)(66946007)(66476007)(66556008)(316002)(8936002)(6486002)(52116002)(1076003)(5660300002)(956004)(26005)(2616005)(8676002)(16526019)(186003)(6506007)(44832011)(6916009)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2uiyyM1MJI38jRR5ybJDrhT6m2/yhKcRpqmfQT0gK0mQWfRSDLaBx1/HQzPl?=
 =?us-ascii?Q?V9EuBtIOFAHelnaJrE4v5zfEwXVvWRsOVlECs7UcrHREaOgEqSWgify3woDg?=
 =?us-ascii?Q?pfwumQK5KyFmWPpVKUtfZ5ODNNqIvU24lE297D9cQoURnB0n2JF8DNALq7S9?=
 =?us-ascii?Q?PNY3jZ75L4xNupzvsFY91LlIVwZ400f4tkUj6ENoGt9/5DBAJVo6VSfqgEpe?=
 =?us-ascii?Q?3MmLSkO33a8oyX1dZIA2xyHt3+0tNtoYkgHHEjCj7GqTF5QSNmQLJuVf1BZ9?=
 =?us-ascii?Q?dP2vLxnAwfUhIup2PtKX3l3mGYA9Z88oCj1CWDurpkkb7r67tjJkFXb4uHC1?=
 =?us-ascii?Q?7NcYoSShlRm4/e8LX6he833PLmELGuSnZgS4Mi1NTKQHSx+u0y/m62cyU8mm?=
 =?us-ascii?Q?79HQBV7VZ1/fbNGGmWQeSalmdchNuTpuF2BDoG8OvlNYHftcu08fbC7t02Ua?=
 =?us-ascii?Q?WyM/OVxkb9HsiJqz7KHkyWVF13jYLtNh4CzZK1t3anGK0JvgXXWbYQQJD3fi?=
 =?us-ascii?Q?izsFmq7SHLYgPk8MsCpCQOLtYcnoeq7pSJflZVUiqdz0Wns9gbOrK3FQ9+/D?=
 =?us-ascii?Q?4brFmYf9xYr0pRCDUnUz+R3TWGIWBddyvwybWgP42ebhUQJMpdL78MHpyuZx?=
 =?us-ascii?Q?X4PzeEe+36BMF7vTRmOlun++XiOx+YPudFjiGmLzkm0cnRgOdbP17e3wplPC?=
 =?us-ascii?Q?DHe6qYyfg4rDD1W/z1oikUd9hDq684nMZdCizhDIPBBcZSHUNohy5yNrGiua?=
 =?us-ascii?Q?T/OEP5LkPWD+t7SV4xImEOk8+7gYTS7s6IUZJOngP3gPEMUs59QXfGJBpW5x?=
 =?us-ascii?Q?jGaYhTsILr/pm8oJBIFIKTyYNNUhT0fDKkW6qg1Ojw904rqzvB5Ko+9so9l1?=
 =?us-ascii?Q?gw2n054qqBJGjFrJuRKrSGpf4vWDEs6d1xcc078v5tfVCBLWL31PKQdpKGZv?=
 =?us-ascii?Q?PCzrFchugyvHvJiBW9z+LW5UwtnQpoJpuTDwtB4GXyPcagIVInYMJBEOXlKy?=
 =?us-ascii?Q?22R2KE1eXWgSpWMSggQDO4h5xcKjRT+CkaWioeSuAtf3G5y+K21f2syUTpTz?=
 =?us-ascii?Q?vLbqBucpDGqvWtNtQ/6kxMUB9UhXjtZqdvDiocziDrwBwdA5SmtMSd1v0UBg?=
 =?us-ascii?Q?suPUV903oQ3rcMskR9YXK+Kji/tNJtkcJ/TeYTQdEPcXNtQkB/lOzhuuE0qR?=
 =?us-ascii?Q?siH0THzP6vAcB7bEbizZwjYlHJsEddjmWWQ/meqiU48A9SfaP69rsDUOGE1r?=
 =?us-ascii?Q?QvEqftKG0Z7UIwC6GSl1mIu6IQPNK+LaU87RfcF39QtmVTXnB+wn5Q6pj35J?=
 =?us-ascii?Q?dKClBsjj9a2uVKVjfOyQy+YX?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 326fdbf8-d4d9-4553-0fe5-08d921c4c472
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:44.4261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSTqG9pdWcP49NSrWDKzoo5iL09Y34+0zCFAre5R8q1RJO2UdmkvUquceJik8arZ+1TAUs0jMBnyT0/tt+0Qgf9b48bkbi8Qudlk4h01Klg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2097
X-Proofpoint-GUID: SbiQ47F-OjNyN_HKCxKRGdDjb9i-6Osn
X-Proofpoint-ORIG-GUID: SbiQ47F-OjNyN_HKCxKRGdDjb9i-6Osn
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

commit 24c109bb1537c12c02aeed2d51a347b4d6a9b76e upstream.

The mixed signed bounds check really belongs into retrieve_ptr_limit()
instead of outside of it in adjust_ptr_min_max_vals(). The reason is
that this check is not tied to PTR_TO_MAP_VALUE only, but to all pointer
types that we handle in retrieve_ptr_limit() and given errors from the latter
propagate back to adjust_ptr_min_max_vals() and lead to rejection of the
program, it's a better place to reside to avoid anything slipping through
for future types. The reason why we must reject such off_reg is that we
otherwise would not be able to derive a mask, see details in 9d7eceede769
("bpf: restrict unknown scalars of mixed signed bounds for unprivileged").

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[fllinden@amazon.com: backport to 5.4]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4edae9b29cd1..cdef8c7769ef 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2730,12 +2730,18 @@ static struct bpf_insn_aux_data *cur_aux(struct bpf_verifier_env *env)
 }
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
-			      u32 *ptr_limit, u8 opcode, bool off_is_neg)
+			      const struct bpf_reg_state *off_reg,
+			      u32 *ptr_limit, u8 opcode)
 {
+	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
 	u32 off, max;
 
+	if (!tnum_is_const(off_reg->var_off) &&
+	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
+		return -EACCES;
+
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
 		/* Offset 0 is out-of-bounds, but acceptable start for the
@@ -2826,7 +2832,7 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	alu_state |= ptr_is_dst_reg ?
 		     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
 
-	err = retrieve_ptr_limit(ptr_reg, &alu_limit, opcode, off_is_neg);
+	err = retrieve_ptr_limit(ptr_reg, off_reg, &alu_limit, opcode);
 	if (err < 0)
 		return err;
 
@@ -2871,8 +2877,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    smin_ptr = ptr_reg->smin_value, smax_ptr = ptr_reg->smax_value;
 	u64 umin_val = off_reg->umin_value, umax_val = off_reg->umax_value,
 	    umin_ptr = ptr_reg->umin_value, umax_ptr = ptr_reg->umax_value;
-	u32 dst = insn->dst_reg, src = insn->src_reg;
 	u8 opcode = BPF_OP(insn->code);
+	u32 dst = insn->dst_reg;
 	int ret;
 
 	dst_reg = &regs[dst];
@@ -2909,12 +2915,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst);
 		return -EACCES;
 	}
-	if (ptr_reg->type == PTR_TO_MAP_VALUE &&
-	    !env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
-		verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
-			off_reg == dst_reg ? dst : src);
-		return -EACCES;
-	}
 
 	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
 	 * The id may be overwritten later if we create a new variable offset.
-- 
2.17.1

