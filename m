Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07404536021
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiE0Lqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351935AbiE0LpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2413C351;
        Fri, 27 May 2022 04:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD52461C3F;
        Fri, 27 May 2022 11:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C766FC385A9;
        Fri, 27 May 2022 11:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651690;
        bh=5Qvl9MRNPbfZ5zmGTUMKK2Aok2MPBZGiLGgl4WAat1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYwx4WEvQ1SNgCUPKmPlqp283w+Z+TdbnJXAsOeZfxvvRtoncvKizDdFf9ENfhsCr
         HUsiNZovbwAGvHpv7EGiKgl/PgZWjTEnFfobjhc0z78T37aT4x3hruDaGkEmC0TeHB
         zoD+Gt0K7LtLxmsdp0HtQlfKnnLEXu1J6xHLuc9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 063/111] random: check for signals every PAGE_SIZE chunk of /dev/[u]random
Date:   Fri, 27 May 2022 10:49:35 +0200
Message-Id: <20220527084828.462781628@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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

commit e3c1c4fd9e6d14059ed93ebfe15e1c57793b1a05 upstream.

In 1448769c9cdb ("random: check for signal_pending() outside of
need_resched() check"), Jann pointed out that we previously were only
checking the TIF_NOTIFY_SIGNAL and TIF_SIGPENDING flags if the process
had TIF_NEED_RESCHED set, which meant in practice, super long reads to
/dev/[u]random would delay signal handling by a long time. I tried this
using the below program, and indeed I wasn't able to interrupt a
/dev/urandom read until after several megabytes had been read. The bug
he fixed has always been there, and so code that reads from /dev/urandom
without checking the return value of read() has mostly worked for a long
time, for most sizes, not just for <= 256.

Maybe it makes sense to keep that code working. The reason it was so
small prior, ignoring the fact that it didn't work anyway, was likely
because /dev/random used to block, and that could happen for pretty
large lengths of time while entropy was gathered. But now, it's just a
chacha20 call, which is extremely fast and is just operating on pure
data, without having to wait for some external event. In that sense,
/dev/[u]random is a lot more like /dev/zero.

Taking a page out of /dev/zero's read_zero() function, it always returns
at least one chunk, and then checks for signals after each chunk. Chunk
sizes there are of length PAGE_SIZE. Let's just copy the same thing for
/dev/[u]random, and check for signals and cond_resched() for every
PAGE_SIZE amount of data. This makes the behavior more consistent with
expectations, and should mitigate the impact of Jann's fix for the
age-old signal check bug.

---- test program ----

  #include <unistd.h>
  #include <signal.h>
  #include <stdio.h>
  #include <sys/random.h>

  static unsigned char x[~0U];

  static void handle(int) { }

  int main(int argc, char *argv[])
  {
    pid_t pid = getpid(), child;
    signal(SIGUSR1, handle);
    if (!(child = fork())) {
      for (;;)
        kill(pid, SIGUSR1);
    }
    pause();
    printf("interrupted after reading %zd bytes\n", getrandom(x, sizeof(x), 0));
    kill(child, SIGTERM);
    return 0;
  }

Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -523,7 +523,6 @@ EXPORT_SYMBOL(get_random_bytes);
 
 static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 {
-	bool large_request = nbytes > 256;
 	ssize_t ret = 0;
 	size_t len;
 	u32 chacha_state[CHACHA_STATE_WORDS];
@@ -549,15 +548,6 @@ static ssize_t get_random_bytes_user(voi
 	}
 
 	do {
-		if (large_request) {
-			if (signal_pending(current)) {
-				if (!ret)
-					ret = -ERESTARTSYS;
-				break;
-			}
-			cond_resched();
-		}
-
 		chacha20_block(chacha_state, output);
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
@@ -571,6 +561,13 @@ static ssize_t get_random_bytes_user(voi
 		nbytes -= len;
 		buf += len;
 		ret += len;
+
+		BUILD_BUG_ON(PAGE_SIZE % CHACHA_BLOCK_SIZE != 0);
+		if (!(ret % PAGE_SIZE) && nbytes) {
+			if (signal_pending(current))
+				break;
+			cond_resched();
+		}
 	} while (nbytes);
 
 	memzero_explicit(output, sizeof(output));


