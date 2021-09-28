Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1C041A868
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhI1GEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239870AbhI1GCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77507613B1;
        Tue, 28 Sep 2021 05:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808658;
        bh=ot6VfK65sg2Y7YZeriZdOjctKXKEZ76qidoh2h4/l4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g38b9t556pbM5JjkBPS32eSeoy+HUQSbzQfaYx5RhmBygKuVrat8TC+VDoe0UI17p
         Q2ZNrJRpr3oXWyOA03lsp5VjyvknlTn5cc7vWwjHfvVnGmN+jNkwJOSpFkdsdeJ0ie
         Tgmtrq1TG8Gz22xaaeoh4nDfTmNnySFYbfmVtR4NxRTw//YeNP4eX15+6JpgtLEaWr
         OvNnRoEweAUjnJliL+b0tgnylpGhORtvNM5TRfF8qamytO3hCqrJCX7kD+cCvRnxEH
         cFeSe/5eQzEAAgDhn26HNv3Aw9/urVzq5eseNf0nDXl2Qr0aAI0hkv9jPonrMWgQCA
         3wlttxkWvLCdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/6] scsi: sd: Free scsi_disk device via put_device()
Date:   Tue, 28 Sep 2021 01:57:33 -0400
Message-Id: <20210928055734.173182-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055734.173182-1-sashal@kernel.org>
References: <20210928055734.173182-1-sashal@kernel.org>
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
index 671bf1e03ee1..426f1b3aa15e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3179,15 +3179,16 @@ static int sd_probe(struct device *dev)
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

