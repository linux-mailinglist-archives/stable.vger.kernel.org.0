Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D695378758
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhEJLPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236318AbhEJLHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BCB6196E;
        Mon, 10 May 2021 10:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644388;
        bh=iQEHHa4iAyoQxmqUDwztqcG9lkhv7QMlm8X+kRdz/wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE7OQyJOeoueIdRZ4Ehv63IPgwEnFJlumj1TtyP1Rg2c1frkW2XbI82FJDzI3gqNL
         UBQuzdKkI5iNJQyZwXq+q2PbPwbriTXnhixXnzESfwpYfRkZRy+73aCEtCCrJ/bio2
         p8oHytK6tKOYvyyeaeN4jBeKEgYPoaat9phVUpmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 062/384] btrfs: zoned: fix unpaired block group unfreeze during device replace
Date:   Mon, 10 May 2021 12:17:31 +0200
Message-Id: <20210510102016.933651954@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 0dc16ef4f6c2708407fab6d141908d46a3b737bc upstream.

When doing a device replace on a zoned filesystem, if we find a block
group with ->to_copy == 0, we jump to the label 'done', which will result
in later calling btrfs_unfreeze_block_group(), even though at this point
we never called btrfs_freeze_block_group().

Since at this point we have neither turned the block group to RO mode nor
made any progress, we don't need to jump to the label 'done'. So fix this
by jumping instead to the label 'skip' and dropping our reference on the
block group before the jump.

Fixes: 78ce9fc269af6e ("btrfs: zoned: mark block groups to copy for device-replace")
CC: stable@vger.kernel.org # 5.12
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3682,8 +3682,8 @@ int scrub_enumerate_chunks(struct scrub_
 			spin_lock(&cache->lock);
 			if (!cache->to_copy) {
 				spin_unlock(&cache->lock);
-				ro_set = 0;
-				goto done;
+				btrfs_put_block_group(cache);
+				goto skip;
 			}
 			spin_unlock(&cache->lock);
 		}
@@ -3841,7 +3841,6 @@ int scrub_enumerate_chunks(struct scrub_
 						      cache, found_key.offset))
 			ro_set = 0;
 
-done:
 		down_write(&dev_replace->rwsem);
 		dev_replace->cursor_left = dev_replace->cursor_right;
 		dev_replace->item_needs_writeback = 1;


