Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F4C672BA4
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 23:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjARWs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 17:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjARWsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 17:48:21 -0500
X-Greylist: delayed 555 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Jan 2023 14:48:19 PST
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE61B63E30
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 14:48:19 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D99237FC01;
        Wed, 18 Jan 2023 22:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1674081542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xH/hNzlPIDmK5xDQV/O8YSZykTGysA2REt6itXwtF+k=;
        b=EoNfdyw7Yw2Ruqw093GbrRU3u1i/IVQKi5FGqGXbgXZG001ktwoKDV1KFuQGOekjkWRREi
        KS1CjIdjyxJfCyAloTU9HRKCNP+lJXWvfBn8uePV6Ih6LHv7MBu9I7DrawS4p0G6ERgLrV
        qqiASm1LJT9eC+92h2CyJxuKX/e0QylriwmUxMq9Wl6Owl8dL7KIyAXH2bHiwsWBWUwWYC
        ik80BPl3p8j3IUvdmt7l8UCz55k1qYJYFRSjwLLH/ZBbNav0NdN9J8xARjd3+7JxAKGkqf
        sMWK7pYFPngfKRanG9wq6T5rG43lXuple2ROt45w8FS4hfB7xyLA8KS3kk3TMA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?J=2E_Pablo_Gonz=C3=A1lez?= <disablez@disablez.com>,
        linux-cifs@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [Bug report] Since 5.17 kernel, non existing files may be
 treated as remote DFS entries
In-Reply-To: <CAF2j4JG_w4XD=LzhPHWAMjA2yRqJ6A4K+x8XZ36d2zJOuZp4KQ@mail.gmail.com>
References: <CAF2j4JFp2=J41j3d7MU-QNmHWPbfidG9V86gGagzEm-e4sDRQQ@mail.gmail.com>
 <878ri2d446.fsf@cjr.nz>
 <CAF2j4JG_w4XD=LzhPHWAMjA2yRqJ6A4K+x8XZ36d2zJOuZp4KQ@mail.gmail.com>
Date:   Wed, 18 Jan 2023 19:38:58 -0300
Message-ID: <87pmbbwjr1.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Stable team,

J. Pablo Gonz=C3=A1lez <disablez@disablez.com> writes:

> On Mon, Jan 16, 2023 at 2:02 PM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> J. Pablo Gonz=C3=A1lez <disablez@disablez.com> writes:
>>
>> > We=E2=80=99re experiencing some issues when accessing some mounts in a=
 DFS
>> > share, which seem to happen since kernel 5.17.
>> >
>> > After some investigation, we=E2=80=99ve pinpointed the origin to commit
>> > a2809d0e16963fdf3984409e47f145
>> > cccb0c6821
>> > - Original BZ for that is https://bugzilla.kernel.org/show_bug.cgi?id=
=3D215440
>> > - Patch discussion is at
>> > https://patchwork.kernel.org/project/cifs-client/patch/YeHUxJ9zTVNrKve=
F@himera.home/
>> > - Similar issues referenced in https://bugzilla.suse.com/show_bug.cgi?=
id=3D1198753
>>
>> 6.2-rc4 has
>>
>>         c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
>>
>> which should fix your issue.
>>
>> Could you try it?  Thanks.
>
> I'll still need to test it more thoroughly, but for now, this patch
> seems to have fixed all issues, including the "-o nodfs ones." Thank
> you!
> Any chance this could be formally backported to 6.1.x ? I see it's
> only tagged for 6.2-rc for now.

Could you please queue

        c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")

