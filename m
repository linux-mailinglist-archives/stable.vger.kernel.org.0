Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1775A2DF84C
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 05:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgLUEfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 23:35:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbgLUEfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 23:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608525233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lZM3RNwmwWP54uqTbzBkqorYuZ8rgPl/4mZufV9L+F8=;
        b=EP7muUfrs0mBA3Kd7AwI6tNPKyhHhzoE7VhtENJk1P0GIYmtDpaSz8DuChC0UWAkcJWOmT
        vQ40dUiKJsJs9s69ImYfCYiYsLT683kZ+2K3UrAavaJYbgNh3sy1Tebv9JxbXrFPMrK9Av
        F0YRH9gqEfm4q4hUHb4oyFRDk94DOf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-al7_xAzLP8yLWtMjbiG1vA-1; Sun, 20 Dec 2020 23:33:48 -0500
X-MC-Unique: al7_xAzLP8yLWtMjbiG1vA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 507C959;
        Mon, 21 Dec 2020 04:33:47 +0000 (UTC)
Received: from localhost (ovpn-13-38.pek2.redhat.com [10.72.13.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAF7160938;
        Mon, 21 Dec 2020 04:33:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org,
        syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
Subject: [PATCH] block: fix use-after-free in disk_part_iter_next
Date:   Mon, 21 Dec 2020 12:33:35 +0800
Message-Id: <20201221043335.2831589-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that bdgrab() is done on the 'block_device' instance before
referring to it for avoiding use-after-free.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/genhd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b84b8671e627..2df3c5b1c9c8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -244,15 +244,18 @@ struct block_device *disk_part_iter_next(struct disk_part_iter *piter)
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
+		piter->part = bdgrab(part);
+		if (!piter->part)
+			continue;
 		if (!bdev_nr_sectors(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
-		      piter->idx == 0))
+		      piter->idx == 0)) {
+			bdput(piter->part);
+			piter->part = NULL;
 			continue;
+		}
 
-		piter->part = bdgrab(part);
-		if (!piter->part)
-			continue;
 		piter->idx += inc;
 		break;
 	}
-- 
2.28.0

