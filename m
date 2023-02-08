Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C331468F8EA
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 21:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjBHUii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 15:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjBHUih (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 15:38:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CABE11147;
        Wed,  8 Feb 2023 12:38:34 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318KYEb7020407;
        Wed, 8 Feb 2023 20:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=2b3rTVXb73zcSnGgWCAz+oII2x9gInto9v0i9EXAkrs=;
 b=CwYr1M3CnAfA9kLj2G0vi8dMr/ZIXLPAWt4iaUTFi7gbjHfiQU6tnUFnHNczSMoyCvlp
 oHSOo9FRpGhLjAcF/encZL/hxlvTLs+k+CQ2yYgoCp+U9dPEe+KDkOR4G17eF3sFFug8
 OfON1LySHVmBT+Du2F/5AXx9har59CGK61LnH0XAeIOWjrRb9op0Vahc7NV6he1orNkk
 gb7F671CVBNtxa+Ur51XTagcwPCb7BQfsCzDfjVtfkQV+nyMcRj8NHlJBvakydGvXd47
 RMhdaU87+6lhRcaF/MOTJ/wxM1fnvQT9+qJkTo6fkLZYjRvIoTZkouNNtz/dlMmkxwqr Rg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe53h8sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 20:37:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318JeaY5028397;
        Wed, 8 Feb 2023 20:37:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdte9d47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 20:37:49 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318Kbhre001108;
        Wed, 8 Feb 2023 20:37:48 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3nhdte9d05-2;
        Wed, 08 Feb 2023 20:37:48 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     stable@vger.kernel.org
Cc:     saeed.mirzamohammadi@oracle.com, Robert Elliott <elliott@hpe.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable 1/1] crypto: testmgr - don't generate WARN for missing modules
Date:   Wed,  8 Feb 2023 12:37:11 -0800
Message-Id: <20230208203711.951845-2-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208203711.951845-1-saeed.mirzamohammadi@oracle.com>
References: <20230208203711.951845-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_09,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302080175
X-Proofpoint-ORIG-GUID: 7AFztC1Hk_D3VEBPyDnv-g1iPJR2CbE3
X-Proofpoint-GUID: 7AFztC1Hk_D3VEBPyDnv-g1iPJR2CbE3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Elliott <elliott@hpe.com>

This userspace command:
    modprobe tcrypt
or
    modprobe tcrypt mode=0

runs all the tcrypt test cases numbered <200 (i.e., all the
test cases calling tcrypt_test() and returning return values).

Tests are sparsely numbered from 0 to 1000. For example:
    modprobe tcrypt mode=12
tests sha512, and
    modprobe tcrypt mode=152
tests rfc4543(gcm(aes))) - AES-GCM as GMAC

The test manager generates WARNING crashdumps every time it attempts
a test using an algorithm that is not available (not built-in to the
kernel or available as a module):

    alg: skcipher: failed to allocate transform for ecb(arc4): -2
    ------------[ cut here ]-----------
    alg: self-tests for ecb(arc4) (ecb(arc4)) failed (rc=-2)
    WARNING: CPU: 9 PID: 4618 at crypto/testmgr.c:5777
alg_test+0x30b/0x510
    [50 more lines....]

    ---[ end trace 0000000000000000 ]---

If the kernel is compiled with CRYPTO_USER_API_ENABLE_OBSOLETE
disabled (the default), then these algorithms are not compiled into
the kernel or made into modules and trigger WARNINGs:
    arc4 tea xtea khazad anubis xeta seed

Additionally, any other algorithms that are not enabled in .config
will generate WARNINGs. In RHEL 9.0, for example, the default
selection of algorithms leads to 16 WARNING dumps.

One attempt to fix this was by modifying tcrypt_test() to check
crypto_has_alg() and immediately return 0 if crypto_has_alg() fails,
rather than proceed and return a non-zero error value that causes
the caller (alg_test() in crypto/testmgr.c) to invoke WARN().
That knocks out too many algorithms, though; some combinations
like ctr(des3_ede) would work.

Instead, change the condition on the WARN to ignore a return
value is ENOENT, which is the value returned when the algorithm
or combination of algorithms doesn't exist. Add a pr_warn to
communicate that information in case the WARN is skipped.

This approach allows algorithm tests to work that are combinations,
not provided by one driver, like ctr(blowfish).

Result - no more WARNINGs:
modprobe tcrypt
[  115.541765] tcrypt: testing md5
[  115.556415] tcrypt: testing sha1
[  115.570463] tcrypt: testing ecb(des)
[  115.585303] cryptomgr: alg: skcipher: failed to allocate transform for ecb(des): -2
[  115.593037] cryptomgr: alg: self-tests for ecb(des) using ecb(des) failed (rc=-2)
[  115.593038] tcrypt: testing cbc(des)
[  115.610641] cryptomgr: alg: skcipher: failed to allocate transform for cbc(des): -2
[  115.618359] cryptomgr: alg: self-tests for cbc(des) using cbc(des) failed (rc=-2)
...

Signed-off-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
(cherry picked from commit a76bd86a85cac9feddc66d38019f943d054f0218)

Fixes: 09a5ef9644bc0 ("crypto: testmgr - WARN on test failure")

Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 crypto/testmgr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 163a1283a866a..6131f81703c93 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5654,8 +5654,11 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 			      driver, alg,
 			      fips_enabled ? "fips" : "panic_on_fail");
 		}
-		WARN(1, "alg: self-tests for %s (%s) failed (rc=%d)",
-		     driver, alg, rc);
+		pr_warn("alg: self-tests for %s using %s failed (rc=%d)",
+			alg, driver, rc);
+		WARN(rc != -ENOENT,
+		     "alg: self-tests for %s using %s failed (rc=%d)",
+		     alg, driver, rc);
 	} else {
 		if (fips_enabled)
 			pr_info("alg: self-tests for %s (%s) passed\n",
-- 
2.39.1

