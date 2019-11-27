Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89310B9D3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfK0U5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731128AbfK0U5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:57:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5FE72154A;
        Wed, 27 Nov 2019 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888219;
        bh=1UHd5Z+iO61oz8qaxXgGlqrU6/ESGUcvWsJ5GK3etOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yboIYK2Lby5g4bqPtlXNzB5XlSMnfgUv+fCdp5OP2b7RyHfCqey95hjE/SHLy3jUH
         Eb/4jgDrpIY0flH+GI53G6JLCJ7f/5gG18beMCp7shShusY/7BrlGo21LCc+vQMHZL
         zDhT0jDnVTX1FKSMLikGEXKYimAKS240EqvbALJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <suy.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/306] btrfs: defrag: use btrfs_mod_outstanding_extents in cluster_pages_for_defrag
Date:   Wed, 27 Nov 2019 21:28:18 +0100
Message-Id: <20191127203118.313948329@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

[ Upstream commit 28c4a3e21ad030d7571ee9b1b246a5cbfd886627 ]

Since commit 8b62f87bad9c ("Btrfs: rework outstanding_extents"),
manual operations of outstanding_extent in btrfs_inode are replaced by
btrfs_mod_outstanding_extents().
The one in cluster_pages_for_defrag seems to be lost, so replace it
of btrfs_mod_outstanding_extents().

Fixes: 8b62f87bad9c ("Btrfs: rework outstanding_extents")
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7592beb53fc4e..00ff4349b4579 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1337,7 +1337,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	if (i_done != page_cnt) {
 		spin_lock(&BTRFS_I(inode)->lock);
-		BTRFS_I(inode)->outstanding_extents++;
+		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
 				start_index << PAGE_SHIFT,
-- 
2.20.1



