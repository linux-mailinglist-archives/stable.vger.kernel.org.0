Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491B927B0EC
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgI1P3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgI1P3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 11:29:44 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C948C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 08:29:44 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d20so1312033qka.5
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mmkQYmsCDPCGs+CK0fD1Ix3fiRZzHeYiHALFqJNTVoQ=;
        b=tmR+ejSkNup4ELfTutY1UAS/C14zmWeNvohqVT1t6hPqpLzkAJCf/uIuy3iiYDXrm+
         r7CibwegiaK1bCTiHQuYw3GXH4gRQY84pYkwpV5B+UlICwyYvdZ9epx546jo5Tg4aKIc
         JwrrVLvDDjZaDpvacrCuWIWIOoKP8k1HBqR7tmNQrtVliBoih2N+5dNmJ96Q8ed1vgYN
         fvwL396kiykPAapu+aAB+/4lsUALYtlxQDI9umiERPUbPLUmCd+bbhrjPjamz1SvIIbU
         ML34Gqoi587meadpOgHV2FP1waUi+79cHx3I6QyoHWUgdkx2rBUe0BP30wnZCS0Uj3TZ
         cy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mmkQYmsCDPCGs+CK0fD1Ix3fiRZzHeYiHALFqJNTVoQ=;
        b=Zhb7MYR+oBIoyn8tja9pe87dbWj1aSVul54FVzlVeJIfWoi14nbPOhNsjUlw3OUvvQ
         t0oNtiq+dIZtihu7GIfQtcLh1NBRoilOm212CJysuCXM50W+Lpu2h00MxMycuIAZf5x0
         MhHLhKHBhDhphl07K1dEsObSt3SqxSIdFrnASyNgYDAqQGjCw/wprSWOMvQE0rJbNZ2b
         JFSTJzF49wxnP7VYU6IOs/YjCU4OPpRJnTbpgowyuFEPC3OObYcXf2ELoCxhuFxhT7XB
         0kFI5RaRUkrst7bDTNxOGfz2RDD2sk9G8tKlxKaZXrxDsKvFMfu7VxVbNuahnLJTQOek
         K1NQ==
X-Gm-Message-State: AOAM533OZkWz4HC2D1iBQJE9hcmKFiffS2cB7SqMlUJB3vzR9iBQ9tq1
        Jiv6Vg1VX8ushFF80RZ8Y38=
X-Google-Smtp-Source: ABdhPJw/bYSavbEjIwNjCxaJX8WlkRU91hHsy8Djfz8d0+rE2Iu9aHX3R+XEOFYhhsZDM/XF8y9LeA==
X-Received: by 2002:a05:620a:222:: with SMTP id u2mr3745qkm.218.1601306983646;
        Mon, 28 Sep 2020 08:29:43 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m67sm1182183qkf.98.2020.09.28.08.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 08:29:42 -0700 (PDT)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Mon, 28 Sep 2020 11:29:41 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     ming.lei@redhat.com, stable@vger.kernel.org
Subject: [PATCH 5.4, 5.8] dm: fix bio splitting and its bio completion order
 for regular IO
Message-ID: <20200928152941.GA66303@lobo>
References: <1601301410240130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601301410240130@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This backport applies (with mild offset) to both v5.4.67 and v5.8.11:

From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 14 Sep 2020 13:04:19 -0400
Subject: [PATCH] dm: fix bio splitting and its bio completion order for regular IO

dm_queue_split() is removed because __split_and_process_bio() _must_
handle splitting bios to ensure proper bio submission and completion
ordering as a bio is split.

Otherwise, multiple recursive calls to ->submit_bio will cause multiple
split bios to be allocated from the same ->bio_split mempool at the same
time. This would result in deadlock in low memory conditions because no
progress could be made (only one bio is available in ->bio_split
mempool).

This fix has been verified to still fix the loss of performance, due
to excess splitting, that commit 120c9257f5f1 provided.

Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

--- a/drivers/md/dm.c	2020-09-21 18:46:16.000000000 -0400
+++ b/drivers/md/dm.c	2020-09-21 18:33:21.000000000 -0400
@@ -1727,23 +1727,6 @@
 	return ret;
 }
 
-static void dm_queue_split(struct mapped_device *md, struct dm_target *ti, struct bio **bio)
-{
-	unsigned len, sector_count;
-
-	sector_count = bio_sectors(*bio);
-	len = min_t(sector_t, max_io_len((*bio)->bi_iter.bi_sector, ti), sector_count);
-
-	if (sector_count > len) {
-		struct bio *split = bio_split(*bio, len, GFP_NOIO, &md->queue->bio_split);
-
-		bio_chain(split, *bio);
-		trace_block_split(md->queue, split, (*bio)->bi_iter.bi_sector);
-		generic_make_request(*bio);
-		*bio = split;
-	}
-}
-
 static blk_qc_t dm_process_bio(struct mapped_device *md,
 			       struct dm_table *map, struct bio *bio)
 {
@@ -1773,14 +1756,12 @@
 	if (current->bio_list) {
 		if (is_abnormal_io(bio))
 			blk_queue_split(md->queue, &bio);
-		else
-			dm_queue_split(md, ti, &bio);
+		/* regular IO is split by __split_and_process_bio */
 	}
 
 	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
 		return __process_bio(md, map, bio, ti);
-	else
-		return __split_and_process_bio(md, map, bio);
+	return __split_and_process_bio(md, map, bio);
 }
 
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
