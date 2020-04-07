Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D511A1238
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDGQz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:55:57 -0400
Received: from mail-wr1-f73.google.com ([209.85.221.73]:48417 "EHLO
        mail-wr1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgDGQz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:55:57 -0400
Received: by mail-wr1-f73.google.com with SMTP id d1so2278934wru.15
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 09:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ru7N6lVHZUKQwaB/xq7ubldw30kehEeDJ6CHby+S89M=;
        b=v3VF9dQo04jJFUN+jCZ/vzznpa9b6Fv2mogtHhW5CMi8EFqJ6X1St+mQsI4ZSF2Ysr
         zyCdeam5US8QcNcNPOy5iWBjnk8kEl6hE29dDR7fJ7dk0ptHZ97OMGiuv636AOvTGgyP
         FsfcIrh11Jeaa6Tqohjv0A+HQTwL7OWHf2SQ4BBaWF0s/oZQuScjUbIWXLL5ooX+w0TY
         u7oLygF6rtQKVxtAmoGcubHYna9JZ8jHCaxoxFtk2CPENxRwiLHUVt+biuFLkLDdBlCa
         kzVVHGltN8fQ1zH/d4VwbpPR3vHn1eBeFcOR7lF7AjEXY4E2d/ayPh9jNe60oHRV8Lk5
         IzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ru7N6lVHZUKQwaB/xq7ubldw30kehEeDJ6CHby+S89M=;
        b=hyYZCbgm6UBrCoGIzE7pz0krZHD0tZpagajxxgzv8zLeCkLxdEJjzJAreTXKbNQhs1
         tzMOO4DXgG3x+2ohghCyIoozj/x16nL/mhz4dyVw67NCJi4gF4S2UOzLOHWvcIhouK8t
         Xh7mA7s6y+uadEaLsobYvS3rPsYyG1NVRcSeFPjKcAZ1qhxYtQRc1DaFNmB33a+vNBvs
         hErOHvmxrkAC3QiSHmiuQXArSRECdWVPZpdiHy1ILYisTpoM2lbkhGMfYTst+dPKg3Uk
         2YNzA9bG2xt+UYVrsD+osDa4tVnEbj9/fx2um+JuegJFqnoF3tN/DckHS28/9mDeiUKH
         S+rw==
X-Gm-Message-State: AGi0PuZacQF4d2OrcIrF4GToP44OKaugLhcOY5L5A5gZcGPAfCf5/TtM
        fTQAh/zNjCfFQOmm6wtSQGBlTerJf0wnBQ==
X-Google-Smtp-Source: APiQypIOQBIVs5ISnw04Zk9zQBkuGCvCJJiflmTZODlk8ouzHa2Qa2njmzyZ8tiIwf53iS0WoxF1+fZuvI2oKA==
X-Received: by 2002:adf:a34d:: with SMTP id d13mr3629177wrb.389.1586278554723;
 Tue, 07 Apr 2020 09:55:54 -0700 (PDT)
Date:   Tue,  7 Apr 2020 17:55:36 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200407165539.161505-2-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH 1/4] block: more locking around delayed work
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.

The upstream commit (block: defer timeouts to a workqueue) included
various locking changes. The original commit message did not say
anything about the extra locking. Perhaps this is only needed for
workqueue callbacks and not timer callbacks. We assume it is needed
here.

This patch includes the locking changes but leaves timeouts using a
timer.

Both blk_mq_rq_timer and blk_rq_timed_out_timer will return without
without doing any work if they cannot acquire the queue (without
waiting).

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
2.26.0.292.g33ef6b2f38-goog

