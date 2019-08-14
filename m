Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9563E8D97F
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfHNRJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730257AbfHNRJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A72208C2;
        Wed, 14 Aug 2019 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802541;
        bh=YEuwsiOPbmEY4UEHEL+C4JDBIzmOVxcNTaAVUFAyJ+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GISj+ZyX8rBeh4zgvNQcFbzP5fd9sID46mXQUoInKyqgVkBcSMyRrUlyeKH+zTwEA
         Bd21PmQTn5aS/s7WtaenzxuzWghMrZz6EvwJwe+k69yp2FoM2MuSaEkKB/oqlqvpsl
         VIvCYobw6I7CFWCcr9i51MAPfsm4QL8GWN/X0qPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com>,
        Laura Abbott <labbott@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 4.19 04/91] staging: android: ion: Bail out upon SIGKILL when allocating memory.
Date:   Wed, 14 Aug 2019 19:00:27 +0200
Message-Id: <20190814165749.236426007@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 8f9e86ee795971eabbf372e6d804d6b8578287a7 upstream.

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
 drivers/staging/android/ion/ion_page_pool.c |    3 +++
 1 file changed, 3 insertions(+)

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
 


