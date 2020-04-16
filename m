Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A521AC3CB
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898741AbgDPNs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896279AbgDPNsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E45421734;
        Thu, 16 Apr 2020 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044901;
        bh=YTCURO/wpL4mZgGhN38MtVtgTdD2kwxE6Zl9cpyaaFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sx22Mb+qVELmYWnNOyGxSBMxPq413lt9HNBsxBlneyoxL+y/uwnDm+2sjFgtkvlO8
         r+J034ZFq6bBWnVvLaKDmEz8RMKP5SshOl7Ys9zetvwBe/sg4Awc3fRigBum8pqZVL
         DYTTOVivlRGz1wTkTi4/OiZjddEquvNF4AExDiCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 149/232] crypto: rng - Fix a refcounting bug in crypto_rng_reset()
Date:   Thu, 16 Apr 2020 15:24:03 +0200
Message-Id: <20200416131333.644960771@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit eed74b3eba9eda36d155c11a12b2b4b50c67c1d8 upstream.

We need to decrement this refcounter on these error paths.

Fixes: f7d76e05d058 ("crypto: user - fix use_after_free of struct xxx_request")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/rng.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -37,12 +37,16 @@ int crypto_rng_reset(struct crypto_rng *
 	crypto_stats_get(alg);
 	if (!seed && slen) {
 		buf = kmalloc(slen, GFP_KERNEL);
-		if (!buf)
+		if (!buf) {
+			crypto_alg_put(alg);
 			return -ENOMEM;
+		}
 
 		err = get_random_bytes_wait(buf, slen);
-		if (err)
+		if (err) {
+			crypto_alg_put(alg);
 			goto out;
+		}
 		seed = buf;
 	}
 


