Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AAB490DF1
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbiAQRGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiAQRCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED2661238;
        Mon, 17 Jan 2022 17:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDABFC36AF6;
        Mon, 17 Jan 2022 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438974;
        bh=VffSaQeFa9LtkWe5JdScSFvdlZGz2Hde+F96tYEm9vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBgR/mfDcPYrCH4ta9lxe6ycxej324l2GKrZGMGsmlPORvvS4i21Lpk3YNkJaavET
         PQXzPqmai2L1mzoWHSeHpcefu49Kh5guArPY0io2hTarB2UW62E5xn1GYA4FDXJwlP
         OZ1+C3vIGYi20vXrTQm2z0AyneKjvKf5hStGl64HJL4uRyZp3dQDhnNQS5ZNfhg6oR
         9x5iiFAS5AUmEceTKLxVw8Rv4J5H5G0tjAsrGb5H8mUPY/UqeKz6Zo5Unusl02b3xn
         0B37nk82MQgbH+IOXXk8tYLgBIxflNFBZNQ9EJJ/XpwoBP8rEn+V5X4aHl6z5x56zm
         1i0grqQtqPT6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 35/44] scsi: sr: Don't use GFP_DMA
Date:   Mon, 17 Jan 2022 12:01:18 -0500
Message-Id: <20220117170127.1471115-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d94d94969a4ba07a43d62429c60372320519c391 ]

The allocated buffers are used as a command payload, for which the block
layer and/or DMA API do the proper bounce buffering if needed.

Link: https://lore.kernel.org/r/20211222090842.920724-1-hch@lst.de
Reported-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr.c        | 2 +-
 drivers/scsi/sr_vendor.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8b17b35283aa5..1203374828b97 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -851,7 +851,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
 		return;
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 1f988a1b9166f..a61635326ae0a 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -131,7 +131,7 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
 	if (cd->vendor == VENDOR_TOSHIBA)
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -179,7 +179,7 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-- 
2.34.1

