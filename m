Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3011851A716
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbiEDRBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355471AbiEDRAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE194B423;
        Wed,  4 May 2022 09:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81002B827A4;
        Wed,  4 May 2022 16:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321EDC385A4;
        Wed,  4 May 2022 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683089;
        bh=fMMHIdAai6YpqHmwr7rcuXTI10q5GJyoB+IfV8UgYz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlfUTKsFflWTOE44nVq82f3CMC0E4fiCnsN1JObtdyuAikVgcI2VfOtWGzLgwq5T8
         iM00d2P8NQE7lnofgNXIm1cysR3xPIAMEOT3gRZoce1Du/g6shWT+vySBXt/Wd18SV
         nhRJQ5cKbO+Xm4jPskzpU25eYltygvJFUutCX2BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Christensen <drc@linux.vnet.ibm.com>,
        Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/129] bnx2x: fix napi API usage sequence
Date:   Wed,  4 May 2022 18:44:45 +0200
Message-Id: <20220504153028.316239959@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit af68656d66eda219b7f55ce8313a1da0312c79e1 ]

While handling PCI errors (AER flow) driver tries to
disable NAPI [napi_disable()] after NAPI is deleted
[__netif_napi_del()] which causes unexpected system
hang/crash.

System message log shows the following:
=======================================
[ 3222.537510] EEH: Detected PCI bus error on PHB#384-PE#800000 [ 3222.537511] EEH: This PCI device has failed 2 times in the last hour and will be permanently disabled after 5 failures.
[ 3222.537512] EEH: Notify device drivers to shutdown [ 3222.537513] EEH: Beginning: 'error_detected(IO frozen)'
[ 3222.537514] EEH: PE#800000 (PCI 0384:80:00.0): Invoking
bnx2x->error_detected(IO frozen)
[ 3222.537516] bnx2x: [bnx2x_io_error_detected:14236(eth14)]IO error detected [ 3222.537650] EEH: PE#800000 (PCI 0384:80:00.0): bnx2x driver reports:
'need reset'
[ 3222.537651] EEH: PE#800000 (PCI 0384:80:00.1): Invoking
bnx2x->error_detected(IO frozen)
[ 3222.537651] bnx2x: [bnx2x_io_error_detected:14236(eth13)]IO error detected [ 3222.537729] EEH: PE#800000 (PCI 0384:80:00.1): bnx2x driver reports:
'need reset'
[ 3222.537729] EEH: Finished:'error_detected(IO frozen)' with aggregate recovery state:'need reset'
[ 3222.537890] EEH: Collect temporary log [ 3222.583481] EEH: of node=0384:80:00.0 [ 3222.583519] EEH: PCI device/vendor: 168e14e4 [ 3222.583557] EEH: PCI cmd/status register: 00100140 [ 3222.583557] EEH: PCI-E capabilities and status follow:
[ 3222.583744] EEH: PCI-E 00: 00020010 012c8da2 00095d5e 00455c82 [ 3222.583892] EEH: PCI-E 10: 10820000 00000000 00000000 00000000 [ 3222.583893] EEH: PCI-E 20: 00000000 [ 3222.583893] EEH: PCI-E AER capability register set follows:
[ 3222.584079] EEH: PCI-E AER 00: 13c10001 00000000 00000000 00062030 [ 3222.584230] EEH: PCI-E AER 10: 00002000 000031c0 000001e0 00000000 [ 3222.584378] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000 [ 3222.584416] EEH: PCI-E AER 30: 00000000 00000000 [ 3222.584416] EEH: of node=0384:80:00.1 [ 3222.584454] EEH: PCI device/vendor: 168e14e4 [ 3222.584491] EEH: PCI cmd/status register: 00100140 [ 3222.584492] EEH: PCI-E capabilities and status follow:
[ 3222.584677] EEH: PCI-E 00: 00020010 012c8da2 00095d5e 00455c82 [ 3222.584825] EEH: PCI-E 10: 10820000 00000000 00000000 00000000 [ 3222.584826] EEH: PCI-E 20: 00000000 [ 3222.584826] EEH: PCI-E AER capability register set follows:
[ 3222.585011] EEH: PCI-E AER 00: 13c10001 00000000 00000000 00062030 [ 3222.585160] EEH: PCI-E AER 10: 00002000 000031c0 000001e0 00000000 [ 3222.585309] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000 [ 3222.585347] EEH: PCI-E AER 30: 00000000 00000000 [ 3222.586872] RTAS: event: 5, Type: Platform Error (224), Severity: 2 [ 3222.586873] EEH: Reset without hotplug activity [ 3224.762767] EEH: Beginning: 'slot_reset'
[ 3224.762770] EEH: PE#800000 (PCI 0384:80:00.0): Invoking
bnx2x->slot_reset()
[ 3224.762771] bnx2x: [bnx2x_io_slot_reset:14271(eth14)]IO slot reset initializing...
[ 3224.762887] bnx2x 0384:80:00.0: enabling device (0140 -> 0142) [ 3224.768157] bnx2x: [bnx2x_io_slot_reset:14287(eth14)]IO slot reset
--> driver unload

