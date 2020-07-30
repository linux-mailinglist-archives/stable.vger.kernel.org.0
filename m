Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB06232D98
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgG3IMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729669AbgG3IMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:12:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 201732075F;
        Thu, 30 Jul 2020 08:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096757;
        bh=5z15zI3/T6HQEd0E/ow7TCeuC7Za8Ty+Of0kwIHX7t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GuDaEmMTx9Cgv9sH+pNHybde7K3Z8ox+QEnt2ubyZPUzNyFB0cH4V/dhjGK7nqUL
         8CxTCxM/13HvHMvd2yE8e6mc2fuM1YLy/Xx8t+iujdZ1oPxFEZfWi8Vppf01vVwq26
         vVfQL4ZF0HnHtuWim61hdLYK/M0AGfoKP9ZfzXaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 49/54] xfs: set format back to extents if xfs_bmap_extents_to_btree
Date:   Thu, 30 Jul 2020 10:05:28 +0200
Message-Id: <20200730074423.544960348@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit 2c4306f719b083d17df2963bc761777576b8ad1b upstream.

If xfs_bmap_extents_to_btree fails in a mode where we call
xfs_iroot_realloc(-1) to de-allocate the root, set the
format back to extents.

Otherwise we can assume we can dereference ifp->if_broot
based on the XFS_DINODE_FMT_BTREE format, and crash.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199423
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[iwamatsu: backported to 4.4.y]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -793,6 +793,8 @@ xfs_bmap_extents_to_btree(
 	*logflagsp = 0;
 	if ((error = xfs_alloc_vextent(&args))) {
 		xfs_iroot_realloc(ip, -1, whichfork);
+		ASSERT(ifp->if_broot == NULL);
+		XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 		return error;
 	}


