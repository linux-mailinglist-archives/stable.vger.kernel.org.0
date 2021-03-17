Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277B733E354
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCQA4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhCQA4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 648F764F99;
        Wed, 17 Mar 2021 00:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942564;
        bh=vQ9jruZV5MO/69WlijaSDOFKPbNF0BPnqPswopqhNys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEtFjnkkefNKIVGXuTZLDAiOmh9ZdxUGAyHKL7BVsjaiVd7pMfO0NlLAYWTBfJl+O
         RtkUF4/oG+5Z/imEfQChdMqUhhTWlRNemoRnUucUStikCCc+LajYMOQ8g2/6BzCqdQ
         neAz8FtsikXsiLnapcjXcCI75ETxYN7wxrvMupW853gDNRYYmdw6QBISIqXbCPKC8X
         EZ/Ejici3SL3aputCzVLsKX7tzxSv7wQxND4TRMO9oGRtVdnhVY8QiAhmXYtNOKRlu
         0PSdJ1BL/mMpLGzFwlTT3QF3KOj3mYKhSsJIdwLZv1ifiuJIeHMw5uBflIt2w31bQB
         V0cDsT5SXEiqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Sorenson <sorenson@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 22/61] NFS: Correct size calculation for create reply length
Date:   Tue, 16 Mar 2021 20:54:56 -0400
Message-Id: <20210317005536.724046-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index ca10072644ff..ed1c83738c30 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -36,6 +36,7 @@
 #define NFS3_pagepad_sz		(1) /* Page padding */
 #define NFS3_fhandle_sz		(1+16)
 #define NFS3_fh_sz		(NFS3_fhandle_sz)	/* shorthand */
+#define NFS3_post_op_fh_sz	(1+NFS3_fh_sz)
 #define NFS3_sattr_sz		(15)
 #define NFS3_filename_sz	(1+(NFS3_MAXNAMLEN>>2))
 #define NFS3_path_sz		(1+(NFS3_MAXPATHLEN>>2))
@@ -73,7 +74,7 @@
 #define NFS3_readlinkres_sz	(1+NFS3_post_op_attr_sz+1+NFS3_pagepad_sz)
 #define NFS3_readres_sz		(1+NFS3_post_op_attr_sz+3+NFS3_pagepad_sz)
 #define NFS3_writeres_sz	(1+NFS3_wcc_data_sz+4)
-#define NFS3_createres_sz	(1+NFS3_fh_sz+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
+#define NFS3_createres_sz	(1+NFS3_post_op_fh_sz+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
 #define NFS3_renameres_sz	(1+(2 * NFS3_wcc_data_sz))
 #define NFS3_linkres_sz		(1+NFS3_post_op_attr_sz+NFS3_wcc_data_sz)
 #define NFS3_readdirres_sz	(1+NFS3_post_op_attr_sz+2+NFS3_pagepad_sz)
-- 
2.30.1

