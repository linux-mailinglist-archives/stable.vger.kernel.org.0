Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA78191065
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgCXN1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgCXN1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:27:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88651208DB;
        Tue, 24 Mar 2020 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056461;
        bh=5Re0jOeUhxzE/zh3aOjTH/ulS46Bc+He6U98wFGAzd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFWjpoT8de7wNMrocrMjnhUnhcGhuvJC6wvUWxVEUejq0OQNlBGmr7IMuz8gDtju8
         HeMkKRx4T2CWjO8CXRHYuv2bHQ3smWBwuaPp6d1FZFy0VfmszMlgHDIib8s5ZvdSoj
         MMQ8V5YLatnLyYN91g3a/1l6p9PaACtdQF+osWJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 088/119] btrfs: fix log context list corruption after rename whiteout error
Date:   Tue, 24 Mar 2020 14:11:13 +0100
Message-Id: <20200324130817.020669790@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 236ebc20d9afc5e9ff52f3cf3f365a91583aac10 upstream.

During a rename whiteout, if btrfs_whiteout_for_rename() returns an error
we can end up returning from btrfs_rename() with the log context object
still in the root's log context list - this happens if 'sync_log' was
set to true before we called btrfs_whiteout_for_rename() and it is
dangerous because we end up with a corrupt linked list (root->log_ctxs)
as the log context object was allocated on the stack.

After btrfs_rename() returns, any task that is running btrfs_sync_log()
concurrently can end up crashing because that linked list is traversed by
btrfs_sync_log() (through btrfs_remove_all_log_ctxs()). That results in
the same issue that commit e6c617102c7e4 ("Btrfs: fix log context list
corruption after rename exchange operation") fixed.

Fixes: d4682ba03ef618 ("Btrfs: sync log after logging new name")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10159,6 +10159,10 @@ out_fail:
 		ret = btrfs_sync_log(trans, BTRFS_I(old_inode)->root, &ctx);
 		if (ret)
 			commit_transaction = true;
+	} else if (sync_log) {
+		mutex_lock(&root->log_mutex);
+		list_del(&ctx.list);
+		mutex_unlock(&root->log_mutex);
 	}
 	if (commit_transaction) {
 		ret = btrfs_commit_transaction(trans);


