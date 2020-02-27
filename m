Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8571720E6
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgB0Npm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbgB0Npl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4323222C2;
        Thu, 27 Feb 2020 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811141;
        bh=wocrEF5e4Hh9pV3gsmFyQHA4RbYVhMgNWgZlk3YP/ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNpkHmYcZGayZg6LPapxo3uR0LvbEVDi0+aZHZHAVVGQbOzbOKYJa0QF7RM9xxJgI
         fcueQlDnBfdEtAL/Bqu5gC3ft/fMMYPWub3Q75vBCsja41XjDFCFSPezs4vk6iL+va
         +RkYy36fReQSg6LASkgGOq7iOfKI27h93otafcNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Anand Jain <anand.jain@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/165] btrfs: print message when tree-log replay starts
Date:   Thu, 27 Feb 2020 14:34:53 +0100
Message-Id: <20200227132233.814709912@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
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
index e3524ecce3d77..390053557d4d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2979,6 +2979,7 @@ int open_ctree(struct super_block *sb,
 	/* do not make disk changes in broken FS or nologreplay is given */
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !btrfs_test_opt(tree_root->fs_info, NOLOGREPLAY)) {
+		btrfs_info(fs_info, "start tree-log replay");
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;
-- 
2.20.1



