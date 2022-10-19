Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE2603CB0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiJSIur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiJSItP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:49:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD402937B;
        Wed, 19 Oct 2022 01:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33920B822E7;
        Wed, 19 Oct 2022 08:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C722C433C1;
        Wed, 19 Oct 2022 08:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169028;
        bh=I5YDn81jI/EDADv6zzlsMUgkxvYfnlhwaafu72TSR3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aM6Zfm5TB/Xz7xPYsbQ7V81QFI417R1YTk49FjwJCrX+PtHHkZt4DfsvhcMdQ6Lbx
         ze70/a/osJXSJ7885yyQDYk65ppcexUpnGbw5HjCTqE4I/FmHTsVSrTbGHfawV/g1c
         cU57PxeB0d3ke+iecvcx8SJs12oDrAxnQUKPfJY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 6.0 134/862] ext2: Add sanity checks for group and filesystem size
Date:   Wed, 19 Oct 2022 10:23:41 +0200
Message-Id: <20221019083255.893841253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit d766f2d1e3e3bd44024a7f971ffcf8b8fbb7c5d2 upstream.

Add sanity check that filesystem size does not exceed the underlying
device size and that group size is big enough so that metadata can fit
into it. This avoid trying to mount some crafted filesystems with
extremely large group counts.

Reported-by: syzbot+0f2f7e65a3007d39539f@syzkaller.appspotmail.com
Reported-by: kernel test robot <oliver.sang@intel.com> # Test fixup
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/super.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1052,6 +1052,13 @@ static int ext2_fill_super(struct super_
 			sbi->s_blocks_per_group);
 		goto failed_mount;
 	}
+	/* At least inode table, bitmaps, and sb have to fit in one group */
+	if (sbi->s_blocks_per_group <= sbi->s_itb_per_group + 3) {
+		ext2_msg(sb, KERN_ERR,
+			"error: #blocks per group smaller than metadata size: %lu <= %lu",
+			sbi->s_blocks_per_group, sbi->s_inodes_per_group + 3);
+		goto failed_mount;
+	}
 	if (sbi->s_frags_per_group > sb->s_blocksize * 8) {
 		ext2_msg(sb, KERN_ERR,
 			"error: #fragments per group too big: %lu",
@@ -1065,9 +1072,14 @@ static int ext2_fill_super(struct super_
 			sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
+	if (sb_bdev_nr_blocks(sb) < le32_to_cpu(es->s_blocks_count)) {
+		ext2_msg(sb, KERN_ERR,
+			 "bad geometry: block count %u exceeds size of device (%u blocks)",
+			 le32_to_cpu(es->s_blocks_count),
+			 (unsigned)sb_bdev_nr_blocks(sb));
+		goto failed_mount;
+	}
 
-	if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
-		goto cantfind_ext2;
 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
 				le32_to_cpu(es->s_first_data_block) - 1)
 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;


