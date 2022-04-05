Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AD64F3057
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiDEI1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbiDEIUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28868E1AC;
        Tue,  5 Apr 2022 01:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E187B81BAC;
        Tue,  5 Apr 2022 08:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5501C385A1;
        Tue,  5 Apr 2022 08:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146372;
        bh=nFAlM8SC4bGfTFPK+QEVwKUwAblEGofTTZTQdXpBBfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ3gEQxS3dOOcKQCo5kKpnK6l9B9U4YmbQr0X9hSN83GYKfaGDtI4IHX+OOJYfwUP
         cge/0Agdefm6TwYM/CMQYKjzdTikLEjwj5Xtpyu4y1sWFKiXBnRpmqVdX/dmQwNeGp
         vfmHnbKe8invq60a2grEoGFHFBfhe78WM0z1YdRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0740/1126] NFS: Return valid errors from nfs2/3_decode_dirent()
Date:   Tue,  5 Apr 2022 09:24:47 +0200
Message-Id: <20220405070429.307647249@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 7fba7711e6b3..3d5ba43f44bb 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -949,7 +949,7 @@ int nfs2_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
 	error = decode_filename_inline(xdr, &entry->name, &entry->len);
 	if (unlikely(error))
-		return error;
+		return -EAGAIN;
 
 	/*
 	 * The type (size and byte order) of nfscookie isn't defined in
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 54a1d21cbcc6..7ab60ad98776 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -1967,7 +1967,6 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 		       bool plus)
 {
 	struct user_namespace *userns = rpc_userns(entry->server->client);
-	struct nfs_entry old = *entry;
 	__be32 *p;
 	int error;
 	u64 new_cookie;
@@ -1987,15 +1986,15 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 
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
 
@@ -2003,7 +2002,7 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
 		entry->fattr->valid = 0;
 		error = decode_post_op_attr(xdr, entry->fattr, userns);
 		if (unlikely(error))
-			return error;
+			return -EAGAIN;
 		if (entry->fattr->valid & NFS_ATTR_FATTR_V3)
 			entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);
 
@@ -2018,11 +2017,8 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
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
@@ -2031,11 +2027,6 @@ int nfs3_decode_dirent(struct xdr_stream *xdr, struct nfs_entry *entry,
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



