Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79F54F3521
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbiDEJBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbiDEIm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C421CE0B5;
        Tue,  5 Apr 2022 01:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74F16B81A32;
        Tue,  5 Apr 2022 08:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8234C385A0;
        Tue,  5 Apr 2022 08:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147694;
        bh=J4S+etbjVCXAa9JX5lxo2e9JY2JCmTmRc3QVIp0kjWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIvubONBY5WZQzOJ6AEYvg7lrjNZtsYVv+5OT7IvjkLSDcePm+sW6JOndDrMsJSO0
         cpyy7qKbbIti7OpiUX5LU6Orl3YVXYy84PcLFUPlFDVQO2QXa0LqRAwAQEd8GkAGvX
         UMvHhhFfjqwx/oUFosiA5iWDEA6W0+keZVTXKjPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhyung Park <qkrwngud825@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.16 0071/1017] f2fs: quota: fix loop condition at f2fs_quota_sync()
Date:   Tue,  5 Apr 2022 09:16:24 +0200
Message-Id: <20220405070356.297493079@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Juhyung Park <qkrwngud825@gmail.com>

commit 680af5b824a52faa819167628665804a14f0e0df upstream.

cnt should be passed to sb_has_quota_active() instead of type to check
active quota properly.

Moreover, when the type is -1, the compiler with enough inline knowledge
can discard sb_has_quota_active() check altogether, causing a NULL pointer
dereference at the following inode_lock(dqopt->files[cnt]):

[    2.796010] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a0
[    2.796024] Mem abort info:
[    2.796025]   ESR = 0x96000005
[    2.796028]   EC = 0x25: DABT (current EL), IL = 32 bits
[    2.796029]   SET = 0, FnV = 0
[    2.796031]   EA = 0, S1PTW = 0
[    2.796032] Data abort info:
[    2.796034]   ISV = 0, ISS = 0x00000005
[    2.796035]   CM = 0, WnR = 0
[    2.796046] user pgtable: 4k pages, 39-bit VAs, pgdp=00000003370d1000
[    2.796048] [00000000000000a0] pgd=0000000000000000, pud=0000000000000000
[    2.796051] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[    2.796056] CPU: 7 PID: 640 Comm: f2fs_ckpt-259:7 Tainted: G S                5.4.179-arter97-r8-64666-g2f16e087f9d8 #1
[    2.796057] Hardware name: Qualcomm Technologies, Inc. Lahaina MTP lemonadep (DT)
[    2.796059] pstate: 80c00005 (Nzcv daif +PAN +UAO)
[    2.796065] pc : down_write+0x28/0x70
[    2.796070] lr : f2fs_quota_sync+0x100/0x294
[    2.796071] sp : ffffffa3f48ffc30
[    2.796073] x29: ffffffa3f48ffc30 x28: 0000000000000000
[    2.796075] x27: ffffffa3f6d718b8 x26: ffffffa415fe9d80
[    2.796077] x25: ffffffa3f7290048 x24: 0000000000000001
[    2.796078] x23: 0000000000000000 x22: ffffffa3f7290000
[    2.796080] x21: ffffffa3f72904a0 x20: ffffffa3f7290110
[    2.796081] x19: ffffffa3f77a9800 x18: ffffffc020aae038
[    2.796083] x17: ffffffa40e38e040 x16: ffffffa40e38e6d0
[    2.796085] x15: ffffffa40e38e6cc x14: ffffffa40e38e6d0
[    2.796086] x13: 00000000000004f6 x12: 00162c44ff493000
[    2.796088] x11: 0000000000000400 x10: ffffffa40e38c948
[    2.796090] x9 : 0000000000000000 x8 : 00000000000000a0
[    2.796091] x7 : 0000000000000000 x6 : 0000d1060f00002a
[    2.796093] x5 : ffffffa3f48ff718 x4 : 000000000000000d
[    2.796094] x3 : 00000000060c0000 x2 : 0000000000000001
[    2.796096] x1 : 0000000000000000 x0 : 00000000000000a0
[    2.796098] Call trace:
[    2.796100]  down_write+0x28/0x70
[    2.796102]  f2fs_quota_sync+0x100/0x294
[    2.796104]  block_operations+0x120/0x204
[    2.796106]  f2fs_write_checkpoint+0x11c/0x520
[    2.796107]  __checkpoint_and_complete_reqs+0x7c/0xd34
[    2.796109]  issue_checkpoint_thread+0x6c/0xb8
[    2.796112]  kthread+0x138/0x414
[    2.796114]  ret_from_fork+0x10/0x18
[    2.796117] Code: aa0803e0 aa1f03e1 52800022 aa0103e9 (c8e97d02)
[    2.796120] ---[ end trace 96e942e8eb6a0b53 ]---
[    2.800116] Kernel panic - not syncing: Fatal exception
[    2.800120] SMP: stopping secondary CPUs

Fixes: 9de71ede81e6 ("f2fs: quota: fix potential deadlock")
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2695,7 +2695,7 @@ int f2fs_quota_sync(struct super_block *
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int cnt;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Now when everything is written we can discard the pagecache so
@@ -2706,8 +2706,8 @@ int f2fs_quota_sync(struct super_block *
 		if (type != -1 && cnt != type)
 			continue;
 
-		if (!sb_has_quota_active(sb, type))
-			return 0;
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
 
 		inode_lock(dqopt->files[cnt]);
 


