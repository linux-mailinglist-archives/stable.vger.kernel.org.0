Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0EE79C53
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 00:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfG2WQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 18:16:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46063 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfG2WQU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 18:16:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so28921962pgp.12
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYK7OhY4Zs3xEZ3rD2sAHSi4xgYu3lqni8LNbwDhtKA=;
        b=YB4YUwXyAaJ50+M7syE0Q4lgd+aJqSKTnUaCXTYF6UidYNiOj8TLOqoPs6e3uO3YjI
         jFeoBQHavH7cJ2LgKOCwQNWhQ5oWgr9maUjmmb+CpN87lkLGpilBgKEv5iJzO8Fipjj1
         VPOCfP3g77t8ByA+fjKHyIbXvppVz7jlDhfkeAzm/LFBIa8/5j6sKKC2zojf/Ox8/cUQ
         QpHQlvRWzT4WOcze51+tohdzGCOR0MRdJ5tCWXD1ijCc5pzwDiQ3JbXS5p4LKaB1qq53
         xJsKhu7sLNkr0PIxbZJp55sEnuaabVHtmHMYPZLHlqBd5rxOuWwPKcBuNH4UN3p1zCAA
         Tw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYK7OhY4Zs3xEZ3rD2sAHSi4xgYu3lqni8LNbwDhtKA=;
        b=lmMmoPyRz4B5pKuR50jVHsQq5FY7RLzVzL0gCzFmXWT4UuuwodNUzOpqWY+2muaed6
         Zn9qXlQvPZsIlUMs7AWDYMbqeLCfPXK+0N/kamYmzErI5WdATwPcaQaAzayrqUPiul3i
         GwKpRQn2uee2kPpvgN4VEE2Btv7c+41+2ucdygShf70VlfwthtUKCXIp8m2+uSGvkkNE
         sQw3kRDla4Mw0oefGAUfxVz57iw9xabawK7FBem3tJuQo1WpvdS7VEUxQzvfV6bmHccE
         MFilws8/Glw+wzrn7Q5LzIgvwHrWlmlaw1o1DD5NeNgVVqDrdns4fT6uNy8l0TX/7JeH
         KauQ==
X-Gm-Message-State: APjAAAU8SxiJW9Lkg1OF2ieZA90mRie+2JZgk5dUcGNv9Y6Qv+OWO4ws
        nWi/JA5eqOSq+mknUK9qY6k=
X-Google-Smtp-Source: APXvYqxFy/r3gUtE9Br/3RiI2lkMxMaKMK/cS/GEPfggKg1YrnVSQ12+QnRB5DJbaJXjUBemSY3uow==
X-Received: by 2002:a17:90a:35e6:: with SMTP id r93mr114645865pjb.20.1564438579714;
        Mon, 29 Jul 2019 15:16:19 -0700 (PDT)
Received: from ava-linux2.mtv.corp.google.com ([2620:15c:211:0:b2de:593e:a6f0:9b20])
        by smtp.googlemail.com with ESMTPSA id o3sm116637836pje.1.2019.07.29.15.16.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 15:16:18 -0700 (PDT)
From:   Todd Kjos <tkjos@android.com>
X-Google-Original-From: Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, gregkh@linuxfoundation.org, arve@android.com,
        maco@google.com, stable@vger.kernel.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Todd Kjos <tkjos@android.com>
Subject: [PATCH 4.14,4.19] binder: fix possible UAF when freeing buffer
Date:   Mon, 29 Jul 2019 15:16:06 -0700
Message-Id: <20190729221606.243098-1-tkjos@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit a370003cc301d4361bae20c9ef615f89bf8d1e8a upstream

There is a race between the binder driver cleaning
up a completed transaction via binder_free_transaction()
and a user calling binder_ioctl(BC_FREE_BUFFER) to
release a buffer. It doesn't matter which is first but
they need to be protected against running concurrently
which can result in a UAF.

Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org> # 4.14 4.19
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 5d67f5fec6c1b..2decb1a5a8e2f 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1960,8 +1960,18 @@ static struct binder_thread *binder_get_txn_from_and_acq_inner(
 
 static void binder_free_transaction(struct binder_transaction *t)
 {
-	if (t->buffer)
-		t->buffer->transaction = NULL;
+	struct binder_proc *target_proc = t->to_proc;
+
+	if (target_proc) {
+		binder_inner_proc_lock(target_proc);
+		if (t->buffer)
+			t->buffer->transaction = NULL;
+		binder_inner_proc_unlock(target_proc);
+	}
+	/*
+	 * If the transaction has no target_proc, then
+	 * t->buffer->transaction has already been cleared.
+	 */
 	kfree(t);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION);
 }
@@ -3484,10 +3494,12 @@ static int binder_thread_write(struct binder_proc *proc,
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
 
+			binder_inner_proc_lock(proc);
 			if (buffer->transaction) {
 				buffer->transaction->buffer = NULL;
 				buffer->transaction = NULL;
 			}
+			binder_inner_proc_unlock(proc);
 			if (buffer->async_transaction && buffer->target_node) {
 				struct binder_node *buf_node;
 				struct binder_work *w;
-- 
2.22.0.709.g102302147b-goog

