Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3059558474
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiFWRnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiFWRmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:42:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E32298C57;
        Thu, 23 Jun 2022 10:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C901B824B8;
        Thu, 23 Jun 2022 17:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB216C3411B;
        Thu, 23 Jun 2022 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004196;
        bh=NGgX2yhDU7zsLdshLqW0cGUunsOEI9fnothbHvT8P34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjEPIDReVOdIm6fKiEE+pkMUuNSqCuAz39wNapct0aHZMRgaBYYTRuPfDbMiyy11M
         sPzKG30MlnYnIkNzYPnD85fat0z9zh9Ibi5R1+wopfELYdCvOXY8VGh+gLlYwC4HY9
         gyQ/wn76T5wY7vE4GHCMAs9EMMSBRoUAn7gEPT1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 182/237] random: check for signals after page of pool writes
Date:   Thu, 23 Jun 2022 18:43:36 +0200
Message-Id: <20220623164348.384788241@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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
@@ -1251,7 +1251,7 @@ static unsigned int random_poll(struct f
 	return crng_ready() ? POLLIN | POLLRDNORM : POLLOUT | POLLWRNORM;
 }
 
-static ssize_t write_pool(struct iov_iter *iter)
+static ssize_t write_pool_user(struct iov_iter *iter)
 {
 	u8 block[BLAKE2S_BLOCK_SIZE];
 	ssize_t ret = 0;
@@ -1266,7 +1266,13 @@ static ssize_t write_pool(struct iov_ite
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
@@ -1275,7 +1281,7 @@ static ssize_t write_pool(struct iov_ite
 
 static ssize_t random_write_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
-	return write_pool(iter);
+	return write_pool_user(iter);
 }
 
 static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
@@ -1342,7 +1348,7 @@ static long random_ioctl(struct file *f,
 		ret = import_single_range(WRITE, p, len, &iov, &iter);
 		if (unlikely(ret))
 			return ret;
-		ret = write_pool(&iter);
+		ret = write_pool_user(&iter);
 		if (unlikely(ret < 0))
 			return ret;
 		/* Since we're crediting, enforce that it was all written into the pool. */


