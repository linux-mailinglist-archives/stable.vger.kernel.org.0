Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECA440E1D0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbhIPQbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242815AbhIPQ3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F66A6137E;
        Thu, 16 Sep 2021 16:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809119;
        bh=JjgT/S3x2botWUAD3hrCiDHjvvAWeqNys+YLdP5R5mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdPHLDbuAoHp16yuvf9S2OAPNgyCBaNPM+R66Sel+55SmTXgJeWt8YCkWDCdnItkZ
         1L64vygT3mxqPQEca1lJe3bBkW4GkeTDzKO+q91LpZVzgeML4gp9pgia5wVmiz1Lv1
         pixVYRrUbmpBxjmj+AbEDcLB8BD8REFKyssDTH3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 005/380] btrfs: zoned: fix block group alloc_offset calculation
Date:   Thu, 16 Sep 2021 17:56:02 +0200
Message-Id: <20210916155804.156357934@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 0ae79c6fe70d5c5c645733b7ed39d5e6021d8c9a upstream.

alloc_offset is offset from the start of a block group and @offset is
actually an address in logical space. Thus, we need to consider
block_group->start when calculating them.

Fixes: 011b41bffa3d ("btrfs: zoned: advance allocation pointer after tree log node")
CC: stable@vger.kernel.org # 5.12+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2652,8 +2652,11 @@ int btrfs_remove_free_space(struct btrfs
 		 * btrfs_pin_extent_for_log_replay() when replaying the log.
 		 * Advance the pointer not to overwrite the tree-log nodes.
 		 */
-		if (block_group->alloc_offset < offset + bytes)
-			block_group->alloc_offset = offset + bytes;
+		if (block_group->start + block_group->alloc_offset <
+		    offset + bytes) {
+			block_group->alloc_offset =
+				offset + bytes - block_group->start;
+		}
 		return 0;
 	}
 