for 6.1.y as a fix for

        a2809d0e1696 ("cifs: quirk for STATUS_OBJECT_NAME_INVALID returned =
for non-ASCII dfs refs")

Find attached a backportable version of such commit.  Thanks.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=cifs-reduce-roundtrips-on-create-qinfo-requests.patch

From c877ce47e1378dbafa6f1bf84c0c83a05ca8972a Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Mon, 12 Dec 2022 23:39:37 -0300
Subject: [PATCH] cifs: reduce roundtrips on create/qinfo requests

To work around some Window servers that return
STATUS_OBJECT_NAME_INVALID on query infos under DFS namespaces that
contain non-ASCII characters, we started checking for -ENOENT on every
file open, and if so, then send additional requests to figure out
whether it is a DFS link or not.  It means that all those requests
will be sent to every non-existing file.

So, in order to reduce the number of roundtrips, check earlier whether
status code is STATUS_OBJECT_NAME_INVALID and tcon supports dfs, and
if so, then map -ENOENT to -EREMOTE so mount or automount will take
care of chasing the DFS link -- if it isn't an DFS link, then -ENOENT
will be returned appropriately.

Before patch

  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...
  SMB2 228 Ioctl Request FSCTL_DFS_GET_REFERRALS, File: \ada.test\dfs\foo
  SMB2 143 Ioctl Response, Error: STATUS_OBJECT_PATH_NOT_FOUND
  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...
  SMB2 228 Ioctl Request FSCTL_DFS_GET_REFERRALS, File: \ada.test\dfs\foo
  SMB2 143 Ioctl Response, Error: STATUS_OBJECT_PATH_NOT_FOUND

After patch

  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...
  SMB2 438 Create Request File: ada.test\dfs\foo;GetInfo Request...
  SMB2 310 Create Response, Error: STATUS_OBJECT_NAME_NOT_FOUND;...

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c   | 16 ----------------
 fs/cifs/inode.c     |  6 ------
 fs/cifs/misc.c      | 45 ---------------------------------------------
 fs/cifs/smb2inode.c | 45 ++++++++++++++++++++++++++++++++-------------
 fs/cifs/smb2ops.c   | 28 ++++++++++++++++++++++++----
 5 files changed, 56 insertions(+), 84 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fde1c371605a..eab36e4ea130 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3554,9 +3554,6 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 	struct cifs_tcon *tcon = mnt_ctx->tcon;
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	char *full_path;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
-#endif
 
 	if (!server->ops->is_path_accessible)
 		return -EOPNOTSUPP;
@@ -3573,19 +3570,6 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 
 	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
 					     full_path);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	if (nodfs) {
-		if (rc == -EREMOTE)
-			rc = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* path *might* exist with non-ASCII characters in DFS root
-	 * try again with full path (only if nodfs is not set) */
-	if (rc == -ENOENT && is_tcon_dfs(tcon))
-		rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
-							full_path);
-#endif
 	if (rc != 0 && rc != -EREMOTE)
 		goto out;
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 4e2ca3c6e5c0..0c9b619e4386 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -991,12 +991,6 @@ int cifs_get_inode_info(struct inode **inode, const char *full_path,
 		}
 		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path, &tmp_data,
 						  &adjust_tz, &is_reparse_point);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-		if (rc == -ENOENT && is_tcon_dfs(tcon))
-			rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon,
-								cifs_sb,
-								full_path);
-#endif
 		data = &tmp_data;
 	}
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1cbecd64d697..062175994e87 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1314,49 +1314,4 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	return 0;
 }
-
-/** cifs_dfs_query_info_nonascii_quirk
- * Handle weird Windows SMB server behaviour. It responds with
- * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
- * for "\<server>\<dfsname>\<linkpath>" DFS reference,
- * where <dfsname> contains non-ASCII unicode symbols.
- *
- * Check such DFS reference.
- */
-int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
-				       struct cifs_tcon *tcon,
-				       struct cifs_sb_info *cifs_sb,
-				       const char *linkpath)
-{
-	char *treename, *dfspath, sep;
-	int treenamelen, linkpathlen, rc;
-
-	treename = tcon->tree_name;
-	/* MS-DFSC: All paths in REQ_GET_DFS_REFERRAL and RESP_GET_DFS_REFERRAL
-	 * messages MUST be encoded with exactly one leading backslash, not two
-	 * leading backslashes.
-	 */
-	sep = CIFS_DIR_SEP(cifs_sb);
-	if (treename[0] == sep && treename[1] == sep)
-		treename++;
-	linkpathlen = strlen(linkpath);
-	treenamelen = strnlen(treename, MAX_TREE_SIZE + 1);
-	dfspath = kzalloc(treenamelen + linkpathlen + 1, GFP_KERNEL);
-	if (!dfspath)
-		return -ENOMEM;
-	if (treenamelen)
-		memcpy(dfspath, treename, treenamelen);
-	memcpy(dfspath + treenamelen, linkpath, linkpathlen);
-	rc = dfs_cache_find(xid, tcon->ses, cifs_sb->local_nls,
-			    cifs_remap(cifs_sb), dfspath, NULL, NULL);
-	if (rc == 0) {
-		cifs_dbg(FYI, "DFS ref '%s' is found, emulate -EREMOTE\n",
-			 dfspath);
-		rc = -EREMOTE;
-	} else {
-		cifs_dbg(FYI, "%s: dfs_cache_find returned %d\n", __func__, rc);
-	}
-	kfree(dfspath);
-	return rc;
-}
 #endif
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 68e08c85fbb8..6c84d2983166 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -540,22 +540,41 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_QUERY_INFO, cfile,
 			      err_iov, err_buftype);
