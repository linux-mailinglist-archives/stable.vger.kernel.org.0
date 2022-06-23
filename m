Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F255852D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiFWRy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiFWRwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:52:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8183D5675F;
        Thu, 23 Jun 2022 10:13:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9D1CB82498;
        Thu, 23 Jun 2022 17:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3595BC341C4;
        Thu, 23 Jun 2022 17:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004411;
        bh=EG8DbuFAy3wSg2q98S5uSLWwJle4ufkndXArKGOdL5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBedXAKRbvJ1jnrCSwwKwK2qliR90ou4QJW4x7vRIH+8ji3oT7C+Lf1tU4YYTme6B
         BfzJ1Y8IJZ5UKarRRJg9ADUqMA67fmqx7Qg4on8nn8Zq5vYivkbKUtOdcoS79uMcnt
         eE/sg7V6VfLnICKoOiw/po0sMNoixvJsu/RRwtM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 029/234] random: convert to ENTROPY_BITS for better code readability
Date:   Thu, 23 Jun 2022 18:41:36 +0200
Message-Id: <20220623164343.889685406@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

commit 12faac30d157970fdbfa171bbeb1fb88350303b1 upstream.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20190607182517.28266-2-tiny.windzz@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -762,7 +762,7 @@ retry:
 			if (entropy_bits < 128)
 				return;
 			crng_reseed(&primary_crng, r);
-			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
+			entropy_bits = ENTROPY_BITS(r);
 		}
 	}
 }
@@ -1397,8 +1397,7 @@ retry:
 		goto retry;
 
 	trace_debit_entropy(r->name, 8 * ibytes);
-	if (ibytes &&
-	    (r->entropy_count >> ENTROPY_SHIFT) < random_write_wakeup_bits) {
+	if (ibytes && ENTROPY_BITS(r) < random_write_wakeup_bits) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}


