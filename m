Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514772FC8DA
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbhATC36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730110AbhATB2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2F823384;
        Wed, 20 Jan 2021 01:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106032;
        bh=4aYKqfny2+FurLm5ERUJNtuNpGS1lclFpA7L3y2j0xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9/ykJtjXsfZpXJOXd+16k4ICUKNgBFbBfUT0k5AteR+vq4pGkPIGQwBdw7ydRIc/
         qI9FR/ushGnRRokBa5PvLwfOyvMtmaJtS08fMlyUb6XWAymDhtOppa3FEVQwqEWK/G
         1+7EF/+0f7BJQcQfudeYbk0HGsyDnvhg0FIHv+ftkoUJNenXWnoy9kgQQk3R/CklgG
         TWOxRIdsox9TO8ikyrh8qG8R7JfyDMk6I/LFFn/zY3YEH5/dErr24jFOKVs9DAddvH
         3a9wtmYvo31SKN8P/sb+xTPOUyby5H1Pn/voI1p7tkvjJ2aa+Qj53JjMLT1cQ+P+2a
         PETw2CNi/5MOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/26] scsi: sd: Suppress spurious errors when WRITE SAME is being disabled
Date:   Tue, 19 Jan 2021 20:26:43 -0500
Message-Id: <20210120012704.770095-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

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
index 6a2f8bacfacea..f55249766d224 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -934,8 +934,10 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
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

