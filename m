Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76AE45C331
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348959AbhKXNgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347110AbhKXNeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:34:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7CC8611C5;
        Wed, 24 Nov 2021 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758446;
        bh=OSnGHfoonZUMR5n0uTW0l0jcpsipm3GfZ/IacPzI8Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWgLifDuBD/WX6KagBO0q5dRqKdfxuhRZdRBjN81kUGFlcUdpvAEuymEL6gw4FTqc
         rWNsY2h2NPRexxcsKDU5qVbbaDL/wTRq5kvWUeKpgiQxuPoL8slTl2F0HSJEZfm7tD
         DN29TQbRnAF+vPdXNgu377zFY/CVmqfFo2IU+lu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/154] scsi: target: Fix alua_tg_pt_gps_count tracking
Date:   Wed, 24 Nov 2021 12:57:17 +0100
Message-Id: <20211124115703.678247764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index 6b72afee2f8b7..b240bd1ccb71d 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1702,7 +1702,6 @@ int core_alua_set_tg_pt_gp_id(
 		pr_err("Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
-		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 		return -ENOSPC;
 	}
 again:
-- 
2.33.0



