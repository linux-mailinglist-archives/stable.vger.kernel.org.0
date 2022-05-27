Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31834536146
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345205AbiE0L5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353302AbiE0L4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F7FBEA;
        Fri, 27 May 2022 04:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D26461D56;
        Fri, 27 May 2022 11:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582F2C385A9;
        Fri, 27 May 2022 11:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652255;
        bh=XSyzW1rqJtEuSAiRzlou7jCCWzgp7BO+3upXjd452X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9hQn6qUXZGs5nWrDy3pW6lyH2r1SQL8xajfTvGQ3MV68B/GsoF182RnftbOEC9EE
         iFpzuP3bcjQBliE/Djj6JtsbJDZbglqrCvxyDiubdagCFmNtnnc0TlPWw67+6HX4aW
         4ZSLqrGYfXSCI0YGDxKE0FP135IcRtfOyyO6m92Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 098/145] random: check for signals every PAGE_SIZE chunk of /dev/[u]random
Date:   Fri, 27 May 2022 10:49:59 +0200
Message-Id: <20220527084902.561475491@linuxfoundation.org>
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
@@ -525,7 +525,6 @@ EXPORT_SYMBOL(get_random_bytes);
 
 static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 {
-	bool large_request = nbytes > 256;
 	ssize_t ret = 0;
 	size_t len;
 	u32 chacha_state[CHACHA_STATE_WORDS];
@@ -551,15 +550,6 @@ static ssize_t get_random_bytes_user(voi
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
@@ -573,6 +563,13 @@ static ssize_t get_random_bytes_user(voi
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


