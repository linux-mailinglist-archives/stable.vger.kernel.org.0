Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19BB2F12E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfE3EKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfE3DQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50ACD24646;
        Thu, 30 May 2019 03:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186217;
        bh=3bXHZzvKXyytTWbUilpHdWW3mqkSwQgfLkel3gxWD6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbU685Oj1HhxSXc+rymFdF2uDmOzv5x2P7JMrqGnTPaoS3XYfaX52XGs5op6gETqH
         daKelX13273QdYv4mRTqS02b0SN07krlLqCl2eAK8pfQWcPZ8nEl3FYwUO8XIgaook
         gNcXfcsLgfrfGgxRtT3Ufm85GMuaxpw4EYFBhNz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/276] bcache: avoid clang -Wunintialized warning
Date:   Wed, 29 May 2019 20:04:24 -0700
Message-Id: <20190530030532.661154521@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 78d4eb8ad9e1d413449d1b7a060f50b6efa81ebd ]

clang has identified a code path in which it thinks a
variable may be unused:

drivers/md/bcache/alloc.c:333:4: error: variable 'bucket' is used uninitialized whenever 'if' condition is false
      [-Werror,-Wsometimes-uninitialized]
                        fifo_pop(&ca->free_inc, bucket);
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/md/bcache/util.h:219:27: note: expanded from macro 'fifo_pop'
 #define fifo_pop(fifo, i)       fifo_pop_front(fifo, (i))
                                ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/md/bcache/util.h:189:6: note: expanded from macro 'fifo_pop_front'
        if (_r) {                                                       \
            ^~
drivers/md/bcache/alloc.c:343:46: note: uninitialized use occurs here
                        allocator_wait(ca, bch_allocator_push(ca, bucket));
                                                                  ^~~~~~
drivers/md/bcache/alloc.c:287:7: note: expanded from macro 'allocator_wait'
                if (cond)                                               \
                    ^~~~
drivers/md/bcache/alloc.c:333:4: note: remove the 'if' if its condition is always true
                        fifo_pop(&ca->free_inc, bucket);
                        ^
drivers/md/bcache/util.h:219:27: note: expanded from macro 'fifo_pop'
 #define fifo_pop(fifo, i)       fifo_pop_front(fifo, (i))
                                ^
drivers/md/bcache/util.h:189:2: note: expanded from macro 'fifo_pop_front'
        if (_r) {                                                       \
        ^
drivers/md/bcache/alloc.c:331:15: note: initialize the variable 'bucket' to silence this warning
                        long bucket;
                                   ^

This cannot happen in practice because we only enter the loop
if there is at least one element in the list.

Slightly rearranging the code makes this clearer to both the
reader and the compiler, which avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 7a28232d868bd..de85b3af3b39d 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -327,10 +327,11 @@ static int bch_allocator_thread(void *arg)
 		 * possibly issue discards to them, then we add the bucket to
 		 * the free list:
 		 */
-		while (!fifo_empty(&ca->free_inc)) {
+		while (1) {
 			long bucket;
 
-			fifo_pop(&ca->free_inc, bucket);
+			if (!fifo_pop(&ca->free_inc, bucket))
+				break;
 
 			if (ca->discard) {
 				mutex_unlock(&ca->set->bucket_lock);
-- 
2.20.1



