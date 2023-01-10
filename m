Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3C36648F5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbjAJSQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbjAJSP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F15325
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A65CDB81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEC6C433EF;
        Tue, 10 Jan 2023 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374453;
        bh=W+fVkrIcCCI/H2MCmJoxTubOjFUEnFRU2Lpyr+C2Ua0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtK0VSY+MZ3fnjeCadcitgmEpKOelFiWT0KohMB2luWyGG2bA0pqr6D43fOy0YERf
         HRtUSHK9YLG++vHVC2hyrqh9W3GYbOoL98fCVgmXJagMWbN/Tq5CEZwYT6HyBIYLud
         BexuZ63k2/XrUXT7QFSe05TCbua01evWDgfC6njc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Joan=20Bruguera=20Mic=C3=B3?= <joanbrugueram@gmail.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 006/159] btrfs: fix off-by-one in delalloc search during lseek
Date:   Tue, 10 Jan 2023 19:02:34 +0100
Message-Id: <20230110180018.502815680@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

commit 2f2e84ca60660402bd81d0859703567c59556e6a upstream.

During lseek, when searching for delalloc in a range that represents a
hole and that range has a length of 1 byte, we end up not doing the actual
delalloc search in the inode's io tree, resulting in not correctly
reporting the offset with data or a hole. This actually only happens when
the start offset is 0 because with any other start offset we round it down
by sector size.

Reproducer:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ xfs_io -f -c "pwrite -q 0 1" /mnt/sdc/foo

  $ xfs_io -c "seek -d 0" /mnt/sdc/foo
  Whence   Result
  DATA	   EOF

It should have reported an offset of 0 instead of EOF.

Fix this by updating btrfs_find_delalloc_in_range() and count_range_bits()
to deal with inclusive ranges properly. These functions are already
supposed to work with inclusive end offsets, they just got it wrong in a
couple places due to off-by-one mistakes.

A test case for fstests will be added later.

Reported-by: Joan Bruguera Micó <joanbrugueram@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/20221223020509.457113-1-joanbrugueram@gmail.com/
Fixes: b6e833567ea1 ("btrfs: make hole and data seeking a lot more efficient")
CC: stable@vger.kernel.org # 6.1
Tested-by: Joan Bruguera Micó <joanbrugueram@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-io-tree.c |    2 +-
 fs/btrfs/file.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -1507,7 +1507,7 @@ u64 count_range_bits(struct extent_io_tr
 	u64 last = 0;
 	int found = 0;
 
-	if (WARN_ON(search_end <= cur_start))
+	if (WARN_ON(search_end < cur_start))
 		return 0;
 
 	spin_lock(&tree->lock);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3671,7 +3671,7 @@ bool btrfs_find_delalloc_in_range(struct
 	u64 prev_delalloc_end = 0;
 	bool ret = false;
 
-	while (cur_offset < end) {
+	while (cur_offset <= end) {
 		u64 delalloc_start;
 		u64 delalloc_end;
 		bool delalloc;


