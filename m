Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE4650A7D6
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 20:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbiDUSKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 14:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390878AbiDUSKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 14:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D81324B438
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 11:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2P6aKxuzCYwfb461N6dGLhRS9TKgnLjvoEZdNV714lc=;
        b=LPd0gxVgwSH/AYPhvIkirnaB4OJgKqaRa3wzZSX7Khbi2v/aw8ut2fIR8UTWXpLTsk45Hk
        jiME/epEATXtRufwT5VYpkDBoZgoldXXSLFItvnKhh/H+k5YXVWRft2GsH33aMFLrruSyb
        rIKo81ratu6hsIHGoGLue/sdVT6Hs4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-5Q_CrXW7M1K9Ib5LQZsDEw-1; Thu, 21 Apr 2022 14:07:20 -0400
X-MC-Unique: 5Q_CrXW7M1K9Ib5LQZsDEw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A548811E75;
        Thu, 21 Apr 2022 18:07:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 590285517C2;
        Thu, 21 Apr 2022 18:07:20 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 23LI7KbH001550;
        Thu, 21 Apr 2022 14:07:20 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 23LI7Kot001546;
        Thu, 21 Apr 2022 14:07:20 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 21 Apr 2022 14:07:20 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH v5.4] dm: fix mempool NULL pointer race when completing IO
Message-ID: <alpine.LRH.2.02.2204211406080.761@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

This is backport of patches d208b89401e0 ("dm: fix mempool NULL pointer
race when completing IO") and 9f6dc6337610 ("dm: interlock pending dm_io
and dm_wait_for_bios_completion") for the kernel 5.4.

The bugs fixed by these patches can cause random crashing when reloading
dm table, so it is eligible for stable backport.

This patch is different from the upstream patches because the code
diverged significantly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2022-04-19 16:25:08.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-19 16:26:18.000000000 +0200
@@ -676,20 +676,27 @@ static void start_io_acct(struct dm_io *
 				    false, 0, &io->stats_aux);
 }
 
+static void free_io(struct mapped_device *md, struct dm_io *io);
+
 static void end_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
-	unsigned long duration = jiffies - io->start_time;
-
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    io->start_time);
+	unsigned long start_time = io->start_time;
+	unsigned long duration = jiffies - start_time;
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, &io->stats_aux);
 
+	free_io(md, io);
+
+	smp_wmb();
+
+	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
+			    start_time);
+
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
@@ -936,7 +943,6 @@ static void dec_pending(struct dm_io *io
 		io_error = io->status;
 		bio = io->orig_bio;
 		end_io_acct(io);
-		free_io(md, io);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
@@ -2491,6 +2497,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 

