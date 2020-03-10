Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA017F2B7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 10:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJJGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 05:06:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726199AbgCJJGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 05:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xSmK9z6pWruyLFXiyy4vOPrb+SMZGU/lI1Jxx2/jwjY=;
        b=RxmbwA0R6nmk82pZh7vjW7m2JsECHftEYaaxNv1a0DIi7PoY5mkkUpW01CPfBgKUxHvxer
        0Tx4NF2p3wvaO4RgfunpQOeHVVJSNC4LeuHdnOP/aV20zzY3TwXFFmNzuCG6w6NFLkXX10
        vhO/7wV3e8zA9sZD2EY9ntvsEfvLIOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-70btbhFaO2C4xwelThq4YA-1; Tue, 10 Mar 2020 05:06:46 -0400
X-MC-Unique: 70btbhFaO2C4xwelThq4YA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F9E58010D9;
        Tue, 10 Mar 2020 09:06:45 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D955D9C5;
        Tue, 10 Mar 2020 09:06:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 02A96emJ008529;
        Tue, 10 Mar 2020 05:06:40 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 02A96doe008525;
        Tue, 10 Mar 2020 05:06:39 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 10 Mar 2020 05:06:39 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     gregkh@linuxfoundation.org
cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: [PATCH v4.4 v4.9] dm cache: fix a crash due to incorrect work item
 cancelling
In-Reply-To: <158378436239197@kroah.com>
Message-ID: <alpine.LRH.2.02.2003100505050.7499@file01.intranet.prod.int.rdu2.redhat.com>
References: <158378436239197@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 9 Mar 2020, gregkh@linuxfoundation.org wrote:

> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi

Here I'm sending the patch for the stable branches 4.4 and 4.9.

Mikulas


------------------ original commit in Linus's tree ------------------

>From 7cdf6a0aae1cccf5167f3f04ecddcf648b78e289 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 19 Feb 2020 10:25:45 -0500
Subject: [PATCH] dm cache: fix a crash due to incorrect work item cancelling

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

---
 drivers/md/dm-cache-target.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-stable/drivers/md/dm-cache-target.c
===================================================================
--- linux-stable.orig/drivers/md/dm-cache-target.c	2020-03-10 10:03:40.000000000 +0100
+++ linux-stable/drivers/md/dm-cache-target.c	2020-03-10 10:03:58.000000000 +0100
@@ -2192,8 +2192,8 @@ static void wait_for_migrations(struct c
 
 static void stop_worker(struct cache *cache)
 {
-	cancel_delayed_work(&cache->waker);
-	flush_workqueue(cache->wq);
+	cancel_delayed_work_sync(&cache->waker);
+	drain_workqueue(cache->wq);
 }
 
 static void requeue_deferred_cells(struct cache *cache)

