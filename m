Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67F866750B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbjALOR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbjALOQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:16:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A403455657
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:08:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CEE2B81E6B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB40C433EF;
        Thu, 12 Jan 2023 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532510;
        bh=6tm0Su+NcKMix7Bw5mhBAoULzit8+XW0NqvG2w/L1hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qctQ6jaLjNoO1C1rw7mPj0RAL2KQtpDQjz/9bEB22+4A+FGI4LLy76CDMzfagWrHF
         Y/QKgQaAd6e392f3RujYL8tRhWxiMB0khNHt9zT6ek1esaAF6E5PdoAIyQPsMB6ROs
         evCceMKX0H6zpOvNkM0w6WhqIZveuxqVO8klfoVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/783] NFSv4.2: Fix initialisation of struct nfs4_label
Date:   Thu, 12 Jan 2023 14:48:22 +0100
Message-Id: <20230112135532.953899886@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c528f70f504434eaff993a5ddd52203a2010d51f ]

The call to nfs4_label_init_security() should return a fully initialised
label.

Fixes: aa9c2669626c ("NFS: Client implementation of Labeled-NFS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 36af3734ac87..15550d673e61 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -130,6 +130,11 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
 	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL) == 0)
 		return NULL;
 
+	label->lfs = 0;
+	label->pi = 0;
+	label->len = 0;
+	label->label = NULL;
+
 	err = security_dentry_init_security(dentry, sattr->ia_mode,
 				&dentry->d_name, (void **)&label->label, &label->len);
 	if (err == 0)
@@ -3793,7 +3798,7 @@ nfs4_atomic_open(struct inode *dir, struct nfs_open_context *ctx,
 		int open_flags, struct iattr *attr, int *opened)
 {
 	struct nfs4_state *state;
-	struct nfs4_label l = {0, 0, 0, NULL}, *label = NULL;
+	struct nfs4_label l, *label;
 
 	label = nfs4_label_init_security(dir, ctx->dentry, attr, &l);
 
@@ -4557,7 +4562,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		 int flags)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
-	struct nfs4_label l, *ilabel = NULL;
+	struct nfs4_label l, *ilabel;
 	struct nfs_open_context *ctx;
 	struct nfs4_state *state;
 	int status = 0;
@@ -4916,7 +4921,7 @@ static int nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
@@ -4957,7 +4962,7 @@ static int nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
@@ -5078,7 +5083,7 @@ static int nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
-- 
2.35.1



