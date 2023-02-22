Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6869F51F
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 14:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjBVNMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 08:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjBVNMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 08:12:23 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C573B38B7C
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 05:12:21 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f41so9920103lfv.13
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 05:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLDojPRW+ZsQOIZwIAXgd8EkXB16fF3Bt+6jaMZKqbM=;
        b=nU2G1RacBkWrQaKi7zeLDSxeZxVWZRQKGxUf7GNywf2v3SnZj4hmFyzNz/LOWA7SNZ
         bCW+WXZoJvLPZP/SFL6rCpAaTnX4pxC4cDsAv844DFRgarExvvrRMU0xFZgTR+UkUINK
         tfnwYi9GStRcs6WIjc1jwrCnFKWeNjiGox+sHWPigIGVb/UfCr+B1hgLbd6l+y9+KMyQ
         V6YlLSYGkjl5hcVhsC0n93fHI9DEcbyGNO+WN48CKPm70NjJKRvYU5IC5tScCcC28W7Y
         PmXt8svVEGb8Z4g3TYuTU8UuYdOneTGmEoDaWRJUHLIdSc4mMHCsVei7LVaUlpX3JmoN
         TefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLDojPRW+ZsQOIZwIAXgd8EkXB16fF3Bt+6jaMZKqbM=;
        b=YsrW4IVtAq59b1sSQ+siYnvHZS+cZpnOSuT5crKI0FnifGBXk+fDp95cuRC33eZHh5
         f+ZS3xm8RcJoSG1ZnIcNKbdgxPXfX9FEfv27KhTRgnRM8s2kmdbAgMpPQed5hrWY4tf1
         XVbVUqOQIloPXcSCyEoNBByQZCjQd7iL0ByzfHH8MB5i6bJ+9ysRShveDhsEeKELTPU8
         Me61QIhva1JkbGlNmOLQAd3xmv1NLVi0pPWDhYiOS6uxfn/G6aCumb5vdNEI+OzVCqIN
         7BBWPtWVNg4lch2HXH9QwxT6J1jcKvIBeInngwAlQn0+yIpDwg6wCd9nvVfEamSyFGtA
         3Rkw==
X-Gm-Message-State: AO0yUKXnYe2R69IAfPNKm/Z/I5tU2GjJaJvjFoLRy3Ph7Q1BbeTKB4Sh
        WYuiYgdWOZC+L7mxiiMS6gbO4w==
X-Google-Smtp-Source: AK7set8fH43IkYA7We+tyutXd5OWGe8JqBzTuF8HKl2nyATWWc0yMbZS9LtIBPXZvNohHQBH9nSVuQ==
X-Received: by 2002:a19:f612:0:b0:4d5:8f3e:7852 with SMTP id x18-20020a19f612000000b004d58f3e7852mr2937893lfe.49.1677071539975;
        Wed, 22 Feb 2023 05:12:19 -0800 (PST)
Received: from ta1.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id y25-20020a2e7d19000000b0029335c12997sm564383ljc.58.2023.02.22.05.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 05:12:19 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     tytso@mit.edu, darrick.wong@oracle.com, djwong@kernel.org,
        adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Tudor Ambarus <tudor.ambarus@linaro.org>,
        stable@vger.kernel.org,
        syzbot+6be2b977c89f79b6b153@syzkaller.appspotmail.com
Subject: [PATCH 1/3] ext4: fsmap: Fix crash caused by poor key validation
Date:   Wed, 22 Feb 2023 13:12:09 +0000
Message-Id: <20230222131211.3898066-2-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
In-Reply-To: <20230222131211.3898066-1-tudor.ambarus@linaro.org>
References: <20230222131211.3898066-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following crash was seen on a 1k-block ext4 filesystem when the user
passed a fmr_physical of value zero for the high key:

