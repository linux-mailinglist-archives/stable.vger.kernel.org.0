Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C836426927
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241876AbhJHLeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241285AbhJHLc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B6C761374;
        Fri,  8 Oct 2021 11:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692647;
        bh=UIb1mYOgGz8ep8P24ertFqEu/OqqtLKGBD+OfVrEhUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUsbtjKidmLxTP+XZE0G9ou7m/9Bo3XJNuauW2kfplM5tATBsESKMVgmO0FIeNHaX
         3N48El3bmLY4CD+WeXcIi5K9YwF0Y+zzkd/aHlTaKxqsrMy/hSkNhWAga8PPNGWWmj
         od7h6VypOJnTvH8WD7Q3SeQnhbSuwfSh67G6fbrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/29] scsi: sd: Free scsi_disk device via put_device()
Date:   Fri,  8 Oct 2021 13:27:58 +0200
Message-Id: <20211008112717.324941234@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f0c0935d7909..56e291708587 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3443,15 +3443,16 @@ static int sd_probe(struct device *dev)
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



