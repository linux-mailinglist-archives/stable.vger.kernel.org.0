Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310D6261844
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731778AbgIHRvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731591AbgIHQNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B96248AB;
        Tue,  8 Sep 2020 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580350;
        bh=EtnrMDPSnzBefgsxcNQ2r0meJuOKoRRndp64tejU9Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxS7m2MDDFBGT0FQPl09tAty3/DQjQtm5zlDqAxV7w/4o1gQADlFppR8UUR3kOQc7
         U7ZVa2BpjcXtewzfjNRIe/d9G7R5FhOhBUT+thRWkIWgfo6BZnyHdJkItEr00o0shh
         EwnQfdF0GxHUNURg83UAvFtilVE0l9Qsoheg84cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/65] btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind
Date:   Tue,  8 Sep 2020 17:26:25 +0200
Message-Id: <20200908152219.101351925@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 24cee18a1c1d7c731ea5987e0c99daea22ae7f4a ]

When a rewound buffer is created it already has a ref count of 1 and the
dummy flag set. Then another ref is taken bumping the count to 2.
Finally when this buffer is released from btrfs_release_path the extra
reference is decremented by the special handling code in
free_extent_buffer.

However, this special code is in fact redundant sinca ref count of 1 is
still correct since the buffer is only accessed via btrfs_path struct.
This paves the way forward of removing the special handling in
free_extent_buffer.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 492a781c27cd4..ae8ac4837eb19 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1367,7 +1367,6 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_tree_read_unlock_blocking(eb);
 	free_extent_buffer(eb);
 
-	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
-- 
2.25.1



