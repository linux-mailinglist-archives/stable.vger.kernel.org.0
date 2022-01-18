Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082A3491A82
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352519AbiARDAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345672AbiARCs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3480C061753;
        Mon, 17 Jan 2022 18:40:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 910C261278;
        Tue, 18 Jan 2022 02:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E693C36AF5;
        Tue, 18 Jan 2022 02:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473604;
        bh=oI1tILeYJHphG+rnfp4DSdnyYZnshvVn8lVEbfxuC8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JszQXjKWNai4s3S1sJMnbDE9HUiU02MbLzJPkbLFOG9/c7+DP5WaPRUW0zKXDPosm
         jwsPWMhn/ZarqvyUMDcHbCBRLk7N9icNYLeBAWV+sYEEtBs/KiON/p3Lu14YnsCSW2
         rif1bxDjjTE2ZvaV5tBMoyD591l5lzXabQnkGLJQctvHqFRGMvzb2WjgkCEzYbM3Mr
         zlqSC/vKBd0xlN3cXKWhgT9L7d6o+9oCb5WjImx6HOBhO6lZZCKLbG6+puwMPd8d88
         bVvzLLkb80ZMINCaQY+nXWwy6/EiDjS1FcOw3cfEBD7nJabT7S60/YPkQNzOe/RALq
         kfdowHredVimw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Czerner <lczerner@redhat.com>,
        Laurent GUERBY <laurent@guerby.net>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 188/188] ext4: allow to change s_last_trim_minblks via sysfs
Date:   Mon, 17 Jan 2022 21:31:52 -0500
Message-Id: <20220118023152.1948105-188-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit 4a69aecbfb30a3fc85bf8028386c047d5607a97a ]

Ext4 has an optimization mechanism for batched disacrd (FITRIM) that
should help speed up subsequent calls of FITRIM ioctl by skipping the
groups that were previously trimmed. However because the FITRIM allows
to set the minimum size of an extent to trim, ext4 stores the last
minimum extent size and only avoids trimming the group if it was
previously trimmed with minimum extent size equal to, or smaller than
the current call.

There is currently no way to bypass the optimization without
umount/mount cycle. This becomes a problem when the file system is
live migrated to a different storage, because the optimization will
prevent possibly useful discard calls to the storage.

Fix it by exporting the s_last_trim_minblks via sysfs interface which
will allow us to set the minimum size to the number of blocks larger
than subsequent FITRIM call, effectively bypassing the optimization.

By setting the s_last_trim_minblks to ULONG_MAX the optimization will be
effectively cleared regardless of the previous state, or file system
configuration.

For example:
getconf ULONG_MAX > /sys/fs/ext4/dm-1/last_trim_minblks

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Laurent GUERBY <laurent@guerby.net>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20211103145122.17338-2-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 2314f74465924..95d8a996d2d89 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -245,6 +245,7 @@ EXT4_ATTR(last_error_time, 0444, last_error_time);
 EXT4_ATTR(journal_task, 0444, journal_task);
 EXT4_RW_ATTR_SBI_UI(mb_prefetch, s_mb_prefetch);
 EXT4_RW_ATTR_SBI_UI(mb_prefetch_limit, s_mb_prefetch_limit);
+EXT4_RW_ATTR_SBI_UL(last_trim_minblks, s_last_trim_minblks);
 
 static unsigned int old_bump_val = 128;
 EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
@@ -295,6 +296,7 @@ static struct attribute *ext4_attrs[] = {
 #endif
 	ATTR_LIST(mb_prefetch),
 	ATTR_LIST(mb_prefetch_limit),
+	ATTR_LIST(last_trim_minblks),
 	NULL,
 };
 ATTRIBUTE_GROUPS(ext4);
-- 
2.34.1

