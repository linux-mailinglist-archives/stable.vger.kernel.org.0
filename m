Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953591F0FEC
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgFGVEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 17:04:08 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2289 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726093AbgFGVEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 17:04:07 -0400
Received: from lhreml726-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 54B20946EDD84EFE634E;
        Sun,  7 Jun 2020 22:04:05 +0100 (IST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 lhreml726-chm.china.huawei.com (10.201.108.77) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Sun, 7 Jun 2020 22:04:05 +0100
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Sun, 7 Jun 2020 23:04:03 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <torvalds@linux-foundation.org>, <zohar@linux.ibm.com>
CC:     <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ima: Remove __init annotation from ima_pcrread()
Date:   Sun, 7 Jun 2020 23:00:29 +0200
Message-ID: <20200607210029.30601-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in
ima_eventdigest_init()") added a call to ima_calc_boot_aggregate() so that
the digest can be recalculated for the boot_aggregate measurement entry if
the 'd' template field has been requested. For the 'd' field, only SHA1 and
MD5 digests are accepted.

Given that ima_eventdigest_init() does not have the __init annotation, all
functions called should not have it. This patch removes __init from
ima_pcrread().

Cc: stable@vger.kernel.org
Fixes:  6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index ba5cc3264240..220b14920c37 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -786,7 +786,7 @@ int ima_calc_buffer_hash(const void *buf, loff_t len,
 	return calc_buffer_shash(buf, len, hash);
 }
 
-static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
+static void ima_pcrread(u32 idx, struct tpm_digest *d)
 {
 	if (!ima_tpm_chip)
 		return;
-- 
2.17.1

