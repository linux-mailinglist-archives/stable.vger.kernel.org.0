Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBE86B84BE
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 23:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCMW37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 18:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCMW35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 18:29:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A9D6BC0E
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:54 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i3so14611282plg.6
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678746594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vVn1LLW9jGH3vizR2Vh0QqNw1Uoj7/4oaLgWURAUoE=;
        b=FDliuMCwyve+rDQBz3ikpE9QZV9Wgy+AmmYSmVsN4I6pOYIVhw2dOXfgLvo8WSjmGt
         9pnm5xlpf3/+5fF1sEoLBpjRlCwoevAU0Py0Q3Fv3R4AEee8ctH5LXLpbkStvJSpF5xy
         DqQjjaJ0tq/iAj6Azmy4WScEwy8Jqc5j3bEc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vVn1LLW9jGH3vizR2Vh0QqNw1Uoj7/4oaLgWURAUoE=;
        b=u6AZVt/e6OjdsBTItx+Qi6pqajqgQ++eaJFDGELtnL4EbMnThJBcTM1AIid0EF1/mL
         mXP4dAOxL6ZJbPPTDIZ0sJYaN9Otoj0E03urar3ZOwe03LT5bMK0RxSl0SIQTB0i3vas
         eRrfyODzSBKEwkMnQEg5FQmWD2ZMs6xH3RJO21cG6qRcEMtVlRFX0eF0W52FBp4S45uQ
         M6Td0e0/zSBwQMoKfoqIVqyMDYkjfssCWEriD0xmGK2hmlOPlI16FovFCNiQBuo3RYoM
         dC3jl4ubggDQjuzvtrDIPlSsGbUTVDGVutzwlscBqDnLT5AD8PeYgU+PYMs2AC38V2PO
         zN6A==
X-Gm-Message-State: AO0yUKWwnu+gZ8swvodjwLM3RoH9dQ5aM3AuiNuBAruCFlJCUhd10dso
        alIFPgKQ3xsS+KMunmeNFf/NLF0TLv+MYGMvoCc=
X-Google-Smtp-Source: AK7set8JxLnbKfrXgkJSXgb3F/hTJt/RLi+cknWDSWt0Dzy0C8up3d5635IExrlxC3q2K75iExEWkw==
X-Received: by 2002:a17:90b:1b4a:b0:237:b5d4:c0df with SMTP id nv10-20020a17090b1b4a00b00237b5d4c0dfmr35428420pjb.6.1678746593809;
        Mon, 13 Mar 2023 15:29:53 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2d4:203:157:b07d:930a:fb24])
        by smtp.gmail.com with ESMTPSA id km8-20020a17090327c800b0019aa8149cb9sm352440plb.79.2023.03.13.15.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:29:53 -0700 (PDT)
From:   Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v5.10 1/5] block, bfq: fix possible uaf for 'bfqq->bic'
Date:   Mon, 13 Mar 2023 15:27:53 -0700
Message-Id: <20230313222757.1103179-2-khazhy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230313222757.1103179-1-khazhy@google.com>
References: <20230313222757.1103179-1-khazhy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 64dc8c732f5c2b406cc752e6aaa1bd5471159cab ]

Our test report a uaf for 'bfqq->bic' in 5.10:

==================================================================
BUG: KASAN: use-after-free in bfq_select_queue+0x378/0xa30

CPU: 6 PID: 2318352 Comm: fsstress Kdump: loaded Not tainted 5.10.0-60.18.0.50.h602.kasan.eulerosv2r11.x86_64 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-20220320_160524-szxrtosci10000 04/01/2014
Call Trace:
 bfq_select_queue+0x378/0xa30
 bfq_dispatch_request+0xe8/0x130
 blk_mq_do_dispatch_sched+0x62/0xb0
 __blk_mq_sched_dispatch_requests+0x215/0x2a0
 blk_mq_sched_dispatch_requests+0x8f/0xd0
 __blk_mq_run_hw_queue+0x98/0x180
 __blk_mq_delay_run_hw_queue+0x22b/0x240
 blk_mq_run_hw_queue+0xe3/0x190
 blk_mq_sched_insert_requests+0x107/0x200
 blk_mq_flush_plug_list+0x26e/0x3c0
 blk_finish_plug+0x63/0x90
 __iomap_dio_rw+0x7b5/0x910
 iomap_dio_rw+0x36/0x80
 ext4_dio_read_iter+0x146/0x190 [ext4]
 ext4_file_read_iter+0x1e2/0x230 [ext4]
 new_sync_read+0x29f/0x400
 vfs_read+0x24e/0x2d0
 ksys_read+0xd5/0x1b0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x61/0xc6

Commit 3bc5e683c67d ("bfq: Split shared queues on move between cgroups")
changes that move process to a new cgroup will allocate a new bfqq to
use, however, the old bfqq and new bfqq can point to the same bic:

1) Initial state, two process with io in the same cgroup.

Process 1       Process 2
 (BIC1)          (BIC2)
  |  Λ            |  Λ
  |  |            |  |
  V  |            V  |
  bfqq1           bfqq2

2) bfqq1 is merged to bfqq2.

Process 1       Process 2
 (BIC1)          (BIC2)
  |               |
   \-------------\|
                  V
  bfqq1           bfqq2(coop)

3) Process 1 exit, then issue new io(denoce IOA) from Process 2.

 (BIC2)
  |  Λ
  |  |
  V  |
  bfqq2(coop)

4) Before IOA is completed, move Process 2 to another cgroup and issue io.

Process 2
 (BIC2)
   Λ
   |\--------------\
   |                V
  bfqq2           bfqq3

Now that BIC2 points to bfqq3, while bfqq2 and bfqq3 both point to BIC2.
If all the requests are completed, and Process 2 exit, BIC2 will be
freed while there is no guarantee that bfqq2 will be freed before BIC2.

Fix the problem by clearing bfqq->bic while bfqq is detached from bic.

Fixes: 3bc5e683c67d ("bfq: Split shared queues on move between cgroups")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221214030430.3304151-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 block/bfq-iosched.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7c4b8d0635eb..afaededb3c49 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -373,6 +373,12 @@ struct bfq_queue *bic_to_bfqq(struct bfq_io_cq *bic, bool is_sync)
 
 void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync)
 {
+	struct bfq_queue *old_bfqq = bic->bfqq[is_sync];
+
+	/* Clear bic pointer if bfqq is detached from this bic */
+	if (old_bfqq && old_bfqq->bic == bic)
+		old_bfqq->bic = NULL;
+
 	bic->bfqq[is_sync] = bfqq;
 }
 
@@ -4977,7 +4983,6 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfqq->bic = NULL;
 		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
-- 
2.40.0.rc1.284.g88254d51c5-goog

