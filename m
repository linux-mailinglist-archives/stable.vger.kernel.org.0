Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE053518F36
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 22:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbiECUqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 16:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiECUqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 16:46:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1B452C114
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651610596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Y9noti8QWi8O7f9yxJXUUZFrN7OTM6hf3YNNVct0scA=;
        b=NA3qKIw37lDkTChgj+C+cb5oMHNo3jvpKa7vLEmARZzzT8AAWj25BEAefA4TzHmAPjeOKO
        ywXTyzn3YreQ6JaCk8zeVNWrnSeAMJAmUV3HVO4JvJhSV+LZInfqEDt6vXXjyCAbKDZ3/n
        h4ibhdN75Cjk+VmTV8x7pSaEl+V9jjA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-DteugY6nNL2-qlokb7Ot0Q-1; Tue, 03 May 2022 16:43:15 -0400
X-MC-Unique: DteugY6nNL2-qlokb7Ot0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 057921C05148;
        Tue,  3 May 2022 20:43:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1CDD1544F7C;
        Tue,  3 May 2022 20:43:13 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 243KhD4a012096;
        Tue, 3 May 2022 16:43:13 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 243KhDsw012092;
        Tue, 3 May 2022 16:43:13 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 3 May 2022 16:43:13 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v5.4] dm: interlock pending dm_io and
 dm_wait_for_bios_completion
Message-ID: <alpine.LRH.2.02.2205031642110.11434@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport of the patch 9f6dc6337610 ("dm: interlock pending dm_io
and dm_wait_for_bios_completion") for the kernel 5.4.

The bugs fixed by this patch can cause random crashing when reloading dm
table, so it is eligible for stable backport.

Note that the percpu variable md->pending_io is not needed in the stable
kernels, because the "in_flight" counter in struct disk_stats counts the
same value, so it is not backported. In order to fix this bug, we swap the
calls to generic_end_io_acct and dm_stats_account_io.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>

---
 drivers/md/dm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2022-04-30 19:57:10.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-30 19:58:57.000000000 +0200
@@ -681,14 +681,16 @@ static void end_io_acct(struct mapped_de
 {
 	unsigned long duration = jiffies - start_time;
 
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    start_time);
-
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, stats_aux);
 
+	smp_wmb();
+
+	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
+			    start_time);
+
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
@@ -2494,6 +2496,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 

