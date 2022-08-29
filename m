Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336FB5A4AB6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiH2LtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiH2Lsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:48:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7B08A1E9;
        Mon, 29 Aug 2022 04:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DDBCB80F79;
        Mon, 29 Aug 2022 11:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D84C433D6;
        Mon, 29 Aug 2022 11:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771796;
        bh=MW7k14D6wvJJxHEMsB9O+rplv0E+qjehGPwxE/Qy2Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZbUe2w9A/JsLYft2fOO+BlWNAtidSb1TxbFsdyRUZJrBB5vTQwE9KvSsZOYFWW+9
         m61kmfi5b8sEeOKZseXoSx3YHrIHIV6xoT362vBqIY+gSiz19tuBI/S/Jn0P7xOMB0
         X7mMxUHVykp75Cjh3pbRDWwZwIIBvhShOcMfNImM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 100/158] btrfs: update generation of hole file extent item when merging holes
Date:   Mon, 29 Aug 2022 12:59:10 +0200
Message-Id: <20220829105813.285939666@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit e6e3dec6c3c288d556b991a85d5d8e3ee71e9046 upstream.

When punching a hole into a file range that is adjacent with a hole and we
are not using the no-holes feature, we expand the range of the adjacent
file extent item that represents a hole, to save metadata space.

However we don't update the generation of hole file extent item, which
means a full fsync will not log that file extent item if the fsync happens
in a later transaction (since commit 7f30c07288bb9e ("btrfs: stop copying
old file extents when doing a full fsync")).

For example, if we do this:

    $ mkfs.btrfs -f -O ^no-holes /dev/sdb
    $ mount /dev/sdb /mnt
    $ xfs_io -f -c "pwrite -S 0xab 2M 2M" /mnt/foobar
    $ sync

We end up with 2 file extent items in our file:

1) One that represents the hole for the file range [0, 2M), with a
   generation of 7;

2) Another one that represents an extent covering the range [2M, 4M).

After that if we do the following:

    $ xfs_io -c "fpunch 2M 2M" /mnt/foobar

We end up with a single file extent item in the file, which represents a
hole for the range [0, 4M) and with a generation of 7 - because we end
dropping the data extent for range [2M, 4M) and then update the file
extent item that represented the hole at [0, 2M), by increasing
length from 2M to 4M.

Then doing a full fsync and power failing:

    $ xfs_io -c "fsync" /mnt/foobar
    <power failure>

will result in the full fsync not logging the file extent item that
represents the hole for the range [0, 4M), because its generation is 7,
which is lower than the generation of the current transaction (8).
As a consequence, after mounting again the filesystem (after log replay),
the region [2M, 4M) does not have a hole, it still points to the
previous data extent.

So fix this by always updating the generation of existing file extent
items representing holes when we merge/expand them. This solves the
problem and it's the same approach as when we merge prealloc extents that
got written (at btrfs_mark_extent_written()). Setting the generation to
the current transaction's generation is also what we do when merging
the new hole extent map with the previous one or the next one.

A test case for fstests, covering both cases of hole file extent item
merging (to the left and to the right), will be sent soon.

Fixes: 7f30c07288bb9e ("btrfs: stop copying old file extents when doing a full fsync")
CC: stable@vger.kernel.org # 5.18+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2483,6 +2483,7 @@ static int fill_holes(struct btrfs_trans
 		btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
 		btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
 		btrfs_set_file_extent_offset(leaf, fi, 0);
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		btrfs_mark_buffer_dirty(leaf);
 		goto out;
 	}
@@ -2499,6 +2500,7 @@ static int fill_holes(struct btrfs_trans
 		btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
 		btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
 		btrfs_set_file_extent_offset(leaf, fi, 0);
+		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		btrfs_mark_buffer_dirty(leaf);
 		goto out;
 	}


