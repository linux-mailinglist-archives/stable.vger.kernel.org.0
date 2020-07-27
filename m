Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279122F1F7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgG0ONz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbgG0ONw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9F320838;
        Mon, 27 Jul 2020 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859232;
        bh=l9AV1UkaxXE9CswV9nnkL1KikVVLloY1b0TxvV7pcGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgSOTisPPH/rY58Iisk/85oULev1+/bLiS0OwCtlB8uXwF/Wuhf92yAZv1Mqu8v0S
         W7QJ5kx0ef223Gz2/pK/VTTuU0ALsWM9w6Xloy3jLI/DnsvW9aOOUkeAG4KaJPhlI1
         cUUyiBFqrSHs3S9Ul2C4+dLTmA35h2ojaEwmC3Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 028/138] btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots to prevent runaway balance
Date:   Mon, 27 Jul 2020 16:03:43 +0200
Message-Id: <20200727134926.778733876@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 1dae7e0e58b484eaa43d530f211098fdeeb0f404 upstream.

[BUG]
There are several reported runaway balance, that balance is flooding the
log with "found X extents" where the X never changes.

[CAUSE]
Commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after
merge_reloc_roots") introduced BTRFS_ROOT_DEAD_RELOC_TREE bit to
indicate that one subvolume has finished its tree blocks swap with its
reloc tree.

However if balance is canceled or hits ENOSPC halfway, we didn't clear
the BTRFS_ROOT_DEAD_RELOC_TREE bit, leaving that bit hanging forever
until unmount.

Any subvolume root with that bit, would cause backref cache to skip this
tree block, as it has finished its tree block swap.  This would cause
all tree blocks of that root be ignored by balance, leading to runaway
balance.

[FIX]
Fix the problem by also clearing the BTRFS_ROOT_DEAD_RELOC_TREE bit for
the original subvolume of orphan reloc root.

Add an umount check for the stale bit still set.

Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[Manually solve the conflicts due to no btrfs root refs rework]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2540,6 +2540,8 @@ again:
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root)
 					root->reloc_root = NULL;
+				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
+					  &root->state);
 			}
 
 			list_del_init(&reloc_root->root_list);


