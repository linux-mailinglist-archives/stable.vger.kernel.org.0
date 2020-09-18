Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B8326EC70
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgIRCLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbgIRCLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA91F23787;
        Fri, 18 Sep 2020 02:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395095;
        bh=2CYtoLE6tkaOuCZ9bu0qmOv22maS6zu8dykYr2rF6Eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjsgG+LQtzX0p8VQYTAAV4RcvKApuojaIJmBm2/trxXXnhELhjB9u94YKg6E9BxNR
         QxAxQEs02+o15d+vQmGYCSFJWZ9u9vbJTX2zYPjnrijkz4r5aQbcFNtUZvagVo4tCm
         WYQNgzlUDBvk5H0Al9Viv8WVmrDV5SY6BlQ3WVU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 176/206] btrfs: don't force read-only after error in drop snapshot
Date:   Thu, 17 Sep 2020 22:07:32 -0400
Message-Id: <20200918020802.2065198-176-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ec3aa76d19b7f..be0776eba7a08 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9099,8 +9099,6 @@ out:
 	 */
 	if (!for_reloc && !root_dropped)
 		btrfs_add_dead_root(root);
-	if (err && err != -EAGAIN)
-		btrfs_handle_fs_error(fs_info, err, NULL);
 	return err;
 }
 
-- 
2.25.1

