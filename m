Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6720E6085F6
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiJVHmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiJVHlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:41:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC99CABC2;
        Sat, 22 Oct 2022 00:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8F64B82DF8;
        Sat, 22 Oct 2022 07:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2E3C433B5;
        Sat, 22 Oct 2022 07:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424348;
        bh=/rlIOwq1/D8lcgHiDoBRaXjaRMN4FAVegRTcoeZ6J7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bga8eJdBMmpTbLz/AvTj7L96JqyxuRHdV8Q4Ob/dFyV48lYNOtJyPc9Y+EHf24ILw
         05nuw9L/tbhiBHun9cIEDcZDV65CyHnVasOkTFohIz418hhD+1K0c5Dq3vNFCMdkpA
         +o5LRD2EWPFeyuxUzIhPTjPZUr4xqkZyRC+l7hjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.19 113/717] f2fs: complete checkpoints during remount
Date:   Sat, 22 Oct 2022 09:19:52 +0200
Message-Id: <20221022072435.432970377@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 4f99484d27961cb194cebcd917176fa038a5025f upstream.

Otherwise, pending checkpoints can contribute a race condition to give a
quota warning.

- Thread                      - checkpoint thread
                              add checkpoints to the list
do_remount()
 down_write(&sb->s_umount);
 f2fs_remount()
                              block_operations()
                               down_read_trylock(&sb->s_umount) = 0
 up_write(&sb->s_umount);
                               f2fs_quota_sync()
                                dquot_writeback_dquots()
                                 WARN_ON_ONCE(!rwsem_is_locked(&sb->s_umount));

Or,

do_remount()
 down_write(&sb->s_umount);
 f2fs_remount()
                              create a ckpt thread
                              f2fs_enable_checkpoint() adds checkpoints
			      wait for f2fs_sync_fs()
                              trigger another pending checkpoint
                               block_operations()
                                down_read_trylock(&sb->s_umount) = 0
 up_write(&sb->s_umount);
                                f2fs_quota_sync()
                                 dquot_writeback_dquots()
                                  WARN_ON_ONCE(!rwsem_is_locked(&sb->s_umount));

Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2146,6 +2146,9 @@ static void f2fs_enable_checkpoint(struc
 	f2fs_up_write(&sbi->gc_lock);
 
 	f2fs_sync_fs(sbi->sb, 1);
+
+	/* Let's ensure there's no pending checkpoint anymore */
+	f2fs_flush_ckpt_thread(sbi);
 }
 
 static int f2fs_remount(struct super_block *sb, int *flags, char *data)
@@ -2311,6 +2314,9 @@ static int f2fs_remount(struct super_blo
 		f2fs_stop_ckpt_thread(sbi);
 		need_restart_ckpt = true;
 	} else {
+		/* Flush if the prevous checkpoint, if exists. */
+		f2fs_flush_ckpt_thread(sbi);
+
 		err = f2fs_start_ckpt_thread(sbi);
 		if (err) {
 			f2fs_err(sbi,


