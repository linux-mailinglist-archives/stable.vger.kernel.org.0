Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4947F3C4909
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhGLGll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238470AbhGLGkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DC060238;
        Mon, 12 Jul 2021 06:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071846;
        bh=z7k6hZxpghgA0HTAKvvdpq0jUkfYmU0Cp8/Xt6fw0Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQqtKYl9HRrVwkm64D0rVXVFtTC/BN5UQu5Vj1NrtdOja4bwUxUIVlQxb1QrvWgKB
         cmWWFQbHfz29iSrXLOzYT7vpPLpRLTAolsL/+KPrf/FO3zCAZ//eI11RPPjMfIvNNm
         jym+R7LQZ0CS50FxAdIbq/0omXaE4tiAmb+rQCFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/593] crypto: sm2 - remove unnecessary reset operations
Date:   Mon, 12 Jul 2021 08:06:43 +0200
Message-Id: <20210712060909.626305937@linuxfoundation.org>
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

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 1bc608b4655b8b1491fb100f4cf4f15ae64a8698 ]

This is an algorithm optimization. The reset operation when
setting the public key is repeated and redundant, so remove it.
At the same time, `sm2_ecc_os2ec()` is optimized to make the
function more simpler and more in line with the Linux code style.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/sm2.c | 75 ++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 46 deletions(-)

diff --git a/crypto/sm2.c b/crypto/sm2.c
index 767e160333f6..b21addc3ac06 100644
--- a/crypto/sm2.c
+++ b/crypto/sm2.c
@@ -119,12 +119,6 @@ static void sm2_ec_ctx_deinit(struct mpi_ec_ctx *ec)
 	memset(ec, 0, sizeof(*ec));
 }
 
-static int sm2_ec_ctx_reset(struct mpi_ec_ctx *ec)
-{
-	sm2_ec_ctx_deinit(ec);
-	return sm2_ec_ctx_init(ec);
-}
-
 /* RESULT must have been initialized and is set on success to the
  * point given by VALUE.
  */
@@ -132,55 +126,48 @@ static int sm2_ecc_os2ec(MPI_POINT result, MPI value)
 {
 	int rc;
 	size_t n;
-	const unsigned char *buf;
-	unsigned char *buf_memory;
+	unsigned char *buf;
 	MPI x, y;
 
-	n = (mpi_get_nbits(value)+7)/8;
-	buf_memory = kmalloc(n, GFP_KERNEL);
-	rc = mpi_print(GCRYMPI_FMT_USG, buf_memory, n, &n, value);
-	if (rc) {
-		kfree(buf_memory);
-		return rc;
-	}
-	buf = buf_memory;
+	n = MPI_NBYTES(value);
+	buf = kmalloc(n, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	if (n < 1) {
-		kfree(buf_memory);
-		return -EINVAL;
-	}
-	if (*buf != 4) {
-		kfree(buf_memory);
-		return -EINVAL; /* No support for point compression.  */
-	}
-	if (((n-1)%2)) {
-		kfree(buf_memory);
-		return -EINVAL;
-	}
-	n = (n-1)/2;
+	rc = mpi_print(GCRYMPI_FMT_USG, buf, n, &n, value);
+	if (rc)
+		goto err_freebuf;
+
+	rc = -EINVAL;
+	if (n < 1 || ((n - 1) % 2))
+		goto err_freebuf;
+	/* No support for point compression */
+	if (*buf != 0x4)
+		goto err_freebuf;
+
+	rc = -ENOMEM;
+	n = (n - 1) / 2;
 	x = mpi_read_raw_data(buf + 1, n);
-	if (!x) {
-		kfree(buf_memory);
-		return -ENOMEM;
-	}
+	if (!x)
+		goto err_freebuf;
 	y = mpi_read_raw_data(buf + 1 + n, n);
-	kfree(buf_memory);
-	if (!y) {
-		mpi_free(x);
-		return -ENOMEM;
-	}
+	if (!y)
+		goto err_freex;
 
 	mpi_normalize(x);
 	mpi_normalize(y);
-
 	mpi_set(result->x, x);
 	mpi_set(result->y, y);
 	mpi_set_ui(result->z, 1);
 
-	mpi_free(x);
-	mpi_free(y);
+	rc = 0;
 
-	return 0;
+	mpi_free(y);
+err_freex:
+	mpi_free(x);
+err_freebuf:
+	kfree(buf);
+	return rc;
 }
 
 struct sm2_signature_ctx {
@@ -399,10 +386,6 @@ static int sm2_set_pub_key(struct crypto_akcipher *tfm,
 	MPI a;
 	int rc;
 
-	rc = sm2_ec_ctx_reset(ec);
-	if (rc)
-		return rc;
-
 	ec->Q = mpi_point_new(0);
 	if (!ec->Q)
 		return -ENOMEM;
-- 
2.30.2



