Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AD613E5AA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390947AbgAPROO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390337AbgAPRON (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8998C246B0;
        Thu, 16 Jan 2020 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194853;
        bh=CLw4gHOlzKBi2xPBIjgsxQE+QMGm79q1jYQOrUriOKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUISP019mid0IRN2r3mZ5GFvkt98KFbLiChtrnr0zZmcJkADeihqAmfI63E9Ab63X
         jnJ46OZSRdMMKHlrLqqEf4GvAj8CgPWm7r2nZce3wsFYG4qrBsJxL9MDPPYah6WXQ0
         0o/vJLCxWqsSR5rOGVxWr7jI+4jtouaA36+eJGWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 649/671] affs: fix a memory leak in affs_remount
Date:   Thu, 16 Jan 2020 12:04:47 -0500
Message-Id: <20200116170509.12787-386-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 450c3d4166837c496ebce03650c08800991f2150 ]

In affs_remount if data is provided it is duplicated into new_opts.  The
allocated memory for new_opts is only released if parse_options fails.

There's a bit of history behind new_options, originally there was
save/replace options on the VFS layer so the 'data' passed must not
change (thus strdup), this got cleaned up in later patches. But not
completely.

There's no reason to do the strdup in cases where the filesystem does
not need to reuse the 'data' again, because strsep would modify it
directly.

Fixes: c8f33d0bec99 ("affs: kstrdup() memory handling")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index d1ad11a8a4a5..b6ce0c36029b 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -561,14 +561,9 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	int			 root_block;
 	unsigned long		 mount_flags;
 	int			 res = 0;
-	char			*new_opts;
 	char			 volume[32];
 	char			*prefix = NULL;
 
-	new_opts = kstrdup(data, GFP_KERNEL);
-	if (data && !new_opts)
-		return -ENOMEM;
-
 	pr_debug("%s(flags=0x%x,opts=\"%s\")\n", __func__, *flags, data);
 
 	sync_filesystem(sb);
@@ -579,7 +574,6 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 			   &blocksize, &prefix, volume,
 			   &mount_flags)) {
 		kfree(prefix);
-		kfree(new_opts);
 		return -EINVAL;
 	}
 
-- 
2.20.1

