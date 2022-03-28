Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156CB4EA070
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343900AbiC1TuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343677AbiC1Trj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:47:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEB0BCA3;
        Mon, 28 Mar 2022 12:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2753ECE169A;
        Mon, 28 Mar 2022 19:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BC4C3410F;
        Mon, 28 Mar 2022 19:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496591;
        bh=AJfBjKjh2+RRkrw2MJojNVGL7DPhthwNBpPtrMeZIT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW3EITEfD1ceIh04cVEogDke+2JCzGpdkBEP34ujt1lGH9KJErKTYpWeRIAjOwq+J
         2/FJ/6ROfLDd3f5Ep00odVr+kTzo8VY9I6x4f4L8GYwTGhPPAiIXtyywXswwb5oDtA
         vZTO2bqpUHcrLI+IP7+hrh/ostHwngT18z+JuAw3slXekAB8Ag6NHktyp3eGYwLcgS
         9V6v3Cng4oueU/heuvgWCYLiG1gm8KYu/Me+5jXHjvMfPgWACzjp8DIw6C9s1/ebSo
         PT5AyCoPX+nYhtq5hByZn9+KtPkC77h/fusVCUfLOEgZ3ijIncvoaEu61yvt2KbzbD
         U2+lRRhM7pj3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, yuchao0@huawei.com,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 08/16] f2fs: fix to do sanity check on curseg->alloc_type
Date:   Mon, 28 Mar 2022 15:42:51 -0400
Message-Id: <20220328194300.1586178-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194300.1586178-1-sashal@kernel.org>
References: <20220328194300.1586178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit f41ee8b91c00770d718be2ff4852a80017ae9ab3 ]

As Wenqing Liu reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215657

- Overview
UBSAN: array-index-out-of-bounds in fs/f2fs/segment.c:3460:2 when mount and operate a corrupted image

- Reproduce
tested on kernel 5.17-rc4, 5.17-rc6

1. mkdir test_crash
2. cd test_crash
3. unzip tmp2.zip
4. mkdir mnt
5. ./single_test.sh f2fs 2

- Kernel dump
[   46.434454] loop0: detected capacity change from 0 to 131072
[   46.529839] F2FS-fs (loop0): Mounted with checkpoint version = 7548c2d9
[   46.738319] ================================================================================
[   46.738412] UBSAN: array-index-out-of-bounds in fs/f2fs/segment.c:3460:2
[   46.738475] index 231 is out of range for type 'unsigned int [2]'
[   46.738539] CPU: 2 PID: 939 Comm: umount Not tainted 5.17.0-rc6 #1
[   46.738547] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   46.738551] Call Trace:
[   46.738556]  <TASK>
[   46.738563]  dump_stack_lvl+0x47/0x5c
[   46.738581]  ubsan_epilogue+0x5/0x50
[   46.738592]  __ubsan_handle_out_of_bounds+0x68/0x80
[   46.738604]  f2fs_allocate_data_block+0xdff/0xe60 [f2fs]
[   46.738819]  do_write_page+0xef/0x210 [f2fs]
[   46.738934]  f2fs_do_write_node_page+0x3f/0x80 [f2fs]
[   46.739038]  __write_node_page+0x2b7/0x920 [f2fs]
[   46.739162]  f2fs_sync_node_pages+0x943/0xb00 [f2fs]
[   46.739293]  f2fs_write_checkpoint+0x7bb/0x1030 [f2fs]
[   46.739405]  kill_f2fs_super+0x125/0x150 [f2fs]
[   46.739507]  deactivate_locked_super+0x60/0xc0
[   46.739517]  deactivate_super+0x70/0xb0
[   46.739524]  cleanup_mnt+0x11a/0x200
[   46.739532]  __cleanup_mnt+0x16/0x20
[   46.739538]  task_work_run+0x67/0xa0
[   46.739547]  exit_to_user_mode_prepare+0x18c/0x1a0
[   46.739559]  syscall_exit_to_user_mode+0x26/0x40
[   46.739568]  do_syscall_64+0x46/0xb0
[   46.739584]  entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is we missed to do sanity check on curseg->alloc_type,
result in out-of-bound accessing on sbi->block_count[] array, fix it.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d716553bdc02..338a57360bb8 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4747,6 +4747,13 @@ static int sanity_check_curseg(struct f2fs_sb_info *sbi)
 
 		sanity_check_seg_type(sbi, curseg->seg_type);
 
+		if (curseg->alloc_type != LFS && curseg->alloc_type != SSR) {
+			f2fs_err(sbi,
+				 "Current segment has invalid alloc_type:%d",
+				 curseg->alloc_type);
+			return -EFSCORRUPTED;
+		}
+
 		if (f2fs_test_bit(blkofs, se->cur_valid_map))
 			goto out;
 
-- 
2.34.1

