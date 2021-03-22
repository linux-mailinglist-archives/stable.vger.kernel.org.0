Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1507F344257
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhCVMkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhCVMjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AF32619A6;
        Mon, 22 Mar 2021 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416689;
        bh=p6MJmlwuXbJfeo71UsxKsr27MR4cdDnLo9GEJukhIB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMbF0jIRaZ0SlitEuMikn2PYoPU+5DJj+LXYwEqsTMq2O2T05KvxyCHKL+g2iRy8X
         hIF0+4CoDNfuuRp8cajdyz5SpAT6wcWUU8xE+F2v/bRj9FJQFDFLyOh+AFgxM7DZmC
         kuTzeYqirdl5/gHUgza+v8RQ42rU7MpP6BQZIIxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/157] scsi: isci: Pass gfp_t flags in isci_port_link_up()
Date:   Mon, 22 Mar 2021 13:27:20 +0100
Message-Id: <20210322121936.426090340@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit 5ce7902902adb8d154d67ba494f06daa29360ef0 ]

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

libsas sas_notify_port_event() is called from isci_port_link_up().  Below
is the context analysis for all of its call chains:

host.c: isci_host_init()                                        (@)
spin_lock_irq(isci_host::scic_lock)
  -> sci_controller_initialize(), atomic                        (*)
    -> port_config.c: sci_port_configuration_agent_initialize()
      -> sci_mpc_agent_validate_phy_configuration()
        -> port.c: sci_port_add_phy()
          -> sci_port_general_link_up_handler()
            -> sci_port_activate_phy()
              -> isci_port_link_up()

port_config.c: apc_agent_timeout(), atomic, timer callback      (*)
  -> sci_apc_agent_configure_ports()
    -> port.c: sci_port_add_phy()
      -> sci_port_general_link_up_handler()
        -> sci_port_activate_phy()
          -> isci_port_link_up()

phy.c: enter SCI state: *SCI_PHY_SUB_FINAL*                     # Cont. from [1]
  -> phy.c: sci_phy_starting_final_substate_enter()
    -> phy.c: sci_change_state(SCI_PHY_READY)
      -> enter SCI state: *SCI_PHY_READY*
        -> phy.c: sci_phy_ready_state_enter()
          -> host.c: sci_controller_link_up()
            -> .link_up_handler()
            == port_config.c: sci_apc_agent_link_up()
              -> port.c: sci_port_link_up()
                -> (continue at [A])
            == port_config.c: sci_mpc_agent_link_up()
	      -> port.c: sci_port_link_up()
                -> (continue at [A])

port_config.c: mpc_agent_timeout(), atomic, timer callback      (*)
spin_lock_irqsave(isci_host::scic_lock, )
  -> ->link_up_handler()
  == port_config.c: sci_apc_agent_link_up()
    -> port.c: sci_port_link_up()
      -> (continue at [A])
  == port_config.c: sci_mpc_agent_link_up()
    -> port.c: sci_port_link_up()
      -> (continue at [A])

[A] port.c: sci_port_link_up()
  -> sci_port_activate_phy()
    -> isci_port_link_up()
  -> sci_port_general_link_up_handler()
    -> sci_port_activate_phy()
      -> isci_port_link_up()

[1] Call chains for entering SCI state: *SCI_PHY_SUB_FINAL*
-----------------------------------------------------------

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

As can be seen from the "(*)" markers above, all the call-chains are
atomic.  Pass GFP_ATOMIC to libsas port event notifier.

Note, the now-replaced libsas APIs used in_interrupt() to implicitly decide
which memory allocation type to use.  This was only partially correct, as
it fails to choose the correct GFP flags when just preemption or interrupts
are disabled. Such buggy code paths are marked with "(@)" in the call
chains above.

Link: https://lore.kernel.org/r/20210118100955.1761652-7-a.darwish@linutronix.de
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
index a3c58718c260..10136ae466e2 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -223,7 +223,8 @@ static void isci_port_link_up(struct isci_host *isci_host,
 	/* Notify libsas that we have an address frame, if indeed
 	 * we've found an SSP, SMP, or STP target */
 	if (success)
-		sas_notify_port_event(&iphy->sas_phy, PORTE_BYTES_DMAED);
+		sas_notify_port_event_gfp(&iphy->sas_phy,
+					  PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 
-- 
2.30.1



