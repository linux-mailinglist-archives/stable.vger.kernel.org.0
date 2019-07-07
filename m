Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C406616C7
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfGGTmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:42:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57598 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727608AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0006jQ-RO; Sun, 07 Jul 2019 20:38:06 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005dI-F3; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>,
        "Joel Fernandes" <joel@joelfernandes.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.208042947@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 087/129] staging: android: ashmem: Avoid
 range_alloc() allocation with ashmem_mutex held.
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit ecd182cbf4e107928077866399100228d2359c60 upstream.

ashmem_pin() is calling range_shrink() without checking whether
range_alloc() succeeded. Also, doing memory allocation with ashmem_mutex
held should be avoided because ashmem_shrink_scan() tries to hold it.

Therefore, move memory allocation for range_alloc() to ashmem_pin_unpin()
and make range_alloc() not to fail.

This patch is mostly meant for backporting purpose for fuzz testing on
stable/distributor kernels, for there is a plan to remove this code in
near future.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/android/ashmem.c | 42 ++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -158,19 +158,15 @@ static inline void lru_del(struct ashmem
  * @end:	   The ending page (inclusive)
  *
  * This function is protected by ashmem_mutex.
- *
- * Return: 0 if successful, or -ENOMEM if there is an error
  */
-static int range_alloc(struct ashmem_area *asma,
-		       struct ashmem_range *prev_range, unsigned int purged,
-		       size_t start, size_t end)
+static void range_alloc(struct ashmem_area *asma,
+			struct ashmem_range *prev_range, unsigned int purged,
+			size_t start, size_t end,
+			struct ashmem_range **new_range)
 {
-	struct ashmem_range *range;
-
-	range = kmem_cache_zalloc(ashmem_range_cachep, GFP_KERNEL);
-	if (unlikely(!range))
-		return -ENOMEM;
+	struct ashmem_range *range = *new_range;
 
+	*new_range = NULL;
 	range->asma = asma;
 	range->pgstart = start;
 	range->pgend = end;
@@ -180,8 +176,6 @@ static int range_alloc(struct ashmem_are
 
 	if (range_on_lru(range))
 		lru_add(range);
-
-	return 0;
 }
 
 /**
@@ -576,7 +570,8 @@ static int get_name(struct ashmem_area *
  *
  * Caller must hold ashmem_mutex.
  */
-static int ashmem_pin(struct ashmem_area *asma, size_t pgstart, size_t pgend)
+static int ashmem_pin(struct ashmem_area *asma, size_t pgstart, size_t pgend,
+		      struct ashmem_range **new_range)
 {
 	struct ashmem_range *range, *next;
 	int ret = ASHMEM_NOT_PURGED;
@@ -628,7 +623,7 @@ static int ashmem_pin(struct ashmem_area
 			 * second half and adjust the first chunk's endpoint.
 			 */
 			range_alloc(asma, range, range->purged,
-				    pgend + 1, range->pgend);
+				    pgend + 1, range->pgend, new_range);
 			range_shrink(range, range->pgstart, pgstart - 1);
 			break;
 		}
@@ -642,7 +637,8 @@ static int ashmem_pin(struct ashmem_area
  *
  * Caller must hold ashmem_mutex.
  */
-static int ashmem_unpin(struct ashmem_area *asma, size_t pgstart, size_t pgend)
+static int ashmem_unpin(struct ashmem_area *asma, size_t pgstart, size_t pgend,
+			struct ashmem_range **new_range)
 {
 	struct ashmem_range *range, *next;
 	unsigned int purged = ASHMEM_NOT_PURGED;
@@ -668,7 +664,8 @@ restart:
 		}
 	}
 
-	return range_alloc(asma, range, purged, pgstart, pgend);
+	range_alloc(asma, range, purged, pgstart, pgend, new_range);
+	return 0;
 }
 
 /*
@@ -701,10 +698,17 @@ static int ashmem_pin_unpin(struct ashme
 	struct ashmem_pin pin;
 	size_t pgstart, pgend;
 	int ret = -EINVAL;
+	struct ashmem_range *range = NULL;
 
 	if (unlikely(copy_from_user(&pin, p, sizeof(pin))))
 		return -EFAULT;
 
+	if (cmd == ASHMEM_PIN || cmd == ASHMEM_UNPIN) {
+		range = kmem_cache_zalloc(ashmem_range_cachep, GFP_KERNEL);
+		if (!range)
+			return -ENOMEM;
+	}
+
 	mutex_lock(&ashmem_mutex);
 
 	if (unlikely(!asma->file))
@@ -728,10 +732,10 @@ static int ashmem_pin_unpin(struct ashme
 
 	switch (cmd) {
 	case ASHMEM_PIN:
-		ret = ashmem_pin(asma, pgstart, pgend);
+		ret = ashmem_pin(asma, pgstart, pgend, &range);
 		break;
 	case ASHMEM_UNPIN:
-		ret = ashmem_unpin(asma, pgstart, pgend);
+		ret = ashmem_unpin(asma, pgstart, pgend, &range);
 		break;
 	case ASHMEM_GET_PIN_STATUS:
 		ret = ashmem_get_pin_status(asma, pgstart, pgend);
@@ -740,6 +744,8 @@ static int ashmem_pin_unpin(struct ashme
 
 out_unlock:
 	mutex_unlock(&ashmem_mutex);
+	if (range)
+		kmem_cache_free(ashmem_range_cachep, range);
 
 	return ret;
 }

