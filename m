Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA93E3F67BA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241880AbhHXRgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242175AbhHXRem (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F3A061BB4;
        Tue, 24 Aug 2021 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824804;
        bh=kln+TdL2yLTp4Awig9Sffb7Fm7JG6GfX55GX2Gh1dxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngJAeiKUAIUk+6SykTg1z2AQrYbOkB2V1z6oLGlsVwKNTVI8gZfGAIuBIkajQ1RhY
         KtmgZLjAtKCluDPD9rFw9cQLWT8aCWwMaQ0HPHfV9NO0c2eIFF0JXsXmh8+OYUEnnx
         0mNco6zJgDV/cUusPB9wzSGmRREZv34QgTxw1HGnQjlGwMceb6NGRIW0nCEK+ep1Ti
         zwbMTwQEVwPqFlSbGqPRMe3jeNaaBlHt97U+n+OxsSc0bRoD10xbHdXXkTE64qFYve
         xW6hi/YMuj/ZfvoTV1SslXHsKRpWqhUOEiYfmdp0IFKJujiqlTrTVYHTKFwjYk8RBA
         aH2r+i3SpXg/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/43] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 24 Aug 2021 13:05:59 -0400
Message-Id: <20210824170614.710813-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 70edd2e6f652f67d854981fd67f9ad0f1deaea92 ]

Avoid printing a 'target allocation failed' error if the driver
target_alloc() callback function returns -ENXIO. This return value
indicates that the corresponding H:C:T:L entry is empty.

Removing this error reduces the scan time if the user issues SCAN_WILD_CARD
scan operation through sysfs parameter on a host with a lot of empty
H:C:T:L entries.

Avoiding the printk on -ENXIO matches the behavior of the other callback
functions during scanning.

Link: https://lore.kernel.org/r/20210726115402.1936-1-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 397deb69c659..e51819e3a508 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -460,7 +460,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			if (error != -ENXIO)
+				dev_err(dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
-- 
2.30.2

