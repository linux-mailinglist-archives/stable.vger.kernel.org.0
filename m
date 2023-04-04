Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9F96D6C14
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 20:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbjDDSbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 14:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbjDDSae (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 14:30:34 -0400
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EE76EAC
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 11:27:04 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id ga7so32714243qtb.2
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 11:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsI89aBxoNjXwhryh0Y5XhntM/4A2U2YcKa3v6rBxI8=;
        b=sGloZnUApom+9pWLiDoXY9f4/EqzhGQD56wtr/tAT6oAOguYIuvwrKmOpLqbqiZHsu
         aVPaaJl1dwt/34lnxe36c0mImlSYbwHH/ZEiB9i4Zph5etBlDTkgX8Mz5HeamMfrTmgI
         ART+tHa0hBYcOFZ02o1iG3+xtFGaU2N46NLj3lG5HJCGR2Y7cnPnf+7uU/5CBKlOHgs7
         cVvStvN1W7uJ3NUq20vZUj0ws9P8el8AcYhmd59MwNpyO4c3qwiVQYIbCO1dK7FvyVX+
         czR/NMcFcv5Z67xcKUyTAjfVScqGfSFhUTFvCztWWHUm50VwzTIa9fuAFK7a+o7MalFv
         azVw==
X-Gm-Message-State: AAQBX9dw2+1+6WCE3U87MlNWS19J51DFq1C0C3d2iNyx88vnGStYexIi
        3hz9cR0YzGMh8/okwa0349DZ4dwQTKdifqBKiSGs
X-Google-Smtp-Source: AKy350Y9po4YQ62q59OkiftwgH0kBRFIynl4dRD9FytXjcXA1pLRGjAd4Z75uJBtaKflpcnW9Oeb0g==
X-Received: by 2002:a05:622a:178f:b0:3e4:e66e:44d1 with SMTP id s15-20020a05622a178f00b003e4e66e44d1mr625101qtk.62.1680632786810;
        Tue, 04 Apr 2023 11:26:26 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id q13-20020a05620a024d00b00746a0672cf3sm3783997qkn.94.2023.04.04.11.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:26:26 -0700 (PDT)
From:   Mike Snitzer <snitzer@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, bmarzins@redhat.com,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1+] dm: fix improper splitting for abnormal bios
Date:   Tue,  4 Apr 2023 14:26:23 -0400
Message-Id: <20230404182623.34623-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023040332-dodgy-chamomile-54f5@gregkh>
References: <2023040332-dodgy-chamomile-54f5@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

Conflicts: Code changes due to missing upstream commit 86a3238c7b9b
           ('dm: change "unsigned" to "unsigned int"')

commit f7b58a69fad9d2c4c90cab0247811155dd0d48e7
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Thu Mar 30 14:56:38 2023 -0400

    dm: fix improper splitting for abnormal bios

    "Abnormal" bios include discards, write zeroes and secure erase. By no
    longer passing the calculated 'len' pointer, commit 7dd06a2548b2 ("dm:
    allow dm_accept_partial_bio() for dm_io without duplicate bios") took a
    senseless approach to disallowing dm_accept_partial_bio() from working
    for duplicate bios processed using __send_duplicate_bios().

    It inadvertently and incorrectly stopped the use of 'len' when
    initializing a target's io (in alloc_tio). As such the resulting tio
    could address more area of a device than it should.

    For example, when discarding an entire DM striped device with the
    following DM table:
     vg-lvol0: 0 159744 striped 2 128 7:0 2048 7:1 2048
     vg-lvol0: 159744 45056 striped 2 128 7:2 2048 7:3 2048

    Before this fix:

     device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=102400
     blkdiscard: attempt to access beyond end of device
     loop0: rw=2051, sector=2048, nr_sectors = 102400 limit=81920

     device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=102400
     blkdiscard: attempt to access beyond end of device
     loop1: rw=2051, sector=2048, nr_sectors = 102400 limit=81920

    After this fix;

     device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=79872
     device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=79872

    Fixes: 7dd06a2548b2 ("dm: allow dm_accept_partial_bio() for dm_io without duplicate bios")
    Cc: stable@vger.kernel.org
    Reported-by: Orange Kao <orange@aiven.io>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f9a402c04666..e624a919fe55 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1460,7 +1460,8 @@ static void setup_split_accounting(struct clone_info *ci, unsigned len)
 }
 
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
-				struct dm_target *ti, unsigned num_bios)
+				struct dm_target *ti, unsigned num_bios,
+				unsigned *len)
 {
 	struct bio *bio;
 	int try;
@@ -1471,7 +1472,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 		if (try)
 			mutex_lock(&ci->io->md->table_devices_lock);
 		for (bio_nr = 0; bio_nr < num_bios; bio_nr++) {
-			bio = alloc_tio(ci, ti, bio_nr, NULL,
+			bio = alloc_tio(ci, ti, bio_nr, len,
 					try ? GFP_NOIO : GFP_NOWAIT);
 			if (!bio)
 				break;
@@ -1507,7 +1508,7 @@ static int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 		break;
 	default:
 		/* dm_accept_partial_bio() is not supported with shared tio->len_ptr */
-		alloc_multiple_bios(&blist, ci, ti, num_bios);
+		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 		while ((clone = bio_list_pop(&blist))) {
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
 			__map_bio(clone);
-- 
2.30.0

