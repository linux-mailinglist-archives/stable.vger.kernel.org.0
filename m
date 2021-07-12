Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083EB3C491B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbhGLGl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236463AbhGLGkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF8961179;
        Mon, 12 Jul 2021 06:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071881;
        bh=T8fUfAkdFqSrkqYjPwrk9Jg41wYzmdXkxx8O38AWlcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zst5fzDH1ZoRDDGpKEOf4NgijVUQEFbPvweG9sHmkirxDh/5zF3A7QBg00+Egmy2A
         aYQzP34zR559UX23+2aKzBoSf1XBH4/7ErxNjPMXOA75EjX/8YChrn4Y/Vu2MwAloH
         0iqQFuW5Nmf+BQCoTvR/gCKR+iGYqe7oJWxd1IhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/593] btrfs: clear log tree recovering status if starting transaction fails
Date:   Mon, 12 Jul 2021 08:07:01 +0200
Message-Id: <20210712060911.986387356@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 1aeb6b563aea18cd55c73cf666d1d3245a00f08c ]

When a log recovery is in progress, lots of operations have to take that
into account, so we keep this status per tree during the operation. Long
time ago error handling revamp patch 79787eaab461 ("btrfs: replace many
BUG_ONs with proper error handling") removed clearing of the status in
an error branch. Add it back as was intended in e02119d5a7b4 ("Btrfs:
Add a write ahead tree log to optimize synchronous operations").

There are probably no visible effects, log replay is done only during
mount and if it fails all structures are cleared so the stale status
won't be kept.

Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 300951088a11..4b913de2f24f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6348,6 +6348,7 @@ next:
 error:
 	if (wc.trans)
 		btrfs_end_transaction(wc.trans);
+	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.30.2



