Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3E329006
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhCAUBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237516AbhCATu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10F83650E6;
        Mon,  1 Mar 2021 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621123;
        bh=4xbMnbAJE7QS6XE+DAYYuCzNzbgB8ye70JQeY7f3cFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdUDOwOK44wAEzbE8M5XL9rKSVLeNc2FZNoshMor3tztw+NTs+lhM7OQLdDWGZi/F
         COomBtPm8zVm5s6JvNqNbQw6wnYlGMnaRNfqcQkrCu9pD6pOleZBnT+AtxnSiY/WcU
         P7ApYAsDSyVyWQMcTECH/c8u9lsC3CC0trq9t7S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 372/775] scsi: isci: Pass gfp_t flags in isci_port_bc_change_received()
Date:   Mon,  1 Mar 2021 17:09:00 +0100
Message-Id: <20210301161219.988409881@linuxfoundation.org>
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

[ Upstream commit 71dca5539fcf977aead0c9ea1962e70e78484b8e ]

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

libsas sas_notify_port_event() is called from
isci_port_bc_change_received(). Below is the context analysis for all of
its call chains:

host.c: sci_controller_error_handler(): atomic, irq handler     (*)
OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
  -> sci_controller_process_completions()
    -> sci_controller_event_completion()
      -> phy.c: sci_phy_event_handler()
        -> port.c: sci_port_broadcast_change_received()
          -> isci_port_bc_change_received()

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
    -> port_config.c: sci_port_configuration_agent_initialize()
      -> sci_mpc_agent_validate_phy_configuration()
        -> port.c: sci_port_add_phy()
          -> sci_port_set_phy()
            -> phy.c: sci_phy_set_port()
              -> port.c: sci_port_broadcast_change_received()
                -> isci_port_bc_change_received()

port_config.c: apc_agent_timeout(), atomic, timer callback      (*)
  -> sci_apc_agent_configure_ports()
    -> port.c: sci_port_add_phy()
      -> sci_port_set_phy()
        -> phy.c: sci_phy_set_port()
          -> port.c: sci_port_broadcast_change_received()
            -> isci_port_bc_change_received()

phy.c: enter SCI state: *SCI_PHY_STOPPED*                       # Cont. from [1]
  -> sci_phy_stopped_state_enter()
    -> host.c: sci_controller_link_down()
      -> ->link_down_handler()
      == port_config.c: sci_apc_agent_link_down()
        -> port.c: sci_port_remove_phy()
          -> sci_port_clear_phy()
            -> phy.c: sci_phy_set_port()
              -> port.c: sci_port_broadcast_change_received()
                -> isci_port_bc_change_received()

phy.c: enter SCI state: *SCI_PHY_STARTING*                      # Cont. from [2]
  -> sci_phy_starting_state_enter()
    -> host.c: sci_controller_link_down()
      -> ->link_down_handler()
      == port_config.c: sci_apc_agent_link_down()
        -> port.c: sci_port_remove_phy()
          -> sci_port_clear_phy()
            -> phy.c: sci_phy_set_port()
              -> port.c: sci_port_broadcast_change_received()
                -> isci_port_bc_change_received()

[1] Call chains for entering state: *SCI_PHY_STOPPED*
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

[2] Call chains for entering state: *SCI_PHY_STARTING*
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

phy.c: Enter SCI state *SCI_PHY_SUB_FINAL*                      # Cont. from [2A]
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

port.c: isci_port_perform_hard_reset()
spin_lock_irqsave(isci_host::scic_lock, )
  -> port.c: sci_port_hard_reset(), atomic                      (*)
    -> phy.c: sci_phy_reset()
      -> sci_change_state(SCI_PHY_RESETTING)
        -> enter SCI PHY state: *SCI_PHY_RESETTING*
          -> sci_phy_resetting_state_enter()
            -> sci_change_state(SCI_PHY_STARTING)

[2A] Call chains for entering SCI state: *SCI_PHY_SUB_FINAL*
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

As can be seen from the "(*)" markers above, almost all the call-chains are
atomic. The only exception, marked with "(+)", is a PCI ->remove() and
PM_OPS ->suspend() cold path. Thus, pass GFP_ATOMIC to the libsas port
event notifier.

Note, the now-replaced libsas APIs used in_interrupt() to implicitly decide
which memory allocation type to use.  This was only partially correct, as
it fails to choose the correct GFP flags when just preemption or interrupts
are disabled. Such buggy code paths are marked with "(@)" in the call
chains above.

Link: https://lore.kernel.org/r/20210118100955.1761652-8-a.darwish@linutronix.de
Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 10136ae466e20..e50c3b0deeb30 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -164,7 +164,8 @@ static void isci_port_bc_change_received(struct isci_host *ihost,
 		"%s: isci_phy = %p, sas_phy = %p\n",
 		__func__, iphy, &iphy->sas_phy);
 
-	sas_notify_port_event(&iphy->sas_phy, PORTE_BROADCAST_RCVD);
+	sas_notify_port_event_gfp(&iphy->sas_phy,
+				  PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 	sci_port_bcn_enable(iport);
 }
 
-- 
2.27.0



