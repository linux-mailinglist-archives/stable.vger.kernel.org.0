Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D994304ACF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbhAZE5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731044AbhAYStW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43BF7229C5;
        Mon, 25 Jan 2021 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600517;
        bh=SXSWDt5X48f4lbgNW+9JjMjL3TwPRoCaIEb4RhlRZGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Id0jEaN7Y8HC38Yh2+ShNB/Pqas63+W1r9zXu2TOAdZJQ1WWcLdVtHFurEQCH1Wql
         Hduiygg0DO0A7VhZlajbqAmBNtIxQkTLnnFwrweRw6QPpFeTnj731+DMmw+1cu71W0
         CIE1CJfM6HvzcEgE5DzAtxExQozFsAqxLBBer9i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/199] scsi: sd: Suppress spurious errors when WRITE SAME is being disabled
Date:   Mon, 25 Jan 2021 19:37:47 +0100
Message-Id: <20210125183218.157967675@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit e5cc9002caafacbaa8dab878d17a313192c3b03b ]

The block layer code will split a large zeroout request into multiple bios
and if WRITE SAME is disabled because the storage device reports that it
does not support it (or support the length used), we can get an error
message from the block layer despite the setting of RQF_QUIET on the first
request.  This is because more than one request may have already been
submitted.

Fix this by setting RQF_QUIET when BLK_STS_TARGET is returned to fail the
request early, we don't need to log a message because we did not actually
submit the command to the device, and the block layer code will handle the
error by submitting individual write bios.

Link: https://lore.kernel.org/r/20201207221021.28243-1-emilne@redhat.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 656bcf4940d6d..fedb89d4ac3f0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -986,8 +986,10 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (sdp->no_write_same)
+	if (sdp->no_write_same) {
+		rq->rq_flags |= RQF_QUIET;
 		return BLK_STS_TARGET;
+	}
 
 	if (sdkp->ws16 || lba > 0xffffffff || nr_blocks > 0xffff)
 		return sd_setup_write_same16_cmnd(cmd, false);
-- 
2.27.0



