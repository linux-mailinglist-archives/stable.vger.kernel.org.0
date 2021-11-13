Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A8344F2C8
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 12:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhKMLcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 06:32:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235377AbhKMLcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 06:32:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9B7610A1;
        Sat, 13 Nov 2021 11:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636802999;
        bh=4t4C5M9a84MkDb+tGoXF7AaK6vfmBvpn5F+aRzl4JOY=;
        h=Subject:To:Cc:From:Date:From;
        b=OVSfjMjijHCs0/lSPzreKJq0bUtPMsZQgiVMFW/uyWeKUiMSn6rgabSS4K57plp+a
         4WVyFjHHHuHS3gpggl6UxD956Zbjh61qVrQPSzunxD6gamQ7f48Pm5bdRZ7AI1NQ+c
         5SURbYyxjhm4vx6UTZZik9cNgh10W/rkgEkkQZ3A=
Subject: FAILED: patch "[PATCH] scsi: scsi_ioctl: Validate command size" failed to apply to 5.14-stable tree
To:     tadeusz.struk@linaro.org, bvanassche@acm.org, hch@lst.de,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 12:29:49 +0100
Message-ID: <1636802989232252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20aaef52eb08f1d987d46ad26edb8f142f74d83a Mon Sep 17 00:00:00 2001
From: Tadeusz Struk <tadeusz.struk@linaro.org>
Date: Wed, 3 Nov 2021 10:06:58 -0700
Subject: [PATCH] scsi: scsi_ioctl: Validate command size

Need to make sure the command size is valid before copying the command from
user space.

Link: https://lore.kernel.org/r/20211103170659.22151-1-tadeusz.struk@linaro.org
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.15, 5.14, 5.10
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 6ff2207bd45a..a06c61f22742 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -347,6 +347,8 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
 {
 	struct scsi_request *req = scsi_req(rq);
 
+	if (hdr->cmd_len < 6)
+		return -EMSGSIZE;
 	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
 	if (!scsi_cmd_allowed(req->cmd, mode))

