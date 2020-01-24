Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18F14837D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391947AbgAXLgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390172AbgAXLgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:36:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9E3206D4;
        Fri, 24 Jan 2020 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865795;
        bh=blAYZbvm7nn6eXGXl1eTJiZIa7ZOATrrxs34OfeT0PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdGKq1hwcnxN0JpQxDuSHITt6GmfAiQCrQw9hi+MydY2m115PdpZsVkg/93POkj9V
         ZrrLIkvNoEM7nehLvPIK2/OIRt28OrINioYZ0TlcbhQFfxKWc7fwAcUmWGSL+Re+0G
         LL0Sj07Gi8Dl22NWcdqf+iCHC9Y3MelDa6WS/6aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 629/639] affs: fix a memory leak in affs_remount
Date:   Fri, 24 Jan 2020 10:33:19 +0100
Message-Id: <20200124093208.423223207@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d1ad11a8a4a59..b6ce0c36029bd 100644
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



