Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A986C9E0C3
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbfH0IFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732430AbfH0IFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E7D217F5;
        Tue, 27 Aug 2019 08:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893145;
        bh=l/ljcQ7Xg1mHTeRX5Cvd93e8nuYIhgNkK4LUpGAu6GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgwsRWBwFrhdkfaQhcjCuRBs5Ub/C/OD1cCVEZedgymqKJYx/9yB2Ju91WWzfUeCN
         Xv2TDLv+I2P6QnGShbWcIkzgO/+kiVYT1cqd2KlTlI8ldxKWvOP/MxZhe+nVHgWb1a
         PSpEAVVo/mlam3WAZ/bCRoAFuYLq9V8L8L2sPnAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.2 135/162] dm kcopyd: always complete failed jobs
Date:   Tue, 27 Aug 2019 09:51:03 +0200
Message-Id: <20190827072743.284931400@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

commit d1fef41465f0e8cae0693fb184caa6bfafb6cd16 upstream.

This patch fixes a problem in dm-kcopyd that may leave jobs in
complete queue indefinitely in the event of backing storage failure.

This behavior has been observed while running 100% write file fio
workload against an XFS volume created on top of a dm-zoned target
device. If the underlying storage of dm-zoned goes to offline state
under I/O, kcopyd sometimes never issues the end copy callback and
dm-zoned reclaim work hangs indefinitely waiting for that completion.

This behavior was traced down to the error handling code in
process_jobs() function that places the failed job to complete_jobs
queue, but doesn't wake up the job handler. In case of backing device
failure, all outstanding jobs may end up going to complete_jobs queue
via this code path and then stay there forever because there are no
more successful I/O jobs to wake up the job handler.

This patch adds a wake() call to always wake up kcopyd job wait queue
for all I/O jobs that fail before dm_io() gets called for that job.

The patch also sets the write error status in all sub jobs that are
failed because their master job has failed.

Fixes: b73c67c2cbb00 ("dm kcopyd: add sequential write feature")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-kcopyd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -548,8 +548,10 @@ static int run_io_job(struct kcopyd_job
 	 * no point in continuing.
 	 */
 	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
-	    job->master_job->write_err)
+	    job->master_job->write_err) {
+		job->write_err = job->master_job->write_err;
 		return -EIO;
+	}
 
 	io_job_start(job->kc->throttle);
 
@@ -601,6 +603,7 @@ static int process_jobs(struct list_head
 			else
 				job->read_err = 1;
 			push(&kc->complete_jobs, job);
+			wake(kc);
 			break;
 		}
 


