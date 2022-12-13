Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358FB64B3AD
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 12:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiLMLCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 06:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiLMLCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 06:02:38 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551AAE7
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 03:02:36 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 203-20020a2502d4000000b006f94ab02400so16142370ybc.2
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 03:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4JMvBjbL8ghtbIkTF27GYLcaRjqPRshuRydk2R7O6LM=;
        b=BBpecZ+hl6A31P+Glt7N5JCChpXRVKhc0Rj3aR1kDPxQ/7mdNIfdb2qf6DyPXzRuLv
         OVzy9b/YlGRSVvVtD8jhFlSmZqqMRcrKJE29Wk1Oa6tP+U6jFug/bx9V3KbZprIvLqgV
         1Xt66zASQpZGLEN3xIxOGqtezDjlNxNeQEWUAqfwhy27PqxXi1FmmdgEcu7/yLnc1/pD
         9GAj4L/zYLHyBDfgsdu9hNe9BPESLOC0zkIwrEW6jMH7DpA7xzVuPQlLsZ1d6l1Ythgs
         dWjZQ4c/sKQq1yeBiJyuavhHqX3YSdsZSRAkWsgGgatLgELChwRtm2ij+JTaBQ7o4gAS
         s34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4JMvBjbL8ghtbIkTF27GYLcaRjqPRshuRydk2R7O6LM=;
        b=TE87k50qn6OT7b610Df21OaPXtS002mrff17iyT7ldj9mQ/ligSRLn+Zfe7hr5swY+
         dqwaHBJxoY/w2758CZ1pBmK4mcUk75XB91ywRz7lr2yJdJZ9u2uEdHRnSM94aJvc8zgD
         Pe03P41iR6hhQee8P7yQ3jbFUO94MeSPCKpllZJ4K4eC7XiXmulerrHTJ4SOv1Oj+2ea
         RjcnfxilVnMFr99mYzHHulq5wCYV2NT2Xuc+escqg0lIPpsJJJ/tq7CKYOvUWnJ8/YJQ
         YSN5vFuW7jkUPD7ztB/23T7pIVGYSRFJkbTYmYs5nMkIrzm94ryJCcvO7agROLeNAHhw
         XpjA==
X-Gm-Message-State: ANoB5plMSajNozdK8HInAlOSwwYjHzwHzcV3Gi7KRd9EnW8eJBr0IBzG
        sQNmc1Nr9JKlqL/RT1LQ7y3MQHodyTFr
X-Google-Smtp-Source: AA0mqf53Mpz9RgPooN6uE2NxcqbDKHcmkOgPxhuo3yY6e0bzc01QjtHXRb//lhvqf40SZzr23gw3Gy79cHqF
X-Received: from localhost ([2a00:79e0:9d:6:a3d1:f0b2:7818:34be])
 (user=wiktorg job=sendgmr) by 2002:a05:6902:703:b0:727:1318:3c5 with SMTP id
 k3-20020a056902070300b00727131803c5mr945525ybt.496.1670929355637; Tue, 13 Dec
 2022 03:02:35 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:02:12 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213110212.649796-1-wiktorg@google.com>
Subject: [PATCH] pipe: avoid creating empty pipe buffers
From:   Wiktor Garbacz <wiktorg@google.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wiktor Garbacz <wiktorg@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pipe_write cannot be called on notification pipes so
post_one_notification cannot race it.
Locking and second pipe_full check are thus redundant.

This fixes an issue where pipe write could unexpectedly block:
  // Assume there is no reader or reader polls and uses FIONREAD ioctl
  // to read all the available bytes.
  for (int i = 0; i < PIPE_DEF_BUFFERS+1; ++i) {
    write(pipe_fd, buf_that_efaults, PAGE_SIZE);
  }
  // Never reached

Fixes: a194dfe6e6f6 ("pipe: Rearrange sequence in pipe_write() to preallocate slot")
Cc: stable@vger.kernel.org
Signed-off-by: Wiktor Garbacz <wiktorg@google.com>
---
 fs/pipe.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 42c7ff41c2db..87356a2823cf 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -501,43 +501,26 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 				pipe->tmp_page = page;
 			}
 
-			/* Allocate a slot in the ring in advance and attach an
-			 * empty buffer.  If we fault or otherwise fail to use
-			 * it, either the reader will consume it or it'll still
-			 * be there for the next write.
-			 */
-			spin_lock_irq(&pipe->rd_wait.lock);
-
-			head = pipe->head;
-			if (pipe_full(head, pipe->tail, pipe->max_usage)) {
-				spin_unlock_irq(&pipe->rd_wait.lock);
-				continue;
+			copied = copy_page_from_iter(page, 0, PAGE_SIZE, from);
+			if (unlikely(copied < PAGE_SIZE && iov_iter_count(from))) {
+				if (!ret)
+					ret = -EFAULT;
+				break;
 			}
-
-			pipe->head = head + 1;
-			spin_unlock_irq(&pipe->rd_wait.lock);
+			ret += copied;
 
 			/* Insert it into the buffer array */
-			buf = &pipe->bufs[head & mask];
 			buf->page = page;
 			buf->ops = &anon_pipe_buf_ops;
 			buf->offset = 0;
-			buf->len = 0;
+			buf->len = copied;
 			if (is_packetized(filp))
 				buf->flags = PIPE_BUF_FLAG_PACKET;
 			else
 				buf->flags = PIPE_BUF_FLAG_CAN_MERGE;
 			pipe->tmp_page = NULL;
-
-			copied = copy_page_from_iter(page, 0, PAGE_SIZE, from);
-			if (unlikely(copied < PAGE_SIZE && iov_iter_count(from))) {
-				if (!ret)
-					ret = -EFAULT;
-				break;
-			}
-			ret += copied;
-			buf->offset = 0;
-			buf->len = copied;
+			head++;
+			pipe->head = head;
 
 			if (!iov_iter_count(from))
 				break;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

