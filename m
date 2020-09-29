Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E8C27CC4A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbgI2Me7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729647AbgI2LVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EE2A23A51;
        Tue, 29 Sep 2020 11:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378367;
        bh=Dw0uf7jH9+tFjjtY6xcOxrgEPbb7T6QlmcsTQZR3hro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0xnNHcBFWxEL8Yrn+0XOFI+6Gn1LZ2OXNFTrCSgztbUwx9ZVxrMCnUGFM9fvz2VV
         GwTMkAXUpjVyUMlj243a12gbbh3EdtMGbRtB+BSr0nXw0p8Je5D8JcH8gS99AjlZjK
         qbQSHpx7gEVQ4b74EopYVcPbUz80QBSaItR561pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 126/166] btrfs: dont force read-only after error in drop snapshot
Date:   Tue, 29 Sep 2020 13:00:38 +0200
Message-Id: <20200929105941.490736202@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
index cb46ad4b2b0d1..00481cfe6cfce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9364,8 +9364,6 @@ out:
 	 */
 	if (!for_reloc && root_dropped == false)
 		btrfs_add_dead_root(root);
-	if (err && err != -EAGAIN)
-		btrfs_handle_fs_error(fs_info, err, NULL);
 	return err;
 }
 
-- 
2.25.1



