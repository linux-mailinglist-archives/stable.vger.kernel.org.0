Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CB750F55B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiDZIwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347343AbiDZIvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D8DD0A80;
        Tue, 26 Apr 2022 01:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4F776104A;
        Tue, 26 Apr 2022 08:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4291C385B0;
        Tue, 26 Apr 2022 08:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962411;
        bh=QWLitrRvFmVyVyJOX1rFDP8ZYjWDXNK6XBXYNABfqg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiXaC0KUNB1O3jxleJlZFZKueqJY3c2oleBs2Is6VvJypdYjeaP+zESH/P0TBg2Pd
         3FwbepJyzbiLw3gabea7bT1PZjEKKJiT5o+ypJDYpFnKQEF82UE8pxvCGjWIL0ZCcP
         Btya+hW8kHPuMKkhD4g9mUtPugBvVg2B5kCyeGVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Tom Rix <trix@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/124] scsi: sr: Do not leak information in ioctl
Date:   Tue, 26 Apr 2022 10:21:29 +0200
Message-Id: <20220426081749.801857443@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit faad6cebded8e0fd902b672f220449b93db479eb ]

sr_ioctl.c uses this pattern:

  result = sr_do_ioctl(cd, &cgc);
  to-user = buffer[];
  kfree(buffer);
  return result;

Use of a buffer without checking leaks information. Check result and jump
over the use of buffer if there is an error.

  result = sr_do_ioctl(cd, &cgc);
  if (result)
    goto err;
  to-user = buffer[];
err:
  kfree(buffer);
  return result;

Additionally, initialize the buffer to zero.

This problem can be seen in the 2.4.0 kernel.

Link: https://lore.kernel.org/r/20220411174756.2418435-1-trix@redhat.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sr_ioctl.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index ddd00efc4882..fbdb5124d7f7 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -41,7 +41,7 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL);
+	buffer = kzalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -55,10 +55,13 @@ static int sr_read_tochdr(struct cdrom_device_info *cdi,
 	cgc.data_direction = DMA_FROM_DEVICE;
 
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	tochdr->cdth_trk0 = buffer[2];
 	tochdr->cdth_trk1 = buffer[3];
 
+err:
 	kfree(buffer);
 	return result;
 }
@@ -71,7 +74,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	int result;
 	unsigned char *buffer;
 
-	buffer = kmalloc(32, GFP_KERNEL);
+	buffer = kzalloc(32, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -86,6 +89,8 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 	cgc.data_direction = DMA_FROM_DEVICE;
 
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	tocentry->cdte_ctrl = buffer[5] & 0xf;
 	tocentry->cdte_adr = buffer[5] >> 4;
@@ -98,6 +103,7 @@ static int sr_read_tocentry(struct cdrom_device_info *cdi,
 		tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
 			+ buffer[10]) << 8) + buffer[11];
 
+err:
 	kfree(buffer);
 	return result;
 }
@@ -384,7 +390,7 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
-	char *buffer = kmalloc(32, GFP_KERNEL);
+	char *buffer = kzalloc(32, GFP_KERNEL);
 	int result;
 
 	if (!buffer)
@@ -400,10 +406,13 @@ int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 	cgc.data_direction = DMA_FROM_DEVICE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	result = sr_do_ioctl(cd, &cgc);
+	if (result)
+		goto err;
 
 	memcpy(mcn->medium_catalog_number, buffer + 9, 13);
 	mcn->medium_catalog_number[13] = 0;
 
+err:
 	kfree(buffer);
 	return result;
 }
-- 
2.35.1



