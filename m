Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DB4E67FF
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbfJ0V0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732897AbfJ0V0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:26:17 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28EF221D81;
        Sun, 27 Oct 2019 21:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211576;
        bh=u5oSFv9xULQGQzEcqZj57rkL26YvaNycrDuA8jm+gcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYSFzwW6NDOPO6yf/9Ax9sJy+CX2js88MzZTghoxWhNYi7vFUc6PvBR5fLf3AYrDQ
         WD6dW6nGTwUdfnWMNQxWMJvlWbb4oVix1TupRgoXc7PL0kwaSY0zLu4+lL91/CJDrO
         +j+Sf6JN4iBsyaUH4lmR4GwRwqIFoJ4GEzJglbrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 184/197] Btrfs: fix qgroup double free after failure to reserve metadata for delalloc
Date:   Sun, 27 Oct 2019 22:01:42 +0100
Message-Id: <20191027203406.419609792@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit c7967fc1499beb9b70bb9d33525fb0b384af8883 upstream.

If we fail to reserve metadata for delalloc operations we end up releasing
the previously reserved qgroup amount twice, once explicitly under the
'out_qgroup' label by calling btrfs_qgroup_free_meta_prealloc() and once
again, under label 'out_fail', by calling btrfs_inode_rsv_release() with a
value of 'true' for its 'qgroup_free' argument, which results in
btrfs_qgroup_free_meta_prealloc() being called again, so we end up having
a double free.

Also if we fail to reserve the necessary qgroup amount, we jump to the
label 'out_fail', which calls btrfs_inode_rsv_release() and that in turns
calls btrfs_qgroup_free_meta_prealloc(), even though we weren't able to
reserve any qgroup amount. So we freed some amount we never reserved.

So fix this by removing the call to btrfs_inode_rsv_release() in the
failure path, since it's not necessary at all as we haven't changed the
inode's block reserve in any way at this point.

Fixes: c8eaeac7b73434 ("btrfs: reserve delalloc metadata differently")
CC: stable@vger.kernel.org # 5.2+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/delalloc-space.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -371,7 +371,6 @@ int btrfs_delalloc_reserve_metadata(stru
 out_qgroup:
 	btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
 out_fail:
-	btrfs_inode_rsv_release(inode, true);
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
 	return ret;


