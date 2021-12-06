Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D90146995C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344504AbhLFOsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 09:48:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47648 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344411AbhLFOsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 09:48:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4996612D4;
        Mon,  6 Dec 2021 14:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590CEC341C2;
        Mon,  6 Dec 2021 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638801885;
        bh=cUjbe/EJAxsJ8SgLeq77UY5nWkrmwigTYc5XTbzXi8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQjdO0FVrurbWZwCXDtJKfjtObhATEZmVtxJCVai418GhufbzFVrL2heqVLnI5cWS
         cuqzt3zMUE3ZQoWwsO3go8P7a+X7KH2ZAbOiAyTQJ1hBuOdWSXdIuoemuhNnibsFeO
         kvZBNntunIbY3TSYXWOOivUjWhMgQcLnXJmg56Yi/PIT7VYbytWO9uhDlAiCD1xENP
         70QC2C11JhCSl+Skz+DgKr1c5fM4rt2MfllQ79lWZCApHv2YFXIwzcWe32kWshepMj
         hGAJDleidIhl3gQCVW3QFotxItH5BOeofXYnFXt1XBVgCCEm8F9MfED53lbbuCqCTw
         7EDZOniskqNew==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] f2fs: fix to do sanity check in is_alive()
Date:   Mon,  6 Dec 2021 22:44:21 +0800
Message-Id: <20211206144421.3735-3-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206144421.3735-1-chao@kernel.org>
References: <20211206144421.3735-1-chao@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In fuzzed image, SSA table may indicate that a data block belongs to
invalid node, which node ID is out-of-range (0, 1, 2 or max_nid), in
order to avoid migrating inconsistent data in such corrupted image,
let's do sanity check anyway before data block migration.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/gc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3e64b234df21..b538cbcba351 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1026,6 +1026,9 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
 
+	if (f2fs_check_nid_range(sbi, dni->ino))
+		return false;
+
 	*nofs = ofs_of_node(node_page);
 	source_blkaddr = data_blkaddr(NULL, node_page, ofs_in_node);
 	f2fs_put_page(node_page, 1);
-- 
2.32.0

