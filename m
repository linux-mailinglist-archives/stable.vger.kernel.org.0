Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3453D490EB2
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbiAQRLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56658 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241838AbiAQRI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:08:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7140B81155;
        Mon, 17 Jan 2022 17:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E991C36AE7;
        Mon, 17 Jan 2022 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439303;
        bh=1WUYU2h+Ihp81t3u07UTnT8V09OXmsMPudnXV6CtIy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4hqjg1XqBet+tDJ+wM5VSFUtZFJXrf5VJTVv/mpUbp+Wv65MgUwLWd/DskMtSgtD
         mc/qiioUUAzQLcTW6CP7pJsDDvDF1pc4yn2Zs0zvnF1IsZvP1T65F60OJAgW7PE5VK
         IsVBELla3G3JORXSJhOS4EbCdd4AVTecE9o2ttBU9MJf64jdcsJoxqY1smLRUdz8bQ
         gPv427Mrz+9WxVY8feTEcA9Ot1971TtpPfcRWRnKtDFD5S8Tt4EQsPv1HaH61hjWX0
         kZdCkifm1zJ3oUBGjpUslYQbQcBRIv7WPJycVLWfVLUbRGjdN5XArDoAEWBYfmLhPY
         HZqgqkiRBOgyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/12] scsi: sr: Don't use GFP_DMA
Date:   Mon, 17 Jan 2022 12:07:56 -0500
Message-Id: <20220117170757.1473318-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170757.1473318-1-sashal@kernel.org>
References: <20220117170757.1473318-1-sashal@kernel.org>
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
index df019b78d9f79..e26d6cc3c8716 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -883,7 +883,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
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

