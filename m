Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3705334DB7F
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhC2W2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232124AbhC2W0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CA8D619FB;
        Mon, 29 Mar 2021 22:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056637;
        bh=OnXkTL0zksksyzHpjaYPciOvlHbjE1VgCsFf5Jx9KsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbZY7ICsWJl+/LeJ19stRDBZXIof3tzipRWu8cef+uLf1d7mrIVzh8cRojYMnfvW3
         iyFp9OlEky9YfH67Tpr0eecuA5JeMdKw4BpDqIDXK35P1cWSmJxKKV0iPpZoIxJLEd
         9hTewfdM7xVk6gk8FhYm0uv5Zjs8K6m+CKDQb7cwxwmI/tVCYUgpLqlMzGbfEv63L6
         8KXkdULK7DCMGl8Hi9HsbVyvc6SM8NbnOHK+zLwpEJAG346ya/aB3cO+/JByUfPFLd
         U3WC/lyhZCqVB5JdaqK9LEF510TjTgsvuyUGOVu3Qp0ukUtAfiU+XDL+xaSofWJU0j
         LpyTmzyoc/R5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/12] scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
Date:   Mon, 29 Mar 2021 18:23:42 -0400
Message-Id: <20210329222345.2383777-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222345.2383777-1-sashal@kernel.org>
References: <20210329222345.2383777-1-sashal@kernel.org>
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
index 6cb933ecc084..f80b31b35a0d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -949,6 +949,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
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

