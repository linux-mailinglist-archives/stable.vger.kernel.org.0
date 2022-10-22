Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C8608705
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiJVHzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiJVHyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684D9951E2;
        Sat, 22 Oct 2022 00:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19B9960B1B;
        Sat, 22 Oct 2022 07:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C50C433D6;
        Sat, 22 Oct 2022 07:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424849;
        bh=okG/4qFfhpuVeMOdSWkHAOkH9AW4hZf9FC85j0+U+3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQMXbGJLrVirqdj8oYr3KfsKtT6XLovFnfQbgfynd0/a1XNLYzUPnsewSss0UFCHI
         7YEooSsWA3l5nAWK0ue7Fq7rwrhG+MGeP8xlTnHL3gkTt6eWSD9uRfXj1+BFyBjUAR
         xpDbTUsJHnlL5DcQNYuAE5pV5+q2YCpqe95grfdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 259/717] wifi: ath11k: fix failed to find the peer with peer_id 0 when disconnected
Date:   Sat, 22 Oct 2022 09:22:18 +0200
Message-Id: <20221022072500.528983268@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit a20ed60bb357776301c2dad7b4a4f0db97e143e9 ]

It has a fail log which is ath11k_dbg in ath11k_dp_rx_process_mon_status(),
as below, it will not print when debug_mask is not set ATH11K_DBG_DATA.
	ath11k_dbg(ab, ATH11K_DBG_DATA,
		  "failed to find the peer with peer_id %d\n",
		   ppdu_info.peer_id);

When run scan with station disconnected, the peer_id is 0 for case
HAL_RX_MPDU_START in ath11k_hal_rx_parse_mon_status_tlv() which called
from ath11k_dp_rx_process_mon_status(), and the peer_id of ppdu_info is
reset to 0 in the while loop, so it does not match condition of the
check "if (ppdu_info->peer_id == HAL_INVALID_PEERID" in the loop, and
then the log "failed to find the peer with peer_id 0" print after the
check in the loop, it is below call stack when debug_mask is set
ATH11K_DBG_DATA.

The reason is this commit 01d2f285e3e5 ("ath11k: decode HE status tlv")
add "memset(ppdu_info, 0, sizeof(struct hal_rx_mon_ppdu_info))" in
ath11k_dp_rx_process_mon_status(), but the commit does not initialize
the peer_id to HAL_INVALID_PEERID, then lead the check mis-match.

Callstack of the failed log:
[12335.689072] RIP: 0010:ath11k_dp_rx_process_mon_status+0x9ea/0x1020 [ath11k]
[12335.689157] Code: 89 ff e8 f9 10 00 00 be 01 00 00 00 4c 89 f7 e8 dc 4b 4e de 48 8b 85 38 ff ff ff c7 80 e4 07 00 00 01 00 00 00 e9 20 f8 ff ff <0f> 0b 41 0f b7 96 be 06 00 00 48 c7 c6 b8 50 44 c1 4c 89 ff e8 fd
[12335.689180] RSP: 0018:ffffb874001a4ca0 EFLAGS: 00010246
[12335.689210] RAX: 0000000000000000 RBX: ffff995642cbd100 RCX: 0000000000000000
[12335.689229] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff99564212cd18
[12335.689248] RBP: ffffb874001a4dc0 R08: 0000000000000001 R09: 0000000000000000
[12335.689268] R10: 0000000000000220 R11: ffffb874001a48e8 R12: ffff995642473d40
[12335.689286] R13: ffff99564212c5b8 R14: ffff9956424736a0 R15: ffff995642120000
[12335.689303] FS:  0000000000000000(0000) GS:ffff995739000000(0000) knlGS:0000000000000000
[12335.689323] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12335.689341] CR2: 00007f43c5d5e039 CR3: 000000011c012005 CR4: 00000000000606e0
[12335.689360] Call Trace:
[12335.689377]  <IRQ>
[12335.689418]  ? rcu_read_lock_held_common+0x12/0x50
[12335.689447]  ? rcu_read_lock_sched_held+0x25/0x80
[12335.689471]  ? rcu_read_lock_held_common+0x12/0x50
[12335.689504]  ath11k_dp_rx_process_mon_rings+0x8d/0x4f0 [ath11k]
[12335.689578]  ? ath11k_dp_rx_process_mon_rings+0x8d/0x4f0 [ath11k]
[12335.689653]  ? lock_acquire+0xef/0x360
[12335.689681]  ? rcu_read_lock_sched_held+0x25/0x80
[12335.689713]  ath11k_dp_service_mon_ring+0x38/0x60 [ath11k]
[12335.689784]  ? ath11k_dp_rx_process_mon_rings+0x4f0/0x4f0 [ath11k]
[12335.689860]  call_timer_fn+0xb2/0x2f0
[12335.689897]  ? ath11k_dp_rx_process_mon_rings+0x4f0/0x4f0 [ath11k]
[12335.689970]  run_timer_softirq+0x21f/0x540
[12335.689999]  ? ktime_get+0xad/0x160
[12335.690025]  ? lapic_next_deadline+0x2c/0x40
[12335.690053]  ? clockevents_program_event+0x82/0x100
[12335.690093]  __do_softirq+0x151/0x4a8
[12335.690135]  irq_exit_rcu+0xc9/0x100
[12335.690165]  sysvec_apic_timer_interrupt+0xa8/0xd0
[12335.690189]  </IRQ>
[12335.690204]  <TASK>
[12335.690225]  asm_sysvec_apic_timer_interrupt+0x12/0x20

Reset the default value to HAL_INVALID_PEERID each time after memset
of ppdu_info as well as others memset which existed in function
ath11k_dp_rx_process_mon_status(), then the failed log disappeared.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Fixes: 01d2f285e3e5 ("ath11k: decode HE status tlv")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220518033556.31940-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index b3e133add1ce..1459e3b1c4f5 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5194,7 +5194,8 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		if (log_type != ATH11K_PKTLOG_TYPE_INVALID)
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
-		memset(ppdu_info, 0, sizeof(struct hal_rx_mon_ppdu_info));
+		memset(ppdu_info, 0, sizeof(*ppdu_info));
+		ppdu_info->peer_id = HAL_INVALID_PEERID;
 		hal_status = ath11k_hal_rx_parse_mon_status(ab, ppdu_info, skb);
 
 		if (test_bit(ATH11K_FLAG_MONITOR_STARTED, &ar->monitor_flags) &&
-- 
2.35.1



