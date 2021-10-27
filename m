Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D065743CDD0
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhJ0Pm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 11:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbhJ0Pm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 11:42:58 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C343C061745
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 08:40:33 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o14so4839729wra.12
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 08:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HBxWl6LYwGRb58E32zkzz9VwsP7mpm0V9udu0IwC1Fg=;
        b=jL5a+GVB71vvVgDaoqq0O3sdAkGtxotDiHj2DcxTKz+UBbg18PfkZuaYdkfCq3yHuK
         FOUI3LBsJ4h0He919zrbPWSpO+VHxkTbd57Q7pan6efUDHP0b00h0Gp+Hq+7eZkEwmJ2
         0Jm5RlR3xHEqzJ7qpW+CzyoubF7x3r1/J4Q3wUau8YNYmMaQVm/i9ZnQLV+5m0ASzhEa
         2O33nRLTuzBM9MdqiRL03e5XmS5cZWQXWbDnzXiranSlKXGnALowb+85e8m6E9U2wN0/
         h1HVYoJ7FpzjZcWny7pN5MHOjbotE/8YwKpk2nabeh/PJJHmsj37ncRvYvCKpBIoVN5D
         yhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HBxWl6LYwGRb58E32zkzz9VwsP7mpm0V9udu0IwC1Fg=;
        b=uf+4DoYoAI/lLR8ufD21eXJSeWY/EA2zo2mRL13UiDraV79CBiJCDCwsaqsRuaLcsI
         ACg58bW5UPEnJdoWMh1EZCi5yoBzh+8UxdVWAou52wyC2JLT/WakEX2YZyr+i64H37+v
         adGNZxNlEWfunGR2IxL3ZVDGbg9Nth5plYzq8g6mgKbaHN1XOM1SGff4GSrAKsMC0mN5
         pgjvAMS1TSRKoFnq+ia/by6a+WRvrDhRQRSqIjH1qIfKK7UDsFCRh7HZDd46R18fDxNc
         +0vu2u4W4cSlFzfvzalkENrthGjzwm7+dukMB/dCMcIHKR0wjJdz5tZtISgD1mNpNzzb
         /ILQ==
X-Gm-Message-State: AOAM532qMmSzXczwM4IcsoLutnpno7NZqIhRdfU6nwvwxW1ETRlO8qT4
        bM5wMn8poCndDUfapJvuSyuerU++S2Tjeg==
X-Google-Smtp-Source: ABdhPJxVfn1nrtEZjB8RMH1aVl7G12bbc2Edm5bxAXZUBE9cEHMMpz5u8i4eDDmNdpOFaB+m0RbDoQ==
X-Received: by 2002:a5d:64ed:: with SMTP id g13mr31060743wri.87.1635349231366;
        Wed, 27 Oct 2021 08:40:31 -0700 (PDT)
Received: from localhost.localdomain ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id u16sm3674284wmc.21.2021.10.27.08.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:40:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        xiaoguang.wang@linux.alibaba.com
Cc:     io-uring@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v5.10.y 1/1] io_uring: don't take uring_lock during iowq cancel
Date:   Wed, 27 Oct 2021 15:08:02 +0100
Message-Id: <20211027140802.1892780-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 792bb6eb862333658bf1bd2260133f0507e2da8d ]

[   97.866748] a.out/2890 is trying to acquire lock:
[   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
io_wq_submit_work+0x155/0x240
[   97.869735]
[   97.869735] but task is already holding lock:
[   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.873074]
[   97.873074] other info that might help us debug this:
[   97.874520]  Possible unsafe locking scenario:
[   97.874520]
[   97.875845]        CPU0
[   97.876440]        ----
[   97.877048]   lock(&ctx->uring_lock);
[   97.877961]   lock(&ctx->uring_lock);
[   97.878881]
[   97.878881]  *** DEADLOCK ***
[   97.878881]
[   97.880341]  May be due to missing lock nesting notation
[   97.880341]
[   97.881952] 1 lock held by a.out/2890:
[   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.885108]
[   97.885108] stack backtrace:
[   97.890457] Call Trace:
[   97.891121]  dump_stack+0xac/0xe3
[   97.891972]  __lock_acquire+0xab6/0x13a0
[   97.892940]  lock_acquire+0x2c3/0x390
[   97.894894]  __mutex_lock+0xae/0x9f0
[   97.901101]  io_wq_submit_work+0x155/0x240
[   97.902112]  io_wq_cancel_cb+0x162/0x490
[   97.904126]  io_async_find_and_cancel+0x3b/0x140
[   97.905247]  io_issue_sqe+0x86d/0x13e0
[   97.909122]  __io_queue_sqe+0x10b/0x550
[   97.913971]  io_queue_sqe+0x235/0x470
[   97.914894]  io_submit_sqes+0xcce/0xf10
[   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
[   97.921424]  do_syscall_64+0x2d/0x40
[   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

While holding uring_lock, e.g. from inline execution, async cancel
request may attempt cancellations through io_wq_submit_work, which may
try to grab a lock. Delay it to task_work, so we do it from a clean
context and don't have to worry about locking.

Cc: <stable@vger.kernel.org> # 5.5+
Fixes: c07e6719511e ("io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()")
Reported-by: Abaci <abaci@linux.alibaba.com>
Reported-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Lee: The first hunk solves a different (double free) issue in v5.10.
      Only the first hunk of the original patch is relevant to v5.10 AND
      the first hunk of the original patch is only relevant to v5.10]
Reported-by: syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26753d0cb4312..361f8ae96c36f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2075,7 +2075,9 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
+	mutex_lock(&ctx->uring_lock);
 	__io_req_task_cancel(req, -ECANCELED);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.33.0.1079.g6e70778dc9-goog

