Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC541A81C
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 08:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhI1GBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239138AbhI1F7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D949061262;
        Tue, 28 Sep 2021 05:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808630;
        bh=MVbTWL27PvgqvTqMM9IB0J6I8H+mdPXgRuBvIV+JlSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBq+UZbeFXS2UdxwV+Huwr38wsClSx+XVnKa47dTI4/OAezo0kz0tZauYHSURCNF7
         j5pM3EqilMcsjCLYmxsqNYiPhBbDUEFH0SFXVw0RG2WFk3TiEgdh/vh1ErnPLKIySn
         IeKTyjofrcAR9fD4v1iCDmkaxTyfnP4Xt1g8a7MVNXHuhpfFh1utXVQNknGk70SvtN
         eRxLO7nwEs+ud4Lx8Yf+ngdjHstYmSgEhCUb8NzK4xXNK/vc1CFWPyZdW0jQU0mSQq
         lH4JoEGDp3t4KaUa2sRN74eElHF1622HF8y5TBMVubNgYxjfsqjBkZWWeCPkrGzCzL
         P7n16YCWQ58Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/11] scsi: sd: Free scsi_disk device via put_device()
Date:   Tue, 28 Sep 2021 01:56:58 -0400
Message-Id: <20210928055704.172814-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055704.172814-1-sashal@kernel.org>
References: <20210928055704.172814-1-sashal@kernel.org>
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
index f55249766d22..152b48605152 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3345,15 +3345,16 @@ static int sd_probe(struct device *dev)
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

