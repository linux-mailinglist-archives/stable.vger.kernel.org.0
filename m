Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7694240E5A5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345909AbhIPRNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350536AbhIPRLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96F70619E2;
        Thu, 16 Sep 2021 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810274;
        bh=vHAEqoFlMuw+ISV/fblADKoeSFRlXicdCYwD2i2lxqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vK762AdQihi6TAxh/8P6JfIC0kdttiZr9/7lCxqmxC8CH5x4ptX0xRRq8+Rm+mc8d
         oVBjfswkF2Oiyc+9SrHAJFRK0Lqa++3w3LcG6ebTE+0e5uwTGJvdyv7dzb71vjTqeJ
         9Eq8waFrwK9szxPBU+L4yjjw9Klunhl7GK7/igUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 080/432] scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND
Date:   Thu, 16 Sep 2021 17:57:09 +0200
Message-Id: <20210916155813.486273809@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 1f196563ae6c..79b42c5cafeb 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -373,10 +373,13 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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



