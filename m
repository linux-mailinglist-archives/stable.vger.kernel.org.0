Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8653291E9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243469AbhCAUgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237038AbhCAU3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:29:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B616541B;
        Mon,  1 Mar 2021 18:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622057;
        bh=sdURjXQa+rXw4apGga8w1TQh81Xvfh98vPomw5v7RMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHHc+XGt2CxcRMnCWGavQyi0GCCtyInAq/GTnDcRX2ZlUCfTQ+fv8NU+34duVHXKJ
         5ItDS5J0v5rcxzPd0kfW8I9Xa82CSLb99aEqwg0BFxHdegyIcKtMMRHa9bjIA3gxwA
         JY5LzmwSekzyYqOt6osm1FlGz87LQatdmiX+oqrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 742/775] cifs: introduce helper for finding referral server to improve DFS target resolution
Date:   Mon,  1 Mar 2021 17:15:10 +0100
Message-Id: <20210301161238.000312499@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 5ff2836ed3a5c24420a7235be25a462594cdc4ea upstream.

Some servers seem to mistakenly report different values for
capabilities and share flags, so we can't always rely on those values
to decide whether the resolved target can handle any new DFS
referrals.

Add a new helper is_referral_server() to check if all resolved targets
can handle new DFS referrals by directly looking at the
GET_DFS_REFERRAL.ReferralHeaderFlags value as specified in MS-DFSC
2.2.4 RESP_GET_DFS_REFERRAL in addition to is_tcon_dfs().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c   |   35 ++++++++++++++++++++++++++++++++++-
 fs/cifs/dfs_cache.c |   33 +++++++++++++++++----------------
 2 files changed, 51 insertions(+), 17 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3324,6 +3324,33 @@ out:
 	return rc;
 }
 
+/* Check if resolved targets can handle any DFS referrals */
+static int is_referral_server(const char *ref_path, struct cifs_tcon *tcon, bool *ref_server)
+{
+	int rc;
+	struct dfs_info3_param ref = {0};
+
+	if (is_tcon_dfs(tcon)) {
+		*ref_server = true;
+	} else {
+		cifs_dbg(FYI, "%s: ref_path=%s\n", __func__, ref_path);
+
+		rc = dfs_cache_noreq_find(ref_path, &ref, NULL);
+		if (rc) {
+			cifs_dbg(VFS, "%s: dfs_cache_noreq_find: failed (rc=%d)\n", __func__, rc);
+			return rc;
+		}
+		cifs_dbg(FYI, "%s: ref.flags=0x%x\n", __func__, ref.flags);
+		/*
+		 * Check if all targets are capable of handling DFS referrals as per
+		 * MS-DFSC 2.2.4 RESP_GET_DFS_REFERRAL.
+		 */
+		*ref_server = !!(ref.flags & DFSREF_REFERRAL_SERVER);
+		free_dfs_info_param(&ref);
+	}
+	return 0;
+}
+
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
@@ -3335,6 +3362,7 @@ int cifs_mount(struct cifs_sb_info *cifs
 	char *ref_path = NULL, *full_path = NULL;
 	char *oldmnt = NULL;
 	char *mntdata = NULL;
+	bool ref_server = false;
 
 	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 	/*
@@ -3400,11 +3428,16 @@ int cifs_mount(struct cifs_sb_info *cifs
 			break;
 		if (!tcon)
 			continue;
+
 		/* Make sure that requests go through new root servers */
-		if (is_tcon_dfs(tcon)) {
+		rc = is_referral_server(ref_path + 1, tcon, &ref_server);
+		if (rc)
+			break;
+		if (ref_server) {
 			put_root_ses(root_ses);
 			set_root_ses(cifs_sb, ses, &root_ses);
 		}
+
 		/* Get next dfs path and then continue chasing them if -EREMOTE */
 		rc = next_dfs_prepath(cifs_sb, ctx, xid, server, tcon, &ref_path);
 		/* Prevent recursion on broken link referrals */
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -37,11 +37,12 @@ struct cache_dfs_tgt {
 struct cache_entry {
 	struct hlist_node hlist;
 	const char *path;
-	int ttl;
-	int srvtype;
-	int flags;
+	int hdr_flags; /* RESP_GET_DFS_REFERRAL.ReferralHeaderFlags */
+	int ttl; /* DFS_REREFERRAL_V3.TimeToLive */
+	int srvtype; /* DFS_REREFERRAL_V3.ServerType */
+	int ref_flags; /* DFS_REREFERRAL_V3.ReferralEntryFlags */
 	struct timespec64 etime;
-	int path_consumed;
+	int path_consumed; /* RESP_GET_DFS_REFERRAL.PathConsumed */
 	int numtgts;
 	struct list_head tlist;
 	struct cache_dfs_tgt *tgthint;
@@ -166,14 +167,11 @@ static int dfscache_proc_show(struct seq
 				continue;
 
 			seq_printf(m,
-				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,"
-				   "interlink=%s,path_consumed=%d,expired=%s\n",
-				   ce->path,
-				   ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
-				   ce->ttl, ce->etime.tv_nsec,
-				   IS_INTERLINK_SET(ce->flags) ? "yes" : "no",
-				   ce->path_consumed,
-				   cache_entry_expired(ce) ? "yes" : "no");
+				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
+				   ce->path, ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
+				   ce->ttl, ce->etime.tv_nsec, ce->ref_flags, ce->hdr_flags,
+				   IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
+				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
 
 			list_for_each_entry(t, &ce->tlist, list) {
 				seq_printf(m, "  %s%s\n",
@@ -236,11 +234,12 @@ static inline void dump_tgts(const struc
 
 static inline void dump_ce(const struct cache_entry *ce)
 {
-	cifs_dbg(FYI, "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,interlink=%s,path_consumed=%d,expired=%s\n",
+	cifs_dbg(FYI, "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
 		 ce->path,
 		 ce->srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ttl,
 		 ce->etime.tv_nsec,
-		 IS_INTERLINK_SET(ce->flags) ? "yes" : "no",
+		 ce->hdr_flags, ce->ref_flags,
+		 IS_INTERLINK_SET(ce->hdr_flags) ? "yes" : "no",
 		 ce->path_consumed,
 		 cache_entry_expired(ce) ? "yes" : "no");
 	dump_tgts(ce);
@@ -381,7 +380,8 @@ static int copy_ref_data(const struct df
 	ce->ttl = refs[0].ttl;
 	ce->etime = get_expire_time(ce->ttl);
 	ce->srvtype = refs[0].server_type;
-	ce->flags = refs[0].ref_flag;
+	ce->hdr_flags = refs[0].flags;
+	ce->ref_flags = refs[0].ref_flag;
 	ce->path_consumed = refs[0].path_consumed;
 
 	for (i = 0; i < numrefs; i++) {
@@ -799,7 +799,8 @@ static int setup_referral(const char *pa
 	ref->path_consumed = ce->path_consumed;
 	ref->ttl = ce->ttl;
 	ref->server_type = ce->srvtype;
-	ref->ref_flag = ce->flags;
+	ref->ref_flag = ce->ref_flags;
+	ref->flags = ce->hdr_flags;
 
 	return 0;
 


