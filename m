Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7626EEA
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbfEVTwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731785AbfEVT0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:26:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ACD620675;
        Wed, 22 May 2019 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553160;
        bh=rLlpe14VGOuEj2srCQTAuhOX025maSbwepQQLAobpNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVdDYnYmIVt/CczI5aLvTseSdM5lMDcQyto5k/RgWhsdLO3FCcCM62jeYIiA1cV3a
         1j2vv0eRaFPf3HtE3K++BlHp0heMKNEqtDuxR7OBGitiKm07eQKtadMYu/B0C4fpS9
         E2Ijel8lj2mga0Zoxppqv/VrnBYMrJwllCdcE1kE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 087/317] bcache: avoid clang -Wunintialized warning
Date:   Wed, 22 May 2019 15:19:48 -0400
Message-Id: <20190522192338.23715-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
index 5002838ea4760..f8986effcb501 100644
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

