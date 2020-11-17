Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8592B6018
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgKQNGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgKQNGW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3899221EB;
        Tue, 17 Nov 2020 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618382;
        bh=Am6Fb1ha9CqL6Ygoc8p8yH7JyPN9dzWPlHGqqaIAKbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+aJkmLjecXjym0VpyTlQFZAhNTaLO8kQMy5oSZkDaNZwe3VA34xAy2TslJLc2qf1
         5fc6hWFjpS5T0XROKlHOibJE1qhXOLYK+Q/El6bWqGyGmD8sLYoJ72UpXTbTTNN/aO
         0KJ9v17l4rzRDFpSruD3vyNWmH+cLT97CeIggyfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/64] Btrfs: fix missing error return if writeback for extent buffer never started
Date:   Tue, 17 Nov 2020 14:04:37 +0100
Message-Id: <20201117122106.835732234@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 0607eb1d452d45c5ac4c745a9e9e0d95152ea9d0 ]

If lock_extent_buffer_for_io() fails, it returns a negative value, but its
caller btree_write_cache_pages() ignores such error. This means that a
call to flush_write_bio(), from lock_extent_buffer_for_io(), might have
failed. We should make btree_write_cache_pages() notice such error values
and stop immediatelly, making sure filemap_fdatawrite_range() returns an
error to the transaction commit path. A failure from flush_write_bio()
should also result in the endio callback end_bio_extent_buffer_writepage()
being invoked, which sets the BTRFS_FS_*_ERR bits appropriately, so that
there's no risk a transaction or log commit doesn't catch a writeback
failure.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 97a80238fdee3..b28bc7690d4b3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4000,6 +4000,10 @@ int btree_write_cache_pages(struct address_space *mapping,
 			if (!ret) {
 				free_extent_buffer(eb);
 				continue;
+			} else if (ret < 0) {
+				done = 1;
+				free_extent_buffer(eb);
+				break;
 			}
 
 			ret = write_one_eb(eb, fs_info, wbc, &epd);
-- 
2.27.0



