Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BBB4F2B4E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350337AbiDEJ50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343958AbiDEJQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14592D4CBA;
        Tue,  5 Apr 2022 02:02:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 848D1CE1C72;
        Tue,  5 Apr 2022 09:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C60C385A0;
        Tue,  5 Apr 2022 09:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149324;
        bh=wFerTDonqlQrjFBy86pIXwyT/HhxOYMYxgYIiyjjPUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXnjIiaHADnHX5Smd7kVLdnN8AtaPltmI1XwDz/oJ/J3x+15D1OBSRLrgSGoQuzjG
         ZqVeAvIDyEHlH8KYripBHTog7mrMgkay81oSqOzy31egrDlXEiBop8A01NGvsFKJNZ
         ZWbUtwFR8yl9Yq4VrzguZMZ02A1RZLDIuEMZvIqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0637/1017] ice: fix scheduling while atomic on aux critical err interrupt
Date:   Tue,  5 Apr 2022 09:25:50 +0200
Message-Id: <20220405070413.191671055@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit 32d53c0aa3a7b727243473949bad2a830b908edc ]

There's a kernel BUG splat on processing aux critical error
interrupts in ice_misc_intr():

[ 2100.917085] BUG: scheduling while atomic: swapper/15/0/0x00010000
...
[ 2101.060770] Call Trace:
[ 2101.063229]  <IRQ>
[ 2101.065252]  dump_stack+0x41/0x60
[ 2101.068587]  __schedule_bug.cold.100+0x4c/0x58
[ 2101.073060]  __schedule+0x6a4/0x830
[ 2101.076570]  schedule+0x35/0xa0
[ 2101.079727]  schedule_preempt_disabled+0xa/0x10
[ 2101.084284]  __mutex_lock.isra.7+0x310/0x420
[ 2101.088580]  ? ice_misc_intr+0x201/0x2e0 [ice]
[ 2101.093078]  ice_send_event_to_aux+0x25/0x70 [ice]
[ 2101.097921]  ice_misc_intr+0x220/0x2e0 [ice]
[ 2101.102232]  __handle_irq_event_percpu+0x40/0x180
[ 2101.106965]  handle_irq_event_percpu+0x30/0x80
[ 2101.111434]  handle_irq_event+0x36/0x53
[ 2101.115292]  handle_edge_irq+0x82/0x190
[ 2101.119148]  handle_irq+0x1c/0x30
[ 2101.122480]  do_IRQ+0x49/0xd0
[ 2101.125465]  common_interrupt+0xf/0xf
[ 2101.129146]  </IRQ>
...

As Andrew correctly mentioned previously[0], the following call
ladder happens:

ice_misc_intr() <- hardirq
  ice_send_event_to_aux()
    device_lock()
      mutex_lock()
        might_sleep()
          might_resched() <- oops

Add a new PF state bit which indicates that an aux critical error
occurred and serve it in ice_service_task() in process context.
The new ice_pf::oicr_err_reg is read-write in both hardirq and
process contexts, but only 3 bits of non-critical data probably
aren't worth explicit synchronizing (and they're even in the same
byte [31:24]).

[0] https://lore.kernel.org/all/YeSRUVmrdmlUXHDn@lunn.ch

Fixes: 348048e724a0e ("ice: Implement iidc operations")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Michal Kubiak <michal.kubiak@intel.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 25 ++++++++++++++---------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8093346f163b..240b4c461d9c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -290,6 +290,7 @@ enum ice_pf_state {
 	ICE_LINK_DEFAULT_OVERRIDE_PENDING,
 	ICE_PHY_INIT_COMPLETE,
 	ICE_FD_VF_FLUSH_CTX,		/* set at FD Rx IRQ or timeout */
+	ICE_AUX_ERR_PENDING,
 	ICE_STATE_NBITS		/* must be last */
 };
 
@@ -557,6 +558,7 @@ struct ice_pf {
 	wait_queue_head_t reset_wait_queue;
 
 	u32 hw_csum_rx_error;
+	u32 oicr_err_reg;
 	u16 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u16 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
 	u16 max_pf_txqs;	/* Total Tx queues PF wide */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b449b3408a1c..523877c2f8b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2237,6 +2237,19 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	if (test_and_clear_bit(ICE_AUX_ERR_PENDING, pf->state)) {
+		struct iidc_event *event;
+
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (event) {
+			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
+			/* report the entire OICR value to AUX driver */
+			swap(event->reg, pf->oicr_err_reg);
+			ice_send_event_to_aux(pf, event);
+			kfree(event);
+		}
+	}
+
 	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
 		/* Plug aux device per request */
 		ice_plug_aux_dev(pf);
@@ -3023,17 +3036,9 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 #define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
 	if (oicr & ICE_AUX_CRIT_ERR) {
-		struct iidc_event *event;
-
+		pf->oicr_err_reg |= oicr;
+		set_bit(ICE_AUX_ERR_PENDING, pf->state);
 		ena_mask &= ~ICE_AUX_CRIT_ERR;
-		event = kzalloc(sizeof(*event), GFP_ATOMIC);
-		if (event) {
-			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
-			/* report the entire OICR value to AUX driver */
-			event->reg = oicr;
-			ice_send_event_to_aux(pf, event);
-			kfree(event);
-		}
 	}
 
 	/* Report any remaining unexpected interrupts */
-- 
2.34.1



