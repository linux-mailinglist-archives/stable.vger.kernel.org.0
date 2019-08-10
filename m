Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501DD88DDB
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfHJUtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54580 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726740AbfHJUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDS-00053i-Fm; Sat, 10 Aug 2019 21:43:54 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-0003mZ-Ic; Sat, 10 Aug 2019 21:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "chenxiang" <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Ewan Milne" <emilne@redhat.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Tomas Henzl" <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Hannes Reinecke" <hare@suse.com>,
        "Christoph Hellwig" <hch@lst.de>, "Jason Yan" <yanaijie@huawei.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.672530587@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 157/157] scsi: libsas: fix a race condition when smp
 task timeout
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yan <yanaijie@huawei.com>

commit b90cd6f2b905905fb42671009dc0e27c310a16ae upstream.

When the lldd is processing the complete sas task in interrupt and set the
task stat as SAS_TASK_STATE_DONE, the smp timeout timer is able to be
triggered at the same time. And smp_task_timedout() will complete the task
wheter the SAS_TASK_STATE_DONE is set or not. Then the sas task may freed
before lldd end the interrupt process. Thus a use-after-free will happen.

Fix this by calling the complete() only when SAS_TASK_STATE_DONE is not
set. And remove the check of the return value of the del_timer(). Once the
LLDD sets DONE, it must call task->done(), which will call
smp_task_done()->complete() and the task will be completed and freed
correctly.

Reported-by: chenxiang <chenxiang66@hisilicon.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/libsas/sas_expander.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -47,17 +47,16 @@ static void smp_task_timedout(unsigned l
 	unsigned long flags;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		complete(&task->slow_task->completion);
+	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	complete(&task->slow_task->completion);
 }
 
 static void smp_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 

