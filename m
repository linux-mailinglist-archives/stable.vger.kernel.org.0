Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE3F40617A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhIJAm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232334AbhIJASu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32DC3611C8;
        Fri, 10 Sep 2021 00:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233042;
        bh=h+Uzma+hZONJfq10oK9MrXnsnU4yu+HCaFhcGa/r6sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEGjLiZxKKKt8rb42vJpYYM7gANMVty0twYm0DAhFP2t8M2VQK23xD9tghCY04arU
         vMKIu4jHg5cyn47kFgNa6G5kkh68gdcbWmrnwxHMPWilCr4/DzN9/P+Mk1IkMTF3cM
         gyT690otYCKZlSvq6XQxsrVnSE9UZ42Cm0BNOWxdYSUdr7PxkEwuZLmuOX5XT1Jc3p
         JKcniSwYvdR77W+/oEUVuqHdtHFK59EhNsl73VfjnRrzBk6D6td5g3iDS2IRJ670Tr
         Ma/4IHzhg6Tlz0n6XDArtdRvtz0TbN+gQO0vC2Xf2BjR0OVyM3l8KuH39Z4pLt7n4F
         zi+NWJRbxhFlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 60/99] scsi: qla2xxx: Fix hang during NVMe session tear down
Date:   Thu,  9 Sep 2021 20:15:19 -0400
Message-Id: <20210910001558.173296-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 310e69edfbd57995868a428eeddea09a7b5d2749 ]

The following hung task call trace was seen:

    [ 1230.183294] INFO: task qla2xxx_wq:523 blocked for more than 120 seconds.
    [ 1230.197749] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [ 1230.205585] qla2xxx_wq      D    0   523      2 0x80004000
    [ 1230.205636] Workqueue: qla2xxx_wq qlt_free_session_done [qla2xxx]
    [ 1230.205639] Call Trace:
    [ 1230.208100]  __schedule+0x2c4/0x700
    [ 1230.211607]  schedule+0x38/0xa0
    [ 1230.214769]  schedule_timeout+0x246/0x2f0
    [ 1230.222651]  wait_for_completion+0x97/0x100
    [ 1230.226921]  qlt_free_session_done+0x6a0/0x6f0 [qla2xxx]
    [ 1230.232254]  process_one_work+0x1a7/0x360

...when device side port resets were done.

Abort threads were getting out without processing due to the "deleted"
flag check. The delete thread, meanwhile, could not proceed with a
logout (that would have cleared out pending requests) as the logout IOCB
work was not progressing. It appears like the hung qlt_free_session_done()
thread is causing the ha->wq works on hold. The qlt_free_session_done()
was hung waiting for nvme_fc_unregister_remoteport() + localport_delete cb
to be complete, which would only happen when all I/Os are released.

Fix this by allowing abort to progress until device delete is completely
done. This should make the qlt_free_session_done() proceed without hang and
thus clear up the deadlock.

Link: https://lore.kernel.org/r/20210817051315.2477-5-njavali@marvell.com
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3e5c70a1d969..6e1abfc1be41 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -227,7 +227,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
 	       __func__, sp, sp->handle, fcport, fcport->deleted);
 
-	if (!ha->flags.fw_started || fcport->deleted)
+	if (!ha->flags.fw_started || fcport->deleted == QLA_SESS_DELETED)
 		goto out;
 
 	if (ha->flags.host_shutting_down) {
-- 
2.30.2

