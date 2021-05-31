Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180D5395D4C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhEaNnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhEaNlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 09:41:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975D1C061343;
        Mon, 31 May 2021 06:27:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso1365pji.0;
        Mon, 31 May 2021 06:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6mf9vxePMwOECmPy8sralSQirr3sPMiFyk3gZWElr34=;
        b=O5h0B6VMZFSPjV0vMk0DbNJvcKsqAmnAGvnRN9UJC61qBB9qAi8ktmFIJ1gNe8zVfO
         rzSrFVJd8HIrAeIUytZNJMbZfUF2FtaOHbnE9nyDebhfwPcL9Qc3Um9pd3J+TIxCB8BW
         yqW0aDTRI2wdgB+6zxgnOqMnThDwVdwSMZttyvF4EDO+sPbmEt98+VqlHBF8ERGSPCbM
         DG4FY+8DcK/6sljrV6RhfnYcjhOgQxfbNJTAcHAEVipYttgDt7Wp4A6j/W1ByQw6dMyL
         IQQWRoyBcFqJJLNHpHP5eFi9RT2nlxGbN7jMxEY9TtvTxaIr+5DFKPvkXUT4SLmjoO08
         UAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6mf9vxePMwOECmPy8sralSQirr3sPMiFyk3gZWElr34=;
        b=LWleLclT0CahTaRNpDYL2TED0aBmyFkXv64g4n8XbL5P+DuPyyd//SH8L0LYYRs+8g
         csp0/Afhpd9DWZOfhztiRB6y+CbSsg5Voj8WnGk2UVO8vuQGFE4bK4n+ifGKnWaPBph2
         pCDY0wFybR00OrGnAnZndAH4Qr/Bi/gi1+7o9t8YOxL9mnA9/4zlebsYEzAEixg0mAuP
         MjEu+puee+rWjdZ8rxJIluTDvzA10Qy8fHQJxcsi1tnS2T7sNkDZStpOe3s31LvdDDGx
         zQ6p6c4FkvD+jEBY9D4SStrtbhajxt+Y2GTrA/vCJ55z/O4M1TEwHbjjQTpyDjYvgqGr
         nmuQ==
X-Gm-Message-State: AOAM530BYVBEy3nDhdXIZYhMOEQECsotu82cNKZlCApEBNNHVliSHfVj
        jCL8kydts1iY5cfb0L8Q65CIwPfs5Vg=
X-Google-Smtp-Source: ABdhPJw1W6y+qvRwnCEGZ7SJOr+gmHDZqS3gazPCOP9+eL15gPdoMAQYipZvSQvuITgeol8jSwX42g==
X-Received: by 2002:a17:902:7b8e:b029:ec:f35a:918e with SMTP id w14-20020a1709027b8eb02900ecf35a918emr20776958pll.77.1622467660913;
        Mon, 31 May 2021 06:27:40 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id o10sm11015225pfh.67.2021.05.31.06.27.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 May 2021 06:27:40 -0700 (PDT)
From:   Hongbo Li <herbert.tencent@gmail.com>
To:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, ebiggers@kernel.org,
        dhowells@redhat.com, jarkko@kernel.org,
        tianjia.zhang@linux.alibaba.com, herberthbli@tencent.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] crypto: fix a memory leak in sm2
Date:   Mon, 31 May 2021 21:26:51 +0800
Message-Id: <1622467611-30383-1-git-send-email-herbert.tencent@gmail.com>
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

