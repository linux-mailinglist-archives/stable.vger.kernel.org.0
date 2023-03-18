Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5DE6BF94F
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCRKPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCRKPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:42 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9876234CE;
        Sat, 18 Mar 2023 03:15:40 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id az3-20020a05600c600300b003ed2920d585so6424255wmb.2;
        Sat, 18 Mar 2023 03:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7e309zG3GVSY+X1IZJ2K6Xi6wPSGKzC+UwjI2avX+I=;
        b=L0vDvTpIwv5eQKRz5a/a6ZE4ctlqIpzt6rqiXD4Zq5xMWmWA+FXMum7wJlrkQu5KXB
         7VZ9/Wf0tC0mvm+qwB1DfpYZAyH2757yVHcBRG54v9ZemST/Z2vHOKxSoLKYK8w93L6R
         HfdCbV2alDp1NmJ2LDFGOdAo6Muxea9lEzeeRodBneg9J2aNv9onECdTK/aS7uVAHOg3
         79ue1WGS8mYrcmV4AKnYZFmD+uue9VEHeH8ZqV6dsbvJAtDS/kdA1TuxqpAeN498kD3B
         Q03YaBN6R7YgTNOoA7+dZip97zno70jH4f3ru9X0gIAAiqPZf7uKcHS5Gd8C8ixfQV1c
         IcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7e309zG3GVSY+X1IZJ2K6Xi6wPSGKzC+UwjI2avX+I=;
        b=4S61lDFVu7rBxPL+AePNMLHj7i7NUa0PLU32bOs7y/iKmqkTJhaLmjT9tBITV7x0TL
         5qaAA44PvRj9jRM5y1zvkLTpUxyWmVUy+J4foiqyZTnaK/CrlNvJxkgne99A+0StQsYd
         Luj+Kl7rleatlNBxna8lTm3n6hs00TkLYUzjgx3AoPXiWi67YHQDcYbpEE8vQ36/JqU7
         fUzOUoGLynhpoAQPGAagxJINWgvqrbspfAlBAoSxaUEO2pgepn4ihbv0+Qi8AL77A9bB
         Xx0SR/824oXLbK+bcmnuX2iUDYSiLFzyGtXr3JaoE98pkrl3K3is7g+/IbxD6v7oHQuu
         KPcg==
X-Gm-Message-State: AO0yUKXNe/PBW6e5d9tl0L5vWJ9cX+dLuABKMG5HISLzfhSmfOjt4+ZV
        z2N7ohQI/n0R9Q+aNhSmvoOs9+8peYc=
X-Google-Smtp-Source: AK7set/c4cQj55J9eWa86RvyQQHY8Tyojdv7maBL6B5LBjVTzyjB+wy7aXEQLVVH/KQu5jY9SyaXqw==
X-Received: by 2002:a05:600c:4592:b0:3e2:201a:5bcc with SMTP id r18-20020a05600c459200b003e2201a5bccmr26656277wmo.33.1679134539005;
        Sat, 18 Mar 2023 03:15:39 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 02/15] xfs: purge dquots after inode walk fails during quotacheck
Date:   Sat, 18 Mar 2023 12:15:16 +0200
Message-Id: <20230318101529.1361673-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 86d40f1e49e9a909d25c35ba01bea80dbcd758cb upstream.

[add XFS_QMOPT_QUOTALL flag to xfs_qm_dqpurge_all() for 5.10.y backport]

xfs/434 and xfs/436 have been reporting occasional memory leaks of
xfs_dquot objects.  These tests themselves were the messenger, not the
culprit, since they unload the xfs module, which trips the slub
debugging code while tearing down all the xfs slab caches:

=============================================================================
BUG xfs_dquot (Tainted: G        W        ): Objects remaining in xfs_dquot on __kmem_cache_shutdown()
-----------------------------------------------------------------------------

Slab 0xffffea000606de00 objects=30 used=5 fp=0xffff888181b78a78 flags=0x17ff80000010200(slab|head|node=0|zone=2|lastcpupid=0xfff)
CPU: 0 PID: 3953166 Comm: modprobe Tainted: G        W         5.18.0-rc6-djwx #rc6 d5824be9e46a2393677bda868f9b154d917ca6a7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014

Since we don't generally rmmod the xfs module between fstests, this
means that xfs/434 is really just the canary in the coal mine --
something leaked a dquot, but we don't know who.  After days of pounding
on fstests with kmemleak enabled, I finally got it to spit this out:

