Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3B44B8AB
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344294AbhKIWp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345935AbhKIWn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:43:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B070761B45;
        Tue,  9 Nov 2021 22:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496659;
        bh=5jF8UW9ywMp5f1se+mwd14wESIYgVkguv5XTK3a5ip8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnc/eDSSEMfULcqhTNvKYp/U39p6c0Rc2xIqOwd9eIS2N5paswkD9kEUMrg4a+Bbs
         1DAzkXHqct0y+XUsQNzbTgULV/bOfzyjTktIP/mbAhx6/hCOgjVamIC9IzNfreX+XE
         xuW7PMe0rzqcs51003nOuE69LlhWS1m8WqSy6FqmrSuiIkMMTbmzQkF6kf0uPGM0DZ
         gBekg0beoASheYbpNPjAVniR2IoHrLE1iFkVVz4gixNI/TV1FobuWpyrSwk7Hlb6Ri
         VE4YzVXtLiAHda0+tqOEHwEQCH8MT60BDlLhC3baZK4VIeW0at0y8cY8Wj8IUIvENY
         WyOmViPrjzEpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, nab@linux-iscsi.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/13] scsi: target: Fix alua_tg_pt_gps_count tracking
Date:   Tue,  9 Nov 2021 17:24:01 -0500
Message-Id: <20211109222405.1236040-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222405.1236040-1-sashal@kernel.org>
References: <20211109222405.1236040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 1283c0d1a32bb924324481586b5d6e8e76f676ba ]

We can't free the tg_pt_gp in core_alua_set_tg_pt_gp_id() because it's
still accessed via configfs. Its release must go through the normal
configfs/refcount process.

The max alua_tg_pt_gps_count check should probably have been done in
core_alua_allocate_tg_pt_gp(), but with the current code userspace could
have created 0x0000ffff + 1 groups, but only set the id for 0x0000ffff.
Then it could have deleted a group with an ID set, and then set the ID for
that extra group and it would work ok.

It's unlikely, but just in case this patch continues to allow that type of
behavior, and just fixes the kfree() while in use bug.

Link: https://lore.kernel.org/r/20210930020422.92578-4-michael.christie@oracle.com
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_alua.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index ee5b29aed54bd..fa28fd89add6c 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1735,7 +1735,6 @@ int core_alua_set_tg_pt_gp_id(
 		pr_err("Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
-		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 		return -ENOSPC;
 	}
 again:
-- 
2.33.0

