Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA89320F56
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 03:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBVCLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 21:11:36 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:45787 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhBVCLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 21:11:36 -0500
Received: by mail-pg1-f176.google.com with SMTP id p21so9293576pgl.12;
        Sun, 21 Feb 2021 18:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kGQE4+8BxKuxGr67RgBvZgkchBVMotq6ozHayczju6s=;
        b=A7AjDFopjZRqbCfYCinnnFBgoSEr0yrS+W5h6Jymie0NhwpycsIl8jaPiMNIrEe23k
         xqPRuD7fp3XcW/gVHl74ERtsXATgdKyvq4Ie4uE0q9/26X1V/Rqgbpj7KjBkWpBUnnBW
         BbiQ7QaDkSTRoAvXXtXWQVp0BxoO2m3+ki3gleWBiJC4wnofNhTKeAy/KwPcwYkdcL6g
         R4ot71FMkvKdfayIWUqnAUMm14XugplmB0Teyfwc0juqJ1Ol5azEbyVsWzfZvcZ6Y0ZZ
         joUWzurMstWB2OznLxLu3m2yBfhWTU1PPvS6tr7dk2xVTyCNyIym4jiSnfPh0qNxgQK0
         olmA==
X-Gm-Message-State: AOAM532wBUVRQAsLxgunpjD7RmNCzdTjDD8sVyV0H5uTZjJx8TwQbrRs
        lgZfV19q5LD8NPDFgjEgey9LoghTGpk=
X-Google-Smtp-Source: ABdhPJyMUcvdr0UJKRq+kXS8Hi92kmSr7KXTBjd7HoLhZ2uOMwQEuBsh/OYm5HcafhnSlU93MxUStQ==
X-Received: by 2002:a65:4345:: with SMTP id k5mr14515168pgq.436.1613959849264;
        Sun, 21 Feb 2021 18:10:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eb6d:74c2:f5f3:564c])
        by smtp.gmail.com with ESMTPSA id f19sm17509640pgl.49.2021.02.21.18.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 18:10:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        chriscjsus@yahoo.com, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: [PATCH v2] scsi/sd: Fix Opal support
Date:   Sun, 21 Feb 2021 18:10:42 -0800
Message-Id: <20210222021042.3534-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The SCSI core has been modified recently such that it only processes PM
requests if rpm_status != RPM_ACTIVE. Since some Opal requests are
submitted while rpm_status != RPM_ACTIVE, set flag RQF_PM for Opal
requests.

See also https://bugzilla.kernel.org/show_bug.cgi?id=211227.

Fixes: d80210f25ff0 ("sd: add support for TCG OPAL self encrypting disks")
Fixes: 271822bbf9fe ("scsi: core: Only process PM requests if rpm_status != RPM_ACTIVE")
Reported-by: chriscjsus@yahoo.com
Tested-by: chriscjsus@yahoo.com
Cc: chriscjsus@yahoo.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
Changes compared to v1:
- Addressed Christoph's review comments.
- Added Cc: stable.
---
 drivers/scsi/sd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a3d2d4bc4a3d..6a3a163b0706 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -707,9 +707,9 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute_req(sdev, cdb,
-			send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-			buffer, len, NULL, SD_TIMEOUT, sdkp->max_retries, NULL);
+	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
+		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
+		RQF_PM, NULL);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
