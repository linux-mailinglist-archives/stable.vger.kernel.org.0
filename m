Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71563DD2E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiK3SZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiK3SZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:25:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CD52A2
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:25:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE471CE1ACC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64006C433C1;
        Wed, 30 Nov 2022 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832702;
        bh=0ZHV+9l9OhxYPg8aN2RGFzR6nI4XMLrSPqhlNuLZQRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EA0hBozsa+MM/0XjG9PwLm+jXxg+DqxKme+B6n1sqxmAYwk9u/bM8i7JEK2G9zaKG
         gVspAEptHVTe0kZIwrc0/guRukqcIJCThOkxZFaXw0cyf1fnFyASjxGYntLAZPhqCt
         VzmLBQZTfU70fsqaLo0JrajIrCl3zPkkEMuJQ3A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Niklas Cassel <niklas.cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/162] ata: libata-core: do not issue non-internal commands once EH is pending
Date:   Wed, 30 Nov 2022 19:21:24 +0100
Message-Id: <20221130180528.569878531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit e20e81a24a4d58744a29715aac2f795cd1651955 ]

While the ATA specification states that a device should return command
aborted for all commands queued after the device has entered error state,
since ATA only keeps the sense data for the latest command (in non-NCQ
case), we really don't want to send block layer commands to the device
after it has entered error state. (Only ATA EH commands should be sent,
to read the sense data etc.)

Currently, scsi_queue_rq() will check if scsi_host_in_recovery()
(state is SHOST_RECOVERY), and if so, it will _not_ issue a command via:
scsi_dispatch_cmd() -> host->hostt->queuecommand() (ata_scsi_queuecmd())
-> __ata_scsi_queuecmd() -> ata_scsi_translate() -> ata_qc_issue()

Before commit e494f6a72839 ("[SCSI] improved eh timeout handler"),
when receiving a TFES error IRQ, the call chain looked like this:
ahci_error_intr() -> ata_port_abort() -> ata_do_link_abort() ->
ata_qc_complete() -> ata_qc_schedule_eh() -> blk_abort_request() ->
blk_rq_timed_out() -> q->rq_timed_out_fn() (scsi_times_out()) ->
scsi_eh_scmd_add() -> scsi_host_set_state(shost, SHOST_RECOVERY)

Which meant that as soon as an error IRQ was serviced, SHOST_RECOVERY
would be set.

However, after commit e494f6a72839 ("[SCSI] improved eh timeout handler"),
scsi_times_out() will instead call scsi_abort_command() which will queue
delayed work, and the worker function scmd_eh_abort_handler() will call
scsi_eh_scmd_add(), which calls scsi_host_set_state(shost, SHOST_RECOVERY).

So now, after the TFES error IRQ has been serviced, we need to wait for
the SCSI workqueue to run its work before SHOST_RECOVERY gets set.

It is worth noting that, even before commit e494f6a72839 ("[SCSI] improved
eh timeout handler"), we could receive an error IRQ from the time when
scsi_queue_rq() checks scsi_host_in_recovery(), to the time when
ata_scsi_queuecmd() is actually called.

In order to handle both the delayed setting of SHOST_RECOVERY and the
window where we can receive an error IRQ, add a check against
ATA_PFLAG_EH_PENDING (which gets set when servicing the error IRQ),
inside ata_scsi_queuecmd() itself, while holding the ap->lock.
(Since the ap->lock is held while servicing IRQs.)

Fixes: e494f6a72839 ("[SCSI] improved eh timeout handler")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Tested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 70744439359d..f1755efd30a2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4032,9 +4032,19 @@ void ata_scsi_dump_cdb(struct ata_port *ap, struct scsi_cmnd *cmd)
 
 int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	u8 scsi_op = scmd->cmnd[0];
 	ata_xlat_func_t xlat_func;
 
+	/*
+	 * scsi_queue_rq() will defer commands if scsi_host_in_recovery().
+	 * However, this check is done without holding the ap->lock (a libata
+	 * specific lock), so we can have received an error irq since then,
+	 * therefore we must check if EH is pending, while holding ap->lock.
+	 */
+	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS))
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
 	if (unlikely(!scmd->cmd_len))
 		goto bad_cdb_len;
 
-- 
2.35.1



