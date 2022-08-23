Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99259D884
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiHWJwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352079AbiHWJvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9339E2C1;
        Tue, 23 Aug 2022 01:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C2FAB81C5C;
        Tue, 23 Aug 2022 08:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AB2C433C1;
        Tue, 23 Aug 2022 08:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244265;
        bh=NlMeMbrGkxLWvMZrzHb+gQ5MshQVvwJITmy05HzkXG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHMSswSWZJF+dMZ2BALf4DWNMlcmNrfwyxz814ra0GYcIsZlV9UWq3z3meyW4AvIP
         TRXpdwSPf13rAqu64iPdThaOnIfNMdLg0YwFxXKVBpVRgudrCrFFCQqO4lg6gMaywZ
         X1ioJXeFGAwmTXI5N8rFoKJ15oyrAGU6n4215q1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 051/244] net: atlantic: fix aq_vec index out of range error
Date:   Tue, 23 Aug 2022 10:23:30 +0200
Message-Id: <20220823080100.767651306@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

commit 2ba5e47fb75fbb8fab45f5c1bc8d5c33d8834bd3 upstream.

The final update statement of the for loop exceeds the array range, the
dereference of self->aq_vec[i] is not checked and then leads to the
index out of range error.
Also fixed this kind of coding style in other for loop.

[   97.937604] UBSAN: array-index-out-of-bounds in drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1404:48
[   97.937607] index 8 is out of range for type 'aq_vec_s *[8]'
[   97.937608] CPU: 38 PID: 3767 Comm: kworker/u256:18 Not tainted 5.19.0+ #2
[   97.937610] Hardware name: Dell Inc. Precision 7865 Tower/, BIOS 1.0.0 06/12/2022
[   97.937611] Workqueue: events_unbound async_run_entry_fn
[   97.937616] Call Trace:
[   97.937617]  <TASK>
[   97.937619]  dump_stack_lvl+0x49/0x63
[   97.937624]  dump_stack+0x10/0x16
[   97.937626]  ubsan_epilogue+0x9/0x3f
[   97.937627]  __ubsan_handle_out_of_bounds.cold+0x44/0x49
[   97.937629]  ? __scm_send+0x348/0x440
[   97.937632]  ? aq_vec_stop+0x72/0x80 [atlantic]
[   97.937639]  aq_nic_stop+0x1b6/0x1c0 [atlantic]
[   97.937644]  aq_suspend_common+0x88/0x90 [atlantic]
[   97.937648]  aq_pm_suspend_poweroff+0xe/0x20 [atlantic]
[   97.937653]  pci_pm_suspend+0x7e/0x1a0
[   97.937655]  ? pci_pm_suspend_noirq+0x2b0/0x2b0
[   97.937657]  dpm_run_callback+0x54/0x190
[   97.937660]  __device_suspend+0x14c/0x4d0
[   97.937661]  async_suspend+0x23/0x70
[   97.937663]  async_run_entry_fn+0x33/0x120
[   97.937664]  process_one_work+0x21f/0x3f0
[   97.937666]  worker_thread+0x4a/0x3c0
[   97.937668]  ? process_one_work+0x3f0/0x3f0
[   97.937669]  kthread+0xf0/0x120
[   97.937671]  ? kthread_complete_and_exit+0x20/0x20
[   97.937672]  ret_from_fork+0x22/0x30
[   97.937676]  </TASK>

v2. fixed "warning: variable 'aq_vec' set but not used"

v3. simplified a for loop

Fixes: 97bde5c4f909 ("net: ethernet: aquantia: Support for NIC-specific code")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Link: https://lore.kernel.org/r/20220808081845.42005-1-acelan.kao@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -265,12 +265,10 @@ static void aq_nic_service_timer_cb(stru
 static void aq_nic_polling_timer_cb(struct timer_list *t)
 {
 	struct aq_nic_s *self = from_timer(self, t, polling_timer);
-	struct aq_vec_s *aq_vec = NULL;
 	unsigned int i = 0U;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_isr(i, (void *)aq_vec);
+	for (i = 0U; self->aq_vecs > i; ++i)
+		aq_vec_isr(i, (void *)self->aq_vec[i]);
 
 	mod_timer(&self->polling_timer, jiffies +
 		  AQ_CFG_POLLING_TIMER_INTERVAL);
@@ -872,7 +870,6 @@ int aq_nic_get_regs_count(struct aq_nic_
 
 u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 {
-	struct aq_vec_s *aq_vec = NULL;
 	struct aq_stats_s *stats;
 	unsigned int count = 0U;
 	unsigned int i = 0U;
@@ -922,11 +919,11 @@ u64 *aq_nic_get_stats(struct aq_nic_s *s
 	data += i;
 
 	for (tc = 0U; tc < self->aq_nic_cfg.tcs; tc++) {
-		for (i = 0U, aq_vec = self->aq_vec[0];
-		     aq_vec && self->aq_vecs > i;
-		     ++i, aq_vec = self->aq_vec[i]) {
+		for (i = 0U; self->aq_vecs > i; ++i) {
+			if (!self->aq_vec[i])
+				break;
 			data += count;
-			count = aq_vec_get_sw_stats(aq_vec, tc, data);
+			count = aq_vec_get_sw_stats(self->aq_vec[i], tc, data);
 		}
 	}
 
@@ -1240,7 +1237,6 @@ int aq_nic_set_loopback(struct aq_nic_s
 
 int aq_nic_stop(struct aq_nic_s *self)
 {
-	struct aq_vec_s *aq_vec = NULL;
 	unsigned int i = 0U;
 
 	netif_tx_disable(self->ndev);
@@ -1258,9 +1254,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 
 	aq_ptp_irq_free(self);
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_stop(aq_vec);
+	for (i = 0U; self->aq_vecs > i; ++i)
+		aq_vec_stop(self->aq_vec[i]);
 
 	aq_ptp_ring_stop(self);
 


