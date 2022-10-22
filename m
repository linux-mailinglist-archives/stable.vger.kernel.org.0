Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D73608662
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiJVHsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiJVHsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15279F76D;
        Sat, 22 Oct 2022 00:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976BB60B39;
        Sat, 22 Oct 2022 07:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A867AC433C1;
        Sat, 22 Oct 2022 07:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424378;
        bh=VuYyMPGk/XiYhf3Eu9DcvuFVQbCk7pNap3RucA1IkF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCw6a0yaCHk9vrhJH3ena1Fv9q2qyBDbQ4ywfL4oLEwFIs6dyZq/K+a2OkHoNhwFh
         sCm3eHIIStzsHjL8NH0JWWnmravFmRLffGMa6FD6R5fJw3IHub0KyBazxS7XYzakOe
         WeRQdKeE4711HG/4E32WYEpzuSgRfFDn3HE2Dg4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        syzbot+bd13648a53ed6933ca49@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.19 123/717] ext4: avoid crash when inline data creation follows DIO write
Date:   Sat, 22 Oct 2022 09:20:02 +0200
Message-Id: <20221022072437.268215448@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 4bb26f2885ac6930984ee451b952c5a6042f2c0e upstream.

When inode is created and written to using direct IO, there is nothing
to clear the EXT4_STATE_MAY_INLINE_DATA flag. Thus when inode gets
truncated later to say 1 byte and written using normal write, we will
try to store the data as inline data. This confuses the code later
because the inode now has both normal block and inline data allocated
and the confusion manifests for example as:

kernel BUG at fs/ext4/inode.c:2721!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 359 Comm: repro Not tainted 5.19.0-rc8-00001-g31ba1e3b8305-dirty #15
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
RIP: 0010:ext4_writepages+0x363d/0x3660
RSP: 0018:ffffc90000ccf260 EFLAGS: 00010293
RAX: ffffffff81e1abcd RBX: 0000008000000000 RCX: ffff88810842a180
RDX: 0000000000000000 RSI: 0000008000000000 RDI: 0000000000000000
RBP: ffffc90000ccf650 R08: ffffffff81e17d58 R09: ffffed10222c680b
R10: dfffe910222c680c R11: 1ffff110222c680a R12: ffff888111634128
R13: ffffc90000ccf880 R14: 0000008410000000 R15: 0000000000000001
FS:  00007f72635d2640(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000565243379180 CR3: 000000010aa74000 CR4: 0000000000150eb0
Call Trace:
 <TASK>
 do_writepages+0x397/0x640
 filemap_fdatawrite_wbc+0x151/0x1b0
 file_write_and_wait_range+0x1c9/0x2b0
 ext4_sync_file+0x19e/0xa00
 vfs_fsync_range+0x17b/0x190
 ext4_buffered_write_iter+0x488/0x530
 ext4_file_write_iter+0x449/0x1b90
 vfs_write+0xbcd/0xf40
 ksys_write+0x198/0x2c0
 __x64_sys_write+0x7b/0x90
 do_syscall_64+0x3d/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Fix the problem by clearing EXT4_STATE_MAY_INLINE_DATA when we are doing
direct IO write to a file.

Cc: stable@kernel.org
Reported-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Reported-by: syzbot+bd13648a53ed6933ca49@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=a1e89d09bbbcbd5c4cb45db230ee28c822953984
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Tested-by: Tadeusz Struk<tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220727155753.13969-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/file.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -528,6 +528,12 @@ static ssize_t ext4_dio_write_iter(struc
 		ret = -EAGAIN;
 		goto out;
 	}
+	/*
+	 * Make sure inline data cannot be created anymore since we are going
+	 * to allocate blocks for DIO. We know the inode does not have any
+	 * inline data now because ext4_dio_supported() checked for that.
+	 */
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 
 	offset = iocb->ki_pos;
 	count = ret;


