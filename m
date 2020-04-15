Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB841AA2F1
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505708AbgDONC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503388AbgDONA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:00:28 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E718C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:26 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id 11so4216803wrc.3
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6dS7YFaNPVPQKiQTYXtftCIcdnxway/D2heEGZex2n4=;
        b=GN3YMppv4e2al3zjUTr+B494gjHY8AbNfC4yFnqM+IKrsTqmEQoGTlsPBFK9u4P0gY
         pQ3NWmfO/m2YJanFLrehvAYntmZOBaXQbseZRvBihGDHkhWzIOrshsrz7FLLiQQmPVYK
         81Qkq3fb/YUAGvp1bSyzuW6EKJu2a0l3ah8QGH80d4rD+eZLubSQ6pLYyq1sUGV3uUtH
         b5wztccg3q0vKLO8q9AGsjeFTlIVar6Dfdea7YMiJtJifXnnZ6uQaEnO+aX4x2kCS08H
         zQ12IVyL8PfaxrWCodXPdypRHVDSrcZCNUXEkSpSasUobmcthDiVMU6/Afy0+hR8SMOX
         nMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6dS7YFaNPVPQKiQTYXtftCIcdnxway/D2heEGZex2n4=;
        b=W5w41BtrCPZFz6xNMajqqHKYx5dYcmxsXr/nWoJRrHgmerFRcZ9JKO1+BKdfm2Pc3D
         64W1hqE9WgWZouUcw4wiKlwyI5E0I0LQrnHGYm2qWQszxuf2L4WCbwc2WHOgxS4WC9Cq
         VJOhZQOST/GayzPlDXVPg0qVam9ti9aI9PrM301f6Vg9BxzSXfLMqc+htYTXjl2Etd6X
         n73G70ABYAJejm2p1ljovz2zfOU3HoBQB0ha6y1D77gOifHCxk3QIfjRUZkUjh2nN4uv
         pwAEZRAdHktf/aLmJxDUFtCgJmlFKbPPnTDkaxQuOJ19taEgLQD3P8bzxhjKDC5q9sel
         76EQ==
X-Gm-Message-State: AGi0PuZOxH5YtWgrv5zu7B3Z9vZCoKO8a6F6ZfHMxoV9g1EkHPfWrcdx
        QF4ulvgCUwUmxMSa1quuFfZyydffxlO0Sw==
X-Google-Smtp-Source: APiQypL5d4zqXS4c2D+114mhbGXZy+tt6OxfrzL5Sp/fDmKPiwlPrV4hd6aFvaNqySeGNC7HFWGni4UuTUbi5A==
X-Received: by 2002:adf:afdf:: with SMTP id y31mr28405625wrd.120.1586955624620;
 Wed, 15 Apr 2020 06:00:24 -0700 (PDT)
Date:   Wed, 15 Apr 2020 14:00:14 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200415130017.244979-2-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v2 1/4] block: more locking around delayed work
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     Giuliano Procida <gprocida@google.com>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.

block: defer timeouts to a workqueue

Timer context is not very useful for drivers to perform any meaningful abort
action from.  So instead of calling the driver from this useless context
defer it to a workqueue as soon as possible.

Note that while a delayed_work item would seem the right thing here I didn't
dare to use it due to the magic in blk_add_timer that pokes deep into timer
internals.  But maybe this encourages Tejun to add a sensible API for that to
the workqueue API and we'll all be fine in the end :)

Contains a major update from Keith Bush:

"This patch removes synchronizing the timeout work so that the timer can
 start a freeze on its own queue. The timer enters the queue, so timer
 context can only start a freeze, but not wait for frozen."

NOTE: Back-ported to 4.4.y.

The only parts of the upstream commit that have been kept are various
locking changes, none of which were mentioned in the original commit
message which therefore describes this change not at all.

Timeout callbacks continue to be run via a timer. Both blk_mq_rq_timer
and blk_rq_timed_out_timer will return without without doing any work
if they cannot acquire the queue (without waiting).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 block/blk-mq.c      | 4 ++++
 block/blk-timeout.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8649dbf06ce4..11a23bf73fd9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -628,6 +628,9 @@ static void blk_mq_rq_timer(unsigned long priv)
 	};
 	int i;
 
+	if (blk_queue_enter(q, GFP_NOWAIT))
+		return;
+
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &data);
 
 	if (data.next_set) {
@@ -642,6 +645,7 @@ static void blk_mq_rq_timer(unsigned long priv)
 				blk_mq_tag_idle(hctx);
 		}
 	}
+	blk_queue_exit(q);
 }
 
 /*
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index aa40aa93381b..2bc03df554a6 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -134,6 +134,8 @@ void blk_rq_timed_out_timer(unsigned long data)
 	struct request *rq, *tmp;
 	int next_set = 0;
 
+	if (blk_queue_enter(q, GFP_NOWAIT))
+		return;
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	list_for_each_entry_safe(rq, tmp, &q->timeout_list, timeout_list)
@@ -143,6 +145,7 @@ void blk_rq_timed_out_timer(unsigned long data)
 		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_queue_exit(q);
 }
 
 /**
-- 
2.26.0.110.g2183baf09c-goog

