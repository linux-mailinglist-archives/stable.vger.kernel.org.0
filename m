Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726A7321607
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBVMQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhBVMPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5887160C3E;
        Mon, 22 Feb 2021 12:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996094;
        bh=uWwTEac1zzpIR/UZfEMerqke2JiQqJ9gDEnw4BmRKEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYr4PC27MzrifEKOKiqe0lcmra6cZkXrYbPCPJTDWJFoIC+I0pa/26/nHwgA267CX
         HZHIAthHSmrlOmb5vkPI2QQ2LMMHz1xZTrCWJ0etdyGuVIdn/fHi9tF4OjaMpP468L
         vR6UjrNB3XG4NYab6yYGKyw9/6fvzrrFPEcuL71g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wang Yugui <wangyugui@e16-tech.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 27/29] btrfs: fix backport of 2175bf57dc952 in 5.10.13
Date:   Mon, 22 Feb 2021 13:13:21 +0100
Message-Id: <20210222121025.374172886@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

There's a mistake in backport of upstream commit 2175bf57dc95 ("btrfs:
fix possible free space tree corruption with online conversion") as
5.10.13 commit 2175bf57dc95.

The enum value BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED has been added to the
wrong enum set, colliding with value of BTRFS_FS_QUOTA_ENABLE. This
could cause problems during the tree conversion, where the quotas
wouldn't be set up properly but the related code executed anyway due to
the bit set.

Link: https://lore.kernel.org/linux-btrfs/20210219111741.95DD.409509F4@e16-tech.com
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
CC: stable@vger.kernel.org # 5.10.13+
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -146,9 +146,6 @@ enum {
 	BTRFS_FS_STATE_DEV_REPLACING,
 	/* The btrfs_fs_info created for self-tests */
 	BTRFS_FS_STATE_DUMMY_FS_INFO,
-
-	/* Indicate that we can't trust the free space tree for caching yet */
-	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 #define BTRFS_BACKREF_REV_MAX		256
@@ -562,6 +559,9 @@ enum {
 
 	/* Indicate that the discard workqueue can service discards. */
 	BTRFS_FS_DISCARD_RUNNING,
+
+	/* Indicate that we can't trust the free space tree for caching yet */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 /*


