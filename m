Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE55B7ECB
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 04:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiINCAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 22:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiINCAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 22:00:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6383130F7D
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 19:00:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 184-20020a2507c1000000b00696056767cfso11785386ybh.22
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 19:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date;
        bh=p6qCghWQbcRewzTnBFceTKv/Y60AI2F5NEC8++qJ2MI=;
        b=FZxg7ZQVvBz9WmQks3L0S9UYycRMX6FNxeIoQWOixAv/JrYVUeom0YA+u4RqWdG96c
         UwdDLEZHnTU9I9fz0Z4OhTcqYz8IgZPUx6E7lVUPz12DOMT5Zcg2kV0JLqQRW/Cp6/qK
         X48Ieg6gkbDHfOqruPwUwzv/U/9v40R+iLCA+WAA6lhXI7bkNeyefyLGfffTwIcxRSCL
         wQ6N8BDNCkqqQGI3bgOhAVcQHeGXF0u6Q97uk9y2UnlTFRG+43WFmAJpo2znrD/CzVAQ
         hMun9nt9+jT4b7CdL/NtNJjSBK+19f/WqTZqzIlXWaWjGWXvHNqCFIFKmH/pwWgkPEbn
         A7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=p6qCghWQbcRewzTnBFceTKv/Y60AI2F5NEC8++qJ2MI=;
        b=pPC+2ZvO8J8q+r3kqp6llMabJslwE82d5PNrizxpr/eyT3AfQNE3vFQJOyDxtvYp94
         Y8L5Ssw6Ih+ng3uVzEpB86pzaOoUlBlDp+2H5Si09eGxNloe16ySBJ5juHOyQrwMnfdm
         KjEpZ3YUdAZfxMrAufq/JzWmlsr+jkp1p++ONn/benFOhmMc3eHPhausEw46RbMVRCNn
         r27EIQRIeYCRzqNyLQPdXxFyrxBIndBfWF9ykNsos9IhLs5lpXuWdfxZMRwnp5Cor5WB
         KahR8zh7IC8NtiBtug2xROzxqcaalNzxTQyWGCFdlT1RZ32/Z/ZAc1NNWKh+TYc8f3Oz
         j+vw==
X-Gm-Message-State: ACgBeo0mrRdcbG0PfOYid/nKXY+cNou4b88ZvLhq1KS0Xxl9b8+j8Mhx
        mbVtz6EwSqkZnxKz4CECWN1ht9U=
X-Google-Smtp-Source: AA6agR4W0NwqBv0embkoehNEbFKrl95x/EFmpO/GESuyJ3JThH+BHAW+2aaI7Tl4bgr20j3mzjFMNac=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:370d:f9c3:6198:7768])
 (user=pcc job=sendgmr) by 2002:a25:2687:0:b0:6a8:e551:b9d8 with SMTP id
 m129-20020a252687000000b006a8e551b9d8mr29117452ybm.472.1663120812652; Tue, 13
 Sep 2022 19:00:12 -0700 (PDT)
Date:   Tue, 13 Sep 2022 19:00:01 -0700
Message-Id: <20220914020001.2846018-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Subject: [PATCH] kasan: call kasan_malloc() from __kmalloc_*track_caller()
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Peter Collingbourne <pcc@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We were failing to call kasan_malloc() from __kmalloc_*track_caller()
which was causing us to sometimes fail to produce KASAN error reports
for allocations made using e.g. devm_kcalloc(), as the KASAN poison was
not being initialized. Fix it.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: <stable@vger.kernel.org> # 5.15
---
The same problem is being fixed upstream in:
https://lore.kernel.org/all/20220817101826.236819-6-42.hyeyoo@gmail.com/
as part of a larger patch series, but this more targeted fix seems
more suitable for the stable kernel. Hyeonggon, maybe you can add
this patch to the start of your series and it can be picked up
by the stable maintainers.

 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 862dbd9af4f5..875c569c5cbe 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4926,6 +4926,8 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	/* Honor the call site pointer we received. */
 	trace_kmalloc(caller, ret, s, size, s->size, gfpflags);
 
+	ret = kasan_kmalloc(s, ret, size, gfpflags);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
@@ -4957,6 +4959,8 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	/* Honor the call site pointer we received. */
 	trace_kmalloc_node(caller, ret, s, size, s->size, gfpflags, node);
 
+	ret = kasan_kmalloc(s, ret, size, gfpflags);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
-- 
2.37.2.789.g6183377224-goog

