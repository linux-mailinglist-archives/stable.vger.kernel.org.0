Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4E518F38
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiECUrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 16:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbiECUrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 16:47:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EEC733E13
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651610655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=xpbDU7xMPB/gUi8f0JIq18vp6vImfu4LBWk++3+tsbk=;
        b=EoS1dCxzTdacENiR+90aGAVKJagOxmIcux+WkM2NANA4+ITrkf3CbC2slorTKOMr50iFFx
        jIoQyezLQmzyTyLhbgrufvjQ2cKATGiuGxXJusv1LXlud1j7hlLTMAFirZaOig5hP0UuVL
        ji0JZTrlixraUv8A8OUkSOnetFn2iL4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-lrsvu4xxNQO-IFKYEqnZ7w-1; Tue, 03 May 2022 16:44:13 -0400
X-MC-Unique: lrsvu4xxNQO-IFKYEqnZ7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6076B1C05133;
        Tue,  3 May 2022 20:44:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5904540D2820;
        Tue,  3 May 2022 20:44:12 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 243KiCuN012169;
        Tue, 3 May 2022 16:44:12 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 243KiC7f012165;
        Tue, 3 May 2022 16:44:12 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 3 May 2022 16:44:12 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH v5.10] dm: interlock pending dm_io and
 dm_wait_for_bios_completion
Message-ID: <alpine.LRH.2.02.2205031643210.11434@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
and dm_wait_for_bios_completion") for the kernel 5.10.

The bugs fixed by this patch can cause random crashing when reloading dm
table, so it is eligible for stable backport.

Note that the percpu variable md->pending_io is not needed in the stable
kernels, because the "in_flight" counter in struct disk_stats counts the
same value, so it is not backported. In order to fix this bug, we swap the
calls to bio_end_io_acct and dm_stats_account_io.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>

---
 drivers/md/dm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2022-04-30 20:09:28.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2022-04-30 20:10:19.000000000 +0200
@@ -612,13 +612,15 @@ static void end_io_acct(struct mapped_de
 {
 	unsigned long duration = jiffies - start_time;
 
-	bio_end_io_acct(bio, start_time);
-
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, stats_aux);
 
+	smp_wmb();
+
+	bio_end_io_acct(bio, start_time);
+
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(wq_has_sleeper(&md->wait)))
 		wake_up(&md->wait);
@@ -2348,6 +2350,8 @@ static int dm_wait_for_bios_completion(s
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb();
+
 	return r;
 }
 

