Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9CD329001
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242432AbhCAUBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241926AbhCATuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:50:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69A8650E4;
        Mon,  1 Mar 2021 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621118;
        bh=CqPgv8u1H/D4I34kDA28iEycHWctJr2IkwLd3FoYtI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqs8FTkYDf1WxSKBlrOZhkMEUk4UJwy7yC55REjWETIHrM3djxIfOkrvteBQwqlad
         spNdhvNrFKPQ4VZgaewEcGERjBiURNi6U3+F0oo9oafiQ06hjwOADD7Cut0YM+B0sj
         M1j3zFpcEvwccYNZFndgVdIFTip7YOOY4vGfiLXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 370/775] scsi: isci: Pass gfp_t flags in isci_port_link_down()
Date:   Mon,  1 Mar 2021 17:08:58 +0100
Message-Id: <20210301161219.888346384@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit 885ab3b8926fdf9cdd7163dfad99deb9b0662b39 ]

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

sas_notify_phy_event() is exclusively called by isci_port_link_down().
Below is the context analysis for all of its call chains:

port.c: port_timeout(), atomic, timer callback                  (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> port_state_machine_change(..., SCI_PORT_FAILED)
    -> enter SCI port state: *SCI_PORT_FAILED*
      -> sci_port_failed_state_enter()
        -> isci_port_hard_reset_complete()
          -> isci_port_link_down()

port.c: isci_port_perform_hard_reset()
spin_lock_irqsave(isci_host::scic_lock, )
  -> port.c: sci_port_hard_reset(), atomic                      (*)
    -> phy.c: sci_phy_reset()
      -> sci_change_state(SCI_PHY_RESETTING)
        -> enter SCI PHY state: *SCI_PHY_RESETTING*
          -> sci_phy_resetting_state_enter()
            -> port.c: sci_port_deactivate_phy()
	      -> isci_port_link_down()

port.c: enter SCI port state: *SCI_PORT_READY*                  # Cont. from [1]
  -> sci_port_ready_state_enter()
    -> isci_port_hard_reset_complete()
      -> isci_port_link_down()

phy.c: enter SCI state: *SCI_PHY_STOPPED*                       # Cont. from [2]
  -> sci_phy_stopped_state_enter()
    -> host.c: sci_controller_link_down()
      -> ->link_down_handler()
      == port_config.c: sci_apc_agent_link_down()
        -> port.c: sci_port_remove_phy()
          -> sci_port_deactivate_phy()
            -> isci_port_link_down()
      == port_config.c: sci_mpc_agent_link_down()
        -> port.c: sci_port_link_down()
          -> sci_port_deactivate_phy()
            -> isci_port_link_down()

phy.c: enter SCI state: *SCI_PHY_STARTING*                      # Cont. from [3]
  -> sci_phy_starting_state_enter()
    -> host.c: sci_controller_link_down()
      -> ->link_down_handler()
      == port_config.c: sci_apc_agent_link_down()
        -> port.c: sci_port_remove_phy()
          -> isci_port_link_down()
      == port_config.c: sci_mpc_agent_link_down()
        -> port.c: sci_port_link_down()
          -> sci_port_deactivate_phy()
            -> isci_port_link_down()

[1] Call chains for 'enter SCI port state: *SCI_PORT_READY*'
------------------------------------------------------------

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
    -> port_config.c: sci_port_configuration_agent_initialize()
      -> sci_mpc_agent_validate_phy_configuration()
        -> port.c: sci_port_add_phy()
          -> sci_port_general_link_up_handler()
            -> port_state_machine_change(, SCI_PORT_READY)
              -> enter port state *SCI_PORT_READY*

host.c: isci_host_start()                                       (@)
spin_lock_irq(isci_host::scic_lock)
  -> host.c: sci_controller_start(), atomic                     (*)
    -> host.c: sci_port_start()
      -> port.c: port_state_machine_change(, SCI_PORT_READY)
        -> enter port state *SCI_PORT_READY*

port_config.c: apc_agent_timeout(), atomic, timer callback      (*)
  -> sci_apc_agent_configure_ports()
    -> port.c: sci_port_add_phy()
      -> sci_port_general_link_up_handler()
        -> port_state_machine_change(, SCI_PORT_READY)
          -> enter port state *SCI_PORT_READY*

port_config.c: mpc_agent_timeout(), atomic, timer callback      (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> ->link_up_handler()
  == port.c: sci_apc_agent_link_up()
    -> sci_port_general_link_up_handler()
      -> port_state_machine_change(, SCI_PORT_READY)
        -> enter port state *SCI_PORT_READY*
  == port.c: sci_mpc_agent_link_up()
    -> port.c: sci_port_link_up()
      -> sci_port_general_link_up_handler()
        -> port_state_machine_change(, SCI_PORT_READY)
          -> enter port state *SCI_PORT_READY*

phy.c: enter SCI state: SCI_PHY_SUB_FINAL                       # Cont. from [1A]
  -> sci_phy_starting_final_substate_enter()
    -> sci_change_state(SCI_PHY_READY)
      -> enter SCI state: *SCI_PHY_READY*
        -> sci_phy_ready_state_enter()
          -> host.c: sci_controller_link_up()
            -> port_agent.link_up_handler()
            == port_config.c: sci_apc_agent_link_up()
              -> port.c: sci_port_link_up()
                -> sci_port_general_link_up_handler()
                  -> port_state_machine_change(, SCI_PORT_READY)
                    -> enter port state *SCI_PORT_READY*
            == port_config.c: sci_mpc_agent_link_up()
              -> port.c: sci_port_link_up()
                -> sci_port_general_link_up_handler()
                  -> port_state_machine_change(, SCI_PORT_READY)
                    -> enter port state *SCI_PORT_READY*

[1A] Call chains for entering SCI state: *SCI_PHY_SUB_FINAL*
------------------------------------------------------------

host.c: power_control_timeout(), atomic, timer callback         (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> phy.c: sci_phy_consume_power_handler()
    -> phy.c: sci_change_state(SCI_PHY_SUB_FINAL)

host.c: sci_controller_error_handler(): atomic, irq handler     (*)
OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
  -> sci_controller_process_completions()
    -> sci_controller_unsolicited_frame()
      -> phy.c: sci_phy_frame_handler()
        -> sci_change_state(SCI_PHY_SUB_AWAIT_SAS_POWER)
          -> sci_phy_starting_await_sas_power_substate_enter()
            -> host.c: sci_controller_power_control_queue_insert()
              -> phy.c: sci_phy_consume_power_handler()
                -> sci_change_state(SCI_PHY_SUB_FINAL)
        -> sci_change_state(SCI_PHY_SUB_FINAL)
    -> sci_controller_event_completion()
      -> phy.c: sci_phy_event_handler()
        -> sci_phy_start_sata_link_training()
          -> sci_change_state(SCI_PHY_SUB_AWAIT_SATA_POWER)
            -> sci_phy_starting_await_sata_power_substate_enter
              -> host.c: sci_controller_power_control_queue_insert()
                -> phy.c: sci_phy_consume_power_handler()
                  -> sci_change_state(SCI_PHY_SUB_FINAL)

[2] Call chains for entering state: *SCI_PHY_STOPPED*
-----------------------------------------------------

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
      -> phy.c: sci_phy_initialize()
        -> phy.c: sci_phy_link_layer_initialization()
          -> phy.c: sci_change_state(SCI_PHY_STOPPED)

init.c: PCI ->remove() || PM_OPS ->suspend,  process context    (+)
  -> host.c: isci_host_deinit()
    -> sci_controller_stop_phys()
      -> phy.c: sci_phy_stop()
	-> sci_change_state(SCI_PHY_STOPPED)

phy.c: isci_phy_control()
spin_lock_irqsave(isci_host::scic_lock, )
  -> sci_phy_stop(), atomic                                     (*)
    -> sci_change_state(SCI_PHY_STOPPED)

[3] Call chains for entering state: *SCI_PHY_STARTING*
------------------------------------------------------

phy.c: phy_sata_timeout(), atimer, timer callback               (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> sci_change_state(SCI_PHY_STARTING)

host.c: phy_startup_timeout(), atomic, timer callback           (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> sci_controller_start_next_phy()
    -> sci_phy_start()
      -> sci_change_state(SCI_PHY_STARTING)

host.c: isci_host_start()                                       (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_start(), atomic                             (*)
    -> sci_controller_start_next_phy()
      -> sci_phy_start()
        -> sci_change_state(SCI_PHY_STARTING)

phy.c: Enter SCI state *SCI_PHY_SUB_FINAL*, atomic, check above (*)
  -> sci_change_state(SCI_PHY_SUB_FINAL)
    -> sci_phy_starting_final_substate_enter()
      -> sci_change_state(SCI_PHY_READY)
        -> Enter SCI state: *SCI_PHY_READY*
          -> sci_phy_ready_state_enter()
            -> host.c: sci_controller_link_up()
              -> sci_controller_start_next_phy()
                -> sci_phy_start()
                  -> sci_change_state(SCI_PHY_STARTING)

phy.c: sci_phy_event_handler(), atomic, discussed earlier       (*)
  -> sci_change_state(SCI_PHY_STARTING), 11 instances

phy.c: enter SCI state: *SCI_PHY_RESETTING*, atomic, discussed  (*)
  -> sci_phy_resetting_state_enter()
    -> sci_change_state(SCI_PHY_STARTING)

As can be seen from the "(*)" markers above, almost all the call-chains are
atomic. The only exception, marked with "(+)", is a PCI ->remove() and
PM_OPS ->suspend() cold path. Thus, pass GFP_ATOMIC to the libsas phy event
notifier.

Note, The now-replaced libsas APIs used in_interrupt() to implicitly decide
which memory allocation type to use.  This was only partially correct, as
it fails to choose the correct GFP flags when just preemption or interrupts
are disabled. Such buggy code paths are marked with "(@)" in the call
chains above.

Link: https://lore.kernel.org/r/20210118100955.1761652-6-a.darwish@linutronix.de
Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 8d93497380674..a3c58718c2600 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -269,8 +269,8 @@ static void isci_port_link_down(struct isci_host *isci_host,
 	 * isci_port_deformed and isci_dev_gone functions.
 	 */
 	sas_phy_disconnected(&isci_phy->sas_phy);
-	sas_notify_phy_event(&isci_phy->sas_phy,
-					   PHYE_LOSS_OF_SIGNAL);
+	sas_notify_phy_event_gfp(&isci_phy->sas_phy,
+				 PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_port = %p - Done\n", __func__, isci_port);
-- 
2.27.0



