Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D458692A
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiHAL6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiHAL5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:57:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14C141987;
        Mon,  1 Aug 2022 04:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F328A612C6;
        Mon,  1 Aug 2022 11:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B169C433D7;
        Mon,  1 Aug 2022 11:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354721;
        bh=RXRfYubtQf+Ck183h4Czd+GZUKxFAmwQWmQtaLmbrLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEfoH8d4fNJ7fOJFZgZGY9i/Ed0GRu+W0ZiVSv8YCgaFUnRsNPbaWdzg8tClLroWu
         OQ1ilzxKh2USmt3/9jFXerArIMjkdKR4GpaSwidsDaDplHLrECvHtDtT83EJaTnVDS
         f70z7VL/0w6aDUe1ARwXQJilV/dWZB+kFKZmPskU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 61/65] xfs: Enforce attr3 buffer recovery order
Date:   Mon,  1 Aug 2022 13:47:18 +0200
Message-Id: <20220801114136.196023602@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit d8f4c2d0398fa1d92cacf854daf80d21a46bfefc upstream.

>From the department of "WTAF? How did we miss that!?"...

When we are recovering a buffer, the first thing we do is check the
buffer magic number and extract the LSN from the buffer. If the LSN
is older than the current LSN, we replay the modification to it. If
the metadata on disk is newer than the transaction in the log, we
skip it. This is a fundamental v5 filesystem metadata recovery
behaviour.

generic/482 failed with an attribute writeback failure during log
recovery. The write verifier caught the corruption before it got
written to disk, and the attr buffer dump looked like:

XFS (dm-3): Metadata corruption detected at xfs_attr3_leaf_verify+0x275/0x2e0, xfs_attr3_leaf block 0x19be8
XFS (dm-3): Unmount and run xfs_repair
XFS (dm-3): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 3b ee 00 00 4d 2a 01 e1  ........;...M*..
00000010: 00 00 00 00 00 01 9b e8 00 00 00 01 00 00 05 38  ...............8
                                  ^^^^^^^^^^^^^^^^^^^^^^^
00000020: df 39 5e 51 58 ac 44 b6 8d c5 e7 10 44 09 bc 17  .9^QX.D.....D...
00000030: 00 00 00 00 00 02 00 83 00 03 00 cc 0f 24 01 00  .............$..
00000040: 00 68 0e bc 0f c8 00 10 00 00 00 00 00 00 00 00  .h..............
00000050: 00 00 3c 31 0f 24 01 00 00 00 3c 32 0f 88 01 00  ..<1.$....<2....
00000060: 00 00 3c 33 0f d8 01 00 00 00 00 00 00 00 00 00  ..<3............
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.....

The highlighted bytes are the LSN that was replayed into the
buffer: 0x100000538. This is cycle 1, block 0x538. Prior to replay,
that block on disk looks like this:

$ sudo xfs_db -c "fsb 0x417d" -c "type attr3" -c p /dev/mapper/thin-vol
hdr.info.hdr.forw = 0
hdr.info.hdr.back = 0
hdr.info.hdr.magic = 0x3bee
hdr.info.crc = 0xb5af0bc6 (correct)
hdr.info.bno = 105448
hdr.info.lsn = 0x100000900
               ^^^^^^^^^^^
hdr.info.uuid = df395e51-58ac-44b6-8dc5-e7104409bc17
hdr.info.owner = 131203
hdr.count = 2
hdr.usedbytes = 120
hdr.firstused = 3796
hdr.holes = 1
hdr.freemap[0-2] = [base,size]

Note the LSN stamped into the buffer on disk: 1/0x900. The version
on disk is much newer than the log transaction that was being
replayed. That's a bug, and should -never- happen.

So I immediately went to look at xlog_recover_get_buf_lsn() to check
that we handled the LSN correctly. I was wondering if there was a
similar "two commits with the same start LSN skips the second
replay" problem with buffers. I didn't get that far, because I found
a much more basic, rudimentary bug: xlog_recover_get_buf_lsn()
doesn't recognise buffers with XFS_ATTR3_LEAF_MAGIC set in them!!!

IOWs, attr3 leaf buffers fall through the magic number checks
unrecognised, so trigger the "recover immediately" behaviour instead
of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
buffers and that causes silent on disk corruption of inode attribute
forks and potentially other things....

Git history shows this is *another* zero day bug, this time
introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
superblocks during recovery") which failed to handle the attr3 leaf
buffers in recovery. And we've failed to handle them ever since...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item_recover.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -796,6 +796,7 @@ xlog_recover_get_buf_lsn(
 	switch (magicda) {
 	case XFS_DIR3_LEAF1_MAGIC:
 	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
 	case XFS_DA3_NODE_MAGIC:
 		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
 		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;


