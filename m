Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C01D25D4D2
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 11:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgIDJ1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 05:27:22 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2754 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728658AbgIDJ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 05:27:22 -0400
Received: from lhreml741-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 9709F4A1BBA0D160854A;
        Fri,  4 Sep 2020 10:27:20 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml741-chm.china.huawei.com (10.201.108.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 10:27:20 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Fri, 4 Sep 2020 11:27:19 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 01/12] ima: Don't ignore errors from crypto_shash_update()
Date:   Fri, 4 Sep 2020 11:23:28 +0200
Message-ID: <20200904092339.19598-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.27.GIT
In-Reply-To: <20200904092339.19598-1-roberto.sassu@huawei.com>
References: <20200904092339.19598-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Errors returned by crypto_shash_update() are not checked in
ima_calc_boot_aggregate_tfm() and thus can be overwritten at the next
iteration of the loop. This patch adds a check after calling
crypto_shash_update() and returns immediately if the result is not zero.

Cc: stable@vger.kernel.org
Fixes: 3323eec921efd ("integrity: IMA as an integrity service provider")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 011c3c76af86..21989fa0c107 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -829,6 +829,8 @@ static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 		/* now accumulate with current aggregate */
 		rc = crypto_shash_update(shash, d.digest,
 					 crypto_shash_digestsize(tfm));
+		if (rc != 0)
+			return rc;
 	}
 	/*
 	 * Extend cumulative digest over TPM registers 8-9, which contain
-- 
2.27.GIT

