Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A67174602
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391357AbfGYFpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbfGYFpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4165521850;
        Thu, 25 Jul 2019 05:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033553;
        bh=J7andB2/FvMjqKSofEQTJjA8xw4+etPlg/dUUrjmMiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuTG3WPQqYGD7QketuVug8lngHVSELygDjUKbpepj+NTLo1VCGbOwtSNU8Tkr+B2d
         08eUPQKrxYh7PIQjufuxNFtaBb8d6+tsb9AGtNIGEk90ZibmTxVeRdYYfSLkNBlGs3
         RLoVkCY6d8YIKhRq1JL/BAQ2gJYTl8kICEue4rsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/271] xfs: reserve blocks for ifree transaction during log recovery
Date:   Wed, 24 Jul 2019 21:21:56 +0200
Message-Id: <20190724191716.361251878@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 15a268d9f263ed3a0601a1296568241a5a3da7aa upstream.

Log recovery frees all the inodes stored in the unlinked list, which can
cause expansion of the free inode btree.  The ifree code skips block
reservations if it thinks there's a per-AG space reservation, but we
don't set up the reservation until after log recovery, which means that
a finobt expansion blows up in xfs_trans_mod_sb when we exceed the
transaction's block reservation.

To fix this, we set the "no finobt reservation" flag to true when we
create the xfs_mount and only set it to false if we confirm that every
AG had enough free space to put aside for the finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsops.c | 1 +
 fs/xfs/xfs_super.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7c00b8bedfe3..09fd602507ef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -534,6 +534,7 @@ xfs_fs_reserve_ag_blocks(
 	int			error = 0;
 	int			err2;
 
+	mp->m_finobt_nores = false;
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		pag = xfs_perag_get(mp, agno);
 		err2 = xfs_ag_resv_init(pag, NULL);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 207ee302b1bb..dce8114e3198 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1561,6 +1561,13 @@ xfs_mount_alloc(
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
+	/*
+	 * We don't create the finobt per-ag space reservation until after log
+	 * recovery, so we must set this to true so that an ifree transaction
+	 * started during log recovery will not depend on space reservations
+	 * for finobt expansion.
+	 */
+	mp->m_finobt_nores = true;
 	return mp;
 }
 
-- 
2.20.1



