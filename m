Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9D6696E26
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 20:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBNTxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 14:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBNTxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 14:53:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403BD2BF15;
        Tue, 14 Feb 2023 11:53:18 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EJOoim015894;
        Tue, 14 Feb 2023 19:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=cpEFMTJF0c8mNrTgaTmrHxC7JkzALGrMQm9hLxqNiF8=;
 b=WHqyfh/aRAhlgn1ZU9qk3KSz8mByETMPUuQ1d89kyBUB+f/vBXIK585PyWB6hyHN+uFB
 enTQtwdGRZD7BJd+4+SbSddFlQk5wsBDCDAgBQ6xOD36O+ScY0OxEUIZX68wWEXAEX3W
 jF606tdgo5edzPU3JGxPONQTIcQifOUPRJPnth0vynXuNcIGuiJVp/L9g7VwANfNDHW8
 OAsmAj+ynXjBuqqt8aSnlhrd8KrcGBNGhvb43KCUcGxpnI3HEGjs2XdNGayUOPRe5Rf2
 uREb+jY3baXRlezqQSI9wi6FR9eQztsy1pkcQ93sB2mgSpLKrhRw16qKx/DX5U/c/+ns 3A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb6f14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 19:53:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EIG9Uf026916;
        Tue, 14 Feb 2023 19:53:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f62ypm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 19:53:11 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EJr9fZ039557;
        Tue, 14 Feb 2023 19:53:11 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3np1f62ymq-2;
        Tue, 14 Feb 2023 19:53:11 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     stable@vger.kernel.org
Cc:     saeed.mirzamohammadi@oracle.com,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable v5.15.y 1/1] crypto: add __init/__exit annotations to init/exit funcs
Date:   Tue, 14 Feb 2023 11:53:00 -0800
Message-Id: <20230214195300.2432989-2-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214195300.2432989-1-saeed.mirzamohammadi@oracle.com>
References: <20230214195300.2432989-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_14,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302140172
X-Proofpoint-ORIG-GUID: GM0CjFnR3y7yaRS0bN2fJmN1Vr-TCUGM
X-Proofpoint-GUID: GM0CjFnR3y7yaRS0bN2fJmN1Vr-TCUGM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

Add missing __init/__exit annotations to init/exit funcs.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
(cherry picked from commit 33837be33367172d66d1f2bd6964cc41448e6e7c)
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 crypto/async_tx/raid6test.c | 4 ++--
 crypto/curve25519-generic.c | 4 ++--
 crypto/dh.c                 | 4 ++--
 crypto/ecdh.c               | 4 ++--
 crypto/ecdsa.c              | 4 ++--
 crypto/rsa.c                | 4 ++--
 crypto/sm2.c                | 4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 66db82e5a3b13..1e413033449b3 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -189,7 +189,7 @@ static int test(int disks, int *tests)
 }
 
 
-static int raid6_test(void)
+static int __init raid6_test(void)
 {
 	int err = 0;
 	int tests = 0;
@@ -236,7 +236,7 @@ static int raid6_test(void)
 	return 0;
 }
 
-static void raid6_test_exit(void)
+static void __exit raid6_test_exit(void)
 {
 }
 
diff --git a/crypto/curve25519-generic.c b/crypto/curve25519-generic.c
index bd88fd571393d..d055b0784c77c 100644
--- a/crypto/curve25519-generic.c
+++ b/crypto/curve25519-generic.c
@@ -72,12 +72,12 @@ static struct kpp_alg curve25519_alg = {
 	.max_size		= curve25519_max_size,
 };
 
-static int curve25519_init(void)
+static int __init curve25519_init(void)
 {
 	return crypto_register_kpp(&curve25519_alg);
 }
 
-static void curve25519_exit(void)
+static void __exit curve25519_exit(void)
 {
 	crypto_unregister_kpp(&curve25519_alg);
 }
diff --git a/crypto/dh.c b/crypto/dh.c
index cd4f32092e5ce..dec4c16cb12a2 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -260,12 +260,12 @@ static struct kpp_alg dh = {
 	},
 };
 
-static int dh_init(void)
+static int __init dh_init(void)
 {
 	return crypto_register_kpp(&dh);
 }
 
-static void dh_exit(void)
+static void __exit dh_exit(void)
 {
 	crypto_unregister_kpp(&dh);
 }
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index c6f61c2211dc7..fe8966511e9d7 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -200,7 +200,7 @@ static struct kpp_alg ecdh_nist_p384 = {
 
 static bool ecdh_nist_p192_registered;
 
-static int ecdh_init(void)
+static int __init ecdh_init(void)
 {
 	int ret;
 
@@ -227,7 +227,7 @@ static int ecdh_init(void)
 	return ret;
 }
 
-static void ecdh_exit(void)
+static void __exit ecdh_exit(void)
 {
 	if (ecdh_nist_p192_registered)
 		crypto_unregister_kpp(&ecdh_nist_p192);
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 1e7b15009bf63..9dd8d977caaed 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -332,7 +332,7 @@ static struct akcipher_alg ecdsa_nist_p192 = {
 };
 static bool ecdsa_nist_p192_registered;
 
-static int ecdsa_init(void)
+static int __init ecdsa_init(void)
 {
 	int ret;
 
@@ -359,7 +359,7 @@ static int ecdsa_init(void)
 	return ret;
 }
 
-static void ecdsa_exit(void)
+static void __exit ecdsa_exit(void)
 {
 	if (ecdsa_nist_p192_registered)
 		crypto_unregister_akcipher(&ecdsa_nist_p192);
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4cdbec95d0779..37a8e629af2dc 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -255,7 +255,7 @@ static struct akcipher_alg rsa = {
 	},
 };
 
-static int rsa_init(void)
+static int __init rsa_init(void)
 {
 	int err;
 
@@ -272,7 +272,7 @@ static int rsa_init(void)
 	return 0;
 }
 
-static void rsa_exit(void)
+static void __exit rsa_exit(void)
 {
 	crypto_unregister_template(&rsa_pkcs1pad_tmpl);
 	crypto_unregister_akcipher(&rsa);
diff --git a/crypto/sm2.c b/crypto/sm2.c
index db8a4a265669d..a1d86a96d88b1 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -441,12 +441,12 @@ static struct akcipher_alg sm2 = {
 	},
 };
 
-static int sm2_init(void)
+static int __init sm2_init(void)
 {
 	return crypto_register_akcipher(&sm2);
 }
 
-static void sm2_exit(void)
+static void __exit sm2_exit(void)
 {
 	crypto_unregister_akcipher(&sm2);
 }
-- 
2.39.1

