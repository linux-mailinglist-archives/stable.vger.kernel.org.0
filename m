Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163D4650086
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiLRQQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiLRQQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:16:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183D7BE07;
        Sun, 18 Dec 2022 08:07:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9B4360DDC;
        Sun, 18 Dec 2022 16:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7449FC43396;
        Sun, 18 Dec 2022 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379636;
        bh=Ze8o+m0mFLQjwiPIvEIpIGMiHCaCyngQcK1Dis3Zl54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQJki8RLBelIFPYmdSgUgN52IDJgVa4Ji9YQD6zi5xsLDHtML+2wk9cY9/6Bt/IFO
         Ws/nkefC34FvMr4WiA6fqoMJz2dNH+zlPHRsl2C9l4mylYzr6JQfjlnxZiKti3I/sB
         c69x2EgVESOqFxYZykN2PgvVEZ2ccB2TVo2fULWJasNIl1lz7fw8HRm1gxgP9oFQJi
         Xj9wklVHWRDodfLCsX6IlL1YkPtWxaYAxd0DADML4QTwO5GE5CzphF7L7yegg3Jf1e
         WHGOztE8CSm48P5w3OyWjH15fX0bzl2j99WM8s/SWTQ6wjSAGwDRny7yBurErAvO9X
         GKVn2ojBeKFNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, anna@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 74/85] nfs: fix possible null-ptr-deref when parsing param
Date:   Sun, 18 Dec 2022 11:01:31 -0500
Message-Id: <20221218160142.925394-74-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawkins Jiawei <yin31149@gmail.com>

[ Upstream commit 5559405df652008e56eee88872126fe4c451da67 ]

According to commit "vfs: parse: deal with zero length string value",
kernel will set the param->string to null pointer in vfs_parse_fs_string()
if fs string has zero length.

Yet the problem is that, nfs_fs_context_parse_param() will dereferences the
param->string, without checking whether it is a null pointer, which may
trigger a null-ptr-deref bug.

This patch solves it by adding sanity check on param->string
in nfs_fs_context_parse_param().

Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 09833ec102fc..9bcd53d5c7d4 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -684,6 +684,8 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 			return ret;
 		break;
 	case Opt_vers:
+		if (!param->string)
+			goto out_invalid_value;
 		trace_nfs_mount_assign(param->key, param->string);
 		ret = nfs_parse_version_string(fc, param->string);
 		if (ret < 0)
@@ -696,6 +698,8 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		break;
 
 	case Opt_proto:
+		if (!param->string)
+			goto out_invalid_value;
 		trace_nfs_mount_assign(param->key, param->string);
 		protofamily = AF_INET;
 		switch (lookup_constant(nfs_xprt_protocol_tokens, param->string, -1)) {
@@ -732,6 +736,8 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		break;
 
 	case Opt_mountproto:
+		if (!param->string)
+			goto out_invalid_value;
 		trace_nfs_mount_assign(param->key, param->string);
 		mountfamily = AF_INET;
 		switch (lookup_constant(nfs_xprt_protocol_tokens, param->string, -1)) {
-- 
2.35.1

