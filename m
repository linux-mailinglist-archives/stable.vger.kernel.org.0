Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209D8395DE3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhEaNvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhEaNtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 09:49:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBDAC0610E8;
        Mon, 31 May 2021 06:30:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so1335237pjs.2;
        Mon, 31 May 2021 06:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6mf9vxePMwOECmPy8sralSQirr3sPMiFyk3gZWElr34=;
        b=NOrEdIkmcjZaaZLptcbrxJMPUDa7Q/13ezvdv+3nz9bra+EWHxhkXbET2vWbh+Nof1
         e7AsdZc5ECngckio0j237QPh9MtqHrvhpjNGcAerPxinHYjUdTqhZAynfj2s5ReDRQsG
         EMEFkK3ckomIHPn5f+r4s6jFsAbJWEim9r77wnppxxuwhVEHkWsAkXlCvZ5Hmpclm4cu
         7xdUhszx/Fo9p8Z7Dl40pORAxOQuSoTSk/GE1OGl2DPwDKQQ3h88XBc7hU4+aWv9we42
         GRvKDZBxvzNh/P6qQeUimp76SjT/DohFQRyhLYw/NJhdi6TZywt+d2388QsdFaEGWevu
         NcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6mf9vxePMwOECmPy8sralSQirr3sPMiFyk3gZWElr34=;
        b=AkLofsZH3P9NCMLnEz5KcEPLCs/aH2aUE1DiBrTKe64KtIINpXQheVZmWC/yKgdGsu
         X6edlsdTGMw9ycQkgzFUPDNau8KHCZGzXhHc88kdHokhpC5VmOuLgZBOmDHwrX/xAj3Q
         2QE8UM8tNvhBnriJYfZZem0tZa3ekHHXJLzNm7bqGb5xP4r0R6AXOiptZXPd+0r48yN0
         r5EemHhytxxonYwCUE4NqqGslEt+Eognswq3o0oyoUaQIiLJP9ElF0VkmJ8YYuQVhWPb
         edVF7hcdxyegSHlQqkFD5VaBMgpdOHKw9nKVl/+lwaVEf3gGT3yLPjTQnOFchMSUn5Nl
         wkLg==
X-Gm-Message-State: AOAM531MvsaZYA72OARUIw3O3Yc/PyYVy9adtzWtF1yZR9ItWwUXro/6
        4Bjk5PLP/hrgsk/elkMoP6WhwrEDCo8=
X-Google-Smtp-Source: ABdhPJydb/0iJtzHNck3YPyW8ss9CWq2h6HdUdwgEV4dWTCY+4Iusd66oOusFiw3mRC6FGxQgyKVkA==
X-Received: by 2002:a17:90a:ce02:: with SMTP id f2mr11705623pju.45.1622467844182;
        Mon, 31 May 2021 06:30:44 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id p36sm11836646pgm.74.2021.05.31.06.30.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 May 2021 06:30:43 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org,
        dhowells@redhat.com, jarkko@kernel.org,
        tianjia.zhang@linux.alibaba.com, herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] crypto: sm2 - fix a memory leak in sm2
Date:   Mon, 31 May 2021 21:30:01 +0800
Message-Id: <1622467801-30957-1-git-send-email-herbert.tencent@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
test_akcipher_one(), it will set public key for every test vector,
and don't free ec->Q. This will cause a memory leak.

This patch alloc ec->Q in sm2_ec_ctx_init().

Fixes: ea7ecb66440b ("crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm")
Signed-off-by: Hongbo Li <herberthbli@tencent.com>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/sm2.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/crypto/sm2.c b/crypto/sm2.c
index b21addc..db8a4a2 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -79,10 +79,17 @@ static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
 		goto free;
 
 	rc = -ENOMEM;
+
+	ec->Q = mpi_point_new(0);
+	if (!ec->Q)
+		goto free;
+
 	/* mpi_ec_setup_elliptic_curve */
 	ec->G = mpi_point_new(0);
-	if (!ec->G)
+	if (!ec->G) {
+		mpi_point_release(ec->Q);
 		goto free;
+	}
 
 	mpi_set(ec->G->x, x);
 	mpi_set(ec->G->y, y);
@@ -91,6 +98,7 @@ static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
 	rc = -EINVAL;
 	ec->n = mpi_scanval(ecp->n);
 	if (!ec->n) {
+		mpi_point_release(ec->Q);
 		mpi_point_release(ec->G);
 		goto free;
 	}
@@ -386,27 +394,15 @@ static int sm2_set_pub_key(struct crypto_akcipher *tfm,
 	MPI a;
 	int rc;
 
-	ec->Q = mpi_point_new(0);
-	if (!ec->Q)
-		return -ENOMEM;
-
 	/* include the uncompressed flag '0x04' */
-	rc = -ENOMEM;
 	a = mpi_read_raw_data(key, keylen);
 	if (!a)
-		goto error;
+		return -ENOMEM;
 
 	mpi_normalize(a);
 	rc = sm2_ecc_os2ec(ec->Q, a);
 	mpi_free(a);
-	if (rc)
-		goto error;
-
-	return 0;
 
-error:
-	mpi_point_release(ec->Q);
-	ec->Q = NULL;
 	return rc;
 }
 
-- 
1.8.3.1

