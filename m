Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0928368FA4
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 11:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbhDWJpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 05:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhDWJpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 05:45:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47CFC06174A
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 02:45:10 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id z16so34825616pga.1
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 02:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=21FONuv9wf/TBhMMknh0pxEkH4v3trVm0zK1vzeowo0=;
        b=oV4cV4Jfo4lrnkTRW2sRKtuG05gpYFkk3Tt0jAzYkKRIU6A0Otu4LPSWAWNZ7ljbih
         nEe+jjEcR1MNp3iRotAIhFB1xgkoZ5SXxXmJ0hOV37p+F6BS/QsWvj+FjReLzTHUIpWP
         VUmqswJDUVMT6Qyn3ZdJQ+4vd6CuOaot30d4S0PeT+kr38ZNsDXzrDuYW8qnhcpDxAgB
         HBzV7ybbeC0kYiOYrvZ/fHnVoSTSlmWrQODt4fNAd/Vv8LR20P0L+ZgxhYE6Hvkv77gw
         uK322bQ1bzVXjXx9PurRUGc38NozHe0R1KiYxIZ4C15TH37D8fUvM8iNAkc1pV5CFrfe
         VpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=21FONuv9wf/TBhMMknh0pxEkH4v3trVm0zK1vzeowo0=;
        b=fD3G29xLdi94c5WCgwiLeU5LNIEp5e6MqdirhoVxJEatxmzv4XNoeb+l+IOtP00dyY
         5lEJ6fUnV4YOYt1tXW8oMgQ17D2og84I1AmEDlKh9rmWR135yOlOiLaV/ep6a3W3pHoZ
         w/3F+R6DoUqI9E/LGZjqnUijGp/8z4Rl2chvsHl/PxCOx0JifVbS9/85Clp9I3G5d7/I
         hku1FZ6SXaZsLGqy+GGhBdvQTvR0sEdjHh3n6El9D19JYFfobQ9t14LNyWKblKYiAmea
         Ab2+2ZS7XMVC5VC/BV0gWR5uolh8B5YW6QwHHVF4A2n3TdCNgh3NKi56pNKuEZS3gVjj
         5RTw==
X-Gm-Message-State: AOAM531zV6Oz3x23OirPKsHDNnKCowA2AMFqwyWsVe3ju83ULOA1mxtg
        li+nYtdJw/elpJN39iXsLCdUcA==
X-Google-Smtp-Source: ABdhPJy7gj088WmvtP2n6iaI5e7hW05Cqk/g+r4zf53cCy+6ANKYDf4b8Oa5ZEkt2EjBgQ2UKGBrlA==
X-Received: by 2002:a62:1c0f:0:b029:25f:ba3c:9cc0 with SMTP id c15-20020a621c0f0000b029025fba3c9cc0mr2866796pfc.56.1619171110271;
        Fri, 23 Apr 2021 02:45:10 -0700 (PDT)
Received: from C02CV1DAMD6P.bytedance.net ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id a6sm4510611pfh.135.2021.04.23.02.45.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Apr 2021 02:45:09 -0700 (PDT)
From:   Chengming Zhou <zhouchengming@bytedance.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhouchengming@bytedance.com, stable@vger.kernel.org
Subject: [PATCH] blk-wbt: fix scale logic when disable wbt
Date:   Fri, 23 Apr 2021 17:45:03 +0800
Message-Id: <20210423094503.25733-1-zhouchengming@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We encountered kernel crash when disable wbt through min_lat_nsec
setting to zero, found the problem is the reset of wb_max to zero in
calc_wb_limits() would break the normal scale logic, caused the
scale_step value overflow and kernel crash. Below is the crash backtrace:

[43061417.487135] task: ffff9250828d6540 task.stack: ffffbc8b839f0000
[43061417.487331] RIP: 0010:rwb_arm_timer+0x52/0x60
[43061417.487472] RSP: 0000:ffff9250bfec3ea8 EFLAGS: 00010206
[43061417.487646] RAX: 000000005f5e1000 RBX: ffff9250ab6113c0 RCX: 0000000000000000
[43061417.487877] RDX: 0000000000000000 RSI: ffffffff9fe4a484 RDI: 000000005f5e1000
[43061417.488109] RBP: 0000000000000100 R08: ffffffff00000000 R09: 00000000ffffffff
[43061417.488343] R10: 0000000000000000 R11: ffffdc8b3fdcf938 R12: ffff9250a9324d90
[43061417.488575] R13: ffffffff9f3583a0 R14: ffff9250a9324d80 R15: 0000000000000000
[43061417.488808] FS:  00007f7aadbee700(0000) GS:ffff9250bfec0000(0000) knlGS:0000000000000000
[43061417.489069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[43061417.489258] CR2: 00007f43b7c809b8 CR3: 0000007e42994006 CR4: 00000000007606e0
[43061417.489490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[43061417.489722] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[43061417.489952] PKRU: 55555554
[43061417.490046] Call Trace:
[43061417.490136]  <IRQ>
[43061417.490206]  call_timer_fn+0x2e/0x130
[43061417.490328]  run_timer_softirq+0x1d4/0x420
[43061417.490466]  ? timerqueue_add+0x54/0x80
[43061417.490593]  ? enqueue_hrtimer+0x38/0x80
[43061417.490722]  __do_softirq+0x108/0x2a9
[43061417.490846]  irq_exit+0xc2/0xd0
[43061417.490953]  smp_apic_timer_interrupt+0x6c/0x120
[43061417.491106]  apic_timer_interrupt+0x7d/0x90
[43061417.491245]  </IRQ>

Seen from the crash dump, the scale_step became a very big value and
overflow to zero divisor in div_u64, so kernel crash happened.

Since wbt use wb_max == 1 and scaled_max flag as the scale min/max
point, we only reset wb_normal and wb_background when set min_lat_nsec
to zero, leave wb_max and scaled_max to be driven by the scale timer.

Higher version kernels than v4.18 include a code refactor patchset that
split the scale up/down logic and calc_wb_limits(), so disable wbt by
setting min_lat_nsec to zero will NOT affect the normal scale logic.

But we don't want to backport that patchset because of very big code
changes, may introduce other problems. So just fix the crash bug in
this patch.

Fixes: e34cbd307477 ("blk-wbt: add general throttling mechanism")
Cc: <stable@vger.kernel.org> # 4.9.x
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 block/blk-wbt.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 5c105514bca7..24c84ee39029 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -194,11 +194,6 @@ static bool calc_wb_limits(struct rq_wb *rwb)
 	unsigned int depth;
 	bool ret = false;
 
-	if (!rwb->min_lat_nsec) {
-		rwb->wb_max = rwb->wb_normal = rwb->wb_background = 0;
-		return false;
-	}
-
 	/*
 	 * For QD=1 devices, this is a special case. It's important for those
 	 * to have one request ready when one completes, so force a depth of
@@ -244,6 +239,9 @@ static bool calc_wb_limits(struct rq_wb *rwb)
 		rwb->wb_background = (rwb->wb_max + 3) / 4;
 	}
 
+	if (!rwb->min_lat_nsec)
+		rwb->wb_normal = rwb->wb_background = 0;
+
 	return ret;
 }
 
-- 
2.11.0

