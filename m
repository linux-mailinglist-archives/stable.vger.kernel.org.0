Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02FF658475
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiL1Q5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbiL1Q4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996C810B68
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5078EB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8CDC433D2;
        Wed, 28 Dec 2022 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246371;
        bh=49jbtjE20D3i7P5igmqRub2WStPr6KsnGhlBmfvJLkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AD+GQFk1/t3VGRzYaCCq186Yil2QmVK7C6b4yrBRBpeNuSf4I5aheklyOYCcmCEmq
         BRyLS4DnG/GLNPp5OHfSTfMmoTWGxYvgdslu+nyLOGwzXn53HOykWw7vEECW0w0qAv
         Dh5rbBQLSDMrgqgC8/UFT4+8ousdR7KmyeSqBCR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+0b1fb6b0108c27419f9f@syzkaller.appspotmail.com,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 1056/1073] btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range
Date:   Wed, 28 Dec 2022 15:44:04 +0100
Message-Id: <20221228144356.912548818@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 162d053e15fe985f754ef495a96eb3db970c43ed upstream.

If we get -ENOMEM while dropping file extent items in a given range, at
btrfs_drop_extents(), due to failure to allocate memory when attempting to
increment the reference count for an extent or drop the reference count,
we handle it with a BUG_ON(). This is excessive, instead we can simply
abort the transaction and return the error to the caller. In fact most
callers of btrfs_drop_extents(), directly or indirectly, already abort
the transaction if btrfs_drop_extents() returns any error.

Also, we already have error paths at btrfs_drop_extents() that may return
-ENOMEM and in those cases we abort the transaction, like for example
anything that changes the b+tree may return -ENOMEM due to a failure to
allocate a new extent buffer when COWing an existing extent buffer, such
as a call to btrfs_duplicate_item() for example.

So replace the BUG_ON() calls with proper logic to abort the transaction
and return the error.

Reported-by: syzbot+0b1fb6b0108c27419f9f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/00000000000089773e05ee4b9cb4@google.com/
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -880,7 +880,10 @@ next_slot:
 						args->start - extent_offset,
 						0, false);
 				ret = btrfs_inc_extent_ref(trans, &ref);
-				BUG_ON(ret); /* -ENOMEM */
+				if (ret) {
+					btrfs_abort_transaction(trans, ret);
+					break;
+				}
 			}
 			key.offset = args->start;
 		}
@@ -967,7 +970,10 @@ delete_extent_item:
 						key.offset - extent_offset, 0,
 						false);
 				ret = btrfs_free_extent(trans, &ref);
-				BUG_ON(ret); /* -ENOMEM */
+				if (ret) {
+					btrfs_abort_transaction(trans, ret);
+					break;
+				}
 				args->bytes_found += extent_end - key.offset;
 			}
 


