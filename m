Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AB24917E4
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347927AbiARCn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345064AbiARCiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:38:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99156C06175C;
        Mon, 17 Jan 2022 18:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A86AB81239;
        Tue, 18 Jan 2022 02:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AA0C36AF3;
        Tue, 18 Jan 2022 02:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473307;
        bh=eEaFiu9oeQzMos//9egNUUciT+D643UA7dei83tarKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzUjSQU8XzS2OadPR8JLQwU3xem4l/9VEYRhtl2EyQXx4EK1Dryabg4BO61t7zvlC
         21nlYUGHza0VzhefCRuQFKldMPewaawXe1dmJKzNLMr2m4/wcwwZ3SW5BYadUXXmnu
         mDnGmbcyeXIuRo85CS+6+BABpcvNek7jZW4nKA/fwfhtgOvjzbo6e+LurZcQnvkfCL
         3vvnmPOu5vPamHhWBWts+7GHpslquKvj2D14Vn/Ca9JUtHu0JayiMJ2oD82iUnD4l1
         jynWOd01OO3hg0yuGff/jDEZ+GNLHMyxv+f1Y7EOMD0CWzMDYFmF/yiFNnX6Bq5Qxe
         tgmFMSpSqGAPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 062/188] crypto: jitter - consider 32 LSB for APT
Date:   Mon, 17 Jan 2022 21:29:46 -0500
Message-Id: <20220118023152.1948105-62-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index a11b3208760f3..f6d3a84e3c214 100644
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

