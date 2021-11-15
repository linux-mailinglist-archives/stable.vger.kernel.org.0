Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDDA4513CA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhKOT40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344052AbhKOTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739C8633B7;
        Mon, 15 Nov 2021 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002256;
        bh=vEppnY2qTR+GDJKuIXbpa1Slw+pd4d/WeTohcrcIYXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K538r+N0fMpAYEH0Fi5RcS+m4JkwsOwkAo93JHTjmKlmzE/6rV5Fx/UpKkFBQK/YI
         AH+JKGEKMFxgz0AITK3bAE86XuTrnNPjzrn4hmpUU7KBByXx/HDt9l8E5amhAObXzZ
         qJghLguPuZeA/QwOwrE3lyNUstCXcK91cI3GuSCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/917] crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks
Date:   Mon, 15 Nov 2021 17:59:53 +0100
Message-Id: <20211115165445.661961430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit 3ae88f676aa63366ffa9eebb8ae787c7e19f0c57 ]

Commit ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
mentions:
> power-of-2 block size. So let's add 1420 bytes explicitly, and round
> it up to the next blocksize multiple of the algo in question if it
> does not support 1420 byte blocks.
but misses updating skcipher multi-buffer tests.

Fix this by using the proper (rounded) input size.

Fixes: ad6d66bcac77e ("crypto: tcrypt - include 1420 byte blocks in aead and skcipher benchmarks")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 82b0400985a51..00149657a4bc1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1333,7 +1333,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 
 			if (bs > XBUFSIZE * PAGE_SIZE) {
 				pr_err("template (%u) too big for buffer (%lu)\n",
-				       *b_size, XBUFSIZE * PAGE_SIZE);
+				       bs, XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
 
@@ -1386,8 +1386,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 				memset(cur->xbuf[p], 0xff, k);
 
 				skcipher_request_set_crypt(cur->req, cur->sg,
-							   cur->sg, *b_size,
-							   iv);
+							   cur->sg, bs, iv);
 			}
 
 			if (secs) {
-- 
2.33.0



