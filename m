Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182A127C616
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgI2Llm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730350AbgI2Lll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E8B9207F7;
        Tue, 29 Sep 2020 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379698;
        bh=sgdynjaZn71vzjUyMwqFO67t7maMrg7lYXb4BDsDg0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1DBuUOp5EytNguw9RDMu+HlrD6GoEFf3RySZ47wMvBkpAin5lgMohb23iJB8hSax
         VbcYoHhhWsiqARcI/tBaqWtmXF8xvUFVJPc7aD+VfOW+3mfsoofnzZgo9oyMhX0pLC
         Umfrrol9jz1gpff4EkTfkZruuKn43SvpOHh1EhCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 278/388] btrfs: dont force read-only after error in drop snapshot
Date:   Tue, 29 Sep 2020 13:00:09 +0200
Message-Id: <20200929110023.911288645@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 7c09c03091ac562ddca2b393e5d65c1d37da79f1 ]

Deleting a subvolume on a full filesystem leads to ENOSPC followed by a
forced read-only. This is not a transaction abort and the filesystem is
otherwise ok, so the error should be just propagated to the callers.

This is caused by unnecessary call to btrfs_handle_fs_error for all
errors, except EAGAIN. This does not make sense as the standard
transaction abort mechanism is in btrfs_drop_snapshot so all relevant
failures are handled.

Originally in commit cb1b69f4508a ("Btrfs: forced readonly when
btrfs_drop_snapshot() fails") there was no return value at all, so the
btrfs_std_error made some sense but once the error handling and
propagation has been implemented we don't need it anymore.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31c1ed554d26d..7658f3193175b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5428,8 +5428,6 @@ out:
 	 */
 	if (!for_reloc && !root_dropped)
 		btrfs_add_dead_root(root);
-	if (err && err != -EAGAIN)
-		btrfs_handle_fs_error(fs_info, err, NULL);
 	return err;
 }
 
-- 
2.25.1



