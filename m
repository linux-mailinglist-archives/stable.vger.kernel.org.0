Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D43D45112C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhKOTBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234216AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F3EB6348F;
        Mon, 15 Nov 2021 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999972;
        bh=lb+/OSX+NchLbrkQfvWwD5TsE5ET1oYUuc7l5nJPC68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMQbSlzAT+z9n4fuaYOxOrxiHquJy0x1/Jhfal27xC4Ix/N8lFwEhY6aqKLCeQSac
         iRV9/zZov9DemfPO/5eDKKz0Bl42j+P04blwbgMdG0mQZPFoW363fhmNVtH3Bw5d/X
         NgCVxMbiX7pB0p8p5S0MiWpf11vP4Ke2thpMBNMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 489/849] crypto: tcrypt - fix skcipher multi-buffer tests for 1420B blocks
Date:   Mon, 15 Nov 2021 17:59:32 +0100
Message-Id: <20211115165436.825627110@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 6863e57b088d5..54cf01020b435 100644
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



