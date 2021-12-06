Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98AA469E76
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385799AbhLFPjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379114AbhLFPgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344D0C08EAD2;
        Mon,  6 Dec 2021 07:22:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C609D61331;
        Mon,  6 Dec 2021 15:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17E0C341C6;
        Mon,  6 Dec 2021 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804167;
        bh=amYCCtwFH1RWlUgu7GDgwbeP/3MTHL57pOnm8t7oNnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ty+/2yqNiO8oBagmItFofRSG26ZOwv5zYoWUnNurwGnxOu2X+hrzOHYutVgRh/FbT
         qyBpAJ6Z2xd5po8NIyDU/klTqOJgOi9z6dvG26+o0cQTczY77g/QeqdcKkCBjOWf2j
         eKQU8ACufUCfJ2qZsN/RSEkcfPDUrlXmUyoKE2LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/207] net/smc: Avoid warning of possible recursive locking
Date:   Mon,  6 Dec 2021 15:55:04 +0100
Message-Id: <20211206145611.957791638@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 7a61432dc81375be06b02f0061247d3efbdfce3a ]

Possible recursive locking is detected by lockdep when SMC
falls back to TCP. The corresponding warnings are as follows:

 ============================================
 WARNING: possible recursive locking detected
 5.16.0-rc1+ #18 Tainted: G            E
 --------------------------------------------
 wrk/1391 is trying to acquire lock:
 ffff975246c8e7d8 (&ei->socket.wq.wait){..-.}-{3:3}, at: smc_switch_to_fallback+0x109/0x250 [smc]

 but task is already holding lock:
 ffff975246c8f918 (&ei->socket.wq.wait){..-.}-{3:3}, at: smc_switch_to_fallback+0xfe/0x250 [smc]

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&ei->socket.wq.wait);
   lock(&ei->socket.wq.wait);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 2 locks held by wrk/1391:
  #0: ffff975246040130 (sk_lock-AF_SMC){+.+.}-{0:0}, at: smc_connect+0x43/0x150 [smc]
  #1: ffff975246c8f918 (&ei->socket.wq.wait){..-.}-{3:3}, at: smc_switch_to_fallback+0xfe/0x250 [smc]

 stack backtrace:
 Call Trace:
  <TASK>
  dump_stack_lvl+0x56/0x7b
  __lock_acquire+0x951/0x11f0
  lock_acquire+0x27a/0x320
  ? smc_switch_to_fallback+0x109/0x250 [smc]
  ? smc_switch_to_fallback+0xfe/0x250 [smc]
  _raw_spin_lock_irq+0x3b/0x80
  ? smc_switch_to_fallback+0x109/0x250 [smc]
  smc_switch_to_fallback+0x109/0x250 [smc]
  smc_connect_fallback+0xe/0x30 [smc]
  __smc_connect+0xcf/0x1090 [smc]
  ? mark_held_locks+0x61/0x80
  ? __local_bh_enable_ip+0x77/0xe0
  ? lockdep_hardirqs_on+0xbf/0x130
  ? smc_connect+0x12a/0x150 [smc]
  smc_connect+0x12a/0x150 [smc]
  __sys_connect+0x8a/0xc0
  ? syscall_enter_from_user_mode+0x20/0x70
  __x64_sys_connect+0x16/0x20
  do_syscall_64+0x34/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The nested locking in smc_switch_to_fallback() is considered to
possibly cause a deadlock because smc_wait->lock and clc_wait->lock
are the same type of lock. But actually it is safe so far since
there is no other place trying to obtain smc_wait->lock when
clc_wait->lock is held. So the patch replaces spin_lock() with
spin_lock_nested() to avoid false report by lockdep.

Link: https://lkml.org/lkml/2021/11/19/962
Fixes: 2153bd1e3d3d ("Transfer remaining wait queue entries during fallback")
Reported-by: syzbot+e979d3597f48262cb4ee@syzkaller.appspotmail.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c0456cb7623cb..06e4a07bdcdc1 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -566,7 +566,7 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * to clcsocket->wq during the fallback.
 		 */
 		spin_lock_irqsave(&smc_wait->lock, flags);
-		spin_lock(&clc_wait->lock);
+		spin_lock_nested(&clc_wait->lock, SINGLE_DEPTH_NESTING);
 		list_splice_init(&smc_wait->head, &clc_wait->head);
 		spin_unlock(&clc_wait->lock);
 		spin_unlock_irqrestore(&smc_wait->lock, flags);
-- 
2.33.0



