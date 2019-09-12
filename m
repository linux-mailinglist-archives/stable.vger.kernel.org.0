Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2223B063E
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 02:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfILAjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 20:39:51 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:56118 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728545AbfILAjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 20:39:51 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7E1E7435DA;
        Thu, 12 Sep 2019 00:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1568248787; x=1570063188; bh=c6YbmxEP6HKZa1EolYlrTeTg/ADs/zEgbwH
        lBT07sjY=; b=PISHcbY5dyMO0o7BVL1zH6P0GPQppf4ntpu4TJp1cpo0iKT/Zy+
        pQEFYKyys/LBuTC7FsyCSoO/vOZ8psXyZZPdiVpCP9OwOvupfL8Mn1iFn1q9fyPx
        9pid+4fb16qQpW81s0d7kFLhwu0fJkiJ4DfqBtfJAQklzKTyGHcBPApk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xh9LTbH5kAii; Thu, 12 Sep 2019 03:39:47 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 48A30412D6;
        Thu, 12 Sep 2019 03:39:47 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Sep 2019 03:39:46 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/4] scsi: qla2xxx: Initialize free_work before flushing it
Date:   Thu, 12 Sep 2019 03:39:17 +0300
Message-ID: <20190912003919.8488-3-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190912003919.8488-1-r.bolshakov@yadro.com>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
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

Target creation triggers a new BUG_ON introduced in in 4d43d395fed12
("workqueue: Try to catch flush_work() without INIT_WORK().").
The BUG_ON reveals an attempt to flush free_work in qla24xx_do_nack_work
before it's initialized in qlt_unreg_sess:

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
Cc: Quinn Tran <qtran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: stable@vger.kernel.org
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cb08004ef3f8..c8d89912d044 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4803,6 +4803,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	}
 
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
+	INIT_WORK(&fcport->free_work, qlt_free_session_done);
 	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0ffda6171614..bd1d30524de5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1160,7 +1160,6 @@ void qlt_unreg_sess(struct fc_port *sess)
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
 
-	INIT_WORK(&sess->free_work, qlt_free_session_done);
 	schedule_work(&sess->free_work);
 }
 EXPORT_SYMBOL(qlt_unreg_sess);
-- 
2.22.0

