Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04632E68D7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgL1QmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729077AbgL1M6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB6622AAD;
        Mon, 28 Dec 2020 12:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160241;
        bh=4iN94wzcaS5kal2SVvCENHWV9T/aOeRVuZZyvpJaycM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGOE993CYnA4P8/fF2sJRdGuCnDK+HAkM1TllMyTkleP3PRlXInHL2YvqJyKNwqUm
         D/Ri9Wb93PIi5UHJtYRALap//KBDuBjBFmAJyLIhhIlZAfGqeGvIivlQunHSFrYJLf
         X+tcfrro1s8OvoFel1twroQTfHP46G9vZtFLrB7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 116/132] btrfs: scrub: Dont use inode page cache in scrub_handle_errored_block()
Date:   Mon, 28 Dec 2020 13:50:00 +0100
Message-Id: <20201228124852.016193073@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 665d4953cde6d9e75c62a07ec8f4f8fd7d396ade upstream

In commit ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device
replace") we removed the branch of copy_nocow_pages() to avoid
corruption for compressed nodatasum extents.

However above commit only solves the problem in scrub_extent(), if
during scrub_pages() we failed to read some pages,
sctx->no_io_error_seen will be non-zero and we go to fixup function
scrub_handle_errored_block().

In scrub_handle_errored_block(), for sctx without csum (no matter if
we're doing replace or scrub) we go to scrub_fixup_nodatasum() routine,
which does the similar thing with copy_nocow_pages(), but does it
without the extra check in copy_nocow_pages() routine.

So for test cases like btrfs/100, where we emulate read errors during
replace/scrub, we could corrupt compressed extent data again.

This patch will fix it just by avoiding any "optimization" for
nodatasum, just falls back to the normal fixup routine by try read from
any good copy.

This also solves WARN_ON() or dead lock caused by lame backref iteration
in scrub_fixup_nodatasum() routine.

The deadlock or WARN_ON() won't be triggered before commit ac0b4145d662
("btrfs: scrub: Don't use inode pages for device replace") since
copy_nocow_pages() have better locking and extra check for data extent,
and it's already doing the fixup work by try to read data from any good
copy, so it won't go scrub_fixup_nodatasum() anyway.

This patch disables the faulty code and will be removed completely in a
followup patch.

Fixes: ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device replace")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -918,11 +918,6 @@ static int scrub_handle_errored_block(st
 	have_csum = sblock_to_check->pagev[0]->have_csum;
 	dev = sblock_to_check->pagev[0]->dev;
 
-	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
-		sblocks_for_recheck = NULL;
-		goto nodatasum_case;
-	}
-
 	/*
 	 * read all mirrors one after the other. This includes to
 	 * re-read the extent or metadata block that failed (that was
@@ -1035,13 +1030,19 @@ static int scrub_handle_errored_block(st
 		goto out;
 	}
 
-	if (!is_metadata && !have_csum) {
+	/*
+	 * NOTE: Even for nodatasum case, it's still possible that it's a
+	 * compressed data extent, thus scrub_fixup_nodatasum(), which write
+	 * inode page cache onto disk, could cause serious data corruption.
+	 *
+	 * So here we could only read from disk, and hope our recovery could
+	 * reach disk before the newer write.
+	 */
+	if (0 && !is_metadata && !have_csum) {
 		struct scrub_fixup_nodatasum *fixup_nodatasum;
 
 		WARN_ON(sctx->is_dev_replace);
 
-nodatasum_case:
-
 		/*
 		 * !is_metadata and !have_csum, this means that the data
 		 * might not be COW'ed, that it might be modified


