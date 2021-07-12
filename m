Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9DB3C4CC3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhGLHHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242109AbhGLHGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27BA861205;
        Mon, 12 Jul 2021 07:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073406;
        bh=nn2wZwDQ4zJF/JdNFxRsoTgZDjGu7g+pmHIAsJijf1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlCbUU20LQ9zxhXvaDlHyILTRQEkDjYriNdOBau2DI/KcL6XyqBDC1Ed48BdCFLbX
         RN35SHRtQraw7uUqhexJFwohgmeMw4KTVs/tnxiISRiTa59iocqdrwp0hRd3KIiV8g
         J3dYAzEpvDimKXijpwz9A8IPFKK8jl8id9JPKpvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 231/700] cifs: fix check of dfs interlinks
Date:   Mon, 12 Jul 2021 08:05:14 +0200
Message-Id: <20210712060959.495900905@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 889c2a700799f3b6f82210925e1faf4a9b833c4a ]

Interlink is a special type of DFS link that resolves to a different
DFS domain-based namespace.  To determine whether it is an interlink
or not, check if ReferralServers and StorageServers bits are set to 1
and 0 respectively in ReferralHeaderFlags, as specified in MS-DFSC
3.1.5.4.5 Determining Whether a Referral Response is an Interlink.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dfs_cache.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 098b4bc8da59..d2d686ee10a3 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -25,8 +25,7 @@
 #define CACHE_HTABLE_SIZE 32
 #define CACHE_MAX_ENTRIES 64
 
-#define IS_INTERLINK_SET(v) ((v) & (DFSREF_REFERRAL_SERVER | \
-				    DFSREF_STORAGE_SERVER))
+#define IS_DFS_INTERLINK(v) (((v) & DFSREF_REFERRAL_SERVER) && !((v) & DFSREF_STORAGE_SERVER))
 
 struct cache_dfs_tgt {
 	char *name;
@@ -170,7 +169,7 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
 				   ce->path, ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
 				   ce->ttl, ce->etime.tv_nsec, ce->ref_flags, ce->hdr_flags,
-				   IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
+				   IS_DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
 				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
 
 			list_for_each_entry(t, &ce->tlist, list) {
@@ -239,7 +238,7 @@ static inline void dump_ce(const struct cache_entry *ce)
 		 ce->srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ttl,
 		 ce->etime.tv_nsec,
 		 ce->hdr_flags, ce->ref_flags,
-		 IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
+		 IS_DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
 		 ce->path_consumed,
 		 cache_entry_expired(ce) ? "yes" : "no");
 	dump_tgts(ce);
-- 
2.30.2



