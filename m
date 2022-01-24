Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DFB499615
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbiAXU7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359088AbiAXUxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0320C047CC6;
        Mon, 24 Jan 2022 11:59:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DD1C60B43;
        Mon, 24 Jan 2022 19:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712F6C340E5;
        Mon, 24 Jan 2022 19:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054349;
        bh=cp+p/t25XdZb2rsecPqcVi9U8jj0FyYDOxIhELjcxZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2PGzIoNoh7QE9x6r3fUnrM/7VQ7B8ad/WGUOLudLrpllhBx8y8kFP7bImAk+A1r0
         OXbgEzba/UNiP50ws5xs37M6WliEYkxF3/x8Dsffp8+7pdAfqBZKqw+Idio+iUJ8AF
         jrDV0PWzTq89baQ2OhVu1LQV85wrWlgnYklPQWUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/563] crypto: jitter - consider 32 LSB for APT
Date:   Mon, 24 Jan 2022 19:41:32 +0100
Message-Id: <20220124184035.742929596@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
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



