Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F26740DF35
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhIPQHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234127AbhIPQHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FCA861263;
        Thu, 16 Sep 2021 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808352;
        bh=J9aWaZfBGx2uTbh0ZAICfl9+7pt3ZQkHDKnpzBfHsIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgCosYzgXZ2KdBVDGR2Sh0YEOW0pJ6N3VPjV5fbRALfyG7NiUV0xyXGksOyECiDs/
         6FaGvcTRFyi9TAR//bhLWU8BaTHtLEFdWjmwaZZYn90Hjl1THeDhrEBezb300goMPH
         EGHOdwqwu0vvVHKqw9Vv44gQJ2Zl5/gD3HuAINcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/306] scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND
Date:   Thu, 16 Sep 2021 17:56:43 +0200
Message-Id: <20210916155755.923264527@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit beec64d0c9749afedf51c3c10cf52de1d9a89cc0 ]

SCSI_IOCTL_SEND_COMMAND has been deprecated longer than bsg exists and has
been warning for just as long.  More importantly it harcodes SCSI CDBs and
thus will do the wrong thing on non-SCSI bsg nodes.

Link: https://lore.kernel.org/r/20210724072033.1284840-2-hch@lst.de
Fixes: aa387cc89567 ("block: add bsg helper library")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bsg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bsg.c b/block/bsg.c
index 3d78e843a83f..2cbc1fcc8247 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -371,10 +371,13 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
-	case SCSI_IOCTL_SEND_COMMAND:
 		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
 	case SG_IO:
 		return bsg_sg_io(bd->queue, file->f_mode, uarg);
+	case SCSI_IOCTL_SEND_COMMAND:
+		pr_warn_ratelimited("%s: calling unsupported SCSI_IOCTL_SEND_COMMAND\n",
+				current->comm);
+		return -EINVAL;
 	default:
 		return -ENOTTY;
 	}
-- 
2.30.2



