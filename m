Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670C45C12D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347103AbhKXNPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348544AbhKXNNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:13:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A10761248;
        Wed, 24 Nov 2021 12:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757780;
        bh=LjySgigGEFpkpOaIZGBYUfKCdv1hq1lfUA+Da8866Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL6qqa09OdS1Yzl65cYDrPYtyqTnGPuSnGf99OwhmXcwHv+9B2wEDKw1A8zqgPXyF
         mX+F8FMisoAtvza/RB8CCeX41GgjbyV4uUPcV0Ic8NR/nY8WhdNLekaGTW82MuKKVk
         a8odzlLnADjwJvTEIr62eKtOwubp/YWFfB1HADXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 275/323] scsi: target: Fix alua_tg_pt_gps_count tracking
Date:   Wed, 24 Nov 2021 12:57:45 +0100
Message-Id: <20211124115728.177953134@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e46ca968009c0..804956c712a5a 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1716,7 +1716,6 @@ int core_alua_set_tg_pt_gp_id(
 		pr_err("Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
-		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 		return -ENOSPC;
 	}
 again:
-- 
2.33.0



