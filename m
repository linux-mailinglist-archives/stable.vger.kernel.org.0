Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF2A1D8753
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgERSdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:33:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:52756 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728490AbgERSdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:33:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DEB5E4C667;
        Mon, 18 May 2020 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1589826786; x=
        1591641187; bh=5veyLmE+XwlS6sb+AeD6bFUjXEVExdI2mtSwN4PL/P0=; b=o
        aWC7UelGUiQ5XJmzXZZjr6S/pJRGkNtROZ3e9JfhowuWzPuhIrj7+HQ+h51X3Tnh
        sxlyo5U2OuWbsrYuglJcIUp0zTEMlMJ7o8BbqPw8BvcfwC0tpVakH23cu50yf2j6
        KQD/EGC2cf0acgfnFN1s7AijEE4tpUAx4uzquGpvJM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OoTef8jXwn9X; Mon, 18 May 2020 21:33:06 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A20D04128B;
        Mon, 18 May 2020 21:33:05 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 18
 May 2020 21:33:07 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>, <stable@vger.kernel.org>
Subject: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
Date:   Mon, 18 May 2020 21:31:42 +0300
Message-ID: <20200518183141.66621-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver performs SCR (state change registration) in all modes
including pure target mode.

For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for the
port mentioned in the RSCN and fabric rescan is scheduled. During the
rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of
the port that caused the RSCN.

In target mode, the session deletion has an impact on ATIO handler,
qlt_24xx_atio_pkt(). Target responds with SAM STATUS BUSY to I/O
incoming from the deleted session. qlt_handle_cmd_for_atio() and
qlt_handle_task_mgmt() return -EFAULT if they are not able to find
session of the command/TMF, and that results in invocation of
qlt_send_busy():

  qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0014
  qla_target(0): Unable to send command to target, sending BUSY status

Such response causes command timeout on the initiator. Error handler
thread on the initiator will be spawned to abort the commands:

  scsi 23:0:0:0: tag#0 abort scheduled
  scsi 23:0:0:0: tag#0 aborting command
  qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
  qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=23:0:0 -- 0 2003.

Command abort is rejected by target and fails (2003), error handler then
tries to perform DEVICE RESET and TARGET RESET but they're also doomed
to fail because TMFs are ignored for the deleted sessions.

Then initiator makes BUS RESET that resets the link via
qla2x00_full_login_lip(). BUS RESET succeeds and brings initiator port
up, SAN switch detects that and sends RSCN to the target port and it
fails again the same way as described above. It never goes out of the
loop.

The change breaks the RSCN loop by keeping initiator sessions mentioned
in RSCN payload in all modes, including dual and pure target mode.

Fixes: 2037ce49d30a ("scsi: qla2xxx: Fix stale session")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Hi Martin,

Please apply the patch to scsi-fixes/5.7 at your earliest convenience.

qla2xxx in target and, likely, dual mode is unusable in some SAN fabrics
due to the bug.

Thanks,
Roman

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 42c3ad27f1cb..b9955af5cffe 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3495,8 +3495,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			if ((fcport->flags & FCF_FABRIC_DEVICE) == 0) {
 				qla2x00_clear_loop_id(fcport);
 				fcport->flags |= FCF_FABRIC_DEVICE;
-			} else if (fcport->d_id.b24 != rp->id.b24 ||
-				fcport->scan_needed) {
+			} else if ((fcport->d_id.b24 != rp->id.b24 ||
+				    fcport->scan_needed) &&
+				   (fcport->port_type != FCT_INITIATOR &&
+				    fcport->port_type != FCT_NVME_INITIATOR)) {
 				qlt_schedule_sess_for_deletion(fcport);
 			}
 			fcport->d_id.b24 = rp->id.b24;
-- 
2.26.1

