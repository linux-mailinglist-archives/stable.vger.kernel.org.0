Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705C255825C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiFWRNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiFWRMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CA74D25A;
        Thu, 23 Jun 2022 09:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F3260AD7;
        Thu, 23 Jun 2022 16:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D09C3411B;
        Thu, 23 Jun 2022 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003515;
        bh=sbi8FXcon8b7rzkaZG1YD95/6rVLNILntmB9ekCc9/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nwpeo5nS+0tDKXBLXYwL6WWOIA5q7yu4nDIT6nj1GauzF+7a0QzBUCTfcdftGyxwW
         175+7JBD0NvonegLikoP23R16lyEZq0s3UtKCtt2nW+X1JpuH5cGkB7tBFe+eN3c0S
         Q1flHyzHuWRbWCN/TlKqO2l0DyjHJUybQ/Gd5pVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 213/264] random: check for signals after page of pool writes
Date:   Thu, 23 Jun 2022 18:43:26 +0200
Message-Id: <20220623164350.100089050@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
@@ -1252,7 +1252,7 @@ static unsigned int random_poll(struct f
 	return crng_ready() ? POLLIN | POLLRDNORM : POLLOUT | POLLWRNORM;
 }
 
-static ssize_t write_pool(struct iov_iter *iter)
+static ssize_t write_pool_user(struct iov_iter *iter)
 {
 	u8 block[BLAKE2S_BLOCK_SIZE];
 	ssize_t ret = 0;
@@ -1267,7 +1267,13 @@ static ssize_t write_pool(struct iov_ite
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
@@ -1276,7 +1282,7 @@ static ssize_t write_pool(struct iov_ite
 
 static ssize_t random_write_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
-	return write_pool(iter);
+	return write_pool_user(iter);
 }
 
 static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
@@ -1343,7 +1349,7 @@ static long random_ioctl(struct file *f,
 		ret = import_single_range(WRITE, p, len, &iov, &iter);
 		if (unlikely(ret))
 			return ret;
-		ret = write_pool(&iter);
+		ret = write_pool_user(&iter);
 		if (unlikely(ret < 0))
 			return ret;
 		/* Since we're crediting, enforce that it was all written into the pool. */


