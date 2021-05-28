Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24929394134
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhE1KlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:41:00 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:4030 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236625AbhE1Kkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:40:45 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14SActBH010271;
        Fri, 28 May 2021 03:38:56 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 38tqu5ra29-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 03:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLYAnAPG6ybuP6Mg5LpdtI0PzM1w1cbYRKK8BHUnJK3b3E9U7eZSjx7i5/ToW6IhC5/Uavn9IgVS0mkV3RUjsLUwlOh5GP3wxARK8ly+xDn1GEgwITS2RKVdv8y34BsqIVHF2O/MrQJ2HGlX/3niFjLX9yq4DpcNDRUaJD6SgEVAExnA/+4S6F56yElm/f3DY7uas95KWtTdk8fkpc4oavoNyfrU6OkvZGoefso6HFo7Kluqtg55I65ZjVE3q/T+/Vle5pZE3N/YQfcZb12TESzPDuK533UkP7Begud73qXsqfhMEdY3cjb8RKllGrphu/Carz8xkCwrXoDLr68YUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t3L7+COS90C5bzZHkokHmPZxSIy8StCAviB1yIOFys=;
 b=gTHpbmv+Yw6A2RYGc+d8S6VkK4oa3EckYORCjicb0wfpMDxr3liLOKPuYP7XAoiwI+3DNPru9hPaw53GI31h5vwj6xdOXmDEePe/JlXdz1jkgV4RZuzspIFnnQ11nIZE4R2hwmeu7XJXHuarCg/4YjuhKtmHvmHWRIFBJBd+SG3laW7LOktcZJXEkzJcgzGo5zyVrogggmOYrL9V6fCGM7xvYxnnB6hOnukKP9Cx4e2aAaC8Xr7hDJL6rJH2/KA3FLS+0jJ1GZstMXpgCgs0MCAQxzM4C9m9o65RiTQ3KjkSQCQh0OgSmR/pZsIJUpDKsn+Pa8iZwMQ3dw7U1z9ceA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t3L7+COS90C5bzZHkokHmPZxSIy8StCAviB1yIOFys=;
 b=YXnyChdKI8jyBa10Wif3fCIOXJS+u51TpbFQ/m9kLImaJMM+yIn67lxSb/YpKheqUGeJnShZs55lQgnvbvCM5HLMkBIjFFR9GVtZb7Xv58HkkHdwddB21X5N7Ryl3iAnlpkqse4zcFw7VSAIXX5ZK4r0wfieTNmjtjUSMGycETM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN6PR11MB1956.namprd11.prod.outlook.com (2603:10b6:404:104::19)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 10:38:51 +0000
