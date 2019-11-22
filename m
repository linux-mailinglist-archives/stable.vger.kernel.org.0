Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955251063A8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbfKVF4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbfKVF4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5662E2068F;
        Fri, 22 Nov 2019 05:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402180;
        bh=9KIGL9hJmNe5tLgJxUosnPLVpcmCOoix6hgMChYhLeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5n+FY5kGo/KHa7iBn1jr63tnvEmYhbsovFnHZXK1zQSYeyDOdY/Nb+pdba9Ma+xF
         vEo7pJ0siYreFWKhwByHi/iDSR2bj3VXtVacZIZr1wucUiOTxEjEhQIqQez2ZCd47p
         UxZcnZMKobtbgoEJiUjB+iwtnICUxwxf/38lUMzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 031/127] btrfs: only track ref_heads in delayed_ref_updates
Date:   Fri, 22 Nov 2019 00:54:09 -0500
Message-Id: <20191122055544.3299-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

[ Upstream commit 158ffa364bf723fa1ef128060646d23dc3942994 ]

We use this number to figure out how many delayed refs to run, but
__btrfs_run_delayed_refs really only checks every time we need a new
delayed ref head, so we always run at least one ref head completely no
matter what the number of items on it.  Fix the accounting to only be
adjusted when we add/remove a ref head.

In addition to using this number to limit the number of delayed refs
run, a future patch is also going to use it to calculate the amount of
space required for delayed refs space reservation.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 93ffa898df6d8..d56bd36254681 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -195,8 +195,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -458,7 +456,6 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.20.1

