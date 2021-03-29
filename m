Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C938E34DA65
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhC2WWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhC2WWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B386661990;
        Mon, 29 Mar 2021 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056531;
        bh=ifP7GrAvdHy3PvqZQPZ0OgZ30TQlGNsg5g+sx/xnfZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5Iq+4JaYvOAWqqToT2P2RQpjBBkpk6+BKh0gnFyB2jNDs+pbqN4Wi3O6rcN01fZX
         cGwDsKKsHstY/VIutPMCWV2U7qEp5U5moNzoG005Pc6abcOXpwTosDkPkVthlcrSrk
         EDfPIASNt8XMLncA5FdvfY+4Megk/4isoRGHXMvDlkXxRsUzB9jCIUQYQMCH8NX8ab
         V/Mpyc5krIbhERkLnlXOOpaJjjDj17Twnpuq4PwGsdaRHcgJjHnBv2WutAmTdVJpHT
         SoiKQUykdTkXEgHfTimpBTohJEVXhfTnHsvM/ZU0h3fSa1hPBuaxMo/esYlZbBv5qt
         dVQ7kPQzVDoDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 30/38] scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
Date:   Mon, 29 Mar 2021 18:21:25 -0400
Message-Id: <20210329222133.2382393-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
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
index 7994f27e4527..0689d550c37a 100644
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

