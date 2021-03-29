Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05EA34DBC2
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhC2Wak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhC2WYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 481F7619C4;
        Mon, 29 Mar 2021 22:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056620;
        bh=/frcPlRyDh7HrKhiF9X0DH5goxXEtcstRp0HjSuhiJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlYZLIo0qna1txLmXou/9VUnZIY1xOfFi8l3dyqJ3jB9P1kcEuvdwuGi9sll7uUDy
         cC/N8b/+M4qkeFQq+QCU6LwSGv9d//EvUsD7e3sre8CAUYFSH0bZ0+pDfM5jXis7b/
         9UNCG60fDzt2ACaW0PTNeCvYrGbG7ZNgfVlEp0icCFrnh5yQaa9U6K3x8lRmfeIXxu
         b69N+dGn7Jc5M0Tb6RlD9YubecMHzhtfRNQ881+wmVz3wq1FAYlrxBE55RhIPOQSZK
         vg1kRp6mhE6jVlB9kVZuyty1lVC1HGjtDCfKJVKfGgZQLJhKaHaE9L4JY6O9iKkPdk
         vXO735U0F2fdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/15] scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
Date:   Mon, 29 Mar 2021 18:23:22 -0400
Message-Id: <20210329222327.2383533-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
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
index 47d76c862014..02c4e3beb264 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -970,6 +970,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
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

