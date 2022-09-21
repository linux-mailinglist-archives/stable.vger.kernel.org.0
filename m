Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10F15C03CA
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiIUQKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbiIUQJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:09:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD75A59BF;
        Wed, 21 Sep 2022 08:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E40563140;
        Wed, 21 Sep 2022 15:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C047C433C1;
        Wed, 21 Sep 2022 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775458;
        bh=a6kGS/JjLChEg7RGBUV5+rcQ4j8aDYMFitWEjGVbpTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWHyOxMONYgRf1iPwx3Z2h47wyTXcU49zMjwbFAyWa/bsGfg0Y2d0Yv3+ds9VPVrP
         LZxo8+N6tPYo268ETTCx5jkn3wUToyM7+Qx0/nLXpJpEyv8a95ife/+z7v6p9Qfela
         D1CygffqmvFq86dRokkUDLdpsV1NxW51BBd5A7Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever III <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/39] NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0
Date:   Wed, 21 Sep 2022 17:46:19 +0200
Message-Id: <20220921153646.212039036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

[ Upstream commit 2a9d683b48c8a87e61a4215792d44c90bcbbb536 ]

The NFSv4.0 protocol only supports open() by name. It cannot therefore
be used with open_by_handle() and friends, nor can it be re-exported by
knfsd.

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: 20fa19027286 ("nfs: add export operations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 4034102010f0..b3fcc27b9564 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1029,22 +1029,31 @@ static void nfs_fill_super(struct super_block *sb, struct nfs_fs_context *ctx)
 	if (ctx && ctx->bsize)
 		sb->s_blocksize = nfs_block_size(ctx->bsize, &sb->s_blocksize_bits);
 
-	if (server->nfs_client->rpc_ops->version != 2) {
-		/* The VFS shouldn't apply the umask to mode bits. We will do
-		 * so ourselves when necessary.
+	switch (server->nfs_client->rpc_ops->version) {
+	case 2:
+		sb->s_time_gran = 1000;
+		sb->s_time_min = 0;
+		sb->s_time_max = U32_MAX;
+		break;
+	case 3:
+		/*
+		 * The VFS shouldn't apply the umask to mode bits.
+		 * We will do so ourselves when necessary.
 		 */
 		sb->s_flags |= SB_POSIXACL;
 		sb->s_time_gran = 1;
-		sb->s_export_op = &nfs_export_ops;
-	} else
-		sb->s_time_gran = 1000;
-
-	if (server->nfs_client->rpc_ops->version != 4) {
 		sb->s_time_min = 0;
 		sb->s_time_max = U32_MAX;
-	} else {
+		sb->s_export_op = &nfs_export_ops;
+		break;
+	case 4:
+		sb->s_flags |= SB_POSIXACL;
+		sb->s_time_gran = 1;
 		sb->s_time_min = S64_MIN;
 		sb->s_time_max = S64_MAX;
+		if (server->caps & NFS_CAP_ATOMIC_OPEN_V1)
+			sb->s_export_op = &nfs_export_ops;
+		break;
 	}
 
 	sb->s_magic = NFS_SUPER_MAGIC;
-- 
2.35.1



