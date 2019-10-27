Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B26E6808
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbfJ0V0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732042AbfJ0V0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:26:23 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38A3321D7F;
        Sun, 27 Oct 2019 21:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211582;
        bh=uPIfQWqLKM5q170ciZ8ZKXKT3PTDtM1DUcLlUr0y/SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqttyMcXbjrAgY5pfRhLB0aJFA1k+movpN7+GmDlXNncBxhmhUhnXKr9tC2SHKWby
         Erp0vYe528cvR4s5hO+IxyhnotAB4c7HKXvrf76pAnzS/yoJtVLUWsGOuEwV0Q6dLF
         9h532M/7RhEjYOZAPIdiRqsgYCW3449qk/nLRfOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 186/197] btrfs: tracepoints: Fix wrong parameter order for qgroup events
Date:   Sun, 27 Oct 2019 22:01:44 +0100
Message-Id: <20191027203406.527183420@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit fd2b007eaec898564e269d1f478a2da0380ecf51 upstream.

[BUG]
For btrfs:qgroup_meta_reserve event, the trace event can output garbage:

  qgroup_meta_reserve: 9c7f6acc-b342-4037-bc47-7f6e4d2232d7: refroot=5(FS_TREE) type=DATA diff=2

The diff should always be alinged to sector size (4k), so there is
definitely something wrong.

[CAUSE]
For the wrong @diff, it's caused by wrong parameter order.
The correct parameters are:

  struct btrfs_root, s64 diff, int type.

However the parameters used are:

  struct btrfs_root, int type, s64 diff.

Fixes: 4ee0d8832c2e ("btrfs: qgroup: Update trace events for metadata reservation")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3617,7 +3617,7 @@ int __btrfs_qgroup_reserve_meta(struct b
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, type, (s64)num_bytes);
+	trace_qgroup_meta_reserve(root, (s64)num_bytes, type);
 	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
@@ -3664,7 +3664,7 @@ void __btrfs_qgroup_free_meta(struct btr
 	 */
 	num_bytes = sub_root_meta_rsv(root, num_bytes, type);
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	trace_qgroup_meta_reserve(root, type, -(s64)num_bytes);
+	trace_qgroup_meta_reserve(root, -(s64)num_bytes, type);
 	btrfs_qgroup_free_refroot(fs_info, root->root_key.objectid,
 				  num_bytes, type);
 }


