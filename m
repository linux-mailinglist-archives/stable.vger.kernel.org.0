Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA8F41A85D
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbhI1GEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239300AbhI1GCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C61613D2;
        Tue, 28 Sep 2021 05:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808665;
        bh=WKW1KA04Qea8MHu2U1L/YYp0sBKmvQ7+kwJfHbNnSPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa5ZLiJ+1hy8F8Mss/UIg+C9xin9GZw8xcObE7o7wKAH+2hkE9lbbdrA07qdGm89i
         Lds1qtkW3Y29754CK8Bk8vrGJ1o4c12wEl8m86ra78B7XcK4yyj2lgQQ5LWyB7gyGV
         DFVN7VcQz6XCbjlfLmC5G820RP+Jk0JJML/u77aTkqEctv7jYZZxnE117GM4XDB7zR
         3ZHCth/bC7KF4Bl58XK89f9o2ggKKJ+bDAHEZgpQ+6Y6bqiA4Ko8F/Sj7fYsC6Ks7D
         jH7l3nmgyfDxzW0SaIdcqO7R930BE/alkF61+0c8geiL0OdLFCEDA9hsi/+Ldf3PYK
         fdsLx7eNpxdPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/5] scsi: sd: Free scsi_disk device via put_device()
Date:   Tue, 28 Sep 2021 01:57:40 -0400
Message-Id: <20210928055741.173265-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055741.173265-1-sashal@kernel.org>
References: <20210928055741.173265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 265dfe8ebbabae7959060bd1c3f75c2473b697ed ]

After a device is initialized via device_initialize() it should be freed
via put_device(). sd_probe() currently gets this wrong, fix it up.

Link: https://lore.kernel.org/r/20210906090112.531442-1-ming.lei@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9176fb1b1615..935add4d6f83 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3146,15 +3146,16 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = dev;
+	sdkp->dev.parent = get_device(dev);
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	error = device_add(&sdkp->dev);
-	if (error)
-		goto out_free_index;
+	if (error) {
+		put_device(&sdkp->dev);
+		goto out;
+	}
 
-	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-- 
2.33.0

