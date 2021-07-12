Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960DE3C5255
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345883AbhGLHpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244821AbhGLHm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E20C661167;
        Mon, 12 Jul 2021 07:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075606;
        bh=wKPmjVSd0l6rTsRpiThpRzRbZtI2FSF9n8vONKwncIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZAw0nrsqA8ETcTeetYp0AuKWvDEIyP8YXCxMZ6sr0w891d1XIYmMafnlhLFff6tj
         I7jHHB7ZMwn9rFpOaJFz7IVexVBaXU15y6Zt9HQw8CHxNpmXBF/RdqzxY/Rdqxctpw
         4H2RSHPD98Alb0dCX2NxdKQztPBeOJHCWkmEoQy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 284/800] crypto: testmgr - fix initialization of secret_size
Date:   Mon, 12 Jul 2021 08:05:07 +0200
Message-Id: <20210712060954.926561831@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 2d016672528a592ada5188e53ac746e1b8b7a978 ]

Actual data length of the 'secret' is not equal to the 'secret_size'.

Since the 'curve_id' has removed in the 'secret', the 'secret_size'
should subtract the length of the 'curve_id'.

Fixes: 6763f5ea2d9a ("crypto: ecdh - move curve_id of ECDH from ...")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index fe1e59da59ff..b9cf5b815532 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2718,7 +2718,7 @@ static const struct kpp_testvec ecdh_p192_tv_template[] = {
 	"\xf4\x57\xcc\x4f\x1f\x4e\x31\xcc"
 	"\xe3\x40\x60\xc8\x06\x93\xc6\x2e"
 	"\x99\x80\x81\x28\xaf\xc5\x51\x74",
-	.secret_size = 32,
+	.secret_size = 30,
 	.b_public_size = 48,
 	.expected_a_public_size = 48,
 	.expected_ss_size = 24
@@ -2764,7 +2764,7 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	"\x9f\x4a\x38\xcc\xc0\x2c\x49\x2f"
 	"\xb1\x32\xbb\xaf\x22\x61\xda\xcb"
 	"\x6f\xdb\xa9\xaa\xfc\x77\x81\xf3",
-	.secret_size = 40,
+	.secret_size = 38,
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32
@@ -2802,8 +2802,8 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	"\x37\x08\xcc\x40\x5e\x7a\xfd\x6a"
 	"\x6a\x02\x6e\x41\x87\x68\x38\x77"
 	"\xfa\xa9\x44\x43\x2d\xef\x09\xdf",
-	.secret_size = 8,
-	.b_secret_size = 40,
+	.secret_size = 6,
+	.b_secret_size = 38,
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32,
-- 
2.30.2