kernel BUG at fs/ext4/ext4.h:3354!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 422 Comm: syz-executor339 Not tainted 5.15.74-syzkaller-00001-g4ec71a9ec769 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:ext4_get_group_info fs/ext4/ext4.h:3354 [inline]
RIP: 0010:ext4_mb_load_buddy_gfp+0xe9d/0xeb0 fs/ext4/mballoc.c:1498
Code: 99 ed c1 ff e9 47 f4 ff ff e8 5f a0 7f ff 48 c7 c7 c0 c3 a9 86 48 89 de 4c 89 ea e8 ad 8e 92 00 e9 a1 f2 ff ff e8 43 a0 7f ff <0f> 0b e8 3c a0 7f ff 0f 0b e8 35 a0 7f ff 0f 0b 0f 1f 00 55 48 89
RSP: 0018:ffffc9000044f320 EFLAGS: 00010293
RAX: ffffffff81f1f14d RBX: 0000000000000001 RCX: ffff888106194f00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffffc9000044f3b0 R08: ffffffff81f1e3a4 R09: ffffc9000044f440
R10: fffff52000089e8f R11: 1ffff92000089e88 R12: ffff888100a553c8
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff888105f9a000
FS:  000055555675b300(0000) GS:ffff8881f7000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c4f7cde3e8 CR3: 000000011c064000 CR4: 00000000003506b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ext4_mb_load_buddy fs/ext4/mballoc.c:1620 [inline]
 ext4_mballoc_query_range+0xb8/0x7b0 fs/ext4/mballoc.c:6560
 ext4_getfsmap_datadev+0x1c8a/0x28c0 fs/ext4/fsmap.c:537
 ext4_getfsmap+0xcff/0x1040 fs/ext4/fsmap.c:708
 ext4_ioc_getfsmap fs/ext4/ioctl.c:660 [inline]
 __ext4_ioctl fs/ext4/ioctl.c:862 [inline]
 ext4_ioctl+0x3020/0x50e0 fs/ext4/ioctl.c:1276
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0x115/0x190 fs/ioctl.c:860
 __x64_sys_ioctl+0x7b/0x90 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x61/0xcb
RIP: 0033:0x7f8d2372e3e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcae7c2578 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f8d2372e3e9
RDX: 0000000020000200 RSI: 00000000c0c0583b RDI: 0000000000000004
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 00000000000003f1 R11: 0000000000000246 R12: 00007f8d236ed5c0
R13: 00007ffcae7c25a0 R14: 00007ffcae7c258c R15: 00007ffcae7c2590

The crash is due to insufficient key validation.
When high_key->fmr_physical is zero for a 1k-block ext4 filesystem we
encounter an underflow in the second call to
ext4_get_group_no_and_offset():
	blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
blocknr comes with value zero (high_key->fmr_physical is zero) and
the first_data_block is one, thus blocknr becomes -1. Since blocknr is
of type ext4_fsblk_t (unsigned long long) the value is all ones. Due to
the high values for blocknr and offset we hit the BUG_ON in
ext4_get_group_info() as the groupnr exceeds EXT4_SB(sb)->s_groups_count).

Fix it by returning early when keys[1].fmr_physical is less than or equal
to the first data block, as there's no data to return. This replicates the
behavior of returning zero, like in keys[0].fmr_physical >= eofs. In both
cases -EINVAL could be returned but for some reason the author decided to
just ignore out of bounds requests.
One may notice that the check introduced addresses just the
ext4_getfsmap_datadev() handler. This is intentional, because for the
ext4_getfsmap_logdev() handler, the value of the high key passed by the
user is ignored and instead the code uses:
	memset(&info->gfi_high, 0xFF, sizeof(info->gfi_high));

Cc: stable@vger.kernel.org
Fixes: 0c9ec4beecac ("ext4: support GETFSMAP ioctls")
Link: https://syzkaller.appspot.com/bug?id=79d5768e9bfe362911ac1a5057a36fc6b5c30002
Reported-by: syzbot+6be2b977c89f79b6b153@syzkaller.appspotmail.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 fs/ext4/fsmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index 4493ef0c715e..b5289378a761 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -479,6 +479,8 @@ static int ext4_getfsmap_datadev(struct super_block *sb,
 	int error = 0;
 
 	bofs = le32_to_cpu(sbi->s_es->s_first_data_block);
+	if (keys[1].fmr_physical <= bofs)
+		return 0;
 	eofs = ext4_blocks_count(sbi->s_es);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-- 
2.39.2.637.g21b0678d19-goog

