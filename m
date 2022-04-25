Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCC50E2BC
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 16:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiDYOOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 10:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiDYOOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 10:14:00 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B17BDD;
        Mon, 25 Apr 2022 07:10:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=shile.zhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VBH0a0i_1650895845;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:shile.zhang@linux.alibaba.com fp:SMTPD_---0VBH0a0i_1650895845)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Apr 2022 22:10:52 +0800
From:   Shile Zhang <shile.zhang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Shile Zhang <shile.zhang@linux.alibaba.com>
Subject: [PATCH v2] drm/cirrus: fix a NULL vs IS_ERR() checks
Date:   Mon, 25 Apr 2022 22:10:43 +0800
Message-Id: <20220425141043.214024-1-shile.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.33.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function drm_gem_shmem_vmap can returns error pointers as well,
which could cause following kernel crash:

BUG: unable to handle page fault for address: fffffffffffffffc
PGD 1426a12067 P4D 1426a12067 PUD 1426a14067 PMD 0
Oops: 0000 [#1] SMP NOPTI
CPU: 12 PID: 3598532 Comm: stress-ng Kdump: loaded Not tainted 5.10.50.x86_64 #1
...
RIP: 0010:memcpy_toio+0x23/0x50
Code: 00 00 00 00 0f 1f 00 0f 1f 44 00 00 48 85 d2 74 28 40 f6 c7 01 75 2b 48 83 fa 01 76 06 40 f6 c7 02 75 17 48 89 d1 48 c1 e9 02 <f3> a5 f6 c2 02 74 02 66 a5 f6 c2 01 74 01 a4 c3 66 a5 48 83 ea 02
RSP: 0018:ffffafbf8a203c68 EFLAGS: 00010216
RAX: 0000000000000000 RBX: fffffffffffffffc RCX: 0000000000000200
RDX: 0000000000000800 RSI: fffffffffffffffc RDI: ffffafbf82000000
RBP: ffffafbf82000000 R08: 0000000000000002 R09: 0000000000000000
R10: 00000000000002b5 R11: 0000000000000000 R12: 0000000000000800
R13: ffff8a6801099300 R14: 0000000000000001 R15: 0000000000000300
FS:  00007f4a6bc5f740(0000) GS:ffff8a8641900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 00000016d3874001 CR4: 00000000003606e0
Call Trace:
 drm_fb_memcpy_dstclip+0x5e/0x80 [drm_kms_helper]
 cirrus_fb_blit_rect.isra.0+0xb7/0xe0 [cirrus]
 cirrus_pipe_update+0x9f/0xa8 [cirrus]
 drm_atomic_helper_commit_planes+0xb8/0x220 [drm_kms_helper]
 drm_atomic_helper_commit_tail+0x42/0x80 [drm_kms_helper]
 commit_tail+0xce/0x130 [drm_kms_helper]
 drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
 drm_client_modeset_commit_atomic+0x1c4/0x200 [drm]
 drm_client_modeset_commit_locked+0x53/0x80 [drm]
 drm_client_modeset_commit+0x24/0x40 [drm]
 drm_fbdev_client_restore+0x48/0x85 [drm_kms_helper]
 drm_client_dev_restore+0x64/0xb0 [drm]
 drm_release+0xf2/0x110 [drm]
 __fput+0x96/0x240
 task_work_run+0x5c/0x90
 exit_to_user_mode_loop+0xce/0xd0
 exit_to_user_mode_prepare+0x6a/0x70
 syscall_exit_to_user_mode+0x12/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f4a6bd82c2b

Fixes: ab3e023b1b4c9 ("drm/cirrus: rewrite and modernize driver.")

Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
---
v2: rebase to latest stable linux-5.10.y branch.
v1: https://lore.kernel.org/lkml/550e9439-adf6-3df8-41a0-9a7ee5447907@linux.alibaba.com/
---
 drivers/gpu/drm/tiny/cirrus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/cirrus.c b/drivers/gpu/drm/tiny/cirrus.c
index 744a8e337e41e..d64f6bb767eeb 100644
--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -323,7 +323,7 @@ static int cirrus_fb_blit_rect(struct drm_framebuffer *fb,
 
 	ret = -ENOMEM;
 	vmap = drm_gem_shmem_vmap(fb->obj[0]);
-	if (!vmap)
+	if (IS_ERR_OR_NULL(vmap))
 		goto out_dev_exit;
 
 	if (cirrus->cpp == fb->format->cpp[0])
-- 
2.33.0.rc2

