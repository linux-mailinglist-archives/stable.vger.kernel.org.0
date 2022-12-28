Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11097657E8B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiL1Pyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiL1Pyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:54:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21FC186EC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FD3F61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD17C433EF;
        Wed, 28 Dec 2022 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242886;
        bh=kFo8dQjP81H/ntBtOQJ9bLRGE+wTyztpJAHGm+A7LuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtgBTQZcWAqZf/lFFWz/Jaz6DUfzBahsLC1z0wgaRGHEWAp6ZQnWw791UdbSDF7oP
         hFqcAozUU43CuQKvsQXRVTP8JZx6cYAZI75dejS2Tp7m/qJLThpYGXImxx8yBhd+Gr
         ZLn4JHa5SoiKyWyDVvU7q7Vo1ZwjNZfxtZsKjBIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0427/1146] NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn
Date:   Wed, 28 Dec 2022 15:32:46 +0100
Message-Id: <20221228144341.780171858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 51069e4aef6257b0454057359faed0ab0c9af083 ]

If we're asked to recover open state while a delegation return is
outstanding, then the state manager thread cannot use a cached open, so
if the server returns a delegation, we can end up deadlocked behind the
pending delegreturn.
To avoid this problem, let's just ask the server not to give us a
delegation unless we're explicitly reclaiming one.

Fixes: be36e185bd26 ("NFSv4: nfs4_open_recover_helper() must set share access")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bd89c7f06952..e51044a5f550 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2131,18 +2131,18 @@ static struct nfs4_opendata *nfs4_open_recoverdata_alloc(struct nfs_open_context
 }
 
 static int nfs4_open_recover_helper(struct nfs4_opendata *opendata,
-		fmode_t fmode)
+				    fmode_t fmode)
 {
 	struct nfs4_state *newstate;
+	struct nfs_server *server = NFS_SB(opendata->dentry->d_sb);
+	int openflags = opendata->o_arg.open_flags;
 	int ret;
 
 	if (!nfs4_mode_match_open_stateid(opendata->state, fmode))
 		return 0;
-	opendata->o_arg.open_flags = 0;
 	opendata->o_arg.fmode = fmode;
-	opendata->o_arg.share_access = nfs4_map_atomic_open_share(
-			NFS_SB(opendata->dentry->d_sb),
-			fmode, 0);
+	opendata->o_arg.share_access =
+		nfs4_map_atomic_open_share(server, fmode, openflags);
 	memset(&opendata->o_res, 0, sizeof(opendata->o_res));
 	memset(&opendata->c_res, 0, sizeof(opendata->c_res));
 	nfs4_init_opendata_res(opendata);
@@ -2724,10 +2724,15 @@ static int _nfs4_open_expired(struct nfs_open_context *ctx, struct nfs4_state *s
 	struct nfs4_opendata *opendata;
 	int ret;
 
-	opendata = nfs4_open_recoverdata_alloc(ctx, state,
-			NFS4_OPEN_CLAIM_FH);
+	opendata = nfs4_open_recoverdata_alloc(ctx, state, NFS4_OPEN_CLAIM_FH);
 	if (IS_ERR(opendata))
 		return PTR_ERR(opendata);
+	/*
+	 * We're not recovering a delegation, so ask for no delegation.
+	 * Otherwise the recovery thread could deadlock with an outstanding
+	 * delegation return.
+	 */
+	opendata->o_arg.open_flags = O_DIRECT;
 	ret = nfs4_open_recover(opendata, state);
 	if (ret == -ESTALE)
 		d_drop(ctx->dentry);
-- 
2.35.1



