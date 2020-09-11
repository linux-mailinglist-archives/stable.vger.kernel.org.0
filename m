Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7662666B9
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIKRbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgIKMze (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547CE221E3;
        Fri, 11 Sep 2020 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828877;
        bh=IsVOSbbTfRCzjXHFy6RzbyMiobywS2BfjcvnnzG8+hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0socJZ5QKHmoj0nneIB66rAjGkkLARY6TU+tOf3DnrjpC6FO2xLUpCLR2LxbKqLnX
         6irWkMvLfixNJjy5IYzCJ5yIxvQpGED7St5s6/tpZpQ/TdX/FlNHoDI4Q4NTnSFQli
         fpVZD4ws1BCxVb2PFumk4tld1mO763NosgJB2GBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 24/62] btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind
Date:   Fri, 11 Sep 2020 14:46:07 +0200
Message-Id: <20200911122503.601915915@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
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
index 8765312743f16..a8660b503bf36 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1372,7 +1372,6 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_tree_read_unlock_blocking(eb);
 	free_extent_buffer(eb);
 
-	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
-- 
2.25.1



