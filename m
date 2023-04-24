Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE5F6DEE37
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjDLIlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjDLIkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847467AAB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B29B62FE4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6D1C433EF;
        Wed, 12 Apr 2023 08:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288698;
        bh=P6WCL041X+PWqQaKsaaUaVJ/YPmO7+2ownAplxPX3zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1g3v8ic51xJXfO3ekecKl6sHcDjCzJwemCCJcz5S4+kQ5dXO8IfgkWIqO2iV6rqR7
         Jc4IKYsQQXDyyEqeU8p0rgWDV2Mh/ya3BbwUP1FtcLBJFa+4D15a5v7cLo+3jPPkIa
         EIyOo3e3iLLnLEWdHJImh3r6c0pb1ut4wmADPuVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 76/93] smb3: allow deferred close timeout to be configurable
Date:   Wed, 12 Apr 2023 10:34:17 +0200
Message-Id: <20230412082826.329566757@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5efdd9122eff772eae2feae9f0fc0ec02d4846a3 ]

Deferred close can be a very useful feature for allowing
caching data for read, and for minimizing the number of
reopens needed for a file that is repeatedly opened and
close but there are workloads where its default (1 second,
similar to actimeo/acregmax) is much too small.

Allow the user to configure the amount of time we can
defer sending the final smb3 close when we have a
handle lease on the file (rather than forcing it to depend
on value of actimeo which is often unrelated, and less safe).

Adds new mount parameter "closetimeo=" which is the maximum
number of seconds we can wait before sending an SMB3
close when we have a handle lease for it.  Default value
also is set to slightly larger at 5 seconds (although some
other clients use larger default this should still help).

Suggested-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d19342c6609b ("cifs: sanitize paths in cifs_update_super_prepath.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c     | 1 +
 fs/cifs/connect.c    | 2 ++
 fs/cifs/file.c       | 4 ++--
 fs/cifs/fs_context.c | 9 +++++++++
 fs/cifs/fs_context.h | 8 ++++++++
 5 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fc736ced6f4a3..26f87437b2dd7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -682,6 +682,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",acdirmax=%lu", cifs_sb->ctx->acdirmax / HZ);
 		seq_printf(s, ",acregmax=%lu", cifs_sb->ctx->acregmax / HZ);
 	}
+	seq_printf(s, ",closetimeo=%lu", cifs_sb->ctx->closetimeo / HZ);
 
 	if (tcon->ses->chan_max > 1)
 		seq_printf(s, ",multichannel,max_channels=%zu",
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 555bd386a24df..f6c41265fdfd9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2436,6 +2436,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 		return 0;
 	if (old->ctx->acdirmax != new->ctx->acdirmax)
 		return 0;
+	if (old->ctx->closetimeo != new->ctx->closetimeo)
+		return 0;
 
 	return 1;
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cca9ff01b30c2..b3cf9ab50139d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -897,12 +897,12 @@ int cifs_close(struct inode *inode, struct file *file)
 				 * So, Increase the ref count to avoid use-after-free.
 				 */
 				if (!mod_delayed_work(deferredclose_wq,
-						&cfile->deferred, cifs_sb->ctx->acregmax))
+						&cfile->deferred, cifs_sb->ctx->closetimeo))
 					cifsFileInfo_get(cfile);
 			} else {
 				/* Deferred close for files */
 				queue_delayed_work(deferredclose_wq,
-						&cfile->deferred, cifs_sb->ctx->acregmax);
+						&cfile->deferred, cifs_sb->ctx->closetimeo);
 				cfile->deferred_close_scheduled = true;
 				spin_unlock(&cinode->deferred_lock);
 				return 0;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 3b8ed36b37113..85ad0c9e2f8b5 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -143,6 +143,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_u32("actimeo", Opt_actimeo),
 	fsparam_u32("acdirmax", Opt_acdirmax),
 	fsparam_u32("acregmax", Opt_acregmax),
+	fsparam_u32("closetimeo", Opt_closetimeo),
 	fsparam_u32("echo_interval", Opt_echo_interval),
 	fsparam_u32("max_credits", Opt_max_credits),
 	fsparam_u32("handletimeout", Opt_handletimeout),
@@ -1058,6 +1059,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		ctx->acdirmax = ctx->acregmax = HZ * result.uint_32;
 		break;
+	case Opt_closetimeo:
+		ctx->closetimeo = HZ * result.uint_32;
+		if (ctx->closetimeo > SMB3_MAX_DCLOSETIMEO) {
+			cifs_errorf(fc, "closetimeo too large\n");
+			goto cifs_parse_mount_err;
+		}
+		break;
 	case Opt_echo_interval:
 		ctx->echo_interval = result.uint_32;
 		break;
@@ -1496,6 +1504,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 
 	ctx->acregmax = CIFS_DEF_ACTIMEO;
 	ctx->acdirmax = CIFS_DEF_ACTIMEO;
+	ctx->closetimeo = SMB3_DEF_DCLOSETIMEO;
 
 	/* Most clients set timeout to 0, allows server to use its default */
 	ctx->handle_timeout = 0; /* See MS-SMB2 spec section 2.2.14.2.12 */
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 29601a4eb4116..b5ae210bafe04 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -123,6 +123,7 @@ enum cifs_param {
 	Opt_actimeo,
 	Opt_acdirmax,
 	Opt_acregmax,
+	Opt_closetimeo,
 	Opt_echo_interval,
 	Opt_max_credits,
 	Opt_snapshot,
@@ -243,6 +244,8 @@ struct smb3_fs_context {
 	/* attribute cache timemout for files and directories in jiffies */
 	unsigned long acregmax;
 	unsigned long acdirmax;
+	/* timeout for deferred close of files in jiffies */
+	unsigned long closetimeo;
 	struct smb_version_operations *ops;
 	struct smb_version_values *vals;
 	char *prepath;
@@ -275,4 +278,9 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
 extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
 extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
+/*
+ * max deferred close timeout (jiffies) - 2^30
+ */
+#define SMB3_MAX_DCLOSETIMEO (1 << 30)
+#define SMB3_DEF_DCLOSETIMEO (5 * HZ) /* Can increase later, other clients use larger */
 #endif
-- 
2.39.2



