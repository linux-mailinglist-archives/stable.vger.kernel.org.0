Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BFF148917
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404280AbgAXOT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404266AbgAXOT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A000222D9;
        Fri, 24 Jan 2020 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875597;
        bh=aKN1cLa8sPeUp3tC/bVgjb/jUPiF5rYOujaxSFcWfus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI4nQESoqZyjn7VsZ33X+ON5uUYshx7VeRd1Fw0jmtS1bajR9uQqZg4EnNaVFML17
         cCyT6MKr/KMhOgcCzxvdMJ8k++qIVMRgorScoNcU69sNwH8QElANfkDVkj+xiuQ3Nk
         PPL5AeDIUdzvFEr3RWzyajhoQAHZY7VQl2D5jSII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 086/107] scsi: storvsc: Correctly set number of hardware queues for IDE disk
Date:   Fri, 24 Jan 2020 09:17:56 -0500
Message-Id: <20200124141817.28793-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 7b571c19d4c0b78d27dd3bf1f3c42e4032390af6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 542d2bac2922c..5087ed6afbdc3 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1835,9 +1835,11 @@ static int storvsc_probe(struct hv_device *device,
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
-- 
2.20.1

