Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C10490EA0
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242884AbiAQRLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242761AbiAQRHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:07:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B9F61242;
        Mon, 17 Jan 2022 17:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DF1C36AEF;
        Mon, 17 Jan 2022 17:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439268;
        bh=GmG+/voixByuzyHwsMFBsuj2PX+ZSiBIZM0+gB8/Sjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBIn2/dFP3qIBD6OOsYg6pCVVLKsTDYwW1W1OaRx8MnlVuelGiAYF+0WIjiQEc9lj
         6RSiEa2rjcTW2dRtyB5lUA6GJci6yOTQbJ1peQBoIN/aQKFc/mkitMljdtpprW5kr+
         BejIKY506xXxBMMSxcamjJlhTYNkW9Vkf1tCDJdNQ5asZYSq61DowRYbpdlz9zXNE9
         nmdBhGWSOvGI06LRTvbSxQUlBCML5aEGIkNLtGWLqnJliUQJNVQSnijzmuwIJJRJxm
         9O7L3D6kZdWYImiUewT37k+o3ko1w8I7UnzxhbD2altNcuGr05sJTicI4TUdQbAhD4
         p211Lfnpe8NUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/13] scsi: sr: Don't use GFP_DMA
Date:   Mon, 17 Jan 2022 12:07:20 -0500
Message-Id: <20220117170722.1473137-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170722.1473137-1-sashal@kernel.org>
References: <20220117170722.1473137-1-sashal@kernel.org>
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
index 9b63e46edffcc..a2a4c6e22c68d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -882,7 +882,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
 		return;
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 11a238cb22223..629bfe1b20263 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -118,7 +118,7 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 #endif
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -166,7 +166,7 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-- 
2.34.1

