Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE7126B92
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbfLSSzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730699AbfLSSzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2896224692;
        Thu, 19 Dec 2019 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781740;
        bh=TZK9qfo0DzdmFZOVWpiZoY7z4vgGJN+XeFnk4PmuS6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wapQJPotLrz6z7DOljKjpt473psWdCwRPJ3K1b3Febh3ybfE6El+6I+z1kWbmlaTb
         p4PJ2ePVNIaGAWJJSsTEj+HbNbWH2vdwNK1SOb+a0MhcyRP1D9JnzuypsoRidbXoHq
         vpmenAmPzmnqaUBG5UbZa1M+HN6KEPXxX5b9vwUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 61/80] scsi: qla2xxx: Initialize free_work before flushing it
Date:   Thu, 19 Dec 2019 19:34:53 +0100
Message-Id: <20191219183134.492394786@linuxfoundation.org>
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

commit 4c86b037a6db3ad2922ef3ba8a8989eb7794e040 upstream.

Target creation triggers a new BUG_ON introduced in in commit 4d43d395fed1
("workqueue: Try to catch flush_work() without INIT_WORK().").  The BUG_ON
reveals an attempt to flush free_work in qla24xx_do_nack_work before it's
initialized in qlt_unreg_sess:

  WARNING: CPU: 7 PID: 211 at kernel/workqueue.c:3031 __flush_work.isra.38+0x40/0x2e0
  CPU: 7 PID: 211 Comm: kworker/7:1 Kdump: loaded Tainted: G            E     5.3.0-rc7-vanilla+ #2
  Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx]
  NIP:  c000000000159620 LR: c0080000009d91b0 CTR: c0000000001598c0
  REGS: c000000005f3f730 TRAP: 0700   Tainted: G            E      (5.3.0-rc7-vanilla+)
  MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24002222  XER: 00000000
  CFAR: c0000000001598d0 IRQMASK: 0
  GPR00: c0080000009d91b0 c000000005f3f9c0 c000000001670a00 c0000003f8655ca8
  GPR04: c0000003f8655c00 000000000000ffff 0000000000000011 ffffffffffffffff
  GPR08: c008000000949228 0000000000000000 0000000000000001 c0080000009e7780
  GPR12: 0000000000002200 c00000003fff6200 c000000000161bc8 0000000000000004
  GPR16: c0000003f9d68280 0000000002000000 0000000000000005 0000000000000003
  GPR20: 0000000000000002 000000000000ffff 0000000000000000 fffffffffffffef7
  GPR24: c000000004f73848 c000000004f73838 c000000004f73f28 c000000005f3fb60
  GPR28: c000000004f73e48 c000000004f73c80 c000000004f73818 c0000003f9d68280
  NIP [c000000000159620] __flush_work.isra.38+0x40/0x2e0
  LR [c0080000009d91b0] qla24xx_do_nack_work+0x88/0x180 [qla2xxx]
  Call Trace:
  [c000000005f3f9c0] [c000000000159644] __flush_work.isra.38+0x64/0x2e0 (unreliable)
  [c000000005f3fa50] [c0080000009d91a0] qla24xx_do_nack_work+0x78/0x180 [qla2xxx]
  [c000000005f3fae0] [c0080000009496ec] qla2x00_do_work+0x604/0xb90 [qla2xxx]
  [c000000005f3fc40] [c008000000949cd8] qla2x00_iocb_work_fn+0x60/0xe0 [qla2xxx]
  [c000000005f3fc80] [c000000000157bb8] process_one_work+0x2c8/0x5b0
  [c000000005f3fd10] [c000000000157f28] worker_thread+0x88/0x660
  [c000000005f3fdb0] [c000000000161d64] kthread+0x1a4/0x1b0
  [c000000005f3fe20] [c00000000000b960] ret_from_kernel_thread+0x5c/0x7c
  Instruction dump:
  3d22001d 892966b1 7d908026 91810008 f821ff71 69290001 0b090000 2e290000
  40920200 e9230018 7d2a0074 794ad182 <0b0a0000> 2fa90000 419e01e8 7c0802a6
  ---[ end trace 5ccf335d4f90fcb8 ]---

Fixes: 1021f0bc2f3d6 ("scsi: qla2xxx: allow session delete to finish before create.")
Cc: Quinn Tran <qutran@marvell.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191125165702.1013-4-r.bolshakov@yadro.com
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_init.c   |    1 +
 drivers/scsi/qla2xxx/qla_target.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4847,6 +4847,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vh
 	}
 
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
+	INIT_WORK(&fcport->free_work, qlt_free_session_done);
 	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1160,7 +1160,6 @@ void qlt_unreg_sess(struct fc_port *sess
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
 
-	INIT_WORK(&sess->free_work, qlt_free_session_done);
 	queue_work(sess->vha->hw->wq, &sess->free_work);
 }
 EXPORT_SYMBOL(qlt_unreg_sess);


