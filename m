Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41BF62803B
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbiKNNEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbiKNNEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178C8201BD
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8400DCE0FE8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61498C433D6;
        Mon, 14 Nov 2022 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431049;
        bh=ISeb5CN/OXYkiUggZIOF6Ib+lL/5TuJCRhDyiqlZ3A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZzovfHa0sCE6m6sDV62WvuiCNoT8ycdCAtsLa5QkDC/GYXP3ilRo6peiTkhSJeDO
         f5a9s1g9l3DzRiurbLio1llTUgWkWTcHXWGLgSyNwoQMPObSYTyvxesuXMQOtlYr+f
         jKandE+EYNQctRvFbk3kURVPbdYnkFrWqXSkFVew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 082/190] net: tun: call napi_schedule_prep() to ensure we own a napi
Date:   Mon, 14 Nov 2022 13:45:06 +0100
Message-Id: <20221114124502.260460004@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 07d120aa33cc9d9115753d159f64d20c94458781 ]

A recent patch exposed another issue in napi_get_frags()
caught by syzbot [1]

Before feeding packets to GRO, and calling napi_complete()
we must first grab NAPI_STATE_SCHED.

[1]
WARNING: CPU: 0 PID: 3612 at net/core/dev.c:6076 napi_complete_done+0x45b/0x880 net/core/dev.c:6076
Modules linked in:
CPU: 0 PID: 3612 Comm: syz-executor408 Not tainted 6.1.0-rc3-syzkaller-00175-g1118b2049d77 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:napi_complete_done+0x45b/0x880 net/core/dev.c:6076
Code: c1 ea 03 0f b6 14 02 4c 89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 24 04 00 00 41 89 5d 1c e9 73 fc ff ff e8 b5 53 22 fa <0f> 0b e9 82 fe ff ff e8 a9 53 22 fa 48 8b 5c 24 08 31 ff 48 89 de
RSP: 0018:ffffc90003c4f920 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000030 RCX: 0000000000000000
RDX: ffff8880251c0000 RSI: ffffffff875a58db RDI: 0000000000000007
RBP: 0000000000000001 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff888072d02628
R13: ffff888072d02618 R14: ffff888072d02634 R15: 0000000000000000
FS: 0000555555f13300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c44d3892b8 CR3: 00000000172d2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
napi_complete include/linux/netdevice.h:510 [inline]
tun_get_user+0x206d/0x3a60 drivers/net/tun.c:1980
tun_chr_write_iter+0xdb/0x200 drivers/net/tun.c:2027
call_write_iter include/linux/fs.h:2191 [inline]
do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:735
do_iter_write+0x182/0x700 fs/read_write.c:861
vfs_writev+0x1aa/0x630 fs/read_write.c:934
do_writev+0x133/0x2f0 fs/read_write.c:977
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f37021a3c19

Fixes: 1118b2049d77 ("net: tun: Fix memory leaks of napi_get_frags")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/20221107180011.188437-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 975b9912bf8f..3387074a2bdb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1967,18 +1967,25 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
+			WARN_ON_ONCE(1);
+			err = -ENOMEM;
 			dev_core_stats_rx_dropped_inc(tun->dev);
+napi_busy:
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
-			WARN_ON(1);
-			return -ENOMEM;
+			return err;
 		}
 
-		local_bh_disable();
-		napi_gro_frags(&tfile->napi);
-		napi_complete(&tfile->napi);
-		local_bh_enable();
+		if (likely(napi_schedule_prep(&tfile->napi))) {
+			local_bh_disable();
+			napi_gro_frags(&tfile->napi);
+			napi_complete(&tfile->napi);
+			local_bh_enable();
+		} else {
+			err = -EBUSY;
+			goto napi_busy;
+		}
 		mutex_unlock(&tfile->napi_mutex);
 	} else if (tfile->napi_enabled) {
 		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
-- 
2.35.1



