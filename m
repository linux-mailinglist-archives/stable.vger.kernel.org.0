Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578FD30DAFA
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhBCNVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhBCNVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:07 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BDFC0613ED
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:26 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c12so24266105wrc.7
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfO/909mdUaRpv6ekeQ5pLoyeo6G7O5g5UYJLsEOL80=;
        b=gsVKCsbnjeaznli0xpdvVmzAqPGuh4XLY8ewqDtW9H0ByfqTqUzh94eZc1D8KKY1hq
         nX1zLzSXvYGlO1euxs91gXIFAyrpG82Ng+uSgqKKYeAMyrb65lk/IhHq4fMt2N5BOUiH
         La9YTIjrJEUf0dG0qVXKD2SzSdJ+h+PYZhlciS0a0yhc27Vko3fmOY3HFHrfoa90khPG
         qgvyraEXz7tJwlOD2sDOTQHl9VldLPQkNWwE1wbaiDLNRAsHFWBN6xKSnek5OZDtew/N
         b+QlcNTvcAU1sGbwt4jx5aovfvSMQ54yUgTAGO6dbbkEHlxFilUcFEU60Jns5irp2IMB
         DxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfO/909mdUaRpv6ekeQ5pLoyeo6G7O5g5UYJLsEOL80=;
        b=T/l+rzA7CA4sP1dU9KPPGwnB828kRQAJetYYwNk32kcO1Sq/aYwD5CRN+tiQ24iAKg
         tCJhkHOdEbOoujHZFtc1usYihzTkRhen4QxwjNVlWVfTexvq9Sx7T24/z5SK13+k0FE/
         FsAg/QwVd8zJ5jQVDjDHGDzpIjsOr4IT4YToeLPx7MT5pNfUTnTO18ltHjaqJW7iipbu
         Rpwlst3/TAFS3SFWnaiI7IUNeqCe6CTwi+yT1E/BXlFbbkcy52JP9r1XeemBuoVzfWSG
         wb6D9yy9SZKLwj7Te4CDOIWPQrT+qoNFOcytn0y6FA7biecUXRlJKX4x3INy9AGuTxuZ
         Sqqw==
X-Gm-Message-State: AOAM5303WZpn6nZ6JAI71h/XwGYK7dB/1RKR0ixRuTZOPW5XaRqGevwZ
        I4Fn6bhMN7o0IUjEvZ5GDmdYYQ==
X-Google-Smtp-Source: ABdhPJy0UOU3brOw2FrfNueaOntHlnbvuoV2ZynvOsSmdEWrTFHUMK2jqRW0vTVx8x4J4DzY39nPuQ==
X-Received: by 2002:adf:c64f:: with SMTP id u15mr3391897wrg.270.1612358425343;
        Wed, 03 Feb 2021 05:20:25 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:24 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 2/8] block: don't hold q->sysfs_lock in elevator_init_mq
Date:   Wed,  3 Feb 2021 14:20:16 +0100
Message-Id: <20210203132022.92406-3-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

The original comment says:

	q->sysfs_lock must be held to provide mutual exclusion between
	elevator_switch() and here.

Which is simply wrong. elevator_init_mq() is only called from
blk_mq_init_allocated_queue, which is always called before the request
queue is registered via blk_register_queue(), for dm-rq or normal rq
based driver. However, queue's kobject is only exposed and added to sysfs
in blk_register_queue(). So there isn't such race between elevator_switch()
and elevator_init_mq().

So avoid to hold q->sysfs_lock in elevator_init_mq().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit c48dac137a62a5d6fa1ef3fa445cbd9c43655a76)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/elevator.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index fae58b2f906f..ddbcd36616a8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -980,23 +980,19 @@ int elevator_init_mq(struct request_queue *q)
 	if (q->nr_hw_queues != 1)
 		return 0;
 
-	/*
-	 * q->sysfs_lock must be held to provide mutual exclusion between
-	 * elevator_switch() and here.
-	 */
-	mutex_lock(&q->sysfs_lock);
+	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
+
 	if (unlikely(q->elevator))
-		goto out_unlock;
+		goto out;
 
 	e = elevator_get(q, "mq-deadline", false);
 	if (!e)
-		goto out_unlock;
+		goto out;
 
 	err = blk_mq_init_sched(q, e);
 	if (err)
 		elevator_put(e);
-out_unlock:
-	mutex_unlock(&q->sysfs_lock);
+out:
 	return err;
 }
 
-- 
2.25.1

