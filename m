Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D484F2FE4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiDEJKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244216AbiDEIvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E7CD3AED;
        Tue,  5 Apr 2022 01:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17415B81B92;
        Tue,  5 Apr 2022 08:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C2DC385A1;
        Tue,  5 Apr 2022 08:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148030;
        bh=wpvEg1OyiXjrTwVS4vykPInIRUlKYaxO8RGYbB+Hdkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HR9PlwqtbuwkdChbLEkhcp3ZIG459z4+IfqxXtU0YRJabiC2w7DO5EFK4zETU5Sde
         TfwaKbB592Tcqg1RgOWW5rv/Mzh/Fb2d5V8jTQOMhNpW7uR35Nr0jBfBwX9EMmRvEI
         okKBQdW+kcAdQFIND8x2a7NY7gwwHB2i7RHLCOCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0209/1017] selinux: Fix selinux_sb_mnt_opts_compat()
Date:   Tue,  5 Apr 2022 09:18:42 +0200
Message-Id: <20220405070400.454980834@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit b8b87fd954b4b1bdd2d739c8f50bf685351a1a94 ]

selinux_sb_mnt_opts_compat() is called under the sb_lock spinlock and
shouldn't be performing any memory allocations.  Fix this by parsing the
sids at the same time we're chopping up the security mount options
string and then using the pre-parsed sids when doing the comparison.

Fixes: cc274ae7763d ("selinux: fix sleeping function called from invalid context")
Fixes: 69c4a42d72eb ("lsm,selinux: add new hook to compare new mount to an existing mount")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 75 ++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5b4b738a3be4..30f08fc1ac09 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -355,6 +355,10 @@ static void inode_free_security(struct inode *inode)
 
 struct selinux_mnt_opts {
 	const char *fscontext, *context, *rootcontext, *defcontext;
+	u32 fscontext_sid;
+	u32 context_sid;
+	u32 rootcontext_sid;
+	u32 defcontext_sid;
 };
 
 static void selinux_free_mnt_opts(void *mnt_opts)
@@ -611,15 +615,14 @@ static int bad_option(struct superblock_security_struct *sbsec, char flag,
 	return 0;
 }
 
-static int parse_sid(struct super_block *sb, const char *s, u32 *sid,
-		     gfp_t gfp)
+static int parse_sid(struct super_block *sb, const char *s, u32 *sid)
 {
 	int rc = security_context_str_to_sid(&selinux_state, s,
-					     sid, gfp);
+					     sid, GFP_KERNEL);
 	if (rc)
 		pr_warn("SELinux: security_context_str_to_sid"
 		       "(%s) failed for (dev %s, type %s) errno=%d\n",
-		       s, sb->s_id, sb->s_type->name, rc);
+		       s, sb ? sb->s_id : "?", sb ? sb->s_type->name : "?", rc);
 	return rc;
 }
 
