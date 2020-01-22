Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED19E145536
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgAVNTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729826AbgAVNTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:54 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC2A82467A;
        Wed, 22 Jan 2020 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699193;
        bh=zrgM32+MfYz8uFvX7xck2BXM2ageeXgUiFXT/ybNLUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fI9i9FgYuQKj/YaiMQ+8BlhnjSi7GcWJ1jCcr+Mj1bIaBOQZ6PrpVF6iT0/VA1QMc
         lWy3e69qnvGvXyELZk/GjPRSEPEfwFy3RznFHtcpK1c/5vEBC9uheU9mmQMcQRg3Ue
         Dp5aUU/zeW6I+C2P3W9yD9FgeJ8NtM6LZDuZ+pjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Long Li <longli@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 068/222] scsi: storvsc: Correctly set number of hardware queues for IDE disk
Date:   Wed, 22 Jan 2020 10:27:34 +0100
Message-Id: <20200122092838.593531809@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

commit 7b571c19d4c0b78d27dd3bf1f3c42e4032390af6 upstream.

Commit 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between hardware
queue and CPU queue") introduced a regression for disks attached to
IDE. For these disks the host VSP only offers one VMBUS channel. Setting
multiple queues can overload the VMBUS channel and result in performance
drop for high queue depth workload on system with large number of CPUs.

Fix it by leaving the number of hardware queues to 1 (default value) for
IDE disks.

Fixes: 0ed881027690 ("scsi: storvsc: setup 1:1 mapping between hardware queue and CPU queue")
Link: https://lore.kernel.org/r/1578960516-108228-1-git-send-email-longli@linuxonhyperv.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1835,9 +1835,11 @@ static int storvsc_probe(struct hv_devic
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
 	/*
+	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
 	 */
-	host->nr_hw_queues = num_present_cpus();
+	if (!dev_is_ide)
+		host->nr_hw_queues = num_present_cpus();
 
 	/*
 	 * Set the error handler work queue.


