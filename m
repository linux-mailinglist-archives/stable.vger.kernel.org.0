Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75ABF34DAD1
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbhC2WXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhC2WWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 558BF61994;
        Mon, 29 Mar 2021 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056574;
        bh=axNQmBo8k1SXEw2pPx30CVmuPCu5/l56hZ7A1hlAKp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwjqt/YNBpPIoLTmysOMNUPM20NkIaEiwsHKebCo+8zstwjd0OxquPJUfmt0tVaIB
         onyRNwyNJd939X3ZDatvMRgWrjbGsPvB1XVDEFreFwZZlcIjIL6ZjgqgsgBCcPjqO5
         0t0IbYsIijryDdLddwjrd4zvrmjTDqPXV/D1xd06NkIyh8ZGAuWedWfaj5deODICQo
         r7+RyCPBZmvo3xF1RRqQOb5UHl5bvpgGuOW2gvDILBiwl88YKNJvexTa3dkfCKbcnh
         uuATl102PXcHHHViSzj0iYNxbMJvHooDXRGmwVNIYmk+8VCtCW+9YZblLZzWgrL83I
         kTVNTbmnlRwlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/33] scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
Date:   Mon, 29 Mar 2021 18:22:14 -0400
Message-Id: <20210329222222.2382987-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 36fa766faa0c822c860e636fe82b1affcd022974 ]

If pscsi_map_sg() fails, make sure to drop references to already allocated
bios.

Link: https://lore.kernel.org/r/20210323212431.15306-2-mwilck@suse.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pscsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 4e37fa9b409d..723a51a3f431 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -939,6 +939,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	return 0;
 fail:
+	if (bio)
+		bio_put(bio);
+	while (req->bio) {
+		bio = req->bio;
+		req->bio = bio->bi_next;
+		bio_put(bio);
+	}
+	req->biotail = NULL;
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
-- 
2.30.1

