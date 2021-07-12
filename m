Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82893C4976
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhGLGpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237571AbhGLGnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD3006100B;
        Mon, 12 Jul 2021 06:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071967;
        bh=lyu8th6dsieXuaidPYvsAExlMqh1296PAjIaPJrI9BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3ynGIyO+Q2iYYSqmu0LkOMyzsGNg7coQchCf+fax1s9gbx+GxT7Wm3L+4X2ld7DT
         lNaJIYB4b9PgYbN6K4YqdnoeWiiOIzc/SRh5blFLO/E7bA0OK6o8iunktOl8BYGRYP
         qIEZfTV1co9nht1Wxa6ihGsUEUcV0cHzwfD7khpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongbo Li <herberthbli@tencent.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/593] crypto: sm2 - fix a memory leak in sm2
Date:   Mon, 12 Jul 2021 08:06:44 +0200
Message-Id: <20210712060909.734018362@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbo Li <herberthbli@tencent.com>

[ Upstream commit 5cd259ca5d466f65ffd21e2e2fa00fb648a8c555 ]

SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
test_akcipher_one(), it will set public key for every test vector,
and don't free ec->Q. This will cause a memory leak.

This patch alloc ec->Q in sm2_ec_ctx_init().

Fixes: ea7ecb66440b ("crypto: sm2 - introduce OSCCA SM2 asymmetric cipher algorithm")
Signed-off-by: Hongbo Li <herberthbli@tencent.com>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/sm2.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/crypto/sm2.c b/crypto/sm2.c
index b21addc3ac06..db8a4a265669 100644
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
2.30.2



