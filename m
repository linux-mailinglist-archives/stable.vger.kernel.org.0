Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01973A6166
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhFNKq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234266AbhFNKou (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:44:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9996C61439;
        Mon, 14 Jun 2021 10:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666983;
        bh=SY/szsUB+ef9QE5b4m2yulKJ1fXnCLSbhSmIaLstYoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lrg2vAPHNOCkpxWvHYAh1K6vQlYc6gcn+jJWX1amYZsQFUxj2tEsQrEroZGDLe5rI
         SdqaHCLQlbeJ3UlAcWldVq5S/iqdU0r2i9wwNm0MdoTnl9avw4EiQo2kaAL7R+VqPz
         mjC6NQ5MwNfSPZ+ZC00o9LEoB1Bn78mh6C5m4oG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+142c9018f5962db69c7e@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 53/67] perf: Fix data race between pin_count increment/decrement
Date:   Mon, 14 Jun 2021 12:27:36 +0200
Message-Id: <20210614102645.564766829@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 6c605f8371159432ec61cbb1488dcf7ad24ad19a upstream.

KCSAN reports a data race between increment and decrement of pin_count:

  write to 0xffff888237c2d4e0 of 4 bytes by task 15740 on cpu 1:
   find_get_context		kernel/events/core.c:4617
   __do_sys_perf_event_open	kernel/events/core.c:12097 [inline]
   __se_sys_perf_event_open	kernel/events/core.c:11933
   ...
  read to 0xffff888237c2d4e0 of 4 bytes by task 15743 on cpu 0:
   perf_unpin_context		kernel/events/core.c:1525 [inline]
   __do_sys_perf_event_open	kernel/events/core.c:12328 [inline]
   __se_sys_perf_event_open	kernel/events/core.c:11933
   ...

Because neither read-modify-write here is atomic, this can lead to one
of the operations being lost, resulting in an inconsistent pin_count.
Fix it by adding the missing locking in the CPU-event case.

Fixes: fe4b04fa31a6 ("perf: Cure task_oncpu_function_call() races")
Reported-by: syzbot+142c9018f5962db69c7e@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210527104711.2671610-1-elver@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4155,7 +4155,9 @@ find_get_context(struct pmu *pmu, struct
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		ctx = &cpuctx->ctx;
 		get_ctx(ctx);
+		raw_spin_lock_irqsave(&ctx->lock, flags);
 		++ctx->pin_count;
+		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 
 		return ctx;
 	}


