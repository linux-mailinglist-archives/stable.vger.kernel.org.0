Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303B9499C7B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579453AbiAXWFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577106AbiAXV7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85DEC0C092B;
        Mon, 24 Jan 2022 12:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E29761383;
        Mon, 24 Jan 2022 20:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3455EC340E5;
        Mon, 24 Jan 2022 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056787;
        bh=nODJdLZgNtDJsYBxRp1SexhPYRVVlpVwxtcXBGJsMPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/+gyR8VpB7eaTrj5lEp6eYxWq8qnWoCdrRfXIlv7e/VqWLq9NxK7QxOPVkk48b9q
         F44nsP3YVLI8VO0Jcn7Nd/3l5BkKZbf3dWFR/Pd2KBu2kms30tCN998IW3yJxQdcVI
         STMRmvvVQEgFIFH+MgCpDlRx11Z82vy3ep8+RIwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 600/846] btrfs: remove BUG_ON() in find_parent_nodes()
Date:   Mon, 24 Jan 2022 19:41:57 +0100
Message-Id: <20220124184121.725700779@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index f735b8798ba12..6b4b0f105a572 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1214,7 +1214,12 @@ again:
 	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
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



