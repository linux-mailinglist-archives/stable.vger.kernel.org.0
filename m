Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A307F192
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390428AbfHBJdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbfHBJdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:33:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677A0217D4;
        Fri,  2 Aug 2019 09:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738389;
        bh=1cg3bNt/7VlbgSLvssmd7fmo/GrOc/mO6jNgEkCnfhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYEXX9r4IkZvC09ze3H+kRTbYlD6XrvFPANXFHqORTgkGDW7DhZIWabEjmMIh8h5F
         W2kOWt0YNv+tzhqgOMlgoN8A0JxKDkV5+BqGcYgW75H/aJ/nq/aSaFSUO/xalk7fjn
         NWmRVL/B1lUfE5IqYHdxmMaWt4y/Hea8O4B9hCOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.4 085/158] dm bufio: fix deadlock with loop device
Date:   Fri,  2 Aug 2019 11:28:26 +0200
Message-Id: <20190802092221.576013612@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit bd293d071ffe65e645b4d8104f9d8fe15ea13862 upstream.

When thin-volume is built on loop device, if available memory is low,
the following deadlock can be triggered:

One process P1 allocates memory with GFP_FS flag, direct alloc fails,
memory reclaim invokes memory shrinker in dm_bufio, dm_bufio_shrink_scan()
runs, mutex dm_bufio_client->lock is acquired, then P1 waits for dm_buffer
IO to complete in __try_evict_buffer().

But this IO may never complete if issued to an underlying loop device
that forwards it using direct-IO, which allocates memory using
GFP_KERNEL (see: do_blockdev_direct_IO()).  If allocation fails, memory
reclaim will invoke memory shrinker in dm_bufio, dm_bufio_shrink_scan()
will be invoked, and since the mutex is already held by P1 the loop
thread will hang, and IO will never complete.  Resulting in ABBA
deadlock.

Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1561,9 +1561,7 @@ dm_bufio_shrink_scan(struct shrinker *sh
 	unsigned long freed;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (sc->gfp_mask & __GFP_FS)
-		dm_bufio_lock(c);
-	else if (!dm_bufio_trylock(c))
+	if (!dm_bufio_trylock(c))
 		return SHRINK_STOP;
 
 	freed  = __scan(c, sc->nr_to_scan, sc->gfp_mask);


