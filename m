Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C74AFB66
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 13:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfIKLbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 07:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfIKLbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 07:31:47 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7EC0C69097
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 11:31:46 +0000 (UTC)
Received: from localhost (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 213A7608C2;
        Wed, 11 Sep 2019 11:31:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc:     Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org
Subject: [PATCH V2] dm-raid: fix updating of max_discard_sectors limit
Date:   Wed, 11 Sep 2019 19:31:33 +0800
Message-Id: <20190911113133.837-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 11 Sep 2019 11:31:46 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unit of 'chunk_size' is byte, instead of sector, so fix it.

Without this fix, too big max_discard_sectors is applied on the request queue
of dm-raid, finally raid code has to split the bio again.

This re-split done by raid causes the following nested clone_endio:

1) one big bio 'A' is submitted to dm queue, and served as the original
bio

2) one new bio 'B' is cloned from the original bio 'A', and .map()
is run on this bio of 'B', and B's original bio points to 'A'

3) raid code sees that 'B' is too big, and split 'B' and re-submit
the remainded part of 'B' to dm-raid queue via generic_make_request().

4) now dm will hanlde 'B' as new original bio, then allocate a new
clone bio of 'C' and run .map() on 'C'. Meantime C's original bio
points to 'B'.

5) suppose now 'C' is completed by raid direclty, then the following
clone_endio() is called recursively:

	clone_endio(C)
		->clone_endio(B)		#B is original bio of 'C'
			->bio_endio(A)

'A' can be big enough to make handreds of nested clone_endio(), then
stack can be corrupted easily.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- fix commit log a bit

 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8a60a4a070ac..c26aa4e8207a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3749,7 +3749,7 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
 		limits->discard_granularity = chunk_size;
-		limits->max_discard_sectors = chunk_size;
+		limits->max_discard_sectors = chunk_size >> 9;
 	}
 }
 
-- 
2.20.1

