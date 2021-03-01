Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F015F3289EA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhCASHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhCASBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E569765225;
        Mon,  1 Mar 2021 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619505;
        bh=x6oOG4uQjxB4tnF00oE/GWfkgnAvj0lEbZHOtaMH5dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Up5dU9oY89gzhgMxdfVf53w8XpC0lXhKxQLF2Yq3NLBIRaYNBc7EAC46bWTKFD4Z
         Mn0Pv+VmjBxjIj1UYA2yrBCy9svfuH1hja8wrk7/KIR8E5MliH7KB6KfSbTZ35g+Mf
         +es81fWbTygHxcLROq62Rs9m9PO/5pvFEQ0t3zTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chriscjsus@yahoo.com,
        Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 478/663] scsi: sd: Fix Opal support
Date:   Mon,  1 Mar 2021 17:12:06 +0100
Message-Id: <20210301161205.508690843@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit aaf15f8c6de932861f1fce6aeec6a89ac0e354b6 upstream.

The SCSI core has been modified recently such that it only processes PM
requests if rpm_status != RPM_ACTIVE. Since some Opal requests are
submitted while rpm_status != RPM_ACTIVE, set flag RQF_PM for Opal
requests.

See also https://bugzilla.kernel.org/show_bug.cgi?id=211227.

[mkp: updated sha for PM patch]

Link: https://lore.kernel.org/r/20210222021042.3534-1-bvanassche@acm.org
Fixes: d80210f25ff0 ("sd: add support for TCG OPAL self encrypting disks")
Fixes: e6044f714b25 ("scsi: core: Only process PM requests if rpm_status != RPM_ACTIVE")
Cc: chriscjsus@yahoo.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Reported-by: chriscjsus@yahoo.com
Tested-by: chriscjsus@yahoo.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -709,9 +709,9 @@ static int sd_sec_submit(void *data, u16
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