Received: from BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33]) by BN6PR11MB1956.namprd11.prod.outlook.com
 ([fe80::f100:256b:e0af:7d33%3]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:38:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     fllinden@amazon.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, john.fastabend@gmail.com,
        samjonas@amazon.com
Subject: [PATCH v2 4.19 13/19] bpf: Move sanitize_val_alu out of op switch
Date:   Fri, 28 May 2021 13:38:04 +0300
Message-Id: <20210528103810.22025-14-ovidiu.panait@windriver.com>
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
Received: from otp-linux01.wrs.com (46.97.150.20) by VI1PR0102CA0083.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 10:38:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffa6d92d-cce2-4cf8-1f01-08d921c4c8c6
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:
X-Microsoft-Antispam-PRVS: <BN8PR11MB3780036BDD67907A4E71663BFE229@BN8PR11MB3780.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:241;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJqAeCWZ98CS9wpjgrX0u4oNFewmHGPdRHket4Fy3TRzW1z3jJF1QDaDyjiJ80/+mSJRWMO1Pwa4/8kicOCEHSHZIkfCzbpbbX0VIp2wNXDkSK2Sc+ZpHXxvsRDlcEn55j9HdisSIMFgUNAzXQPsuy5kP8Z6GRVYSriZNmZ4dFjFNwxYhSWC2FBpi6QP5taYn/5UIIU93y5q61nmQ12D19onsjv6+3Lsw5fomJh1KPPFeXBPXMWPKWEdnmdgxdWdjjRsWE5reHBUyzMLklGAgrJ7yPP+3bV8oegLgDAhmqy3wmb07FbiA2GC9BmMupIKravFXmGQwtgRlAZFXwMq7FLYwHvU8Y1ejqUlp4BebBffm0rIsrxNlurGK1iOtdpLNjDE1xsgz1WDyK5w+m5a8WUeLhfgVp1VRC2IDL7V79ZOlnUSn3BhbpTdcNtrDKc/mU+G4+M4VS61J0CN7F76AHwruTg+DNQ76V1ojoKAFH/Y8PgATP7Ju49FYGdqAt+Pbz+BJYD1kte3cRkAEa/t4ajM8JSzuw0nG0S2BMxq9WEZBbcOSa3xcnvRvBxT84baD+8OLhECM/nsScUrR7Eh/8aPUUsdaYnPIHBr2Q6gWLTvQa3vjLhZcF/KvxDLhfLJnOwotdElOMTzmVRRmS9ydw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1956.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(346002)(396003)(376002)(8676002)(6506007)(26005)(6666004)(316002)(52116002)(8936002)(5660300002)(66946007)(66556008)(66476007)(2906002)(83380400001)(38350700002)(6916009)(38100700002)(4326008)(86362001)(6512007)(186003)(16526019)(956004)(478600001)(44832011)(6486002)(36756003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I0O5NKBaLe/hhON6Mog3Ggk7Qt4KV5uiZkdbsHocm1n2oltkHsp4fsxVYUwx?=
 =?us-ascii?Q?lYMrshbw6cyiT2LNCmx6p43AaeJIQGjldx0CiPiDd7Se2NV+6Okh7PIY70Ej?=
 =?us-ascii?Q?xKBnyDO4wgXf4McDGaB8MxFwt/LHVJ5p9iZjgMiJ7wYa7rwTk+lp6Q8vT1B5?=
 =?us-ascii?Q?cfzwkTLSQbZ/s+pVOl9V0NwlXlRTtRiqIfDJrj51lK1G6J99aX9L5GNrLAGq?=
 =?us-ascii?Q?5804q0Onl2qcUJcMKynzy2fjj1YjShGOq5xsKi47U8MSWke8LIrT+rRC1gtM?=
 =?us-ascii?Q?7LaPzgSG8efmBYXg2PamSK67j7bBS1YcVz/vq1HhAlxrf4zIVtT2u4/QeQ76?=
 =?us-ascii?Q?TZKu2uf/z6DRoZ9b1H5hOuKml8QewrjDWBz2CbQgCyWwIu6ynQ1IcwfTPMQe?=
 =?us-ascii?Q?kEQa8SzFORDOtwmHGbT2dTdDCbI9toK1XthDgLb20hW/RqNEbqmVbuleb8Y6?=
 =?us-ascii?Q?pTGE2gLv7H0lQwQCzoubt3qK0zpZKh50rUQFI/xaGltj4pu90fIIrovN2Kt0?=
 =?us-ascii?Q?Ovp7kaineSHj4CSHnBD156OiNKlsNMOSG2rIeHAMpUC9Uewh/KDFmUdgpUX5?=
 =?us-ascii?Q?UTI8omrouadHUWSZ2s4zo4xygQ0eX4Q4JtGwg7nO/3ABh64nNBfeeiJz5Erb?=
 =?us-ascii?Q?J6SYYhwg+Z58aoRa53Mr41fFnuC6wBNqcvuaMPVvZ1t5oxshUoWXOiGgnTmf?=
 =?us-ascii?Q?4bVxGBp/ZaY72darmyjKAts++ZkL5MSWoZuSI9WMalfITkBTgcfFll8/H/j4?=
 =?us-ascii?Q?saNgVH1ExRd0rsHaZp8kpmQ/6zqFz9lHnNh/vp4skGe4cXGRbHxEzHQzHTWn?=
 =?us-ascii?Q?yf1U2GcqaLjdpIqh8HBsKNI7O9M0NQIlmvag0ciwz2grv6Of91rN0Kdwy4ry?=
 =?us-ascii?Q?oUqBPwonWTMVrfc+5XvQsyz+mA8NxQbEyMLzr24+mPizfgy/4CCKYeaZANHe?=
 =?us-ascii?Q?v9NfDadXQ7CNsrhlVKMOLszSzCzY+7hOQGPaq5uPLgc18TBr51o5qUjS/QQE?=
 =?us-ascii?Q?BDWh/DenohOqN9Llf/C9K5zM/XOXfVXKNTr+sJ9M4oO2KjB2t9QoAjTNvW5s?=
 =?us-ascii?Q?GHinl4AAQhP2znZci0vCBj+SgY2zIqVG4bT0P5qOLGt9jpQ2Ic4OT0BKMPBw?=
 =?us-ascii?Q?D8jtUu06uDjBYJXZDMHGXNblub7FFb7CK5JrBCf9akwXj3g4euG9/qfu52jy?=
 =?us-ascii?Q?3LoWb191RNzGMBKseXSs38ubmxjJy66bo/vjKv+gsiI1fzFUpSRVazhgML1a?=
 =?us-ascii?Q?zkwMI6vQSoQE4Yy/8uaiTjrrx6l9nMlvKMzpERu21wOW5mqGSAnsgzl/RcGA?=
 =?us-ascii?Q?a/M8civGKwrNoiA3UyU9Vs5v?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa6d92d-cce2-4cf8-1f01-08d921c4c8c6
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1956.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 10:38:51.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kjG+OGA64J8IIlAA4/i+cFYwyvX9wOf73pHGbwqoUe8DV1AShy4HOwyss1NJhoCazKkywHS+zZTSSgYmRpYAyApKR+WJSTpKSJYCie2cWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-Proofpoint-ORIG-GUID: ukePhuw2GCzLtcEANXhYYb7_quBCPROM
X-Proofpoint-GUID: ukePhuw2GCzLtcEANXhYYb7_quBCPROM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-28_04:2021-05-27,2021-05-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=991 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280070
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
index faa2a4c3467d..094f70876923 100644
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

