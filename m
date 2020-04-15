Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3231A9F29
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897640AbgDOLrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897629AbgDOLrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FE1321707;
        Wed, 15 Apr 2020 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951242;
        bh=p5ddbxDhA1jc54Gx4CCIbQNlqIrl5vm5oi2x7eDQN8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSESNmeJSQQVr5vbVWTFaY6hQu5RjB7uz/5s6XhflqGCfcixI9s42swnCD/g5Cw24
         boUKVYpy1bPi0hyL0VN1+4YeZW76r+zmKndwlnHZCjiwCRRLUjjk00eZBzinTD83ni
         eioR9Y916H4RZmoCy/rVGvEJ2PZ5UsNcksx/PGgQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/30] btrfs: handle NULL roots in btrfs_put/btrfs_grab_fs_root
Date:   Wed, 15 Apr 2020 07:46:50 -0400
Message-Id: <20200415114711.15381-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
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
index 7f7c35d6347a3..4066220a980b2 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -109,6 +109,8 @@ struct btrfs_root *btrfs_alloc_dummy_root(struct btrfs_fs_info *fs_info);
  */
 static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
 {
+	if (!root)
+		return NULL;
 	if (refcount_inc_not_zero(&root->refs))
 		return root;
 	return NULL;
@@ -116,6 +118,8 @@ static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
 
 static inline void btrfs_put_fs_root(struct btrfs_root *root)
 {
+	if (!root)
+		return;
 	if (refcount_dec_and_test(&root->refs))
 		kfree(root);
 }
-- 
2.20.1

