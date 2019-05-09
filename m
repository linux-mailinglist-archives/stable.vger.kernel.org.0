Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162B81923D
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfEISrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbfEISrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88133217F5;
        Thu,  9 May 2019 18:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427626;
        bh=2kJoZ+cjfSzkpzoetEwzeleoVs2fuDkITfPVv3PmI4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUo64gfq81yb3S/PhakiBB8yWGRnRASCr7Iqt0wrJuXQ5eNvUMWbCN4ADUa1wHvMJ
         05UlK83eHgFb0W5RINaK+pCmUu+1SuZIf5x100R9PoSHRN5xBZy+XGkceGCjbp2PyA
         xM2RROEty7Dvkxv2RNqoLM9dWQxK519KELLqbxQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 02/66] scsi: libsas: fix a race condition when smp task timeout
Date:   Thu,  9 May 2019 20:41:37 +0200
Message-Id: <20190509181301.995626693@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Guenter Roeck <linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libsas/sas_expander.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -48,17 +48,16 @@ static void smp_task_timedout(struct tim
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
 


