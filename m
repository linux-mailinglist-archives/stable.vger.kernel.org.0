Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791B141A84D
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbhI1GDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239445AbhI1GBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 02:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DB656139F;
        Tue, 28 Sep 2021 05:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808650;
        bh=/00Lf3urktfw45fyj76HWnSij/aE1/Aq36a6JKc3F5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gT7URA3tXp8MTSJSeutWqQmiFxFlwA+nIrRz9e+MLX598tXjuijN7pqpfbUiTIEvU
         uDV2ZBdlnl5dS1HSLqsCmjnjOIP6gr2L0+fOr2OxGB7bAWCCP3mLhW4iR51R8NP49b
         jdxorunlA9bs7NHl9BcxIQ9/tKGm5fjR9rdaJkbm38A+izYJgIsMSZiK9ga8HPOTYp
         7frzisc3Nf5kftpUhPBx6EBYkAgHra33dVeM/BfKF/fl/h3DF2u/5NJNkK3D1nJBKF
         3yFe98zmNjysX1VCqE9UAqZeZCTzZhmRBuLV0hPdZg8WaiqZk5W4xHMXP4KJ1wbq5n
         aul9nk/dpZ2Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/8] scsi: sd: Free scsi_disk device via put_device()
Date:   Tue, 28 Sep 2021 01:57:23 -0400
Message-Id: <20210928055727.173078-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055727.173078-1-sashal@kernel.org>
References: <20210928055727.173078-1-sashal@kernel.org>
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
index 49d0720a0b7d..e490cbdaad9b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3454,15 +3454,16 @@ static int sd_probe(struct device *dev)
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

