Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347B641A770
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbhI1F5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238972AbhI1F5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9D1611F0;
        Tue, 28 Sep 2021 05:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808534;
        bh=i0ZX03M/4AJvVgj9jzQFNICM8I7YZ7H8d2FqLXzyEas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCvsG5ve6KN0Rf5NZqk878izmhoa2Wy/lq6tby6FtrWq3S0kEWeS0+5xn/CE0kfJa
         MpjppxB0QrFUSBUU+GehR2nwoboukTt6R6hZ2TGtddPBJk8JsccA+Nv8aIQGLBnGqG
         qRme8//FUhy1cS5pnh81Wd56KT13N81SeMKdu8Dnq1nJaQJTm2UcmkY2ZzQ71whvJz
         pcHr95aaxDuZVRXhbI5vPDahjrzJBwZImCiNuzfyop/FZ9vNNT8sezlSoAu0gDwLti
         rRkuHCsDlDE1aqXG29AQrnvM2VqIDCkDm2uzxr8zH/AnXZkCwAb2VWIf1akiQpGFBR
         E2hO8WbgR+1jA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 16/40] scsi: sd: Free scsi_disk device via put_device()
Date:   Tue, 28 Sep 2021 01:55:00 -0400
Message-Id: <20210928055524.172051-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
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
index b8d55af763f9..134c7a8145ef 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3441,15 +3441,16 @@ static int sd_probe(struct device *dev)
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
 
 	gd->major = sd_major((index & 0xf0) >> 4);
-- 
2.33.0

