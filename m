Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00F02E6916
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634606AbgL1QoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:44:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbgL1M5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32CDA21D94;
        Mon, 28 Dec 2020 12:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160238;
        bh=oDISvas2pGZUuW07NLlTAfNN1dOhEfPKWMbtilyRO+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5dhLXJhg5eLpLLQzVF4YPOjrMcJyDgXFbOGqVioMPK6SD/TBcbe02uYGQwf06CKS
         Ed+0MVuuCpz2VXCACbtpRt/MshK8HVPtMeOAYGXxgRmojsAWcahpr0C190mWVYECDA
         SlKLQjmyXpo7tn6nLndg2PkXQtYGgr0BOrqJZKuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 115/132] btrfs: quota: Set rescan progress to (u64)-1 if we hit last leaf
Date:   Mon, 28 Dec 2020 13:49:59 +0100
Message-Id: <20201228124851.968470638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commoit 6f7de19ed3d4d3526ca5eca428009f97cf969c2f upstream

Commit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf
of extent tree") added a new exit for rescan finish.

However after finishing quota rescan, we set
fs_info->qgroup_rescan_progress to (u64)-1 before we exit through the
original exit path.
While we missed that assignment of (u64)-1 in the new exit path.

The end result is, the quota status item doesn't have the same value.
(-1 vs the last bytenr + 1)
Although it doesn't affect quota accounting, it's still better to keep
the original behavior.

Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Fixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf of extent tree")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2288,8 +2288,10 @@ out:
 	}
 	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 
-	if (done && !ret)
+	if (done && !ret) {
 		ret = 1;
+		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
+	}
 	return ret;
 }
 


