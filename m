Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E44498C96
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344855AbiAXTXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:23:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349341AbiAXTUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:20:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BC24B810BD;
        Mon, 24 Jan 2022 19:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7262CC340E7;
        Mon, 24 Jan 2022 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052035;
        bh=SxxwnMfSk4Ap3HH/T1GeP+W5fi6E/M5OdYQhitu79yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e72Hn5sFajy4h1zZg/RbmmazIGreaOXS3OBA5wYVDMo+aNcMT2zHsMKv+kijZqEEC
         XF9u25h8fFVmuEnJ3NqosSNh/WftrlJLp3biTwzr7l7H+4fm0C5APGb+04tdx9nbyE
         kEtvq8vnz9SVTsaNns2nZ85OKAYHZ1l2fBHXQ3yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/239] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 24 Jan 2022 19:43:24 +0100
Message-Id: <20220124183948.372038283@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit fcba0120edf88328524a4878d1d6f4ad39f2ec81 ]

We search for an extent entry with .offset = -1, which shouldn't be a
thing, but corruption happens.  Add an ASSERT() for the developers,
return -EUCLEAN for mortals.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6b8824de2abb2..0073182d4e689 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1160,7 +1160,12 @@ again:
 	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/* This shouldn't happen, indicates a bug or fs corruption. */
+		ASSERT(ret != 0);
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (trans && likely(trans->type != __TRANS_DUMMY) &&
-- 
2.34.1



