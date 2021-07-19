Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC863CE22B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346535AbhGSP3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348220AbhGSPYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C63F613F0;
        Mon, 19 Jul 2021 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710583;
        bh=kR4rGXaj+fSyBhupG/0kvtljqdtyArO3zLmYzlaCnbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mXmJQHnVgOO4ue7Tb4F806tGOw2NtG35G+6/+GHBzGnf5+myuoX9sWNx2Lg1EdGk
         caxTaO1ic3p47jgBldlQZWn2t2eQV9lRTuRPw9ClGL6xVX8MOttBe+AW8CVzUFY25n
         dCSyBRqwN1VfElLX+CN7sWY0RdcgguOwblSobS5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 033/351] btrfs: zoned: fix wrong mutex unlock on failure to allocate log root tree
Date:   Mon, 19 Jul 2021 16:49:39 +0200
Message-Id: <20210719144945.622596059@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ea32af47f00a046a1f953370514d6d946efe0152 upstream.

When syncing the log, if we fail to allocate the root node for the log
root tree:

1) We are unlocking fs_info->tree_log_mutex, but at this point we have
   not yet locked this mutex;

2) We have locked fs_info->tree_root->log_mutex, but we end up not
   unlocking it;

So fix this by unlocking fs_info->tree_root->log_mutex instead of
fs_info->tree_log_mutex.

Fixes: e75f9fd194090e ("btrfs: zoned: move log tree node allocation out of log_root_tree->log_mutex")
CC: stable@vger.kernel.org # 5.13+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3173,7 +3173,7 @@ int btrfs_sync_log(struct btrfs_trans_ha
 		if (!log_root_tree->node) {
 			ret = btrfs_alloc_log_tree_node(trans, log_root_tree);
 			if (ret) {
-				mutex_unlock(&fs_info->tree_log_mutex);
+				mutex_unlock(&fs_info->tree_root->log_mutex);
 				goto out;
 			}
 		}


