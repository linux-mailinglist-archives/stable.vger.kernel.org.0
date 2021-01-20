Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5A12FC7E0
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbhATC25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbhATB2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A5222313A;
        Wed, 20 Jan 2021 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105979;
        bh=01AXPeuvHq4YkqZS4wMolAMnbMUyq0ZgtRslBq9z/gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFVH4+QUoFzYGM7Up6m6nESpszA+SIqQqhmRcwWv5Wijd44rlV4vOnkH32dnMiWC0
         28FzSF7CuhY+DMpjQCzK2GRNGQMdDTafVfCHnrqnN2WBhtmqtiZ63EJQA5NoksW8CS
         9GnfnkBKOrAOIrEh9dSJWvs0tvhFgjFGI15LWik7SVmB33BAuQauC8uNXM29SjDN+o
         xhsA9hKzYzBjTyeC15rKNuZTnEMozwjQtCO5cfV71bUazsDLQDzlX3tuMo9Zr8ghDp
         m67g64ZYO/g9kKuCnx/pO5TINLGxZaYETVnPOkOQ7PijSu6rNGjpRRLfBq1UDhAZAk
         iHH8vs9+X6lTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/45] scsi: sd: Suppress spurious errors when WRITE SAME is being disabled
Date:   Tue, 19 Jan 2021 20:25:30 -0500
Message-Id: <20210120012602.769683-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
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