-	if (rc == -EOPNOTSUPP) {
-		if (err_iov[0].iov_base && err_buftype[0] != CIFS_NO_BUFFER &&
-		    ((struct smb2_hdr *)err_iov[0].iov_base)->Command == SMB2_CREATE &&
-		    ((struct smb2_hdr *)err_iov[0].iov_base)->Status == STATUS_STOPPED_ON_SYMLINK) {
-			rc = smb2_parse_symlink_response(cifs_sb, err_iov, &data->symlink_target);
+	if (rc) {
+		struct smb2_hdr *hdr = err_iov[0].iov_base;
+
+		if (unlikely(!hdr || err_buftype[0] == CIFS_NO_BUFFER))
+			goto out;
+		if (rc == -EOPNOTSUPP && hdr->Command == SMB2_CREATE &&
+		    hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
+			rc = smb2_parse_symlink_response(cifs_sb, err_iov,
+							 &data->symlink_target);
 			if (rc)
 				goto out;
+
+			*reparse = true;
+			create_options |= OPEN_REPARSE_POINT;
+
+			/* Failed on a symbolic link - query a reparse point info */
+			cifs_get_readable_path(tcon, full_path, &cfile);
+			rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+					      FILE_READ_ATTRIBUTES, FILE_OPEN,
+					      create_options, ACL_NO_MODE, data,
+					      SMB2_OP_QUERY_INFO, cfile, NULL, NULL);
+			goto out;
+		} else if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
+			   hdr->Status == STATUS_OBJECT_NAME_INVALID) {
+			/*
+			 * Handle weird Windows SMB server behaviour. It responds with
+			 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
+			 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
+			 * where <dfsname> contains non-ASCII unicode symbols.
+			 */
+			rc = -EREMOTE;
 		}
-		*reparse = true;
-		create_options |= OPEN_REPARSE_POINT;
-
-		/* Failed on a symbolic link - query a reparse point info */
-		cifs_get_readable_path(tcon, full_path, &cfile);
-		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES,
-				      FILE_OPEN, create_options, ACL_NO_MODE, data,
-				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL);
+		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
+		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+			rc = -EOPNOTSUPP;
 	}
 
 out:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 8da98918cf86..1ff5b6b0e07a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -797,7 +797,9 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_open_parms oparms;
+	struct kvec err_iov = {};
 	struct cifs_fid fid;
 	struct cached_fid *cfid;
 
@@ -821,14 +823,32 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
-		       NULL);
+	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
+		       &err_iov, &err_buftype);
 	if (rc) {
-		kfree(utf16_path);
-		return rc;
+		struct smb2_hdr *hdr = err_iov.iov_base;
+
+		if (unlikely(!hdr || err_buftype == CIFS_NO_BUFFER))
+			goto out;
+		/*
+		 * Handle weird Windows SMB server behaviour. It responds with
+		 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
+		 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
+		 * where <dfsname> contains non-ASCII unicode symbols.
+		 */
+		if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
+		    hdr->Status == STATUS_OBJECT_NAME_INVALID)
+			rc = -EREMOTE;
+		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
+		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
+			rc = -EOPNOTSUPP;
+		goto out;
 	}
 
 	rc = SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+
+out:
+	free_rsp_buf(err_buftype, err_iov.iov_base);
 	kfree(utf16_path);
 	return rc;
 }
-- 
2.39.0


--=-=-=--
