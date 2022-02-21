Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE53C4BE000
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiBUJNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:13:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349744AbiBUJMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661A42CC80;
        Mon, 21 Feb 2022 01:05:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F193E60FB6;
        Mon, 21 Feb 2022 09:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F3CC340E9;
        Mon, 21 Feb 2022 09:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434349;
        bh=fID+Kd/lIJ/NaWew1k1KAFADnmsxMbE3DYrzB5MuU10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GE1Wv+K4sfIvBqvu0RgRyp6bMQ+Yy6V64ZtmjKuc6R461vtHUPtCOwLPwUQwJB0HB
         ZB4PJiwxDsua/Zu9jeEI9H0J44v4V3WS2YFDfk40tO00wheTjBA9/et5fzZbJgOF2w
         7PfJ680To1enIwAnMbw8t/5zNs9yHZKussGsCanU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/121] NFS: Dont set NFS_INO_INVALID_XATTR if there is no xattr cache
Date:   Mon, 21 Feb 2022 09:49:43 +0100
Message-Id: <20220221084924.275257880@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 848fdd62399c638e65a1512616acaa5de7d5c5e8 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 21addb78523d2..6e7fd73a264af 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -195,6 +195,18 @@ bool nfs_check_cache_invalid(struct inode *inode, unsigned long flags)
 }
 EXPORT_SYMBOL_GPL(nfs_check_cache_invalid);
 
+#ifdef CONFIG_NFS_V4_2
+static bool nfs_has_xattr_cache(const struct nfs_inode *nfsi)
+{
+	return nfsi->xattr_cache != NULL;
+}
+#else
+static bool nfs_has_xattr_cache(const struct nfs_inode *nfsi)
+{
+	return false;
+}
+#endif
+
 static void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
@@ -210,6 +222,8 @@ static void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 	} else if (flags & NFS_INO_REVAL_PAGECACHE)
 		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
+	if (!nfs_has_xattr_cache(nfsi))
+		flags &= ~NFS_INO_INVALID_XATTR;
 	if (inode->i_mapping->nrpages == 0)
 		flags &= ~(NFS_INO_INVALID_DATA|NFS_INO_DATA_INVAL_DEFER);
 	nfsi->cache_validity |= flags;
-- 
2.34.1



