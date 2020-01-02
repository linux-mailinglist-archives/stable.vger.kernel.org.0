Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0075D12EDA9
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgABWab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbgABWa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E7A20863;
        Thu,  2 Jan 2020 22:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004229;
        bh=HlWtydBh50Mj0Uo1Xv9uPwtA+4j6QdPpT+cdBwzapbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9za3oYUW4s83tTAiIpOSp06nvI7JmxkjFTaqD2fRGQQX/U2GFPoyNtmK677XxLgN
         wN3iP/m1F8PV9WM7BHZfyKWWXkmKwXKh+EdmeQgwvOoxrL8n+13aC2cfudYAmCcBpp
         rqPPIAsaxBY7/WL/OaPwjEOx6H6dcVKQJ27g3B3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 091/171] btrfs: abort transaction after failed inode updates in create_subvol
Date:   Thu,  2 Jan 2020 23:07:02 +0100
Message-Id: <20200102220559.733480218@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit c7e54b5102bf3614cadb9ca32d7be73bad6cecf0 ]

We can just abort the transaction here, and in fact do that for every
other failure in this function except these two cases.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a67143c579aa..eefe103c65da 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -610,12 +610,18 @@ static noinline int create_subvol(struct inode *dir,
 
 	btrfs_i_size_write(dir, dir->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, root, dir);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
 
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 btrfs_ino(dir), index, name, namelen);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
 
 	ret = btrfs_uuid_tree_add(trans, root->fs_info->uuid_root,
 				  root_item->uuid, BTRFS_UUID_KEY_SUBVOL,
-- 
2.20.1



