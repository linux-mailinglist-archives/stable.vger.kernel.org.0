Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1660A194D1C
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgCZX3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgCZXYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDAA20719;
        Thu, 26 Mar 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265063;
        bh=ugF1C5/vF94YwU2OV9TAX2LV23Lfxd+eXmOauT11yTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng01d3FS/SB7hl1mg7H5P6dqdR43ZqI+QKEy+OH/bk5xJxYMuEjOvtVKBlmCp8SrG
         n/Kc9p6/J1nyJ4sPjwrn4KiAbxtOWbpa+eWFi4KY8/0tyyVN1BFDUFBeNXGZmXZEgb
         NFTSl0eMPM4GGA4vA5w04v85ME3DNfKA6SzOfMEA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 22/28] btrfs: fix removal of raid[56|1c34} incompat flags after removing block group
Date:   Thu, 26 Mar 2020 19:23:51 -0400
Message-Id: <20200326232357.7516-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d8e6fd5c7991033037842b32c9774370a038e902 ]

We are incorrectly dropping the raid56 and raid1c34 incompat flags when
there are still raid56 and raid1c34 block groups, not when we do not any
of those anymore. The logic just got unintentionally broken after adding
the support for the raid1c34 modes.

Fix this by clear the flags only if we do not have block groups with the
respective profiles.

Fixes: 9c907446dce3 ("btrfs: drop incompat bit for raid1c34 after last block group is gone")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 6934a5b8708fe..acf0b7d879bc0 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -849,9 +849,9 @@ static void clear_incompat_bg_bits(struct btrfs_fs_info *fs_info, u64 flags)
 				found_raid1c34 = true;
 			up_read(&sinfo->groups_sem);
 		}
-		if (found_raid56)
+		if (!found_raid56)
 			btrfs_clear_fs_incompat(fs_info, RAID56);
-		if (found_raid1c34)
+		if (!found_raid1c34)
 			btrfs_clear_fs_incompat(fs_info, RAID1C34);
 	}
 }
-- 
2.20.1

