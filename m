Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5996517E5
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiLTBWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiLTBWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:22:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E92112AEA;
        Mon, 19 Dec 2022 17:21:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F1DCB81104;
        Tue, 20 Dec 2022 01:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095A5C433F1;
        Tue, 20 Dec 2022 01:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499290;
        bh=ld4GI8IxkG5GhH1HYhSS/uEu2E7iHy1QQzt0YzYVSSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9m7sZxwhmPYtBsQrNoqPglEchC2bEqP38IDox+RH/OMCqhkTjIDzijOar4sWpdG5
         sI7rQIJWfMvyg0IwRrVwb3PPrqoa0ICsqvv28hb6lXpVhb9rETDipwUWAT5xsmhFKq
         ljIHZFpqqM5tGRu3C8Z/rwKoeUHpwJjS2GZbEyDaT7GDgBB5Mv3hpqnsEkF2LMhHRK
         wx07zCD8tQzlBCb51wA9HlaPdM3GffHEZoO5aJg4fhx2BEXVaU/dISLPH0e4vLZtOq
         qes88NhQXjPA70Wa1aVVRbneop2+K92HWKYmbKmuhIdXZsNBc98Tnb6PE7HeuO/KS9
         DebxGDkfYtpew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/16] scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs
Date:   Mon, 19 Dec 2022 20:21:12 -0500
Message-Id: <20221220012127.1222311-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012127.1222311-1-sashal@kernel.org>
References: <20221220012127.1222311-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit c44e50f4a0ec00c2298f31f91bc2c3e9bbd81c7e ]

During I/O and simultaneous cat of /sys/kernel/debug/lpfc/fnX/rx_monitor, a
hard lockup similar to the call trace below may occur.

The spin_lock_bh in lpfc_rx_monitor_report is not protecting from timer
interrupts as expected, so change the strength of the spin lock to _irq.

Kernel panic - not syncing: Hard LOCKUP
CPU: 3 PID: 110402 Comm: cat Kdump: loaded

exception RIP: native_queued_spin_lock_slowpath+91

[IRQ stack]
 native_queued_spin_lock_slowpath at ffffffffb814e30b
 _raw_spin_lock at ffffffffb89a667a
 lpfc_rx_monitor_record at ffffffffc0a73a36 [lpfc]
 lpfc_cmf_timer at ffffffffc0abbc67 [lpfc]
 __hrtimer_run_queues at ffffffffb8184250
 hrtimer_interrupt at ffffffffb8184ab0
 smp_apic_timer_interrupt at ffffffffb8a026ba
 apic_timer_interrupt at ffffffffb8a01c4f
[End of IRQ stack]

 apic_timer_interrupt at ffffffffb8a01c4f
 lpfc_rx_monitor_report at ffffffffc0a73c80 [lpfc]
 lpfc_rx_monitor_read at ffffffffc0addde1 [lpfc]
 full_proxy_read at ffffffffb83e7fc3
 vfs_read at ffffffffb833fe71
 ksys_read at ffffffffb83402af
 do_syscall_64 at ffffffffb800430b
 entry_SYSCALL_64_after_hwframe at ffffffffb8a000ad

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20221017164323.14536-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 03c21167fc85..c4960da4c1c4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8076,10 +8076,10 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 					"IO_cnt", "Info", "BWutil(ms)");
 	}
 
-	/* Needs to be _bh because record is called from timer interrupt
+	/* Needs to be _irq because record is called from timer interrupt
 	 * context
 	 */
-	spin_lock_bh(ring_lock);
+	spin_lock_irq(ring_lock);
 	while (*head_idx != *tail_idx) {
 		entry = &ring[*head_idx];
 
@@ -8123,7 +8123,7 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 		if (cnt >= max_read_entries)
 			break;
 	}
-	spin_unlock_bh(ring_lock);
+	spin_unlock_irq(ring_lock);
 
 	return cnt;
 }
-- 
2.35.1

