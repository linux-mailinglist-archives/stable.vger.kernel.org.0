Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8476A3CE22C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346579AbhGSP30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348198AbhGSPYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A42F613FE;
        Mon, 19 Jul 2021 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710581;
        bh=xxsBuwLGjTFe88cs4CLFygPNJoQvsK31NzBoSy1dToU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/SOKQ8/gSgkGQ7sfyBuhjM7Y8QyuEUh7bp7nOaf/oVk/GqklwxO6XScoashq4A8K
         PNyYwdJCjeMMJ/6erBZ/gMCliWQaToU6C790cTgSzwgGv07gqIUaXBR3DiMf1NsyVw
         e/RmGbDr3URMNj6D0cr9T0vCtUsKLCDEla8xAc88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 032/351] btrfs: dont block if we cant acquire the reclaim lock
Date:   Mon, 19 Jul 2021 16:49:38 +0200
Message-Id: <20210719144945.592297152@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 9cc0b837e14ae913581ec1ea6e979a738f71b0fd upstream.

If we can't acquire the reclaim_bgs_lock on block group reclaim, we
block until it is free. This can potentially stall for a long time.

While reclaim of block groups is necessary for a good user experience on
a zoned file system, there still is no need to block as it is best
effort only, just like when we're deleting unused block groups.

CC: stable@vger.kernel.org # 5.13
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1499,7 +1499,15 @@ void btrfs_reclaim_bgs_work(struct work_
 	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE))
 		return;
 
-	mutex_lock(&fs_info->reclaim_bgs_lock);
+	/*
+	 * Long running balances can keep us blocked here for eternity, so
+	 * simply skip reclaim if we're unable to get the mutex.
+	 */
+	if (!mutex_trylock(&fs_info->reclaim_bgs_lock)) {
+		btrfs_exclop_finish(fs_info);
+		return;
+	}
+
 	spin_lock(&fs_info->unused_bgs_lock);
 	while (!list_empty(&fs_info->reclaim_bgs)) {
 		bg = list_first_entry(&fs_info->reclaim_bgs,


