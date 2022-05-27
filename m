Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B818B535C83
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242363AbiE0Izg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350181AbiE0Iyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:54:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D7D57150;
        Fri, 27 May 2022 01:53:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43FE7CE23C7;
        Fri, 27 May 2022 08:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2193AC385A9;
        Fri, 27 May 2022 08:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641592;
        bh=F6HYdTu8y5D04U97NP8ICb8h5IlyZ/Zzy3gf8MAugFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNWgEuZK358mcOI7OPFprLtUxJWYh0uUqlQ/Drme1IgHqyww8NcOgBjmfJDnE8tIo
         +P6WfWhOgYwEAX7iskfLzwkTy4T53uqRl2V/M7OhJW7SqWxRxslCUv78abElqldPAT
         00yMJmCzP0k4Wd1Q1wDSydJPPjMV09ZPK1AsuY1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 21/47] random: do not use batches when !crng_ready()
Date:   Fri, 27 May 2022 10:50:01 +0200
Message-Id: <20220527084804.890256943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit cbe89e5a375a51bbb952929b93fa973416fea74e upstream.

It's too hard to keep the batches synchronized, and pointless anyway,
since in !crng_ready(), we're updating the base_crng key really often,
where batching only hurts. So instead, if the crng isn't ready, just
call into get_random_bytes(). At this stage nothing is performance
critical anyhow.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -465,10 +465,8 @@ static void crng_pre_init_inject(const v
 
 	if (account) {
 		crng_init_cnt += min_t(size_t, len, CRNG_INIT_CNT_THRESH - crng_init_cnt);
-		if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-			++base_crng.generation;
+		if (crng_init_cnt >= CRNG_INIT_CNT_THRESH)
 			crng_init = 1;
-		}
 	}
 
 	spin_unlock_irqrestore(&base_crng.lock, flags);
@@ -624,6 +622,11 @@ u64 get_random_u64(void)
 
 	warn_unseeded_randomness(&previous);
 
+	if  (!crng_ready()) {
+		_get_random_bytes(&ret, sizeof(ret));
+		return ret;
+	}
+
 	local_lock_irqsave(&batched_entropy_u64.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 
@@ -658,6 +661,11 @@ u32 get_random_u32(void)
 
 	warn_unseeded_randomness(&previous);
 
+	if  (!crng_ready()) {
+		_get_random_bytes(&ret, sizeof(ret));
+		return ret;
+	}
+
 	local_lock_irqsave(&batched_entropy_u32.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 


