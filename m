Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C789774CB8
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 13:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403869AbfGYLRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 07:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403849AbfGYLRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364DD2238C;
        Thu, 25 Jul 2019 11:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053456;
        bh=fEERm1Ewd7b82swCQZo2RLPPIYZG6f/Jt6BrmmRrpWk=;
        h=Subject:To:From:Date:From;
        b=tWY/V9xLgzIbbKPAZIOPgoGjrNnCI+J1tR7d4Dulpjl0m66RHoZzkHqXo8S56cSEM
         lviL3ROqHrqUqDq+H/7RgnfQvi/u+ADbGK7nqkYMZ5CciEmqBzq4DwIe291BQL3msc
         aLqC9XVRKfYywCIpmYbyqLyvoAuz7JE443nkIyQE=
Subject: patch "staging: android: ion: Bail out upon SIGKILL when allocating memory." added to staging-linus
To:     penguin-kernel@I-love.SAKURA.ne.jp, gregkh@linuxfoundation.org,
        labbott@redhat.com, stable@vger.kernel.org,
        sumit.semwal@linaro.org,
        syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 13:17:34 +0200
Message-ID: <1564053454143101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: android: ion: Bail out upon SIGKILL when allocating memory.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8f9e86ee795971eabbf372e6d804d6b8578287a7 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 1 Jul 2019 19:55:19 +0900
Subject: staging: android: ion: Bail out upon SIGKILL when allocating memory.

syzbot found that a thread can stall for minutes inside
ion_system_heap_allocate() after that thread was killed by SIGKILL [1].
Let's check for SIGKILL before doing memory allocation.

[1] https://syzkaller.appspot.com/bug?id=a0e3436829698d5824231251fad9d8e998f94f5e

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot <syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com>
Acked-by: Laura Abbott <labbott@redhat.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://lore.kernel.org/r/d088f188-5f32-d8fc-b9a0-0b404f7501cc@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/android/ion/ion_page_pool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index fd4995fb676e..f85ec5b16b65 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -8,11 +8,14 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
+#include <linux/sched/signal.h>
 
 #include "ion.h"
 
 static inline struct page *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 {
+	if (fatal_signal_pending(current))
+		return NULL;
 	return alloc_pages(pool->gfp_mask, pool->order);
 }
 
-- 
2.22.0


