Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248D1656EA4
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiL0Uc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiL0Ucz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:32:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F3565DB;
        Tue, 27 Dec 2022 12:32:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0148E6123B;
        Tue, 27 Dec 2022 20:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9957C433EF;
        Tue, 27 Dec 2022 20:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173173;
        bh=R0xzDaJAIYhuOOYsXD73fbY4k7O8EkfwaraLfqDWu+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfeHrsPRoPvrWEiJ46SrO5PUXmpY5rf0G8Vr449sqM7fTYGr+KsH89fspAITUJaWe
         4xZnJ3ogz8p147ruWvHY9xvGcKuBHkS6JclZX5tTJo0xxuo0cb+dCV92IGiEAt2UY9
         guM1OAjLvuDKm1eYTgK7l35/gHqE0S5dbRVCK9i//gwGZrrJqv78XFkru0tFOCVdXf
         RXw1S4x7v/zzSSVz71riRY3p36RrDahEw4ywFr1apIBpJCNS9dIVIRhfAleBeJv6Fh
         7kgkXqIlErkR0DomYFmljlecrbK9a6jd5bN2OFtntXSYZCj4b41Gkt0YpdYcRRO0h3
         AIReEA3tEZV/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     edward lo <edward.lo@ambergroup.io>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 02/28] fs/ntfs3: Add overflow check for attribute size
Date:   Tue, 27 Dec 2022 15:32:23 -0500
Message-Id: <20221227203249.1213526-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: edward lo <edward.lo@ambergroup.io>

[ Upstream commit e19c6277652efba203af4ecd8eed4bd30a0054c9 ]

The offset addition could overflow and pass the used size check given an
attribute with very large size (e.g., 0xffffff7f) while parsing MFT
attributes. This could lead to out-of-bound memory R/W if we try to
access the next attribute derived by Add2Ptr(attr, asize)

[   32.963847] BUG: unable to handle page fault for address: ffff956a83c76067
[   32.964301] #PF: supervisor read access in kernel mode
[   32.964526] #PF: error_code(0x0000) - not-present page
[   32.964893] PGD 4dc01067 P4D 4dc01067 PUD 0
[   32.965316] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   32.965727] CPU: 0 PID: 243 Comm: mount Not tainted 5.19.0+ #6
[   32.966050] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   32.966628] RIP: 0010:mi_enum_attr+0x44/0x110
[   32.967239] Code: 89 f0 48 29 c8 48 89 c1 39 c7 0f 86 94 00 00 00 8b 56 04 83 fa 17 0f 86 88 00 00 00 89 d0 01 ca 48 01 f0 8d 4a 08 39 f9a
[   32.968101] RSP: 0018:ffffba15c06a7c38 EFLAGS: 00000283
[   32.968364] RAX: ffff956a83c76067 RBX: ffff956983c76050 RCX: 000000000000006f
[   32.968651] RDX: 0000000000000067 RSI: ffff956983c760e8 RDI: 00000000000001c8
[   32.968963] RBP: ffffba15c06a7c38 R08: 0000000000000064 R09: 00000000ffffff7f
[   32.969249] R10: 0000000000000007 R11: ffff956983c760e8 R12: ffff95698225e000
[   32.969870] R13: 0000000000000000 R14: ffffba15c06a7cd8 R15: ffff95698225e170
[   32.970655] FS:  00007fdab8189e40(0000) GS:ffff9569fdc00000(0000) knlGS:0000000000000000
[   32.971098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.971378] CR2: ffff956a83c76067 CR3: 0000000002c58000 CR4: 00000000000006f0
[   32.972098] Call Trace:
[   32.972842]  <TASK>
[   32.973341]  ni_enum_attr_ex+0xda/0xf0
[   32.974087]  ntfs_iget5+0x1db/0xde0
[   32.974386]  ? slab_post_alloc_hook+0x53/0x270
[   32.974778]  ? ntfs_fill_super+0x4c7/0x12a0
[   32.975115]  ntfs_fill_super+0x5d6/0x12a0
[   32.975336]  get_tree_bdev+0x175/0x270
[   32.975709]  ? put_ntfs+0x150/0x150
[   32.975956]  ntfs_fs_get_tree+0x15/0x20
[   32.976191]  vfs_get_tree+0x2a/0xc0
[   32.976374]  ? capable+0x19/0x20
[   32.976572]  path_mount+0x484/0xaa0
[   32.977025]  ? putname+0x57/0x70
[   32.977380]  do_mount+0x80/0xa0
[   32.977555]  __x64_sys_mount+0x8b/0xe0
[   32.978105]  do_syscall_64+0x3b/0x90
[   32.978830]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   32.979311] RIP: 0033:0x7fdab72e948a
[   32.980015] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 008
[   32.981251] RSP: 002b:00007ffd15b87588 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[   32.981832] RAX: ffffffffffffffda RBX: 0000557de0aaf060 RCX: 00007fdab72e948a
[   32.982234] RDX: 0000557de0aaf260 RSI: 0000557de0aaf2e0 RDI: 0000557de0ab7ce0
[   32.982714] RBP: 0000000000000000 R08: 0000557de0aaf280 R09: 0000000000000020
[   32.983046] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 0000557de0ab7ce0
[   32.983494] R13: 0000557de0aaf260 R14: 0000000000000000 R15: 00000000ffffffff
[   32.984094]  </TASK>
[   32.984352] Modules linked in:
[   32.984753] CR2: ffff956a83c76067
[   32.985911] ---[ end trace 0000000000000000 ]---
[   32.986555] RIP: 0010:mi_enum_attr+0x44/0x110
[   32.987217] Code: 89 f0 48 29 c8 48 89 c1 39 c7 0f 86 94 00 00 00 8b 56 04 83 fa 17 0f 86 88 00 00 00 89 d0 01 ca 48 01 f0 8d 4a 08 39 f9a
[   32.988232] RSP: 0018:ffffba15c06a7c38 EFLAGS: 00000283
[   32.988532] RAX: ffff956a83c76067 RBX: ffff956983c76050 RCX: 000000000000006f
[   32.988916] RDX: 0000000000000067 RSI: ffff956983c760e8 RDI: 00000000000001c8
[   32.989356] RBP: ffffba15c06a7c38 R08: 0000000000000064 R09: 00000000ffffff7f
[   32.989994] R10: 0000000000000007 R11: ffff956983c760e8 R12: ffff95698225e000
[   32.990415] R13: 0000000000000000 R14: ffffba15c06a7cd8 R15: ffff95698225e170
[   32.991011] FS:  00007fdab8189e40(0000) GS:ffff9569fdc00000(0000) knlGS:0000000000000000
[   32.991524] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.991936] CR2: ffff956a83c76067 CR3: 0000000002c58000 CR4: 00000000000006f0

This patch adds an overflow check

Signed-off-by: edward lo <edward.lo@ambergroup.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 7d2fac5ee215..9f81944441ae 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -220,6 +220,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 			return NULL;
 		}
 
+		if (off + asize < off) {
+			/* overflow check */
+			return NULL;
+		}
+
 		attr = Add2Ptr(attr, asize);
 		off += asize;
 	}
-- 
2.35.1

