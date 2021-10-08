Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A824268D5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbhJHLbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240509AbhJHLbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA89C6103C;
        Fri,  8 Oct 2021 11:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692545;
        bh=ot6VfK65sg2Y7YZeriZdOjctKXKEZ76qidoh2h4/l4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnCeS8Tclb099P+PyJiQHzYOKwTYf2sTpOqdQFuK+4uhtv0MpEECCZ1jezVLoAnkm
         SFpjyadGY4Glpt9kQr7Og0MPYWTi03638fE2PkrETM8DRwKEX9VYSoG6+IpYywjgPQ
         r9Uqb5WX/o41c6eGmzVmUuWTbmJTKz/oeq1nuYDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 6/8] scsi: sd: Free scsi_disk device via put_device()
Date:   Fri,  8 Oct 2021 13:27:43 +0200
Message-Id: <20211008112714.158150639@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
References: <20211008112713.941269121@linuxfoundation.org>
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



