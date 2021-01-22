Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA7300357
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 13:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbhAVMkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 07:40:11 -0500
Received: from m12-12.163.com ([220.181.12.12]:60735 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbhAVMj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 07:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=qQdgD
        kScP3b2//FDvOoUaLkcOuaz06wcJpQgufq/+lM=; b=KKKvrnFw1HhtSi1W0VtZA
        bY5GJY9fvL+paQpmpV1VasXCpB+zMih56VfR9qNxejhJB9lVgYN0x84oeeFqy6SZ
        66RcO3cTit6VXaW2JiCfM9YArxPpKNk4sEpZ4+zmIAsf+lgKoNVQswf+ciJH7wEC
        rIg8o5R5SiecX4kB6qCi0E=
Received: from localhost.localdomain (unknown [119.137.55.101])
        by smtp8 (Coremail) with SMTP id DMCowABnbLDXwgpgruQYNQ--.49498S2;
        Fri, 22 Jan 2021 20:19:36 +0800 (CST)
From:   =?UTF-8?q?=C2=A0Tan=20Zhongjun?= <hbut_tan@163.com>
To:     tanzhongjun@yulong.com
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Tobias Markus <tobias@markus-regensburg.de>,
        David Howells <dhowells@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        =?UTF-8?q?Jo=C3=A3o=20Fonseca?= <jpedrofonseca@ua.pt>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] X.509: Fix crash caused by NULL pointer
Date:   Fri, 22 Jan 2021 20:19:15 +0800
Message-Id: <20210122121917.1414-1-hbut_tan@163.com>
X-Mailer: git-send-email 2.30.0.windows.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABnbLDXwgpgruQYNQ--.49498S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zry7AF1fGw1fJw4UWr43trb_yoW8ArWfpa
        97ur10gFy8Gr1Ik3WUJw1I9a45GFWj9F4agw4fAw1xG3ZxXw4rC3yIvFs8WFn3GryrXryF
        yrZFqw1xZw1DAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jh9N3UUUUU=
X-Originating-IP: [119.137.55.101]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/xtbBXhgixlaD5iyqbwAAs4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

On the following call path, `sig->pkey_algo` is not assigned
in asymmetric_key_verify_signature(), which causes runtime
crash in public_key_verify_signature().

  keyctl_pkey_verify
    asymmetric_key_verify_signature
      verify_signature
        public_key_verify_signature

This patch simply check this situation and fixes the crash
caused by NULL pointer.

Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
Reported-by: Tobias Markus <tobias@markus-regensburg.de>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: João Fonseca <jpedrofonseca@ua.pt>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: george.tan <tanzhongjun@yulong.com>
---
 crypto/asymmetric_keys/public_key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908..788a4ba 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_key *pkey,
 	if (ret)
 		goto error_free_key;
 
-	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
+	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
+	    sig->data_size) {
 		ret = cert_sig_digest_update(sig, tfm);
 		if (ret)
 			goto error_free_key;
-- 
1.9.1


