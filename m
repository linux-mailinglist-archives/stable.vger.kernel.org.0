Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1AE501056
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345663AbiDNNx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344987AbiDNNo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F5766615;
        Thu, 14 Apr 2022 06:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C26B1B82983;
        Thu, 14 Apr 2022 13:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA8CC385A1;
        Thu, 14 Apr 2022 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943662;
        bh=ZGW8BiQG7HCfwzspUwBInQ6eQWFaOMQ0x/bgFalDr/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hyhg6aDU1kkhakg3XdJhPIG0TCIlBQDVKMwpbTzzrH9HHwjjgktyZWgogAB+BJUCf
         eK62lN4FOmcGv9BLEbdFYKkHrUckzEasn9nh/e+BVWZTYItZLijY1KbKJ95EB9/ZoE
         t0bh9xv+ggk1xd0fACm8QHqYoSdrxlXXf080+VsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/475] NFS: Return valid errors from nfs2/3_decode_dirent()
Date:   Thu, 14 Apr 2022 15:10:22 +0200
Message-Id: <20220414110901.751641174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 64cfca85bacde54caa64e0ab855c48734894fa37 ]

Valid return values for decode_dirent() callback functions are:
 0: Success
 -EBADCOOKIE: End of directory
 -EAGAIN: End of xdr_stream

All errors need to map into one of those three values.

Fixes: 573c4e1ef53a ("NFS: Simplify ->decode_dirent() calling sequence")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs2xdr.c |  2 +-
 fs/nfs/nfs3xdr.c | 21 ++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 887f9136a9db..af557dc2cfe1 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -953,7 +953,7 @@ int nfs2_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_filename_inline(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return error;
+		return -EAGAIN;
 
 	/*
 	 * The type (size and byte order) of nfscookie isn't defined in
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 23d75cddbb2e..84369d51353a 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -1968,7 +1968,6 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 		       bool plus)
 {
 	struct user_namespace *userns = rpc_userns(entry->server->client);
-	struct nfs_entry old = *entry;
 	__be32 *p;
 	int error;
 	u64 new_cookie;
@@ -1988,15 +1987,15 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_fileid3(xdr, &entry->ino);
 	if (unlikely(error))
-		return error;
+		return -EAGAIN;
 
 	error = decode_inline_filename3(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return error;
+		return -EAGAIN;
 
 	error = decode_cookie3(xdr, &new_cookie);
 	if (unlikely(error))
-		return error;
+		return -EAGAIN;
 
 	entry->d_type = DT_UNKNOWN;
 
@@ -2004,7 +2003,7 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 		entry->fattr->valid = 0;
 		error = decode_post_op_attr(xdr, entry->fattr, userns);
 		if (unlikely(error))
-			return error;
+			return -EAGAIN;
 		if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
 			entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);
 
@@ -2019,11 +2018,8 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 			return -EAGAIN;
 		if (*p != xdr_zero) {
 			error = decode_nfs_fh3(xdr, entry->fh);
-			if (unlikely(error)) {
-				if (error == -E2BIG)
-					goto out_truncated;
-				return error;
-			}
+			if (unlikely(error))
+				return -EAGAIN;
 		} else
 			zero_nfs_fh3(entry->fh);
 	}
@@ -2032,11 +2028,6 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 	entry->cookie = new_cookie;
 
 	return 0;
-
-out_truncated:
-	dprintk("NFS: directory entry contains invalid file handle\n");
-	*entry = old;
-	return -EAGAIN;
 }
 
 /*
-- 
2.34.1



