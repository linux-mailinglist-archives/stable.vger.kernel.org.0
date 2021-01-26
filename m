Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5468303C81
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392347AbhAZMHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392343AbhAZLW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:58 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095E7C061793
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:09 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id r12so22373720ejb.9
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43tk6v3IVG2/MesRm+z+pQpDZTwX1/vxi63pQJvRipg=;
        b=CQYgS/cvzzkk16lLeYHNEzPzrTPh29AP2JhvgDOTWaR0aFt+yNBYM4uKPu7yusFhBO
         aEVodqe6CzD4LH646HbYc6SP9yqCxYKVmCQPOU+a/S+S91npBw2OVdAS3Jspt2Ggv6Zs
         NPuhDPXjwFFV6qxHG8NL2Guu0aY1l8DtoFpizDC0TUyt+VckqoZ4uaIYwWuvz84A4Idm
         OG2QOR5g2EMXBFrJuNssPdOa2zLtzQB/Q0xwKL4nZylkFEcvamRk66SL5WQ8mLBuiC7R
         sjKYLVLiQOWneCDVE/hwls+y9Be0WG4YTjleiHzzlQKxDvW9hwOvqb2gz9ex/9KZq90A
         8CIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43tk6v3IVG2/MesRm+z+pQpDZTwX1/vxi63pQJvRipg=;
        b=JTJ5GDO358b0In/KX84dim1gC/+AAJ0+aR0lNkVQglLccMq8pzp4bSC1ss8syOjeP5
         Uz+sL2lIl6r+bB3zKiVFkmRECsBjdNhFHiNlkG2RCxaxiQ0G63lNlOuHQMH/t9JF2akO
         cX0wHLQob9s8TpNix8ABC7uyPJg3JuCj4Bg5piv8KGm33b+kBNrAFK+sOZRJbfbyiUNG
         fjt367bI5/jc6tVtTlLjdY1Pz6yFo3Qp1dtB67gPU79el+94052rBsnm2+TxgyXamvbw
         yjoKHPIhp+DUchvssEOffrT+3KyI3Hmd4Bk9ncHwD8ndeJhEvIGmoOh0Y7TdPFIcaNIp
         hLUw==
X-Gm-Message-State: AOAM533Sn6ToAfdpc++M64Wyt6kGxRDUzrCOuhI+aRQCd/t2tDPFlB0q
        fwvrbJs5zhsHYcNCyRfd8X+gdJOz0JE65g==
X-Google-Smtp-Source: ABdhPJwl3NOhtSsb7q0O6s0l9JbSsho+0RLToUKXR4ut5Y9mHVY288/kouyYyhqFIPeAyPCt/5N5Xg==
X-Received: by 2002:a17:906:b2d5:: with SMTP id cf21mr3164578ejb.387.1611660067623;
        Tue, 26 Jan 2021 03:21:07 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Subject: [PATCH stable 10/11] io_uring: dont kill fasync under completion_lock
Date:   Tue, 26 Jan 2021 11:17:09 +0000
Message-Id: <41777a0d41ba61011c7ef96d44de36f37ec5e8ea.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4aa84f2ffa81f71e15e5cffc2cc6090dbee78f8e ]

      CPU0                    CPU1
       ----                    ----
  lock(&new->fa_lock);
                               local_irq_disable();
                               lock(&ctx->completion_lock);
                               lock(&new->fa_lock);
  <Interrupt>
    lock(&ctx->completion_lock);

 *** DEADLOCK ***

Move kill_fasync() out of io_commit_cqring() to io_cqring_ev_posted(),
so it doesn't hold completion_lock while doing it. That saves from the
reported deadlock, and it's just nice to shorten the locking time and
untangle nested locks (compl_lock -> wq_head::lock).

Cc: stable@vger.kernel.org # 5.5+
Reported-by: syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ead8b6aeda2..1c5d71829bf5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1213,11 +1213,6 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 
 	/* order cqe stores with ring update */
 	smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
-
-	if (wq_has_sleeper(&ctx->cq_wait)) {
-		wake_up_interruptible(&ctx->cq_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
@@ -1584,6 +1579,10 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
-- 
2.24.0

