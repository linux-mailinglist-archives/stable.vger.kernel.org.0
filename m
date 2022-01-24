Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01DC49A372
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1846008AbiAXX6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846029AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF5C06F8CE;
        Mon, 24 Jan 2022 13:22:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 620CAB81243;
        Mon, 24 Jan 2022 21:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49840C340E4;
        Mon, 24 Jan 2022 21:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059374;
        bh=FtVstA5Qd9mauR9+4JEDWKdV8yzsC6t8OYr2IPene8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCjpmZEVdcEk5hcIBmkBnJIYQHuTJSips7LRyKcoq0PIquEEh4nPELyQBo1FW8eW4
         4H8DaEpuQ6TB0vyaJOrGtl+rb6waWwmbGDHD7boEc+EkSRmNwQjc8m2GH8ibCdSMfn
         +mdRAA3/p5yNORAkfAg3Ja5BpDxNvmAVliSLVQ8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0595/1039] crypto: jitter - consider 32 LSB for APT
Date:   Mon, 24 Jan 2022 19:39:44 +0100
Message-Id: <20220124184145.331956167@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 4dc2261cdeefb..788d90749715a 100644
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



