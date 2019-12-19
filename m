Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43BA126B51
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbfLSSzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbfLSSzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F0624683;
        Thu, 19 Dec 2019 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781738;
        bh=0Q7DYkjFvgj/gnox9xftAfBZ7CWvtlzuCzCkA4TTwhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUi9Xcq3Z+rAAkkcdtlSR3qGuB0a4rNTwTrNzsf97mWk5hcuWx44f/0pMYT9aKEqN
         /3Sxy3KdXQiB9NrD9+JuMflRolOMGYAaR38FoyqjUU6gPsUgu6P7Q6yhgy5rLCuknv
         tq+7zYcb12dz9Lyiibp2O9QHuVMH/rbVzfg3/AxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Thomas Abraham <tabraham@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 60/80] scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
Date:   Thu, 19 Dec 2019 19:34:52 +0100
Message-Id: <20191219183132.870287271@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

commit f2c9ee54a56995a293efef290657d8a1d80e14ab upstream.

If ABTS cannot be completed in target mode, the driver attempts to free
related management command and crashes:

  NIP [d000000019181ee8] tcm_qla2xxx_free_mcmd+0x40/0x80 [tcm_qla2xxx]
  LR [d00000001dc1e6f8] qlt_response_pkt+0x190/0xa10 [qla2xxx]
  Call Trace:
  [c000003fff27bb50] [c000003fff27bc10] 0xc000003fff27bc10 (unreliable)
  [c000003fff27bb70] [d00000001dc1e6f8] qlt_response_pkt+0x190/0xa10 [qla2xxx]
  [c000003fff27bc10] [d00000001dbc2be0] qla24xx_process_response_queue+0x5d8/0xbd0 [qla2xxx]
  [c000003fff27bd50] [d00000001dbc632c] qla24xx_msix_rsp_q+0x64/0x150 [qla2xxx]
  [c000003fff27bde0] [c000000000187200] __handle_irq_event_percpu+0x90/0x310
  [c000003fff27bea0] [c0000000001874b8] handle_irq_event_percpu+0x38/0x90
  [c000003fff27bee0] [c000000000187574] handle_irq_event+0x64/0xb0
  [c000003fff27bf10] [c00000000018cd38] handle_fasteoi_irq+0xe8/0x280
  [c000003fff27bf40] [c000000000185ccc] generic_handle_irq+0x4c/0x70
  [c000003fff27bf60] [c000000000016cec] __do_irq+0x7c/0x1d0
  [c000003fff27bf90] [c00000000002a530] call_do_irq+0x14/0x24
  [c00000207d2cba90] [c000000000016edc] do_IRQ+0x9c/0x130
  [c00000207d2cbae0] [c000000000008bf4] hardware_interrupt_common+0x114/0x120
  --- interrupt: 501 at arch_local_irq_restore+0x74/0x90
      LR = arch_local_irq_restore+0x74/0x90
  [c00000207d2cbdd0] [c0000000001c64fc] tick_broadcast_oneshot_control+0x4c/0x60 (unreliable)
  [c00000207d2cbdf0] [c0000000007ac840] cpuidle_enter_state+0xf0/0x450
  [c00000207d2cbe50] [c00000000016b81c] call_cpuidle+0x4c/0x90
  [c00000207d2cbe70] [c00000000016bc30] do_idle+0x2b0/0x330
  [c00000207d2cbec0] [c00000000016beec] cpu_startup_entry+0x3c/0x50
  [c00000207d2cbef0] [c00000000004a06c] start_secondary+0x63c/0x670
  [c00000207d2cbf90] [c00000000000aa6c] start_secondary_prolog+0x10/0x14

The crash can be triggered by ACL deletion when there's active I/O.

During ACL deletion, qla2xxx performs implicit LOGO that's invisible for
the initiator. Only the driver and firmware are aware of the logout.
Therefore the initiator continues to send SCSI commands and the target
always responds with SAM STATUS BUSY as it can't find the session.

The command times out after a while and initiator invokes ABORT TASK TMF
for the command. The TMF is mapped to ABTS-LS in FCP. The target can't find
session for S_ID originating ABTS-LS so it never allocates mcmd.  And since
N_Port handle was deleted after LOGO, it is no longer valid and ABTS
Response IOCB is returned from firmware with status 31. Then free_mcmd is
invoked on NULL pointer and the kernel crashes.

[ 7734.578642] qla2xxx [0000:00:0c.0]-e837:6: ABTS_RECV_24XX: instance 0
[ 7734.578644] qla2xxx [0000:00:0c.0]-f811:6: qla_target(0): task abort (s_id=1:2:0, tag=1209504, param=0)
[ 7734.578645] find_sess_by_s_id: 0x010200
[ 7734.578645] Unable to locate s_id: 0x010200
[ 7734.578646] qla2xxx [0000:00:0c.0]-f812:6: qla_target(0): task abort for non-existent session
[ 7734.578648] qla2xxx [0000:00:0c.0]-e806:6: Sending task mgmt ABTS response (ha=c0000000d5819000, atio=c0000000d3fd4700, status=4
[ 7734.578730] qla2xxx [0000:00:0c.0]-e838:6: ABTS_RESP_24XX: compl_status 31
[ 7734.578732] qla2xxx [0000:00:0c.0]-e863:6: qla_target(0): ABTS_RESP_24XX failed 31 (subcode 19:a)
[ 7734.578740] Unable to handle kernel paging request for data at address 0x00000200

Fixes: 6b0431d6fa20b ("scsi: qla2xxx: Fix out of order Termination and ABTS response")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Thomas Abraham <tabraham@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191125165702.1013-2-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -246,6 +246,8 @@ static void tcm_qla2xxx_complete_mcmd(st
  */
 static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 {
+	if (!mcmd)
+		return;
 	INIT_WORK(&mcmd->free_work, tcm_qla2xxx_complete_mcmd);
 	queue_work(tcm_qla2xxx_free_wq, &mcmd->free_work);
 }


