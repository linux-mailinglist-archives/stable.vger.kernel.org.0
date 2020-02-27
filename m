Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0EF172134
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgB0Nlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729288AbgB0Nlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:41:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A872C222C2;
        Thu, 27 Feb 2020 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582810907;
        bh=9tIYBVS/aBTE245KcMrgQ3burHBIEyEISkV8uvZ8saQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3vjDb3vDrNi2/GkfaqfxCwv1jLl7ZsZI/zl2Hf7RjRKvnVj88XMGUS1MzLhft4R7
         SFSYPEaXcWpWGEZIcMly1TCfp/nwp0OKqKTsSL8wBJwCyV8n/tgKbjZzvhs8T0Ei2d
         0yCFuXzyfoBoHPLE//eCfUFtLe8E2NCzMgZfO+bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Anand Jain <anand.jain@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 016/113] btrfs: print message when tree-log replay starts
Date:   Thu, 27 Feb 2020 14:35:32 +0100
Message-Id: <20200227132214.311504481@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit e8294f2f6aa6208ed0923aa6d70cea3be178309a ]

There's no logged information about tree-log replay although this is
something that points to previous unclean unmount. Other filesystems
report that as well.

Suggested-by: Chris Murphy <lists@colorremedies.com>
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2fb533233e8e3..656f0b7681855 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2972,6 +2972,7 @@ int open_ctree(struct super_block *sb,
 
 	/* do not make disk changes in broken FS */
 	if (btrfs_super_log_root(disk_super) != 0) {
+		btrfs_info(fs_info, "start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;
-- 
2.20.1



