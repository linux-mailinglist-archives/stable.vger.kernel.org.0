Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9973C467D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhGLG01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235050AbhGLGZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C4E361130;
        Mon, 12 Jul 2021 06:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070954;
        bh=kZcZbSICOodmW+tw82VmlXzK9HEDFbTXPZk8P/dXstc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIF/AKCHMBytqSTjTJzTVzsr8ZwGRW0IsdQ7mFVEfxJr8EmUIU4hH7rwBtNOo87Cx
         ElI+DUyth5C2IJQm4F2LcJ1/pVRsEqltLapGV9KAI7q3M39981WE3mm5rMziE4MDp3
         9pwqqWh434Hg51bwQ2GsREO3tH3fmPc/XEvA6H8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/348] btrfs: clear log tree recovering status if starting transaction fails
Date:   Mon, 12 Jul 2021 08:09:13 +0200
Message-Id: <20210712060723.298346730@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 4ff381c23cef..afc6731bb692 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6327,6 +6327,7 @@ next:
 error:
 	if (wc.trans)
 		btrfs_end_transaction(wc.trans);
+	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.30.2



