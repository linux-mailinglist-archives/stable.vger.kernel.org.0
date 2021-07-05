Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05F23BBF46
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhGEPb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232208AbhGEPbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B06BF619A3;
        Mon,  5 Jul 2021 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498947;
        bh=PmdTRyrk2fYR1G6c8lKyKUpIjHZZ4kzHvUHxo91goiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhIHCaqscdDI0LvtCZl7K+d9wcecsofghllUQL9ZublYpYMOlnYfV8DLVnhnqy1zk
         av/IRHv1CZloEtNBvYEG0labvdjEfr/nS88+C9GYVWmaeCTgI6CyKH/MPqSv4GxtGi
         FZAd3VgaAjru6+K4mcgD++u1C4n7cQoH0pHxOK7tEsAtlknIM2CXoX5vvM3xDpHrtY
         KVxXxBsRNMqXKSMZ4dxXrbIZw85sy8p5i/SesdvmHeX8wS1WD3eUQ0Mz5Vw7Gy8pAr
         ZzrEXzpUaHekRUytEkoycGsayElEnZZN5ZlBVYI6rGoKB1FQUbeH+8rJb1/Io89E1M
         oT1WJTR3p8PeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 39/59] cifs: fix check of dfs interlinks
Date:   Mon,  5 Jul 2021 11:27:55 -0400
Message-Id: <20210705152815.1520546-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b1fa30fefe1f..8e16ee1e5fd1 100644
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
@@ -171,7 +170,7 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
 				   ce->path, ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
 				   ce->ttl, ce->etime.tv_nsec, ce->ref_flags, ce->hdr_flags,
-				   IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
+				   IS_DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
 				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
 
 			list_for_each_entry(t, &ce->tlist, list) {
@@ -240,7 +239,7 @@ static inline void dump_ce(const struct cache_entry *ce)
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

