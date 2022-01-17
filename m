Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CACD490D3F
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbiAQRBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:01:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48528 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241510AbiAQRAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:00:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E1E6B810A2;
        Mon, 17 Jan 2022 17:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345CEC36AF7;
        Mon, 17 Jan 2022 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438844;
        bh=hiKltHgWQoklyviP7j9xJYA49jfJQ7EKWXU3uv1sDos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubzUhT7Wpkwlh/3DgujGP5GI57Pzx5iRVVPJjPNGLsfuauj/W1hxlqyPW+x98qSNT
         cMC7L8UeQt9oNAPx1EeT4dRsxk8pH6fvnSDtGzdu7U49jvIkfBKWyjMcylZQUPpEgx
         uLcWRSe4SPu5OW4heJQY+O8o1qMCf3egqnDkPc7MGvaWLj0/WyAiqHB5uikPDeTOCz
         uGS91Ye+xGGHttacATENiK70Av/XgUzWMRMmJ/aX9KLg+YNRKiwlfj+lpI9CUaQlS6
         SgeAi1a1PY6sXaNxJDqx0RnztA3KT8aHtq2MFbiOBLif0hec6EBq8PVXF++oLSyFyj
         et8I+ePHCfXyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 41/52] scsi: sr: Don't use GFP_DMA
Date:   Mon, 17 Jan 2022 11:58:42 -0500
Message-Id: <20220117165853.1470420-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
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
index 8e4af111c0787..f5a2eed543452 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -856,7 +856,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
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

