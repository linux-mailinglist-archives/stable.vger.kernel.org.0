Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3265D6A5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjADO4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239460AbjADO4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:56:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF495FACC
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 909A7B8169C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C6BC433D2;
        Wed,  4 Jan 2023 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844166;
        bh=L/c3ELo7Ky2poQXx1CZFXtSE5Cx/sGehSK5kRAVr6cQ=;
        h=Subject:To:Cc:From:Date:From;
        b=V3+pi/soX/a8WIL5VCw43lpGZ710Lar/4rK0Vk2Deydog6QsuSQ9zDfWx16mG0jaL
         lDu0vSyQSWdqwEi0IToYc74ICuZ8I8BzfrM2EiILVe9Xd/OzYYqBtiGuVkfJHSOrUF
         osVnh8i0/qnnhfG5YPjKJg2Mc8A990HPmesKN6y4=
Subject: FAILED: patch "[PATCH] ext4: correct inconsistent error msg in nojournal mode" failed to apply to 5.10-stable tree
To:     libaokun1@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:54:40 +0100
Message-ID: <167284408079164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

89481b5fa8c0 ("ext4: correct inconsistent error msg in nojournal mode")
43bd6f1b49b6 ("ext4: goto right label 'failed_mount3a'")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89481b5fa8c0640e62ba84c6020cee895f7ac643 Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Wed, 9 Nov 2022 15:43:43 +0800
Subject: [PATCH] ext4: correct inconsistent error msg in nojournal mode

When we used the journal_async_commit mounting option in nojournal mode,
the kernel told me that "can't mount with journal_checksum", was very
confusing. I find that when we mount with journal_async_commit, both the
JOURNAL_ASYNC_COMMIT and EXPLICIT_JOURNAL_CHECKSUM flags are set. However,
in the error branch, CHECKSUM is checked before ASYNC_COMMIT. As a result,
the above inconsistency occurs, and the ASYNC_COMMIT branch becomes dead
code that cannot be executed. Therefore, we exchange the positions of the
two judgments to make the error msg more accurate.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221109074343.4184862-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f5e6919ea650..878be47faaaf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5288,14 +5288,15 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount3a;
 	} else {
 		/* Nojournal mode, all journal mount options are illegal */
-		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
+		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_checksum, fs mounted w/o journal");
+				 "journal_async_commit, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
-		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+
+		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_async_commit, fs mounted w/o journal");
+				 "journal_checksum, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
 		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {

