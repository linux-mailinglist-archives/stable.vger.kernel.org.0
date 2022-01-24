Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D340498E61
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbiAXTk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35730 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348643AbiAXTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A844D6152B;
        Mon, 24 Jan 2022 19:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFEFC340E5;
        Mon, 24 Jan 2022 19:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053094;
        bh=SO3cHiV5I28ThnTZPDoMcc4LPiomENv4E0MOcsvj+qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/AjQLa+O5bQuEBXygm/0vpXJSucQDiue2/kWWR7YqtoOHxJtivrwPG9S+aDijxke
         1DDNKWg5zW8GthO2uWgro/y3FJC2lTlSnyOsf3SCykRGp6xPwjg9YmpAFzX2rahahc
         5RdGxVoAsMlGs/ibOu0SGIIpY/0jg1IyQMVJ6exM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 242/320] scsi: sr: Dont use GFP_DMA
Date:   Mon, 24 Jan 2022 19:43:46 +0100
Message-Id: <20220124184002.221437620@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 279dea628620d..310da62cda263 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -887,7 +887,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 
 	/* allocate transfer buffer */
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer) {
 		sr_printk(KERN_ERR, cd, "out of memory.\n");
 		return;
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index b9db2ec6d0361..996bccadd3866 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -113,7 +113,7 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
 	if (cd->vendor == VENDOR_TOSHIBA)
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -161,7 +161,7 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-- 
2.34.1