@@ -686,8 +689,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	 */
 	if (opts) {
 		if (opts->fscontext) {
-			rc = parse_sid(sb, opts->fscontext, &fscontext_sid,
-					GFP_KERNEL);
+			rc = parse_sid(sb, opts->fscontext, &fscontext_sid);
 			if (rc)
 				goto out;
 			if (bad_option(sbsec, FSCONTEXT_MNT, sbsec->sid,
@@ -696,8 +698,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 			sbsec->flags |= FSCONTEXT_MNT;
 		}
 		if (opts->context) {
-			rc = parse_sid(sb, opts->context, &context_sid,
-					GFP_KERNEL);
+			rc = parse_sid(sb, opts->context, &context_sid);
 			if (rc)
 				goto out;
 			if (bad_option(sbsec, CONTEXT_MNT, sbsec->mntpoint_sid,
@@ -706,8 +707,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 			sbsec->flags |= CONTEXT_MNT;
 		}
 		if (opts->rootcontext) {
-			rc = parse_sid(sb, opts->rootcontext, &rootcontext_sid,
-					GFP_KERNEL);
+			rc = parse_sid(sb, opts->rootcontext, &rootcontext_sid);
 			if (rc)
 				goto out;
 			if (bad_option(sbsec, ROOTCONTEXT_MNT, root_isec->sid,
@@ -716,8 +716,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 			sbsec->flags |= ROOTCONTEXT_MNT;
 		}
 		if (opts->defcontext) {
-			rc = parse_sid(sb, opts->defcontext, &defcontext_sid,
-					GFP_KERNEL);
+			rc = parse_sid(sb, opts->defcontext, &defcontext_sid);
 			if (rc)
 				goto out;
 			if (bad_option(sbsec, DEFCONTEXT_MNT, sbsec->def_sid,
@@ -1009,21 +1008,29 @@ static int selinux_add_opt(int token, const char *s, void **mnt_opts)
 		if (opts->context || opts->defcontext)
 			goto Einval;
 		opts->context = s;
+		if (selinux_initialized(&selinux_state))
+			parse_sid(NULL, s, &opts->context_sid);
 		break;
 	case Opt_fscontext:
 		if (opts->fscontext)
 			goto Einval;
 		opts->fscontext = s;
+		if (selinux_initialized(&selinux_state))
+			parse_sid(NULL, s, &opts->fscontext_sid);
 		break;
 	case Opt_rootcontext:
 		if (opts->rootcontext)
 			goto Einval;
 		opts->rootcontext = s;
+		if (selinux_initialized(&selinux_state))
+			parse_sid(NULL, s, &opts->rootcontext_sid);
 		break;
 	case Opt_defcontext:
 		if (opts->context || opts->defcontext)
 			goto Einval;
 		opts->defcontext = s;
+		if (selinux_initialized(&selinux_state))
+			parse_sid(NULL, s, &opts->defcontext_sid);
 		break;
 	}
 	return 0;
@@ -2697,8 +2704,6 @@ static int selinux_sb_mnt_opts_compat(struct super_block *sb, void *mnt_opts)
 {
 	struct selinux_mnt_opts *opts = mnt_opts;
 	struct superblock_security_struct *sbsec = selinux_superblock(sb);
-	u32 sid;
-	int rc;
 
 	/*
 	 * Superblock not initialized (i.e. no options) - reject if any
@@ -2715,34 +2720,36 @@ static int selinux_sb_mnt_opts_compat(struct super_block *sb, void *mnt_opts)
 		return (sbsec->flags & SE_MNTMASK) ? 1 : 0;
 
 	if (opts->fscontext) {
-		rc = parse_sid(sb, opts->fscontext, &sid, GFP_NOWAIT);
-		if (rc)
+		if (opts->fscontext_sid == SECSID_NULL)
 			return 1;
-		if (bad_option(sbsec, FSCONTEXT_MNT, sbsec->sid, sid))
+		else if (bad_option(sbsec, FSCONTEXT_MNT, sbsec->sid,
+				       opts->fscontext_sid))
 			return 1;
 	}
 	if (opts->context) {
-		rc = parse_sid(sb, opts->context, &sid, GFP_NOWAIT);
-		if (rc)
+		if (opts->context_sid == SECSID_NULL)
 			return 1;
-		if (bad_option(sbsec, CONTEXT_MNT, sbsec->mntpoint_sid, sid))
+		else if (bad_option(sbsec, CONTEXT_MNT, sbsec->mntpoint_sid,
+				       opts->context_sid))
 			return 1;
 	}
 	if (opts->rootcontext) {
-		struct inode_security_struct *root_isec;
-
-		root_isec = backing_inode_security(sb->s_root);
-		rc = parse_sid(sb, opts->rootcontext, &sid, GFP_NOWAIT);
-		if (rc)
-			return 1;
-		if (bad_option(sbsec, ROOTCONTEXT_MNT, root_isec->sid, sid))
+		if (opts->rootcontext_sid == SECSID_NULL)
 			return 1;
+		else {
+			struct inode_security_struct *root_isec;
+
+			root_isec = backing_inode_security(sb->s_root);
+			if (bad_option(sbsec, ROOTCONTEXT_MNT, root_isec->sid,
+				       opts->rootcontext_sid))
+				return 1;
+		}
 	}
 	if (opts->defcontext) {
-		rc = parse_sid(sb, opts->defcontext, &sid, GFP_NOWAIT);
-		if (rc)
+		if (opts->defcontext_sid == SECSID_NULL)
 			return 1;
-		if (bad_option(sbsec, DEFCONTEXT_MNT, sbsec->def_sid, sid))
+		else if (bad_option(sbsec, DEFCONTEXT_MNT, sbsec->def_sid,
+				       opts->defcontext_sid))
 			return 1;
 	}
 	return 0;
@@ -2762,14 +2769,14 @@ static int selinux_sb_remount(struct super_block *sb, void *mnt_opts)
 		return 0;
 
 	if (opts->fscontext) {
-		rc = parse_sid(sb, opts->fscontext, &sid, GFP_KERNEL);
+		rc = parse_sid(sb, opts->fscontext, &sid);
 		if (rc)
 			return rc;
 		if (bad_option(sbsec, FSCONTEXT_MNT, sbsec->sid, sid))
 			goto out_bad_option;
 	}
 	if (opts->context) {
-		rc = parse_sid(sb, opts->context, &sid, GFP_KERNEL);
+		rc = parse_sid(sb, opts->context, &sid);
 		if (rc)
 			return rc;
 		if (bad_option(sbsec, CONTEXT_MNT, sbsec->mntpoint_sid, sid))
@@ -2778,14 +2785,14 @@ static int selinux_sb_remount(struct super_block *sb, void *mnt_opts)
 	if (opts->rootcontext) {
 		struct inode_security_struct *root_isec;
 		root_isec = backing_inode_security(sb->s_root);
-		rc = parse_sid(sb, opts->rootcontext, &sid, GFP_KERNEL);
+		rc = parse_sid(sb, opts->rootcontext, &sid);
 		if (rc)
 			return rc;
 		if (bad_option(sbsec, ROOTCONTEXT_MNT, root_isec->sid, sid))
 			goto out_bad_option;
 	}
 	if (opts->defcontext) {
-		rc = parse_sid(sb, opts->defcontext, &sid, GFP_KERNEL);
+		rc = parse_sid(sb, opts->defcontext, &sid);
 		if (rc)
 			return rc;
 		if (bad_option(sbsec, DEFCONTEXT_MNT, sbsec->def_sid, sid))
-- 
2.34.1



