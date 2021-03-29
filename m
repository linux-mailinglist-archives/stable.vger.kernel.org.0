Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32E34C7DC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhC2IS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233345AbhC2IRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C086619A0;
        Mon, 29 Mar 2021 08:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005838;
        bh=F+/1jRtl4oh8fKzC81jYd6ay7UwsjSgYDTNsZApfhJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTKd3nG1KGzxkau5808UjWVCHdvpDj1YaHyKddWyeUCxdC0WNi/s1G18icb/IyNeB
         /iFG47/ReN2LPHXiYoYexetKf9KcAxyHaZ8FKi+CH695+vm1Ry3bN/30/J/S8pPvSq
         Az6p9HxHsn25iGqo/u4hXh+Q5DoDx0kR9S1t3EJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/221] NFS: Correct size calculation for create reply length
Date:   Mon, 29 Mar 2021 09:55:54 +0200
Message-Id: <20210329075629.957367138@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 69971f6c840d..dff6b52d26a8 100644
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



