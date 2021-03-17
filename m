Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E1333E54E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhCQBCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhCQBAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 272FB64F9B;
        Wed, 17 Mar 2021 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942818;
        bh=O+bGaQbgppl7EBlZBXLS8rnc8WcSz3t4LTbgzH+Wb1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rv4zUrP3hnHNU5hnksyoocty4XGdMRHA/RxxMUfLXHnz+UbpH91IVhRDL6NsJ/Ca3
         B6/GKMFV78iHV9wOzHcvPZ4xMV7E11QAaYOl5ImREFoiEQJ7yWs/QxdPh3ITyXaX9/
         b+00Lre/HGPa/3XqDh4S6AgY471YdENOgCkKomME9gAELIjTSCcRELF7pJ2jBOm2ig
         XzCeKEezEeyb/fCteLiVvmH8OcRvHCjVgjyEBqLwDZo7cO8qDKZMS0cdkeR3C3sGWG
         DkKo7q865d0uv0WX4JxfxVA8Q3+fnOn/CDOP5TssVYZAsdGab32i7oARx3bdEvR/80
         Ixe/8usR8Z3hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Sorenson <sorenson@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/14] NFS: Correct size calculation for create reply length
Date:   Tue, 16 Mar 2021 21:00:02 -0400
Message-Id: <20210317010008.727496-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317010008.727496-1-sashal@kernel.org>
References: <20210317010008.727496-1-sashal@kernel.org>
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
index 267126d32ec0..4a68837e92ea 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -33,6 +33,7 @@
  */
 #define NFS3_fhandle_sz		(1+16)
 #define NFS3_fh_sz		(NFS3_fhandle_sz)	/* shorthand */
+#define NFS3_post_op_fh_sz	(1+NFS3_fh_sz)
 #define NFS3_sattr_sz		(15)
 #define NFS3_filename_sz	(1+(NFS3_MAXNAMLEN>>2))
 #define NFS3_path_sz		(1+(NFS3_MAXPATHLEN>>2))
@@ -70,7 +71,7 @@
 #define NFS3_readlinkres_sz	(1+NFS3_post_op_attr_sz+1)
 #define NFS3_readres_sz		(1+NFS3_post_op_attr_sz+3)
 #define NFS3_writeres_sz	(1+NFS3_wcc_data_sz+4)
-#define NFS3_createres_sz	(1+NFS3_fh_sz+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
+#define NFS3_createres_sz	(1+NFS3_post_op_fh_sz+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
 #define NFS3_renameres_sz	(1+(2 * NFS3_wcc_data_sz))
 #define NFS3_linkres_sz		(1+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
 #define NFS3_readdirres_sz	(1+NFS3_post_op_attr_sz+2)
-- 
2.30.1

