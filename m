Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E6650A7D0
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391254AbiDUSH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 14:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391257AbiDUSHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 14:07:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E7E262E7
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 11:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650564302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=PWEeOcAoqNSPxD/knm794G0IGZpIA2eESKbPsfhoQDY=;
        b=VPrEl5idP8LMD+wf8DpKWcZvmtRe7OOl/bmi+Q2ad2P/OlkO6mHMojCZsYb9BeGueTVsTC
        HgzKuTAkMJug2hNeqjY+5WNqJljLzA2Ot0o3A1u2NkH1BAic/Mo2TpM2zOvlVtPq2og8pQ
        HeXYuSZ/pTXn8F4YouA6v4+Dm4+vnXo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-SZ31aPgFNJ2LoPvv5gTVCA-1; Thu, 21 Apr 2022 14:05:00 -0400
X-MC-Unique: SZ31aPgFNJ2LoPvv5gTVCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 132F13C0F0A7;
        Thu, 21 Apr 2022 18:05:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B658409B3E5;
        Thu, 21 Apr 2022 18:05:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 23LI50XY001257;
        Thu, 21 Apr 2022 14:05:00 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 23LI4xIo001253;
        Thu, 21 Apr 2022 14:04:59 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 21 Apr 2022 14:04:59 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH v4.14] dm: fix mempool NULL pointer race when completing IO
Message-ID: <alpine.LRH.2.02.2204211403570.761@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
and dm_wait_for_bios_completion") for the kernel 4.14.

The bugs fixed by these patches can cause random crashing when reloading
dm table, so it is eligible for stable backport.

This patch is different from the upstream patches because the code
diverged significantly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

 drivers/md/dm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2022-04-19 16:33:39.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-19 16:33:39.000000000 +0200
@@ -543,6 +543,8 @@ static void end_io_acct(struct dm_io *io
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, &io->stats_aux);
 
+	free_io(md, io);
+
 	/*
 	 * After this is decremented the bio must not be touched if it is
 	 * a flush.
@@ -802,7 +804,6 @@ static void dec_pending(struct dm_io *io
 		io_error = io->status;
 		bio = io->bio;
 		end_io_acct(io);
-		free_io(md, io);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
 			return;
@@ -2227,6 +2228,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 

