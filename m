Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94BDFF3B3
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfKPQ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbfKPPlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:39 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2103320830;
        Sat, 16 Nov 2019 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918899;
        bh=1UHd5Z+iO61oz8qaxXgGlqrU6/ESGUcvWsJ5GK3etOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8MYdDZRxS10ql0g6lEnXSQiHHdYXMXNp0FddstZmy0SCLtnlLwZoSVcD7v8Diff5
         vQWCrhMRB0gJusD0dbsLL+K6dln4EG5bEO2tw1d38F67Y3ssExtp6OO0xWQcU2Cp3Z
         aQRXnIQ1uF/y5FgKi0L39YCh/ZeS4A6hFDQsgC1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 027/237] btrfs: defrag: use btrfs_mod_outstanding_extents in cluster_pages_for_defrag
Date:   Sat, 16 Nov 2019 10:37:42 -0500
Message-Id: <20191116154113.7417-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

