Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0C9205CA3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbgFWUDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387509AbgFWUDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C1E20FC3;
        Tue, 23 Jun 2020 20:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942632;
        bh=hGt5jvVshFXEzuKSCI0ypKNX8m8Q+hiYVHQAKRJQ80Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNI+32tBznJJTdbjwtcyFTWWtrKrANPJtz2lfYQ0SVRhIWwScTLn1M0PxyHfcL6yF
         9J9yB9EdCS6nPf5jp6clE8/btM1O1ax8MFMH8DNKJfT11QjzjEx4Uf9dBzWkpFSerW
         WwbUsUuHjyg3OCIzhT8ubkquwHZpmouFoKaUvsYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 067/477] habanalabs: dont allow hard reset with open processes
Date:   Tue, 23 Jun 2020 21:51:04 +0200
Message-Id: <20200623195410.788341159@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aef4de36b7aae..6d9c298e02c73 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -718,7 +718,7 @@ disable_device:
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
@@ -894,7 +892,12 @@ again:
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



