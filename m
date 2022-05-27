Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224E4535C79
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbiE0JBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350406AbiE0I7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:59:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045345DD01;
        Fri, 27 May 2022 01:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25E7561CB7;
        Fri, 27 May 2022 08:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E9CC385A9;
        Fri, 27 May 2022 08:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641745;
        bh=6kI8yzffPb1Y2zoMAnVPuSD3+gXWH64NJ8kHrC8DPZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DflxiKYannHnDCv4N8CpqTGAUTqzhLbqw5nFxpQ8axWFsWbQW8npUtkP1ky4ZfvUr
         qoRpOAF1C39JtjLNOATyuHdd6ZFENQsvGJMAtWHcC85fAiBUIMcWSeNANn7EkDmiiz
         X3CBACQtHvqaAJK1zlHEeccteTs3pwc3uTtZQvqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 45/47] random: check for signals after page of pool writes
Date:   Fri, 27 May 2022 10:50:25 +0200
Message-Id: <20220527084808.686141336@linuxfoundation.org>
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

commit 1ce6c8d68f8ac587f54d0a271ac594d3d51f3efb upstream.

get_random_bytes_user() checks for signals after producing a PAGE_SIZE
worth of output, just like /dev/zero does. write_pool() is doing
basically the same work (actually, slightly more expensive), and so
should stop to check for signals in the same way. Let's also name it
write_pool_user() to match get_random_bytes_user(), so this won't be
misused in the future.

Before this patch, massive writes to /dev/urandom would tie up the
process for an extremely long time and make it unterminatable. After, it
can be successfully interrupted. The following test program can be used
to see this works as intended:

  #include <unistd.h>
  #include <fcntl.h>
  #include <signal.h>
  #include <stdio.h>

  static unsigned char x[~0U];

  static void handle(int) { }

  int main(int argc, char *argv[])
  {
    pid_t pid = getpid(), child;
    int fd;
    signal(SIGUSR1, handle);
    if (!(child = fork())) {
      for (;;)
        kill(pid, SIGUSR1);
    }
    fd = open("/dev/urandom", O_WRONLY);
    pause();
    printf("interrupted after writing %zd bytes\n", write(fd, x, sizeof(x)));
    close(fd);
    kill(child, SIGTERM);
    return 0;
  }

Result before: "interrupted after writing 2147479552 bytes"
Result after: "interrupted after writing 4096 bytes"

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1291,7 +1291,7 @@ static __poll_t random_poll(struct file
 	return crng_ready() ? EPOLLIN | EPOLLRDNORM : EPOLLOUT | EPOLLWRNORM;
 }
 
-static ssize_t write_pool(struct iov_iter *iter)
+static ssize_t write_pool_user(struct iov_iter *iter)
 {
 	u8 block[BLAKE2S_BLOCK_SIZE];
 	ssize_t ret = 0;
@@ -1306,7 +1306,13 @@ static ssize_t write_pool(struct iov_ite
 		mix_pool_bytes(block, copied);
 		if (!iov_iter_count(iter) || copied != sizeof(block))
 			break;
-		cond_resched();
+
+		BUILD_BUG_ON(PAGE_SIZE % sizeof(block) != 0);
+		if (ret % PAGE_SIZE == 0) {
+			if (signal_pending(current))
+				break;
+			cond_resched();
+		}
 	}
 
 	memzero_explicit(block, sizeof(block));
@@ -1315,7 +1321,7 @@ static ssize_t write_pool(struct iov_ite
 
 static ssize_t random_write_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
-	return write_pool(iter);
+	return write_pool_user(iter);
 }
 
 static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
@@ -1389,7 +1395,7 @@ static long random_ioctl(struct file *f,
 		ret = import_single_range(WRITE, p, len, &iov, &iter);
 		if (unlikely(ret))
 			return ret;
-		ret = write_pool(&iter);
+		ret = write_pool_user(&iter);
 		if (unlikely(ret < 0))
 			return ret;
 		/* Since we're crediting, enforce that it was all written into the pool. */


