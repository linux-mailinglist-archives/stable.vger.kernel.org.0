Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141271AA368
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503977AbgDONJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897046AbgDOLfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEAF92166E;
        Wed, 15 Apr 2020 11:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950544;
        bh=Ei7sJHbTUMMZtJhOvk3ipWf8WtSAiJzcufzicYNEPww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=berBmtTSSJBM6Hcf0L4nVVCXrFlLKJ6RryQ3fMqrrVOLJkbYRHH5tUfIc2s4qvdaK
         IBfvE9L2zIqBGC3HWAxDoFzbrc9qTv2waOQFCkZYnJQtYJMdjgx3igTiDv3i/NeJZD
         KKpB3GthDxu1PzCBgAsQK/mVcJtQEfP2G9LBAdgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 051/129] btrfs: handle NULL roots in btrfs_put/btrfs_grab_fs_root
Date:   Wed, 15 Apr 2020 07:33:26 -0400
Message-Id: <20200415113445.11881-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4cdfd93002cb84471ed85b4999cd38077a317873 ]

We want to use this for dropping all roots, and in some error cases we
may not have a root, so handle this to make the cleanup code easier.
Make btrfs_grab_fs_root the same so we can use it in cases where the
root may not exist (like the quota root).

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 8c2d6cf1ce596..424c9c97b1ce8 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -97,6 +97,8 @@ struct btrfs_root *btrfs_alloc_dummy_root(struct btrfs_fs_info *fs_info);
  */
 static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
 {
+	if (!root)
+		return NULL;
 	if (refcount_inc_not_zero(&root->refs))
 		return root;
 	return NULL;
@@ -104,6 +106,8 @@ static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
 
 static inline void btrfs_put_fs_root(struct btrfs_root *root)
 {
+	if (!root)
+		return;
 	if (refcount_dec_and_test(&root->refs))
 		kfree(root);
 }
-- 
2.20.1

