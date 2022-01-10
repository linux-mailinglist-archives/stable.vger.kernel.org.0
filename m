Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D72489156
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbiAJHbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58502 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbiAJH3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07E25B81215;
        Mon, 10 Jan 2022 07:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3AEC36AE9;
        Mon, 10 Jan 2022 07:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799740;
        bh=FMcC811dLrfa+pEL4aeEAecmD3gp+jbs0tlpxKta/6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3SnN1thXB7qY7L5+vq0HbW8ermmcP6VP715bhRpnU+MSYyXitpOd+VrQyXz9NHmG
         RZfeaSvY1ipcs3GH+XeQM/NXaWwAMEvA2GwokWyJpuON1QDeoYAEIdBahEk801KYC0
         nqe/+2Oojin2hra3JLQ0coT+L9Vy53TD3PaToxSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zekun Shen <bruceshenzk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/34] atlantic: Fix buff_ring OOB in aq_ring_rx_clean
Date:   Mon, 10 Jan 2022 08:23:28 +0100
Message-Id: <20220110071816.794916416@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 5f50153288452e10b6edd69ec9112c49442b054a ]

The function obtain the next buffer without boundary check.
We should return with I/O error code.

The bug is found by fuzzing and the crash report is attached.
It is an OOB bug although reported as use-after-free.

[    4.804724] BUG: KASAN: use-after-free in aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.805661] Read of size 4 at addr ffff888034fe93a8 by task ksoftirqd/0/9
[    4.806505]
[    4.806703] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.6.0 #34
[    4.809030] Call Trace:
[    4.809343]  dump_stack+0x76/0xa0
[    4.809755]  print_address_description.constprop.0+0x16/0x200
[    4.810455]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.811234]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.813183]  __kasan_report.cold+0x37/0x7c
[    4.813715]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.814393]  kasan_report+0xe/0x20
[    4.814837]  aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.815499]  ? hw_atl_b0_hw_ring_rx_receive+0x9a5/0xb90 [atlantic]
[    4.816290]  aq_vec_poll+0x179/0x5d0 [atlantic]
[    4.816870]  ? _GLOBAL__sub_I_65535_1_aq_pci_func_init+0x20/0x20 [atlantic]
[    4.817746]  ? __next_timer_interrupt+0xba/0xf0
[    4.818322]  net_rx_action+0x363/0xbd0
[    4.818803]  ? call_timer_fn+0x240/0x240
[    4.819302]  ? __switch_to_asm+0x40/0x70
[    4.819809]  ? napi_busy_loop+0x520/0x520
[    4.820324]  __do_softirq+0x18c/0x634
[    4.820797]  ? takeover_tasklets+0x5f0/0x5f0
[    4.821343]  run_ksoftirqd+0x15/0x20
[    4.821804]  smpboot_thread_fn+0x2f1/0x6b0
[    4.822331]  ? smpboot_unregister_percpu_thread+0x160/0x160
[    4.823041]  ? __kthread_parkme+0x80/0x100
[    4.823571]  ? smpboot_unregister_percpu_thread+0x160/0x160
[    4.824301]  kthread+0x2b5/0x3b0
[    4.824723]  ? kthread_create_on_node+0xd0/0xd0
[    4.825304]  ret_from_fork+0x35/0x40

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 03821b46a8cb4..4c22f119ac62f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -305,6 +305,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		if (!buff->is_eop) {
 			buff_ = buff;
 			do {
+				if (buff_->next >= self->size) {
+					err = -EIO;
+					goto err_exit;
+				}
 				next_ = buff_->next,
 				buff_ = &self->buff_ring[next_];
 				is_rsc_completed =
@@ -327,6 +331,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			if (buff->is_error || buff->is_cso_err) {
 				buff_ = buff;
 				do {
+					if (buff_->next >= self->size) {
+						err = -EIO;
+						goto err_exit;
+					}
 					next_ = buff_->next,
 					buff_ = &self->buff_ring[next_];
 
-- 
2.34.1



