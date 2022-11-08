Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02F6212F7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiKHNox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiKHNow (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:44:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66685800D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:44:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BFE6158F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8484AC433C1;
        Tue,  8 Nov 2022 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915089;
        bh=siLfrBKMZ4vlj6odFfcf0qRx7ImnQJVyuSJ1eJ4PWag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abPWt8fCTt7mcAVViVxvqGELtBFMJusW6TBGcCLRxkqDbK9fH7wmhW3a7SHW+vhZz
         iY061eCP3DQn2IxRkIjDVtB2hLEhj340rCdulPljjYWWqiEJeWT8AFR1gsdh5B4Wmv
         9zfI6et/fhAyiITe5YcBtMRbnxJkL5NzBr6ke2N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dokyung Song <dokyungs@yonsei.ac.kr>,
        Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Arend van Spriel <aspriel@gmail.com>,
        Dokyung Song <dokyung.song@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.14 40/40] wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()
Date:   Tue,  8 Nov 2022 14:39:25 +0100
Message-Id: <20221108133329.809386873@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
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

From: Dokyung Song <dokyung.song@gmail.com>

commit 6788ba8aed4e28e90f72d68a9d794e34eac17295 upstream.

This patch fixes an intra-object buffer overflow in brcmfmac that occurs
when the device provides a 'bsscfgidx' equal to or greater than the
buffer size. The patch adds a check that leads to a safe failure if that
is the case.

This fixes CVE-2022-3628.

UBSAN: array-index-out-of-bounds in drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 52 is out of range for type 'brcmf_if *[16]'
CPU: 0 PID: 1898 Comm: kworker/0:2 Tainted: G           O      5.14.0+ #132
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: events brcmf_fweh_event_worker
Call Trace:
 dump_stack_lvl+0x57/0x7d
 ubsan_epilogue+0x5/0x40
 __ubsan_handle_out_of_bounds+0x69/0x80
 ? memcpy+0x39/0x60
 brcmf_fweh_event_worker+0xae1/0xc00
 ? brcmf_fweh_call_event_handler.isra.0+0x100/0x100
 ? rcu_read_lock_sched_held+0xa1/0xd0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 process_one_work+0x873/0x13e0
 ? lock_release+0x640/0x640
 ? pwq_dec_nr_in_flight+0x320/0x320
 ? rwlock_bug.part.0+0x90/0x90
 worker_thread+0x8b/0xd10
 ? __kthread_parkme+0xd9/0x1d0
 ? process_one_work+0x13e0/0x13e0
 kthread+0x379/0x450
 ? _raw_spin_unlock_irq+0x24/0x30
 ? set_kthread_struct+0x100/0x100
 ret_from_fork+0x1f/0x30
================================================================================
general protection fault, probably for non-canonical address 0xe5601c0020023fff: 0000 [#1] SMP KASAN
KASAN: maybe wild-memory-access in range [0x2b0100010011fff8-0x2b0100010011ffff]
CPU: 0 PID: 1898 Comm: kworker/0:2 Tainted: G           O      5.14.0+ #132
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: events brcmf_fweh_event_worker
RIP: 0010:brcmf_fweh_call_event_handler.isra.0+0x42/0x100
Code: 89 f5 53 48 89 fb 48 83 ec 08 e8 79 0b 38 fe 48 85 ed 74 7e e8 6f 0b 38 fe 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 8b 00 00 00 4c 8b 7d 00 44 89 e0 48 ba 00 00 00
RSP: 0018:ffffc9000259fbd8 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff888115d8cd50 RCX: 0000000000000000
RDX: 0560200020023fff RSI: ffffffff8304bc91 RDI: ffff888115d8cd50
RBP: 2b0100010011ffff R08: ffff888112340050 R09: ffffed1023549809
R10: ffff88811aa4c047 R11: ffffed1023549808 R12: 0000000000000045
R13: ffffc9000259fca0 R14: ffff888112340050 R15: ffff888112340000
FS:  0000000000000000(0000) GS:ffff88811aa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000004053ccc0 CR3: 0000000112740000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 brcmf_fweh_event_worker+0x117/0xc00
 ? brcmf_fweh_call_event_handler.isra.0+0x100/0x100
 ? rcu_read_lock_sched_held+0xa1/0xd0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 process_one_work+0x873/0x13e0
 ? lock_release+0x640/0x640
 ? pwq_dec_nr_in_flight+0x320/0x320
 ? rwlock_bug.part.0+0x90/0x90
 worker_thread+0x8b/0xd10
 ? __kthread_parkme+0xd9/0x1d0
 ? process_one_work+0x13e0/0x13e0
 kthread+0x379/0x450
 ? _raw_spin_unlock_irq+0x24/0x30
 ? set_kthread_struct+0x100/0x100
 ret_from_fork+0x1f/0x30
Modules linked in: 88XXau(O) 88x2bu(O)
---[ end trace 41d302138f3ff55a ]---
RIP: 0010:brcmf_fweh_call_event_handler.isra.0+0x42/0x100
Code: 89 f5 53 48 89 fb 48 83 ec 08 e8 79 0b 38 fe 48 85 ed 74 7e e8 6f 0b 38 fe 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 8b 00 00 00 4c 8b 7d 00 44 89 e0 48 ba 00 00 00
RSP: 0018:ffffc9000259fbd8 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff888115d8cd50 RCX: 0000000000000000
RDX: 0560200020023fff RSI: ffffffff8304bc91 RDI: ffff888115d8cd50
RBP: 2b0100010011ffff R08: ffff888112340050 R09: ffffed1023549809
R10: ffff88811aa4c047 R11: ffffed1023549808 R12: 0000000000000045
R13: ffffc9000259fca0 R14: ffff888112340050 R15: ffff888112340000
FS:  0000000000000000(0000) GS:ffff88811aa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000004053ccc0 CR3: 0000000112740000 CR4: 0000000000750ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Kernel panic - not syncing: Fatal exception

Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Reviewed-by: Arend van Spriel <aspriel@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dokyung Song <dokyung.song@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221021061359.GA550858@laguna
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -237,6 +237,10 @@ static void brcmf_fweh_event_worker(stru
 			  brcmf_fweh_event_name(event->code), event->code,
 			  event->emsg.ifidx, event->emsg.bsscfgidx,
 			  event->emsg.addr);
+		if (event->emsg.bsscfgidx >= BRCMF_MAX_IFS) {
+			brcmf_err("invalid bsscfg index: %u\n", event->emsg.bsscfgidx);
+			goto event_free;
+		}
 
 		/* convert event message */
 		emsg_be = &event->emsg;


