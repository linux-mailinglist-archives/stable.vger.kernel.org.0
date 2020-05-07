Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324C51C904D
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgEGOiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgEGO1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6061E20870;
        Thu,  7 May 2020 14:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861661;
        bh=AbF2uNFJWRWl/L5czMYiTGS/1WgEFm5qePayN96IG0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MteUrxW8vja2negiTpGhTzftXr1O5QxoahaHMBFkhujKt0kb0kVhFGPYxyfbCuBl1
         Gqmr1K/IqI6GW9TCuI8M8Niqup9JGQ50irbE6OnHEeVDWbJCpAFC/6mtznT3WYIvhY
         fqZu2ANglPMOZe+6O6XfdiOMMIzZ7FmJYDqE8T5c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 11/50] scsi: target/iblock: fix WRITE SAME zeroing
Date:   Thu,  7 May 2020 10:26:47 -0400
Message-Id: <20200507142726.25751-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 1d2ff149b263c9325875726a7804a0c75ef7112e ]

SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
"shall perform the specified write operation to each LBA specified by the
command".  Commit 2237498f0b5c ("target/iblock: Convert WRITE_SAME to
blkdev_issue_zeroout") modified the iblock backend to call
blkdev_issue_zeroout() when handling WRITE SAME requests with UNMAP=0 and a
zero data segment.

The iblock blkdev_issue_zeroout() call incorrectly provides a flags
parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP.  The bool
false parameter reflects the blkdev_issue_zeroout() API prior to commit
ee472d835c26 ("block: add a flags argument to (__)blkdev_issue_zeroout")
which was merged shortly before 2237498f0b5c.

Link: https://lore.kernel.org/r/20200419163109.11689-1-ddiss@suse.de
Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 51ffd5c002dee..1c181d31f4c87 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -432,7 +432,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 				target_to_linux_sector(dev, cmd->t_task_lba),
 				target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd)),
-				GFP_KERNEL, false);
+				GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-- 
2.20.1

