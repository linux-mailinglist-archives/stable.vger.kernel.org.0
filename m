Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1653614F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbiE0L5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353252AbiE0L4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4310692B6;
        Fri, 27 May 2022 04:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87F66B8091D;
        Fri, 27 May 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9345C385A9;
        Fri, 27 May 2022 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652211;
        bh=t+CWp4gJ78L2N63BE4YI9JQVYhLl6AuUO2Wxjs1ljEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzY7mdORrGFSDfjzvh6qYTiZbO3V9hkdHW5N2qmQF1ebnNhyy0EdgoDGKybmJIodc
         OtSAPbt+3mYl8QirIlqDwJFoN59Twc5IQk36jrXsbv4bKYEwS4Vn0gMIzE7gWx6JIW
         tn0SqXHLcFZVEdYUfJsyD1GYfgCwU0O9+BHK+46I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 101/145] random: document crng_fast_key_erasure() destination possibility
Date:   Fri, 27 May 2022 10:50:02 +0200
Message-Id: <20220527084902.884154326@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 8717627d6ac53251ee012c3c7aca392f29f38a42 upstream.

This reverts 35a33ff3807d ("random: use memmove instead of memcpy for
remaining 32 bytes"), which was made on a totally bogus basis. The thing
it was worried about overlapping came from the stack, not from one of
its arguments, as Eric pointed out.

But the fact that this confusion even happened draws attention to the
fact that it's a bit non-obvious that the random_data parameter can
alias chacha_state, and in fact should do so when the caller can't rely
on the stack being cleared in a timely manner. So this commit documents
that.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -320,6 +320,13 @@ static void crng_reseed(void)
  * the resultant ChaCha state to the user, along with the second
  * half of the block containing 32 bytes of random data that may
  * be used; random_data_len may not be greater than 32.
+ *
+ * The returned ChaCha state contains within it a copy of the old
+ * key value, at index 4, so the state should always be zeroed out
+ * immediately after using in order to maintain forward secrecy.
+ * If the state cannot be erased in a timely manner, then it is
+ * safer to set the random_data parameter to &chacha_state[4] so
+ * that this function overwrites it before returning.
  */
 static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
 				  u32 chacha_state[CHACHA_STATE_WORDS],


