Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC78265D83B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239867AbjADQMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240063AbjADQMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0991B34746
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DAF2B8172E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887F1C433F0;
        Wed,  4 Jan 2023 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848705;
        bh=e7oN45J6Bdw4SwilEHA4osAZtrTVi4GDuRXrTySbeAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agM4sVNoR60JLUJvjyAaDY95Etsx897m7nDXqZQJsDxiJb1kB3fjkVoGbjXhV3HHT
         3T9Y5ZGNFS2dPTNKH+jqxGKtPBJNvJQV5S09V0irOzPeFc7sBgilDM72PacjZzpH44
         iQY3R7fDYto0IGjuf6hBji+2Jp0sfEde08TjdZMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luo Meng <luomeng12@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 070/207] dm thin: Fix UAF in run_timer_softirq()
Date:   Wed,  4 Jan 2023 17:05:28 +0100
Message-Id: <20230104160514.149613648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

commit 88430ebcbc0ec637b710b947738839848c20feff upstream.

When dm_resume() and dm_destroy() are concurrent, it will
lead to UAF, as follows:

 BUG: KASAN: use-after-free in __run_timers+0x173/0x710
 Write of size 8 at addr ffff88816d9490f0 by task swapper/0/0
<snip>
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x73/0x9f
  print_report.cold+0x132/0xaa2
  _raw_spin_lock_irqsave+0xcd/0x160
  __run_timers+0x173/0x710
  kasan_report+0xad/0x110
  __run_timers+0x173/0x710
  __asan_store8+0x9c/0x140
  __run_timers+0x173/0x710
  call_timer_fn+0x310/0x310
  pvclock_clocksource_read+0xfa/0x250
  kvm_clock_read+0x2c/0x70
  kvm_clock_get_cycles+0xd/0x20
  ktime_get+0x5c/0x110
  lapic_next_event+0x38/0x50
  clockevents_program_event+0xf1/0x1e0
  run_timer_softirq+0x49/0x90
  __do_softirq+0x16e/0x62c
  __irq_exit_rcu+0x1fa/0x270
  irq_exit_rcu+0x12/0x20
  sysvec_apic_timer_interrupt+0x8e/0xc0

One of the concurrency UAF can be shown as below:

        use                                  free
do_resume                           |
  __find_device_hash_cell           |
    dm_get                          |
      atomic_inc(&md->holders)      |
                                    | dm_destroy
                                    |   __dm_destroy
                                    |     if (!dm_suspended_md(md))
                                    |     atomic_read(&md->holders)
                                    |     msleep(1)
  dm_resume                         |
    __dm_resume                     |
      dm_table_resume_targets       |
        pool_resume                 |
          do_waker  #add delay work |
  dm_put                            |
    atomic_dec(&md->holders)        |
                                    |     dm_table_destroy
                                    |       pool_dtr
                                    |         __pool_dec
                                    |           __pool_destroy
                                    |             destroy_workqueue
                                    |             kfree(pool) # free pool
        time out
__do_softirq
  run_timer_softirq # pool has already been freed

This can be easily reproduced using:
  1. create thin-pool
  2. dmsetup suspend pool
  3. dmsetup resume pool
  4. dmsetup remove_all # Concurrent with 3

The root cause of this UAF bug is that dm_resume() adds timer after
dm_destroy() skips cancelling the timer because of suspend status.
After timeout, it will call run_timer_softirq(), however pool has
already been freed. The concurrency UAF bug will happen.

Therefore, cancelling timer again in __pool_destroy().

Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0d ("dm: add thin provisioning target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2889,6 +2889,8 @@ static void __pool_destroy(struct pool *
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 