unreferenced object 0xffff8880465654c0 (size 536):
  comm "u10:4", pid 88, jiffies 4294935810 (age 29.512s)
  hex dump (first 32 bytes):
    60 4a 56 46 80 88 ff ff 58 ea e4 5c 80 88 ff ff  `JVF....X..\....
    00 e0 52 49 80 88 ff ff 01 00 01 00 00 00 00 00  ..RI............
  backtrace:
    [<ffffffffa0740f6c>] xfs_dquot_alloc+0x2c/0x530 [xfs]
    [<ffffffffa07443df>] xfs_qm_dqread+0x6f/0x330 [xfs]
    [<ffffffffa07462a2>] xfs_qm_dqget+0x132/0x4e0 [xfs]
    [<ffffffffa0756bb0>] xfs_qm_quotacheck_dqadjust+0xa0/0x3e0 [xfs]
    [<ffffffffa075724d>] xfs_qm_dqusage_adjust+0x35d/0x4f0 [xfs]
    [<ffffffffa06c9068>] xfs_iwalk_ag_recs+0x348/0x5d0 [xfs]
    [<ffffffffa06c95d3>] xfs_iwalk_run_callbacks+0x273/0x540 [xfs]
    [<ffffffffa06c9e8d>] xfs_iwalk_ag+0x5ed/0x890 [xfs]
    [<ffffffffa06ca22f>] xfs_iwalk_ag_work+0xff/0x170 [xfs]
    [<ffffffffa06d22c9>] xfs_pwork_work+0x79/0x130 [xfs]
    [<ffffffff81170bb2>] process_one_work+0x672/0x1040
    [<ffffffff81171b1b>] worker_thread+0x59b/0xec0
    [<ffffffff8118711e>] kthread+0x29e/0x340
    [<ffffffff810032bf>] ret_from_fork+0x1f/0x30

Now we know that quotacheck is at fault, but even this report was
canaryish -- it was triggered by xfs/494, which doesn't actually mount
any filesystems.  (kmemleak can be a little slow to notice leaks, even
with fstests repeatedly whacking it to look for them.)  Looking at the
*previous* fstest, however, showed that the test run before xfs/494 was
xfs/117.  The tipoff to the problem is in this excerpt from dmesg:

XFS (sda4): Quotacheck needed: Please wait.
XFS (sda4): Metadata corruption detected at xfs_dinode_verify.part.0+0xdb/0x7b0 [xfs], inode 0x119 dinode
XFS (sda4): Unmount and run xfs_repair
XFS (sda4): First 128 bytes of corrupted metadata buffer:
00000000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
00000010: 00 00 00 01 00 00 00 00 00 90 57 54 54 1a 4c 68  ..........WTT.Lh
00000020: 81 f9 7d e1 6d ee 16 00 34 bd 7d e1 6d ee 16 00  ..}.m...4.}.m...
00000030: 34 bd 7d e1 6d ee 16 00 00 00 00 00 00 00 00 00  4.}.m...........
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 02 00 00 00 00 00 00 00 00 96 80 f3 ab  ................
00000060: ff ff ff ff da 57 7b 11 00 00 00 00 00 00 00 03  .....W{.........
00000070: 00 00 00 01 00 00 00 10 00 00 00 00 00 00 00 08  ................
XFS (sda4): Quotacheck: Unsuccessful (Error -117): Disabling quotas.

The dinode verifier decided that the inode was corrupt, which causes
iget to return with EFSCORRUPTED.  Since this happened during
quotacheck, it is obvious that the kernel aborted the inode walk on
account of the corruption error and disabled quotas.  Unfortunately, we
neglect to purge the dquot cache before doing that, which is how the
dquots leaked.

The problems started 10 years ago in commit b84a3a, when the dquot lists
were converted to a radix tree, but the error handling behavior was not
correctly preserved -- in that commit, if the bulkstat failed and
usrquota was enabled, the bulkstat failure code would be overwritten by
the result of flushing all the dquots to disk.  As long as that
succeeds, we'd continue the quota mount as if everything were ok, but
instead we're now operating with a corrupt inode and incorrect quota
usage counts.  I didn't notice this bug in 2019 when I wrote commit
ebd126a, which changed quotacheck to skip the dqflush when the scan
doesn't complete due to inode walk failures.

Introduced-by: b84a3a96751f ("xfs: remove the per-filesystem list of dquots")
Fixes: ebd126a651f8 ("xfs: convert quotacheck to use the new iwalk functions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_qm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 64e5da33733b..3c17e0c0f816 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1318,8 +1318,15 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error)
+	if (error) {
+		/*
+		 * The inode walk may have partially populated the dquot
+		 * caches.  We must purge them before disabling quota and
+		 * tearing down the quotainfo, or else the dquots will leak.
+		 */
+		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
 		goto error_return;
+	}
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
-- 
2.34.1

