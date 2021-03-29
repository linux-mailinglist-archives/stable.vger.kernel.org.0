Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D405134C617
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhC2IE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232125AbhC2IEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E89E6196D;
        Mon, 29 Mar 2021 08:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005059;
        bh=ohiOF/8XY/nQljM9J8ufEBUI1rh4ND1W69aAsA9HhxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEld+fpZdvE8PBzWkVpitt2EYEKh/AO3kPFThJmMssBOuxLXWAAglKnsCLH/X1aO+
         1AVIGrmX5ZUSpWwAE8t0uGNSO+lsXUgQdQy/EgRQyJZElVI/Ksb/QmNFob0G9S8One
         9EjLntRlVkj7NJ+p+olFP8y8QIiMhXQCvc4ISxnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/59] NFS: Correct size calculation for create reply length
Date:   Mon, 29 Mar 2021 09:57:51 +0200
Message-Id: <20210329075609.272080949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
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
index f1cb0b7eb05f..be666aee28cc 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -34,6 +34,7 @@
  */
 #define NFS3_fhandle_sz		(1+16)
 #define NFS3_fh_sz		(NFS3_fhandle_sz)	/* shorthand */
+#define NFS3_post_op_fh_sz	(1+NFS3_fh_sz)
 #define NFS3_sattr_sz		(15)
 #define NFS3_filename_sz	(1+(NFS3_MAXNAMLEN>>2))
 #define NFS3_path_sz		(1+(NFS3_MAXPATHLEN>>2))
@@ -71,7 +72,7 @@
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



