Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D436DC2A8
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 04:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjDJCXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 22:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDJCXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 22:23:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845FC3580;
        Sun,  9 Apr 2023 19:23:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3AF211FD9F;
        Mon, 10 Apr 2023 02:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681093396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=FeONrruqbTFevjsYQ1htd64pqZrz17smrzZYfGdgAl4=;
        b=UE8QGvyEZiuHugD1Q74FBxoSoJ2MirElWiSmwDInrukgPSZT4VbsbrasuFPERrIgNJmgac
        2KamSMMbfeqn6+Ek2bf4+UsL+CFDFpe9wbwYm/1Gn/Ak/yVshOhSh/b8RZyKCq0u1H1CUT
        QSCcmtyUlIDo4M1a86Tyg6SiooZvg4A=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08C7113438;
        Mon, 10 Apr 2023 02:23:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BrhuMhJzM2TQVAAAMHmgww
        (envelope-from <wqu@suse.com>); Mon, 10 Apr 2023 02:23:14 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH pre-6.4] btrfs: dev-replace: error out if we have unrepaired metadata error during
Date:   Mon, 10 Apr 2023 10:22:57 +0800
Message-Id: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is for pre-6.4 kernels, as scrub code goes through a huge rework.

[BUG]
Even before the scrub rework, if we have some corrupted metadata failed
to be repaired during replace, we still continue replace and let it
finish just as there is nothing wrong:

 BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
 BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
 BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad csum, has 0x00000000 want 0xade80ca1
 BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
 BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
 BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
 BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad bytenr, has 0 want 5578752
 BTRFS error (device dm-4): unable to fixup (regular) error at logical 5578752 on dev /dev/mapper/test-scratch1
 BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 finished

This can lead to unexpected problems for the result fs.

[CAUSE]
Btrfs reuses scrub code path for dev-replace to iterate all dev extents.

But unlike scrub, dev-replace doesn't really bother to check the scrub
progress, which records all the errors found during replace.

And even if we checks the progress, we can not really determine which
errors are minor, which are critical just by the plain numbers.
(remember we don't treat metadata/data checksum error differently).

This behavior is there from the very beginning.

[FIX]
Instead of continue the replace, just error out if we hit an unrepaired
metadata sector.

Now the dev-replace would be rejected with -EIO, to inform the user.
Although it also means, the fs has some metadata error which can not be
repaired, the user would be super upset anyway.

The new dmesg would look like this:

 BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
 BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
 BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
 BTRFS error (device dm-4): unable to fixup (regular) error at logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
 BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
 BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
 BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata sector at 5578752
 BTRFS error (device dm-4): btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, /dev/mapper/test-scratch2) failed -5

CC: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
I'm not sure how should we merge this patch.

The misc-next is already merging the new scrub code, but the problem is
there for all old kernels thus we need such fixes.

Maybe we can merge this fix before the scrub rework, then the rework,
and finally the better fix using reworked interface?
---
 fs/btrfs/scrub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ef4046a2572c..71f64b9bcd9f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -195,6 +195,7 @@ struct scrub_ctx {
 	struct mutex            wr_lock;
 	struct btrfs_device     *wr_tgtdev;
 	bool                    flush_all_writes;
+	bool			has_meta_failed;
 
 	/*
 	 * statistics
@@ -1380,6 +1381,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		btrfs_err_rl_in_rcu(fs_info,
 			"unable to fixup (regular) error at logical %llu on dev %s",
 			logical, btrfs_dev_name(dev));
+		if (is_metadata)
+			sctx->has_meta_failed = true;
 	}
 
 out:
@@ -3838,6 +3841,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 	blk_finish_plug(&plug);
 
+	/*
+	 * If we have metadata unable to be repaired, we should error
+	 * out the dev-replace.
+	 */
+	if (sctx->is_dev_replace && sctx->has_meta_failed && ret >= 0)
+		ret = -EIO;
 	if (sctx->is_dev_replace && ret >= 0) {
 		int ret2;
 
-- 
2.39.2

