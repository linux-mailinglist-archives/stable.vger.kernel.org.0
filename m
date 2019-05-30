Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7F82F1BB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfE3DP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730539AbfE3DP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6609424585;
        Thu, 30 May 2019 03:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186156;
        bh=g7WW4hCAqoz9YrVrGwYWvImdBx87C0/YOTv7ftVL5F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vJka0/UIKeWIqcwMLJIg7i+mNoU8Pm1M5TEBRVXeB+06BTGmwq3WveuWsn8neLrT
         KXqxqaZ0gYiP+OrLqBiw8e1h/0kLadWlA/o1FfSUcrSel4hfahP2oBX30ub3+omZQC
         xMZ/GP6NsNofh6IB2zDake4LU7PSpWC3kHbkp4is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 343/346] vfio-ccw: Prevent quiesce function going into an infinite loop
Date:   Wed, 29 May 2019 20:06:56 -0700
Message-Id: <20190530030558.107327907@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d1ffa760d22aa1d8190478e5ef555c59a771db27 ]

The quiesce function calls cio_cancel_halt_clear() and if we
get an -EBUSY we go into a loop where we:
	- wait for any interrupts
	- flush all I/O in the workqueue
	- retry cio_cancel_halt_clear

During the period where we are waiting for interrupts or
flushing all I/O, the channel subsystem could have completed
a halt/clear action and turned off the corresponding activity
control bits in the subchannel status word. This means the next
time we call cio_cancel_halt_clear(), we will again start by
calling cancel subchannel and so we can be stuck between calling
cancel and halt forever.

Rather than calling cio_cancel_halt_clear() immediately after
waiting, let's try to disable the subchannel. If we succeed in
disabling the subchannel then we know nothing else can happen
with the device.

Suggested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Message-Id: <4d5a4b98ab1b41ac6131b5c36de18b76c5d66898.1555449329.git.alifm@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_drv.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 64bb121ba5987..9e84d8a971ad9 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -40,26 +40,30 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch)
 	if (ret != -EBUSY)
 		goto out_unlock;
 
+	iretry = 255;
 	do {
-		iretry = 255;
 
 		ret = cio_cancel_halt_clear(sch, &iretry);
-		while (ret == -EBUSY) {
-			/*
-			 * Flush all I/O and wait for
-			 * cancel/halt/clear completion.
-			 */
-			private->completion = &completion;
-			spin_unlock_irq(sch->lock);
 
-			wait_for_completion_timeout(&completion, 3*HZ);
+		if (ret == -EIO) {
+			pr_err("vfio_ccw: could not quiesce subchannel 0.%x.%04x!\n",
+			       sch->schid.ssid, sch->schid.sch_no);
+			break;
+		}
+
+		/*
+		 * Flush all I/O and wait for
+		 * cancel/halt/clear completion.
+		 */
+		private->completion = &completion;
+		spin_unlock_irq(sch->lock);
 
-			private->completion = NULL;
-			flush_workqueue(vfio_ccw_work_q);
-			spin_lock_irq(sch->lock);
-			ret = cio_cancel_halt_clear(sch, &iretry);
-		};
+		if (ret == -EBUSY)
+			wait_for_completion_timeout(&completion, 3*HZ);
 
+		private->completion = NULL;
+		flush_workqueue(vfio_ccw_work_q);
+		spin_lock_irq(sch->lock);
 		ret = cio_disable_subchannel(sch);
 	} while (ret == -EBUSY);
 out_unlock:
-- 
2.20.1



