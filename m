Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC42EC23
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbfE3DSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731587AbfE3DSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD2A247CF;
        Thu, 30 May 2019 03:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186313;
        bh=WEkxGOTOrldUFzewf8WLDqXHSWnnWqn7UaLHQjhoE0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIKsAqTwo1BbOpmFENLd+2yInOV8ZLDAIlNiVtO12b8rB5UIF+Z1IDmO1mvMjnhjT
         fZCFCs6xCWm1OVc9jJHB7/TGSLmNYi+MtwiMy2Uj/z/wDL7eOaS3hXbfiTZevtOqzp
         /DBbZ2Og3lHIsy6KiXnPQdrofenmaB2RXWpDrKXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 016/193] Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path
Date:   Wed, 29 May 2019 20:04:30 -0700
Message-Id: <20190530030450.301586277@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 72bd2323ec87722c115a5906bc6a1b31d11e8f54 upstream.

Currently when we fail to COW a path at btrfs_update_root() we end up
always aborting the transaction. However all the current callers of
btrfs_update_root() are able to deal with errors returned from it, many do
end up aborting the transaction themselves (directly or not, such as the
transaction commit path), other BUG_ON() or just gracefully cancel whatever
they were doing.

When syncing the fsync log, we call btrfs_update_root() through
tree-log.c:update_log_root(), and if it returns an -ENOSPC error, the log
sync code does not abort the transaction, instead it gracefully handles
the error and returns -EAGAIN to the fsync handler, so that it falls back
to a transaction commit. Any other error different from -ENOSPC, makes the
log sync code abort the transaction.

So remove the transaction abort from btrfs_update_log() when we fail to
COW a path to update the root item, so that if an -ENOSPC failure happens
we avoid aborting the current transaction and have a chance of the fsync
succeeding after falling back to a transaction commit.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203413
Fixes: 79787eaab46121 ("btrfs: replace many BUG_ONs with proper error handling")
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/root-tree.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -145,10 +145,8 @@ int btrfs_update_root(struct btrfs_trans
 		return -ENOMEM;
 
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
-	if (ret < 0) {
-		btrfs_abort_transaction(trans, ret);
+	if (ret < 0)
 		goto out;
-	}
 
 	if (ret != 0) {
 		btrfs_print_leaf(path->nodes[0]);


