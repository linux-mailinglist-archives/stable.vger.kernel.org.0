Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF5A1FE885
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgFRBJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbgFRBJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E2721D91;
        Thu, 18 Jun 2020 01:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442575;
        bh=VPy5v/RwQZSLoBoZ5LZIPpSb3rjfOo7G621Ach7vWmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2clCOj/bJQS9k8jw0gyvJcamHnd9sQQkGiVoNbzYf6Ce7ra1hm1063NN5nSKs8BFT
         MFSn3i0oCu15payeKtAa8ItPqz/YvKaPWKs+BezzHXBz27Cyd4u1ZcY5Hm+94Dq+lc
         vA5lziAjve6WPLQvlmF4rZKEDpLwzHD/XiR+BejI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 068/388] habanalabs: don't allow hard reset with open processes
Date:   Wed, 17 Jun 2020 21:02:45 -0400
Message-Id: <20200618010805.600873-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

[ Upstream commit 36fafe87edd636292a4ed6a3af9608f2c7d0d0fb ]

When the MMU is heavily used by the engines, unmapping might take a lot of
time due to a full MMU cache invalidation done as part of the unmap flow.
Hence we might not be able to kill all open processes before going to hard
reset the device, as it involves unmapping of all user memory.
In case of a failure in killing all open processes, we should stop the
hard reset flow as it might lead to a kernel crash - one thread (killing
of a process) is updating MMU structures that other thread (hard reset) is
freeing.
Stopping a hard reset flow leaves the device as nonoperational and the
user can then initiate a hard reset via sysfs to reinitialize the device.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/device.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index aef4de36b7aa..6d9c298e02c7 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -718,7 +718,7 @@ int hl_device_resume(struct hl_device *hdev)
 	return rc;
 }
 
-static void device_kill_open_processes(struct hl_device *hdev)
+static int device_kill_open_processes(struct hl_device *hdev)
 {
 	u16 pending_total, pending_cnt;
 	struct hl_fpriv	*hpriv;
@@ -771,9 +771,7 @@ static void device_kill_open_processes(struct hl_device *hdev)
 		ssleep(1);
 	}
 
-	if (!list_empty(&hdev->fpriv_list))
-		dev_crit(hdev->dev,
-			"Going to hard reset with open user contexts\n");
+	return list_empty(&hdev->fpriv_list) ? 0 : -EBUSY;
 }
 
 static void device_hard_reset_pending(struct work_struct *work)
@@ -894,7 +892,12 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 		 * process can't really exit until all its CSs are done, which
 		 * is what we do in cs rollback
 		 */
-		device_kill_open_processes(hdev);
+		rc = device_kill_open_processes(hdev);
+		if (rc) {
+			dev_crit(hdev->dev,
+				"Failed to kill all open processes, stopping hard reset\n");
+			goto out_err;
+		}
 
 		/* Flush the Event queue workers to make sure no other thread is
 		 * reading or writing to registers during the reset
@@ -1375,7 +1378,9 @@ void hl_device_fini(struct hl_device *hdev)
 	 * can't really exit until all its CSs are done, which is what we
 	 * do in cs rollback
 	 */
-	device_kill_open_processes(hdev);
+	rc = device_kill_open_processes(hdev);
+	if (rc)
+		dev_crit(hdev->dev, "Failed to kill all open processes\n");
 
 	hl_cb_pool_fini(hdev);
 
-- 
2.25.1

