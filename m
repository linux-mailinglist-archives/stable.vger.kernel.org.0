Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BF350A89A
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 20:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbiDUTAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 15:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351440AbiDUTAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 15:00:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3651D2194;
        Thu, 21 Apr 2022 11:57:48 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LINT1q004811;
        Thu, 21 Apr 2022 18:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yH3e3O+rZ2tn1EqO8Imom1AG6duRE+lhELtbT/HFyQQ=;
 b=HoRT8AfGNws3DCRe8JbbeZdb47cRPtTdbowwNQ89lQ811a8pm4EeZHQIHWJAjuXDEJk8
 AgxSoDB9yBO7rd0o0QJiG7MaxkoAzLQ/gfKgGzTOTiNU+0Nmbd4yuP13gYUxT+9DeMRo
 lxau7Ymh1XOIt6jRKtd9IlASWqDi9/4diZ5YW0fdoA59w0KV/INByjP1LpBSg0Ju49Hp
 YHyGF/Z8+l55c4Y0E0tyuVto0s2gdDCnwZeNZQA5bMAIqVYzpfybbStmPxmpzzKr6uQS
 rbgbnig5qsXDLs9pbhc1F49VyMZ27a37Zbn1R2qUHc+1kp0JICPkRfUL4sMIhzV1RJF3 Zw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer8xke8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 18:57:43 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LIr0kx027257;
        Thu, 21 Apr 2022 18:57:42 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3ffneantn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 18:57:42 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LIvggD61342052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 18:57:42 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D78E124053;
        Thu, 21 Apr 2022 18:57:42 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15F89124052;
        Thu, 21 Apr 2022 18:57:42 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 18:57:42 +0000 (GMT)
From:   Stefan Berger <stefanb@linux.ibm.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH] ecdsa: Fix incorrect usage of vli_cmp
Date:   Thu, 21 Apr 2022 14:57:40 -0400
Message-Id: <20220421185740.799271-1-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7VZxFIY05jd0-f9UHPCO1iLIfXjU5szl
X-Proofpoint-ORIG-GUID: 7VZxFIY05jd0-f9UHPCO1iLIfXjU5szl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_04,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix incorrect usage of vli_cmp when calculating the value of res.x. For
signature verification to succeed, res.x must be the same as the r
component of the signature which is in the range of [1..n-1] with 'n'
being the order of the curve. Therefore, when res.x equals n calculate
res.x = res.x - n as well. Signature verification could have previously
unnecessarily failed in extremely rare cases.

Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
Cc: <stable@vger.kernel.org>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/ecdsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index b3a8a6b572ba..674ab9275366 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -120,8 +120,8 @@ static int _ecdsa_verify(struct ecc_ctx *ctx, const u64 *hash, const u64 *r, con
 	/* res = u1*G + u2 * pub_key */
 	ecc_point_mult_shamir(&res, u1, &curve->g, u2, &ctx->pub_key, curve);
 
-	/* res.x = res.x mod n (if res.x > order) */
-	if (unlikely(vli_cmp(res.x, curve->n, ndigits) == 1))
+	/* res.x = res.x mod n (if res.x >= order) */
+	if (unlikely(vli_cmp(res.x, curve->n, ndigits) >= 0))
 		/* faster alternative for NIST p384, p256 & p192 */
 		vli_sub(res.x, res.x, curve->n, ndigits);
 
-- 
2.34.1

