Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C7217F865
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgCJMre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgCJMrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF6724696;
        Tue, 10 Mar 2020 12:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844452;
        bh=la9qw1l3uMA53Tssfqtz17j/JLxUUBGrf9xPRhZu1Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWbvIpeT5idI2ertN84tmSqpA5wj/RfwvU/rYvI+eEKjtZCq6QfSQpPJobv6DDuaS
         KfSnypo/8SiZXaoee6G0zwTmoNGRGDrKVJvYGMt9z9p4B4ZyPIZj8wO+yqs/0aJQYH
         1kDpYGvSmEVFKPhlXjXlm6lxCh35lPzinjrvIX2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 87/88] dm cache: fix a crash due to incorrect work item cancelling
Date:   Tue, 10 Mar 2020 13:39:35 +0100
Message-Id: <20200310123625.267758815@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 7cdf6a0aae1cccf5167f3f04ecddcf648b78e289 upstream.

The crash can be reproduced by running the lvm2 testsuite test
lvconvert-thin-external-cache.sh for several minutes, e.g.:
  while :; do make check T=shell/lvconvert-thin-external-cache.sh; done

The crash happens in this call chain:
do_waker -> policy_tick -> smq_tick -> end_hotspot_period -> clear_bitset
-> memset -> __memset -- which accesses an invalid pointer in the vmalloc
area.

The work entry on the workqueue is executed even after the bitmap was
freed. The problem is that cancel_delayed_work doesn't wait for the
running work item to finish, so the work item can continue running and
re-submitting itself even after cache_postsuspend. In order to make sure
that the work item won't be running, we must use cancel_delayed_work_sync.

Also, change flush_workqueue to drain_workqueue, so that if some work item
submits itself or another work item, we are properly waiting for both of
them.

Fixes: c6b4fcbad044 ("dm: add cache target")
Cc: stable@vger.kernel.org # v3.9
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2192,8 +2192,8 @@ static void wait_for_migrations(struct c
 
 static void stop_worker(struct cache *cache)
 {
-	cancel_delayed_work(&cache->waker);
-	flush_workqueue(cache->wq);
+	cancel_delayed_work_sync(&cache->waker);
+	drain_workqueue(cache->wq);
 }
 
 static void requeue_deferred_cells(struct cache *cache)


