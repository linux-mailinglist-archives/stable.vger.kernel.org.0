Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A606D6A204B
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBXRIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBXRIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:08:53 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F30117159
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:08:51 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id b16so101261iln.3
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3rugt0kcqzEr09E9TYYrNcya1Yke+FnObjHejahto8=;
        b=cDUpGhxszykKXpp8/Iq26Xa/q3SrqpOO6Gd0mkCkeNVXj10d0nqNw6gMtcAoB4HK8r
         DZTomPSQrpxPpH0/lSNRHWTI4lnSIo+edgEf+ozof7hc7+Ch8l30mphxTDpdA6iX5RMX
         AAFC/376gJHY8FBvYuc6uRKEYWGR5DAPDQ7JcmbYzZP6fxH0If6+9fFzviIIv0BzBigM
         a5DHsgvtiRcgBLlEocpRkkVIRBR976VBnd4f9nY9Gl2nrle5yTnpVmdjmvz2OHUpuGj+
         RwncXRMQ/fcc8rq5gOX/cwrgTGND5fHy2Bh91qzx0EBKzZGmtirpOPCZ1dXjYn195lhx
         O9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D3rugt0kcqzEr09E9TYYrNcya1Yke+FnObjHejahto8=;
        b=GrD41Mku/ZI+ldXIH2HxSTZiYPCoaaMO7YbF/gTZN//zk1KxJ3OldaP150a8NbHOBX
         //5yLUeV7Lq8cEQHXitoKs3KyiBuBZ/HaSjKEJCU4n9FH+HnQ3EJOSMF79fwK/4Hjymo
         5kDa0RM8S5Eju3QdWbWCY0p39Npo7X2HSl/WHilPpFNkekSc3oWHKp31u/4eQr6V4gjK
         KWN1ILdcjqGoXW7iHDZGfp03XqwzKmhXm+tirvbpfFPFUV+zrc4TIj/lGr+iXzrlh3rb
         bg2MqNcAdPDDTvKnZlIv5yKwaYZw5ZBqXkB2Trjv/RvbSp4FU7WksLtYSwLA1ojFOToL
         RXew==
X-Gm-Message-State: AO0yUKV74ATZ9r89e7RNUvJG9c8KMoZLxzf2iVdE/n2O6aO3gc3CTr4k
        VMrLE1em0bAFqqihQ3+xeAYncw==
X-Google-Smtp-Source: AK7set+kDzJRsqFGEY1uPTnRuTcoK+mCmFkBBoj/HVCCqqhA57MaesprK2TS1iN5fbFygF9bHu2V+w==
X-Received: by 2002:a92:680f:0:b0:317:1ca3:f518 with SMTP id d15-20020a92680f000000b003171ca3f518mr831529ilc.0.1677258530686;
        Fri, 24 Feb 2023 09:08:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a92d341000000b0031535ce9cc8sm4166018ilh.83.2023.02.24.09.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:08:50 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     kbusch@kernel.org, Jens Axboe <axboe@kernel.dk>,
        Wei Zhang <wzhang@meta.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] block: be a bit more careful in checking for NULL bdev while polling
Date:   Fri, 24 Feb 2023 10:08:45 -0700
Message-Id: <20230224170845.175485-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230224170845.175485-1-axboe@kernel.dk>
References: <20230224170845.175485-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Wei reports a crash with an application using polled IO:

PGD 14265e067 P4D 14265e067 PUD 47ec50067 PMD 0
Oops: 0000 [#1] SMP
CPU: 0 PID: 21915 Comm: iocore_0 Kdump: loaded Tainted: G S                5.12.0-0_fbk12_clang_7346_g1bb6f2e7058f #1
Hardware name: Wiwynn Delta Lake MP T8/Delta Lake-Class2, BIOS Y3DLM08 04/10/2022
RIP: 0010:bio_poll+0x25/0x200
Code: 0f 1f 44 00 00 0f 1f 44 00 00 55 41 57 41 56 41 55 41 54 53 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 44 24 20 48 8b 47 08 <48> 8b 80 70 02 00 00 4c 8b 70 50 8b 6f 34 31 db 83 fd ff 75 25 65
RSP: 0018:ffffc90005fafdf8 EFLAGS: 00010292
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 74b43cd65dd66600
RDX: 0000000000000003 RSI: ffffc90005fafe78 RDI: ffff8884b614e140
RBP: ffff88849964df78 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88849964df00
R13: ffffc90005fafe78 R14: ffff888137d3c378 R15: 0000000000000001
FS:  00007fd195000640(0000) GS:ffff88903f400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000270 CR3: 0000000466121001 CR4: 00000000007706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 iocb_bio_iopoll+0x1d/0x30
 io_do_iopoll+0xac/0x250
 __se_sys_io_uring_enter+0x3c5/0x5a0
 ? __x64_sys_write+0x89/0xd0
 do_syscall_64+0x2d/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x94f225d
Code: 24 cc 00 00 00 41 8b 84 24 d0 00 00 00 c1 e0 04 83 e0 10 41 09 c2 8b 33 8b 53 04 4c 8b 43 18 4c 63 4b 0c b8 aa 01 00 00 0f 05 <85> c0 0f 88 85 00 00 00 29 03 45 84 f6 0f 84 88 00 00 00 41 f6 c7
RSP: 002b:00007fd194ffcd88 EFLAGS: 00000202 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007fd194ffcdc0 RCX: 00000000094f225d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00007fd194ffcdb0 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000001 R11: 0000000000000202 R12: 00007fd269d68030
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000

which is due to bio->bi_bdev being NULL. This can happen if we have two
tasks doing polled IO, and task B ends up completing IO from task A if
they are sharing a poll queue. If task B completes the IO and puts the
bio into our cache, then it can allocate that bio again before task A
is done polling for it. As that would necessitate a preempt between the
two tasks, it's enough to just be a bit more careful in checking for
whether or not bio->bi_bdev is NULL.

Reported-and-tested-by: Wei Zhang <wzhang@meta.com>
Cc: stable@vger.kernel.org
Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5fb6856745b4..5d7e2ca75234 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -854,10 +854,16 @@ EXPORT_SYMBOL(submit_bio);
  */
 int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 {
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
+	struct block_device *bdev;
+	struct request_queue *q;
 	int ret = 0;
 
+	bdev = READ_ONCE(bio->bi_bdev);
+	if (!bdev)
+		return 0;
+
+	q = bdev_get_queue(bdev);
 	if (cookie == BLK_QC_T_NONE ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
 		return 0;
@@ -926,7 +932,7 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 	 */
 	rcu_read_lock();
 	bio = READ_ONCE(kiocb->private);
-	if (bio && bio->bi_bdev)
+	if (bio)
 		ret = bio_poll(bio, iob, flags);
 	rcu_read_unlock();
 
-- 
2.39.1

