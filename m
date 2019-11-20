Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA010466B
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 23:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKTW1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 17:27:37 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51224 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfKTW1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 17:27:37 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 13218437F6;
        Wed, 20 Nov 2019 22:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1574288852; x=1576103253; bh=9fNV4bbeGM8GwuUw0Ic03IOWWS6vLEJ0/fd
        1qigtzgg=; b=K1NQ/5WrSuISYF4UYqMZxLLhKmUGabjJ0IsQCOfderBq/Oh6JGn
        dP2wIfF/6fK44HJCOBsvXQ1JzmOILFF00psAR3oIPBAN1/d8mDifDKSgfqKhe+e4
        0iw9ieOkHJEUJRjHcy/gFX0nGBzPYj38Q7MZvFeVlKy0oodV//OK12tE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 31vxLfNzJBaI; Thu, 21 Nov 2019 01:27:32 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EFAD342F10;
        Thu, 21 Nov 2019 01:27:31 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Nov 2019 01:27:31 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Thomas Abraham <tabraham@suse.com>, <stable@vger.kernel.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 01/15] scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
Date:   Thu, 21 Nov 2019 01:27:09 +0300
Message-ID: <20191120222723.27779-2-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
for the command. The TMF is mapped to ABTS-LS in FCP. The target can't
find session for S_ID originating ABTS-LS so it never allocates mcmd.
And since N_Port handle was deleted after LOGO, it is no longer valid
and ABTS Response IOCB is returned from firmware with status 31. Then
free_mcmd is invoked on NULL pointer and the kernel crashes.

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
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 042a24314edc..bab2073c1f72 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -246,6 +246,8 @@ static void tcm_qla2xxx_complete_mcmd(struct work_struct *work)
  */
 static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 {
+	if (!mcmd)
+		return;
 	INIT_WORK(&mcmd->free_work, tcm_qla2xxx_complete_mcmd);
 	queue_work(tcm_qla2xxx_free_wq, &mcmd->free_work);
 }
-- 
2.24.0

