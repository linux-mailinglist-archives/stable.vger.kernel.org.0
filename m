Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0322240E561
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347356AbhIPRLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349871AbhIPRHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBACC61B41;
        Thu, 16 Sep 2021 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810183;
        bh=8gg7AK441555JIJ//7xJtZMyg3TqeqWKgaUCit8Uwqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZUhasjudDGLAskB+ZJbEHGnIkb90FWh7bWEAwodCXQJSXX9kwc4kJIa9hpR2+EGO
         VrtV11P2XWeOdg2UWUN14bjsVmHAGYoLiICn8Iysk3BQDKmPypju2Z5mFQhLRDyIEh
         Id+1OrJ1o0WT1xhrq/DH5TCkc/jv5ksa/W2wBFu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DJ Gregor <dj@corelight.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Arne Welzel <arne.welzel@corelight.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.14 047/432] dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()
Date:   Thu, 16 Sep 2021 17:56:36 +0200
Message-Id: <20210916155812.404259563@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arne Welzel <arne.welzel@corelight.com>

commit 528b16bfc3ae5f11638e71b3b63a81f9999df727 upstream.

On systems with many cores using dm-crypt, heavy spinlock contention in
percpu_counter_compare() can be observed when the page allocation limit
for a given device is reached or close to be reached. This is due
to percpu_counter_compare() taking a spinlock to compute an exact
result on potentially many CPUs at the same time.

Switch to non-exact comparison of allocated and allowed pages by using
the value returned by percpu_counter_read_positive() to avoid taking
the percpu_counter spinlock.

This may over/under estimate the actual number of allocated pages by at
most (batch-1) * num_online_cpus().

Currently, batch is bounded by 32. The system on which this issue was
first observed has 256 CPUs and 512GB of RAM. With a 4k page size, this
change may over/under estimate by 31MB. With ~10G (2%) allowed dm-crypt
allocations, this seems an acceptable error. Certainly preferred over
running into the spinlock contention.

This behavior was reproduced on an EC2 c5.24xlarge instance with 96 CPUs
and 192GB RAM as follows, but can be provoked on systems with less CPUs
as well.

 * Disable swap
 * Tune vm settings to promote regular writeback
     $ echo 50 > /proc/sys/vm/dirty_expire_centisecs
     $ echo 25 > /proc/sys/vm/dirty_writeback_centisecs
     $ echo $((128 * 1024 * 1024)) > /proc/sys/vm/dirty_background_bytes

 * Create 8 dmcrypt devices based on files on a tmpfs
 * Create and mount an ext4 filesystem on each crypt devices
 * Run stress-ng --hdd 8 within one of above filesystems

Total %system usage collected from sysstat goes to ~35%. Write throughput
on the underlying loop device is ~2GB/s. perf profiling an individual
kworker kcryptd thread shows the following profile, indicating spinlock
contention in percpu_counter_compare():

    99.98%     0.00%  kworker/u193:46  [kernel.kallsyms]  [k] ret_from_fork
      |
      --ret_from_fork
        kthread
        worker_thread
        |
         --99.92%--process_one_work
            |
            |--80.52%--kcryptd_crypt
            |    |
            |    |--62.58%--mempool_alloc
            |    |  |
            |    |   --62.24%--crypt_page_alloc
            |    |     |
            |    |      --61.51%--__percpu_counter_compare
            |    |        |
            |    |         --61.34%--__percpu_counter_sum
            |    |           |
            |    |           |--58.68%--_raw_spin_lock_irqsave
            |    |           |  |
            |    |           |   --58.30%--native_queued_spin_lock_slowpath
            |    |           |
            |    |            --0.69%--cpumask_next
            |    |                |
            |    |                 --0.51%--_find_next_bit
            |    |
            |    |--10.61%--crypt_convert
            |    |          |
            |    |          |--6.05%--xts_crypt
            ...

After applying this patch and running the same test, %system usage is
lowered to ~7% and write throughput on the loop device increases
to ~2.7GB/s. perf report shows mempool_alloc() as ~8% rather than ~62%
in the profile and not hitting the percpu_counter() spinlock anymore.

    |--8.15%--mempool_alloc
    |    |
    |    |--3.93%--crypt_page_alloc
    |    |    |
    |    |     --3.75%--__alloc_pages
    |    |         |
    |    |          --3.62%--get_page_from_freelist
    |    |              |
    |    |               --3.22%--rmqueue_bulk
    |    |                   |
    |    |                    --2.59%--_raw_spin_lock
    |    |                      |
    |    |                       --2.57%--native_queued_spin_lock_slowpath
    |    |
    |     --3.05%--_raw_spin_lock_irqsave
    |               |
    |                --2.49%--native_queued_spin_lock_slowpath

Suggested-by: DJ Gregor <dj@corelight.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Arne Welzel <arne.welzel@corelight.com>
Fixes: 5059353df86e ("dm crypt: limit the number of allocated pages")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2661,7 +2661,12 @@ static void *crypt_page_alloc(gfp_t gfp_
 	struct crypt_config *cc = pool_data;
 	struct page *page;
 
-	if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
+	/*
+	 * Note, percpu_counter_read_positive() may over (and under) estimate
+	 * the current usage by at most (batch - 1) * num_online_cpus() pages,
+	 * but avoids potential spinlock contention of an exact result.
+	 */
+	if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) >= dm_crypt_pages_per_client) &&
 	    likely(gfp_mask & __GFP_NORETRY))
 		return NULL;
 


