Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92533111D1E
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfLCWuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbfLCWuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9315B2080F;
        Tue,  3 Dec 2019 22:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413424;
        bh=n7bbc5CvXmVJKbMZHCqQRLTFZI8HbEAAyJkp28oPY4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/3pqlkM8xWaNe4xe5bMqRfrOsCXdZOhWR9M/vOYHhKkC6KDpqjzkTy+dAsF2E+Ty
         3HHr89GuOpB8t+fZciKWO99Q7NMLyzvnTRjH1h3rR6gPcNpE5F11WZ3g7cbyUPfNiX
         3pCjqLe2CHLGDk13VuDYwFrrgkoX+lA5ZIuReV68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/321] btrfs: only track ref_heads in delayed_ref_updates
Date:   Tue,  3 Dec 2019 23:33:07 +0100
Message-Id: <20191203223433.451314810@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 62ff545ba1f71..7e5c81e80e15d 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -234,8 +234,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -446,7 +444,6 @@ inserted:
 	if (ref->action == BTRFS_ADD_DELAYED_REF)
 		list_add_tail(&ref->add_list, &href->ref_add_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.20.1



