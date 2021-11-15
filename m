Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD55B451277
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347540AbhKOTkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245157AbhKOTTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F24C9632D1;
        Mon, 15 Nov 2021 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000972;
        bh=cMi7/WR0SzFjhWw9coJvUoHsGKU8YWx/WwqkhgiBMbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhHoob/swEhpltceIOFKwc1XpRaylWlJMgr6hkLZPGPAG4qZyAcn+whKnoaTmBkLJ
         OmU8geHkSeqLnHMDI91jtQ0fdnoCLO2PpnhXMSs9OVeYNdRUGEjCJ6+MWvpqNiWZQo
         Mw250M4kdTBgBkUoakTIn7A6lmD7uhex4A1tjZKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 013/917] scsi: qla2xxx: Fix crash in NVMe abort path
Date:   Mon, 15 Nov 2021 17:51:48 +0100
Message-Id: <20211115165429.187025452@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

commit e6e22e6cc2962d3f3d71914b47f7fbc454670e8a upstream.

System crash was seen when I/O was run against an NVMe target and aborts
were occurring.

Crash stack is:

    -- relevant crash stack --
    BUG: kernel NULL pointer dereference, address: 0000000000000010
    :
    #6 [ffffae1f8666bdd0] page_fault at ffffffffa740122e
       [exception RIP: qla_nvme_abort_work+339]
       RIP: ffffffffc0f592e3  RSP: ffffae1f8666be80  RFLAGS: 00010297
       RAX: 0000000000000000  RBX: ffff9b581fc8af80  RCX: ffffffffc0f83bd0
       RDX: 0000000000000001  RSI: ffff9b5839c6c7c8  RDI: 0000000008000000
       RBP: ffff9b6832f85000   R8: ffffffffc0f68160   R9: ffffffffc0f70652
       R10: ffffae1f862ffdc8  R11: 0000000000000300  R12: 000000000000010d
       R13: 0000000000000000  R14: ffff9b5839cea000  R15: 0ffff9b583fab170
       ORIG_RAX: ffffffffffffffff   CS: 0010  SS: 0018
    #7 [ffffae1f8666be98] process_one_work at ffffffffa6aba184
    #8 [ffffae1f8666bed8] worker_thread at ffffffffa6aba39d
    #9 [ffffae1f8666bf10] kthread at ffffffffa6ac06ed

The crash was due to a stale SRB structure access after it was aborted.
Fix the issue by removing stale access.

Link: https://lore.kernel.org/r/20210908164622.19240-5-njavali@marvell.com
Fixes: 2cabf10dbbe3 ("scsi: qla2xxx: Fix hang on NVMe command timeouts")
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -228,6 +228,8 @@ static void qla_nvme_abort_work(struct w
 	fc_port_t *fcport = sp->fcport;
 	struct qla_hw_data *ha = fcport->vha->hw;
 	int rval, abts_done_called = 1;
+	bool io_wait_for_abort_done;
+	uint32_t handle;
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0xffff,
 	       "%s called for sp=%p, hndl=%x on fcport=%p desc=%p deleted=%d\n",
@@ -244,12 +246,20 @@ static void qla_nvme_abort_work(struct w
 		goto out;
 	}
 
+	/*
+	 * sp may not be valid after abort_command if return code is either
+	 * SUCCESS or ERR_FROM_FW codes, so cache the value here.
+	 */
+	io_wait_for_abort_done = ql2xabts_wait_nvme &&
+					QLA_ABTS_WAIT_ENABLED(sp);
+	handle = sp->handle;
+
 	rval = ha->isp_ops->abort_command(sp);
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0x212b,
 	    "%s: %s command for sp=%p, handle=%x on fcport=%p rval=%x\n",
 	    __func__, (rval != QLA_SUCCESS) ? "Failed to abort" : "Aborted",
-	    sp, sp->handle, fcport, rval);
+	    sp, handle, fcport, rval);
 
 	/*
 	 * If async tmf is enabled, the abort callback is called only on
@@ -264,7 +274,7 @@ static void qla_nvme_abort_work(struct w
 	 * are waited until ABTS complete. This kref is decreased
 	 * at qla24xx_abort_sp_done function.
 	 */
-	if (abts_done_called && ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(sp))
+	if (abts_done_called && io_wait_for_abort_done)
 		return;
 out:
 	/* kref_get was done before work was schedule. */


