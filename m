Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A2940E4FC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245074AbhIPRG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349200AbhIPRDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F8E7613DB;
        Thu, 16 Sep 2021 16:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810087;
        bh=JjgT/S3x2botWUAD3hrCiDHjvvAWeqNys+YLdP5R5mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0cAc3ysev826lxGAGSAd2duVUncET9n0JmiGNVO2/sCxsM/iafBQDHZ9hPrknLIn
         VrTyax5Pg/juaYDzDI76YIEWG1aMsC5uY0W1p8fyL2UZsG99+jcSIOwR4g9vwCKx2D
         DZRL5lX87EsKhxdaS2yoJmsXoam8rUwLTuRxnu0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 013/432] btrfs: zoned: fix block group alloc_offset calculation
Date:   Thu, 16 Sep 2021 17:56:02 +0200
Message-Id: <20210916155811.259322586@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
 


