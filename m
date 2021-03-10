Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1585333E24
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhCJNZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233155AbhCJNY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0243A64FF4;
        Wed, 10 Mar 2021 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382699;
        bh=FeRVY0rVDHLoX6Xkb15Dp53Q/1Q+zVP1AiO/fqTJZ5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qE9bmfki+0G0Jy/sD3wsX4U1yFlsERVz7xsFkPeKvSL7ubgJhyK4OSL4mOlp6oUy9
         gVtAmcvdWYw/teNGZdxMII6eC0vSa+aLmF+UFKACgHBvExQ9qHaG/PGKsFLOEoHuUn
         1KmJ5j57CjB8ZLoXHn5fRv667gKPruzuYstJS5rE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 04/39] btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata
Date:   Wed, 10 Mar 2021 14:24:12 +0100
Message-Id: <20210310132319.865687239@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nikolay Borisov <nborisov@suse.com>

commit 0f9c03d824f6f522d3bc43629635c9765546ebc5 upstream.

Following commit f218ea6c4792 ("btrfs: delayed-inode: Remove wrong
qgroup meta reservation calls") this function now reserves num_bytes,
rather than the fixed amount of nodesize. As such this requires the
same amount to be freed in case of failure. Fix this by adjusting
the amount we are freeing.

Fixes: f218ea6c4792 ("btrfs: delayed-inode: Remove wrong qgroup meta reservation calls")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -642,7 +642,7 @@ static int btrfs_delayed_inode_reserve_m
 						      btrfs_ino(inode),
 						      num_bytes, 1);
 		} else {
-			btrfs_qgroup_free_meta_prealloc(root, fs_info->nodesize);
+			btrfs_qgroup_free_meta_prealloc(root, num_bytes);
 		}
 		return ret;
 	}


