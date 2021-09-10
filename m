Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3C2406225
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhIJAox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhIJAUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE3661167;
        Fri, 10 Sep 2021 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233176;
        bh=2qQNOgnNyxzf0vkIICdlP+LKDnOnLdrCGNML7DqDb7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjuQZJRgwRnBIT6HDvIquAS62sQ9wMEL7B1+sIRBl01dNjyhzwUNdeejfDpziojm7
         wKuesAAY8LwCz9FCNB4jT9Y+MZPbfjjzFLGkKSQ06pD2s5zVvyk1cHnsHieW+7FLpz
         UfSJ06Sr8Hn9Bb084WfSCh0W/yTvfBp3g3qt3vYJ/74aB0g/F2V8zP9C6v+ztX4KqY
         HtLvn8BRyFYH7lq4wWeiK6VSH3jpY93EHa9WC2ON7Qv2QpwZgBUKNv5C6Wh/syGbE8
         ZTbAfrbQ31DJQait2pGSxypVT8UanjKqfsALsnJ5k7c4SnMDkmYeh7UaAGSeW6GDP2
         1wlUKTLmOXc1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 53/88] scsi: qla2xxx: Fix hang during NVMe session tear down
Date:   Thu,  9 Sep 2021 20:17:45 -0400
Message-Id: <20210910001820.174272-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index 0cacb667a88b..955af14e948a 100644
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

