Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5120B33E4BB
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhCQBA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhCQA63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E0B64FBD;
        Wed, 17 Mar 2021 00:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942702;
        bh=ta3dKZVAV9B/VKNvCRlZ6dIfetMUV3vUg7TK+R3aPeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgJDaO4GdhwKjHVBkGuO27ouWSzJapax1zvcjaAhA5zGUqGnf0Fa1jAQs78xcLRnn
         rLCqoPXVpTBXgldgAe61AEqZgIoy55VJ4mFB9HMLR6RfiScX6j+byhOyvAHH+FDpmA
         dD+m7j9wwEzF1JGbg7gB2gRpLxrQwZiMH5Ta6dTqULrLGbtqJKVF8XdAex8pd9emkT
         /cs38OqqVi7A1ANCIojn163SAuE+XollvRSOd3t85KMu5LIa0AoTL3SnSY0Qdorgwc
         bArQHOqNBaiWKuW/Q/Ke0swnym3y4drT9aq1aPSxVFf4t9K+dtqlkgaiZE2XAMVHiF
         vFB9/rYFoT//w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Sorenson <sorenson@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/37] NFS: Correct size calculation for create reply length
Date:   Tue, 16 Mar 2021 20:57:41 -0400
Message-Id: <20210317005802.725825-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit ad3dbe35c833c2d4d0bbf3f04c785d32f931e7c9 ]

CREATE requests return a post_op_fh3, rather than nfs_fh3. The
post_op_fh3 includes an extra word to indicate 'handle_follows'.

Without that additional word, create fails when full 64-byte
filehandles are in use.

Add NFS3_post_op_fh_sz, and correct the size calculation for
NFS3_createres_sz.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3xdr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index 1f60ab2535ee..23d75cddbb2e 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -35,6 +35,7 @@
  */
 #define NFS3_fhandle_sz		(1+16)
 #define NFS3_fh_sz		(NFS3_fhandle_sz)	/* shorthand */
+#define NFS3_post_op_fh_sz	(1+NFS3_fh_sz)
 #define NFS3_sattr_sz		(15)
 #define NFS3_filename_sz	(1+(NFS3_MAXNAMLEN>>2))
 #define NFS3_path_sz		(1+(NFS3_MAXPATHLEN>>2))
@@ -72,7 +73,7 @@
 #define NFS3_readlinkres_sz	(1+NFS3_post_op_attr_sz+1+1)
 #define NFS3_readres_sz		(1+NFS3_post_op_attr_sz+3+1)
 #define NFS3_writeres_sz	(1+NFS3_wcc_data_sz+4)
-#define NFS3_createres_sz	(1+NFS3_fh_sz+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
+#define NFS3_createres_sz	(1+NFS3_post_op_fh_sz+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
 #define NFS3_renameres_sz	(1+(2 * NFS3_wcc_data_sz))
 #define NFS3_linkres_sz		(1+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
 #define NFS3_readdirres_sz	(1+NFS3_post_op_attr_sz+2+1)
-- 
2.30.1

