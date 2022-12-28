Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68CE658488
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiL1Q55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiL1Q5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E4912AD2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E91661563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91742C433D2;
        Wed, 28 Dec 2022 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246416;
        bh=Ze8o+m0mFLQjwiPIvEIpIGMiHCaCyngQcK1Dis3Zl54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr8atXIx1LJ5XkZcFCaujyNG8ytgffbTHgWnCrmbauhoXpjqBHGRpr+vS46esEf0K
         nLHmRA+BVdFZIIFdX9rUytDNGzZHDuXSCqM4OlAlpNdRa+J9yMMcRTMGvLUuV9dY5G
         ngT1/mkP/c7KaSZv35JnvfVOcg8GrB17HAOFshQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hawkins Jiawei <yin31149@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1037/1146] nfs: fix possible null-ptr-deref when parsing param
Date:   Wed, 28 Dec 2022 15:42:56 +0100
Message-Id: <20221228144358.519204978@linuxfoundation.org>
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



