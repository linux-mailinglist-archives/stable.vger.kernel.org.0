Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8E2FE5D4
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 10:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbhAUJHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 04:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbhAUJGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 04:06:52 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38DEC061575
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 01:06:12 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id r77so770040qka.12
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 01:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4SlXcnQDqE/oFnnOU9GhrU1i4FAq2OthdaAHhyPQWM=;
        b=YifaCZKL2i5rSGAlGwh1xfK+X5raS3E9we4q6sUQUSWFs/QN4hsSkJRjIo/tj4PykM
         gxhG1/octrsd9KtpVPXpQAjHZzBx6xpQD9eElvfzlCUOi/w20VVNRjEMoBpj4G1f86P+
         itykmxQUMryYO0tXrkkbsXV5O0S8QH4QIKK7v4R8y30b6qPAwq3jAo6aZTMW9p3Rsu8U
         +kJgAq3qFS0Yv0fhyJDcNgK5pRztmSn/HEeK0a9cXdsF63D3r7TnTkArQae+7v/3muwt
         U2hpqICuFjsPn2BvwgkQd2K5TeQB9IDlCrxX8turKOLJKArY0bgqRl1PnNUJC0g7jDbx
         QLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4SlXcnQDqE/oFnnOU9GhrU1i4FAq2OthdaAHhyPQWM=;
        b=qRvKLKgIZmiYUaif1SVYAqttlwmd1RSEblS5yJJ/a75zKYApT8WETX0zLitcpVjV1E
         ldnyR1P/NIMvDSRVZcBLfjirus6vkv+uXIsxWl4lTdj/GsuoqyHM5va0k0dOIXg5Fi3a
         kjWfh1lrpvA4BJDoF1RrKwCJwZhTZ9Gj2S5dqXCCccw8jg5h9j/E11WZWcwBNS1EakRo
         egUb0gkn63pR2KVl+4c4GIJdpL3sfvUfgz3oMogOqulWjTYC5+KrBQ0qPsmn4rMMFREj
         gV78JhID2fCWaewVJ0uCk6y0BTt/OVmbJ55SCTU7gqkVrlUKzEg/7W7QpQogLzqA4isz
         lu7A==
X-Gm-Message-State: AOAM530KO3KBCTw8NhBIBdFMrivZqgPKfDvH24r1npd1fqQUqwp/dCGh
        9+PMyQ1yvV/9wYfq1JTHKoY=
X-Google-Smtp-Source: ABdhPJwv5/9FzHSPit+LgmPyVF6fPrpcGGfMklLfcJUU0J+9fw4oDt0w4pcjnRq41i4uWYC1TFVByQ==
X-Received: by 2002:a37:eca:: with SMTP id 193mr3227306qko.261.1611219971991;
        Thu, 21 Jan 2021 01:06:11 -0800 (PST)
Received: from localhost.localdomain ([158.101.100.46])
        by smtp.gmail.com with ESMTPSA id y26sm3176607qth.53.2021.01.21.01.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 01:06:10 -0800 (PST)
From:   hansyao <hansyow@gmail.com>
To:     yao_hang@163.com
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Tobias Markus <tobias@markus-regensburg.de>,
        David Howells <dhowells@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        =?UTF-8?q?Jo=C3=A3o=20Fonseca?= <jpedrofonseca@ua.pt>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] X.509: Fix crash caused by NULL pointer
Date:   Thu, 21 Jan 2021 04:06:02 -0500
Message-Id: <20210121090602.20943-1-hansyow@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
---
 crypto/asymmetric_keys/public_key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 8892908ad58c..788a4ba1e2e7 100644
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
2.29.2

