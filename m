Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24226E6E02
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjDRVW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbjDRVWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79061AD0D;
        Tue, 18 Apr 2023 14:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 061846391F;
        Tue, 18 Apr 2023 21:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F654C433EF;
        Tue, 18 Apr 2023 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852959;
        bh=VtAS+axXMM9n1fjQ8fMN+pRCfNIrByizTqR/8ER/dvA=;
        h=Date:To:From:Subject:From;
        b=ylmhv28igcEe/CfGAk7WkJOxowX8opi0KL9JmapR5WNT82E6/mNLFifc00NXIklD+
         Ih3erx+pMJMCJ3ak2DPWA86d79B3MwKv5P43KjG7G6cKHPVIY+KrwspV/heQzyZZgX
         z5KWZMKFpNp/JKbSc4MFI2Bf9kDBdmUY96eSizXY=
Date:   Tue, 18 Apr 2023 14:22:38 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+223c7461c58c58a4cb10@syzkaller.appspotmail.com,
        stable@vger.kernel.org, senozhatsky@chromium.org,
        rostedt@goodmis.org, quic_pdaly@quicinc.com, pmladek@suse.com,
        mhocko@suse.com, mgorman@techsingularity.net,
        john.ogness@linutronix.de, ilpo.jarvinen@linux.intel.com,
        david@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-fix-potential-deadlock-on-zonelist_update_seq-seqlock.patch removed from -mm tree
Message-Id: <20230418212239.5F654C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: fix potential deadlock on zonelist_update_seq seqlock
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-potential-deadlock-on-zonelist_update_seq-seqlock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm/page_alloc: fix potential deadlock on zonelist_update_seq seqlock
Date: Tue, 4 Apr 2023 23:31:58 +0900

syzbot is reporting circular locking dependency which involves
zonelist_update_seq seqlock [1], for this lock is checked by memory
allocation requests which do not need to be retried.

One deadlock scenario is kmalloc(GFP_ATOMIC) from an interrupt handler.

  CPU0
  ----
  __build_all_zonelists() {
    write_seqlock(&zonelist_update_seq); // makes zonelist_update_seq.seqcount odd
    // e.g. timer interrupt handler runs at this moment
      some_timer_func() {
        kmalloc(GFP_ATOMIC) {
          __alloc_pages_slowpath() {
            read_seqbegin(&zonelist_update_seq) {
              // spins forever because zonelist_update_seq.seqcount is odd
            }
          }
        }
      }
    // e.g. timer interrupt handler finishes
    write_sequnlock(&zonelist_update_seq); // makes zonelist_update_seq.seqcount even
  }

This deadlock scenario can be easily eliminated by not calling
read_seqbegin(&zonelist_update_seq) from !__GFP_DIRECT_RECLAIM allocation
requests, for retry is applicable to only __GFP_DIRECT_RECLAIM allocation
requests.  But Michal Hocko does not know whether we should go with this
approach.

Another deadlock scenario which syzbot is reporting is a race between
kmalloc(GFP_ATOMIC) from tty_insert_flip_string_and_push_buffer() with
port->lock held and printk() from __build_all_zonelists() with
zonelist_update_seq held.

  CPU0                                   CPU1
  ----                                   ----
  pty_write() {
    tty_insert_flip_string_and_push_buffer() {
                                         __build_all_zonelists() {
                                           write_seqlock(&zonelist_update_seq);
                                           build_zonelists() {
                                             printk() {
                                               vprintk() {
                                                 vprintk_default() {
                                                   vprintk_emit() {
                                                     console_unlock() {
                                                       console_flush_all() {
                                                         console_emit_next_record() {
                                                           con->write() = serial8250_console_write() {
      spin_lock_irqsave(&port->lock, flags);
      tty_insert_flip_string() {
        tty_insert_flip_string_fixed_flag() {
          __tty_buffer_request_room() {
            tty_buffer_alloc() {
              kmalloc(GFP_ATOMIC | __GFP_NOWARN) {
                __alloc_pages_slowpath() {
                  zonelist_iter_begin() {
                    read_seqbegin(&zonelist_update_seq); // spins forever because zonelist_update_seq.seqcount is odd
                                                             spin_lock_irqsave(&port->lock, flags); // spins forever because port->lock is held
                    }
                  }
                }
              }
            }
          }
        }
      }
      spin_unlock_irqrestore(&port->lock, flags);
                                                             // message is printed to console
                                                             spin_unlock_irqrestore(&port->lock, flags);
                                                           }
                                                         }
                                                       }
                                                     }
                                                   }
                                                 }
                                               }
                                             }
                                           }
                                           write_sequnlock(&zonelist_update_seq);
                                         }
    }
  }

This deadlock scenario can be eliminated by

  preventing interrupt context from calling kmalloc(GFP_ATOMIC)

and

  preventing printk() from calling console_flush_all()

while zonelist_update_seq.seqcount is odd.

Since Petr Mladek thinks that __build_all_zonelists() can become a
candidate for deferring printk() [2], let's address this problem by

  disabling local interrupts in order to avoid kmalloc(GFP_ATOMIC)

and

  disabling synchronous printk() in order to avoid console_flush_all()

.

As a side effect of minimizing duration of zonelist_update_seq.seqcount
being odd by disabling synchronous printk(), latency at
read_seqbegin(&zonelist_update_seq) for both !__GFP_DIRECT_RECLAIM and
__GFP_DIRECT_RECLAIM allocation requests will be reduced.  Although, from
lockdep perspective, not calling read_seqbegin(&zonelist_update_seq) (i.e.
do not record unnecessary locking dependency) from interrupt context is
still preferable, even if we don't allow calling kmalloc(GFP_ATOMIC)
inside
write_seqlock(&zonelist_update_seq)/write_sequnlock(&zonelist_update_seq)
section...

Link: https://lkml.kernel.org/r/8796b95c-3da3-5885-fddd-6ef55f30e4d3@I-love.SAKURA.ne.jp
Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Link: https://lkml.kernel.org/r/ZCrs+1cDqPWTDFNM@alley [2]
Reported-by: syzbot <syzbot+223c7461c58c58a4cb10@syzkaller.appspotmail.com>
  Link: https://syzkaller.appspot.com/bug?extid=223c7461c58c58a4cb10 [1]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Patrick Daly <quic_pdaly@quicinc.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-potential-deadlock-on-zonelist_update_seq-seqlock
+++ a/mm/page_alloc.c
@@ -6632,7 +6632,21 @@ static void __build_all_zonelists(void *
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
+	unsigned long flags;
 
+	/*
+	 * Explicitly disable this CPU's interrupts before taking seqlock
+	 * to prevent any IRQ handler from calling into the page allocator
+	 * (e.g. GFP_ATOMIC) that could hit zonelist_iter_begin and livelock.
+	 */
+	local_irq_save(flags);
+	/*
+	 * Explicitly disable this CPU's synchronous printk() before taking
+	 * seqlock to prevent any printk() from trying to hold port->lock, for
+	 * tty_insert_flip_string_and_push_buffer() on other CPU might be
+	 * calling kmalloc(GFP_ATOMIC | __GFP_NOWARN) with port->lock held.
+	 */
+	printk_deferred_enter();
 	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
@@ -6671,6 +6685,8 @@ static void __build_all_zonelists(void *
 	}
 
 	write_sequnlock(&zonelist_update_seq);
+	printk_deferred_exit();
+	local_irq_restore(flags);
 }
 
 static noinline void __init
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


