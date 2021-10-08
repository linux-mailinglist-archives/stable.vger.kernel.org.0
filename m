Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DC1426977
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241416AbhJHLh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241501AbhJHLf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1624861505;
        Fri,  8 Oct 2021 11:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692721;
        bh=i0ZX03M/4AJvVgj9jzQFNICM8I7YZ7H8d2FqLXzyEas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWhXDIDcgMMlGC/L0KzIBHvS++RmwzrMFqwEWcJxoClR6tAud8HzGtXs1rxP39luz
         1fb/25DHTtTN6Wmh/woHsKosQhO+KiVxcfhiON8Pt44uADOlQvpX9Yzmxst9wBQy9K
         rRRma/0kuUGHyc/+tupruu7RZglk3DauZzxqqNPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 15/48] scsi: sd: Free scsi_disk device via put_device()
Date:   Fri,  8 Oct 2021 13:27:51 +0200
Message-Id: <20211008112720.530059641@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
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