Uninterruptible tasks
=====================
crash> ps | grep UN
     213      2  11  c000000004c89e00  UN   0.0       0      0  [eehd]
     215      2   0  c000000004c80000  UN   0.0       0      0
[kworker/0:2]
    2196      1  28  c000000004504f00  UN   0.1   15936  11136  wickedd
    4287      1   9  c00000020d076800  UN   0.0    4032   3008  agetty
    4289      1  20  c00000020d056680  UN   0.0    7232   3840  agetty
   32423      2  26  c00000020038c580  UN   0.0       0      0
[kworker/26:3]
   32871   4241  27  c0000002609ddd00  UN   0.1   18624  11648  sshd
   32920  10130  16  c00000027284a100  UN   0.1   48512  12608  sendmail
   33092  32987   0  c000000205218b00  UN   0.1   48512  12608  sendmail
   33154   4567  16  c000000260e51780  UN   0.1   48832  12864  pickup
   33209   4241  36  c000000270cb6500  UN   0.1   18624  11712  sshd
   33473  33283   0  c000000205211480  UN   0.1   48512  12672  sendmail
   33531   4241  37  c00000023c902780  UN   0.1   18624  11648  sshd

EEH handler hung while bnx2x sleeping and holding RTNL lock
===========================================================
crash> bt 213
PID: 213    TASK: c000000004c89e00  CPU: 11  COMMAND: "eehd"
  #0 [c000000004d477e0] __schedule at c000000000c70808
  #1 [c000000004d478b0] schedule at c000000000c70ee0
  #2 [c000000004d478e0] schedule_timeout at c000000000c76dec
  #3 [c000000004d479c0] msleep at c0000000002120cc
  #4 [c000000004d479f0] napi_disable at c000000000a06448
                                        ^^^^^^^^^^^^^^^^
  #5 [c000000004d47a30] bnx2x_netif_stop at c0080000018dba94 [bnx2x]
  #6 [c000000004d47a60] bnx2x_io_slot_reset at c0080000018a551c [bnx2x]
  #7 [c000000004d47b20] eeh_report_reset at c00000000004c9bc
  #8 [c000000004d47b90] eeh_pe_report at c00000000004d1a8
  #9 [c000000004d47c40] eeh_handle_normal_event at c00000000004da64

And the sleeping source code
============================
crash> dis -ls c000000000a06448
FILE: ../net/core/dev.c
LINE: 6702

   6697  {
   6698          might_sleep();
   6699          set_bit(NAPI_STATE_DISABLE, &n->state);
   6700
   6701          while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
* 6702                  msleep(1);
   6703          while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
   6704                  msleep(1);
   6705
   6706          hrtimer_cancel(&n->timer);
   6707
   6708          clear_bit(NAPI_STATE_DISABLE, &n->state);
   6709  }

EEH calls into bnx2x twice based on the system log above, first through
bnx2x_io_error_detected() and then bnx2x_io_slot_reset(), and executes
the following call chains:

bnx2x_io_error_detected()
  +-> bnx2x_eeh_nic_unload()
       +-> bnx2x_del_all_napi()
            +-> __netif_napi_del()

bnx2x_io_slot_reset()
  +-> bnx2x_netif_stop()
       +-> bnx2x_napi_disable()
            +->napi_disable()

Fix this by correcting the sequence of NAPI APIs usage,
that is delete the NAPI after disabling it.

Fixes: 7fa6f34081f1 ("bnx2x: AER revised")
Reported-by: David Christensen <drc@linux.vnet.ibm.com>
Tested-by: David Christensen <drc@linux.vnet.ibm.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Link: https://lore.kernel.org/r/20220426153913.6966-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 6333471916be..afb6d3ee1f56 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14213,10 +14213,6 @@ static int bnx2x_eeh_nic_unload(struct bnx2x *bp)
 
 	/* Stop Tx */
 	bnx2x_tx_disable(bp);
-	/* Delete all NAPI objects */
-	bnx2x_del_all_napi(bp);
-	if (CNIC_LOADED(bp))
-		bnx2x_del_all_napi_cnic(bp);
 	netdev_reset_tc(bp->dev);
 
 	del_timer_sync(&bp->timer);
@@ -14321,6 +14317,11 @@ static pci_ers_result_t bnx2x_io_slot_reset(struct pci_dev *pdev)
 		bnx2x_drain_tx_queues(bp);
 		bnx2x_send_unload_req(bp, UNLOAD_RECOVERY);
 		bnx2x_netif_stop(bp, 1);
+		bnx2x_del_all_napi(bp);
+
+		if (CNIC_LOADED(bp))
+			bnx2x_del_all_napi_cnic(bp);
+
 		bnx2x_free_irq(bp);
 
 		/* Report UNLOAD_DONE to MCP */
-- 
2.35.1



