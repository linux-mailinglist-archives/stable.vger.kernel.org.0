Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1620F491837
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348071AbiARCot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50504 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245273AbiARClp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:41:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9122CB81262;
        Tue, 18 Jan 2022 02:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBDEC36AF6;
        Tue, 18 Jan 2022 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473699;
        bh=cp+p/t25XdZb2rsecPqcVi9U8jj0FyYDOxIhELjcxZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxTaj6+nq7IvXJZL2VCn6loHWT0Nu+TlqhjUYyo/J63TMt+TuoEkSZZSvmFOE1S+t
         lryXZc8K2kCEOsFIMPMGQj2MTzZ+Mp3sRW98vBnHgRO7f1LCQ/J8qgjqQ/sC92GrJw
         0i/+qfVNC8Wso1aY0FtlFV7dhuhPkUq8/gQdknbsaxoZhL8R9nJ/U9fL0Ju/QpPBth
         0U7AGwGBFig0jJYs3kajK2vk8n6j5RV+5hHgOMlxuAca/v+MSwJCToEKTn/JGIoDIC
         Ir/pHgrCroe1/f1NZYWafKw3anv49iViculInmBMDu7Iv6wcagMjwQmybJ0+9QUn8l
         GyW/kfJ8Q9a+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 030/116] crypto: jitter - consider 32 LSB for APT
Date:   Mon, 17 Jan 2022 21:38:41 -0500
Message-Id: <20220118024007.1950576-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Müller <smueller@chronox.de>

[ Upstream commit 552d03a223eda3df84526ab2c1f4d82e15eaee7a ]

The APT compares the current time stamp with a pre-set value. The
current code only considered the 4 LSB only. Yet, after reviews by
mathematicians of the user space Jitter RNG version >= 3.1.0, it was
concluded that the APT can be calculated on the 32 LSB of the time
delta. Thi change is applied to the kernel.

This fixes a bug where an AMD EPYC fails this test as its RDTSC value
contains zeros in the LSB. The most appropriate fix would have been to
apply a GCD calculation and divide the time stamp by the GCD. Yet, this
is a significant code change that will be considered for a future
update. Note, tests showed that constantly the GCD always was 32 on
these systems, i.e. the 5 LSB were always zero (thus failing the APT
since it only considered the 4 LSB for its calculation).

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/jitterentropy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 6e147c43fc186..37c4c308339e4 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -265,7 +265,6 @@ static int jent_stuck(struct rand_data *ec, __u64 current_delta)
 {
 	__u64 delta2 = jent_delta(ec->last_delta, current_delta);
 	__u64 delta3 = jent_delta(ec->last_delta2, delta2);
-	unsigned int delta_masked = current_delta & JENT_APT_WORD_MASK;
 
 	ec->last_delta = current_delta;
 	ec->last_delta2 = delta2;
@@ -274,7 +273,7 @@ static int jent_stuck(struct rand_data *ec, __u64 current_delta)
 	 * Insert the result of the comparison of two back-to-back time
 	 * deltas.
 	 */
-	jent_apt_insert(ec, delta_masked);
+	jent_apt_insert(ec, current_delta);
 
 	if (!current_delta || !delta2 || !delta3) {
 		/* RCT with a stuck bit */
-- 
2.34.1

