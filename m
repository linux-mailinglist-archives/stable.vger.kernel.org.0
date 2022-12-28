Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33493657EDC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiL1P61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiL1P60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7ED183B3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61FB2B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2207C433D2;
        Wed, 28 Dec 2022 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243103;
        bh=NxM83+USHhwwxGcBp16Ts/UMl6kRvcItqMXZWctqbNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYl8MXVRojQll4pSuLxcfi7O3zJU1L9+Sp/uTH5YMm1LdwQ7a3nn/SNqSQcfndYHF
         hMGoe208KT1WY2c0O07MIaX978pzPsJzSCrFOpGwZAysvLWHcFMjPT1+IxAbuTwbXp
         Fns4ty9VyaWx7piWUAdBhbs9Y1kYjIfTlQ+z2ZhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Tee <justin.tee@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 675/731] scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs
Date:   Wed, 28 Dec 2022 15:43:02 +0100
Message-Id: <20221228144316.043176344@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index d6e761adf1f1..df3b190fccd1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7992,10 +7992,10 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
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
 
@@ -8039,7 +8039,7 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 		if (cnt >= max_read_entries)
 			break;
 	}
-	spin_unlock_bh(ring_lock);
+	spin_unlock_irq(ring_lock);
 
 	return cnt;
 }
-- 
2.35.1



