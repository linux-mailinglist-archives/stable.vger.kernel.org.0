Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133085316E6
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbiEWRNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240396AbiEWRML (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:12:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDF6506EF;
        Mon, 23 May 2022 10:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92458B8120F;
        Mon, 23 May 2022 17:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EDFC385A9;
        Mon, 23 May 2022 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325822;
        bh=x4AGqORDs/MFJIWyP9gd2UI+ou7Vb+JfsBNrRNV4Wzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WVI80bFZ89xlN2TEXMvW/gXYgVoliCirEp4KCVpzbVoEHWHpyMXjZIAmTcFTzT53
         8QPygO5PbCW1pmieLXEn8mt1SOXlDrZte+6kfJ9vdYZuqQvS3cjN5y2rfre0d4bCPL
         Lcq0EU2iJPKJoAFXp2wASheZuBb8IBIigntnUqQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com
Subject: [PATCH 4.19 22/44] net/sched: act_pedit: sanitize shift argument before usage
Date:   Mon, 23 May 2022 19:05:06 +0200
Message-Id: <20220523165757.196133082@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 4d42d54a7d6aa6d29221d3fd4f2ae9503e94f011 ]

syzbot was able to trigger an Out-of-Bound on the pedit action:

UBSAN: shift-out-of-bounds in net/sched/act_pedit.c:238:43
shift exponent 1400735974 is too large for 32-bit type 'unsigned int'
CPU: 0 PID: 3606 Comm: syz-executor151 Not tainted 5.18.0-rc5-syzkaller-00165-g810c2f0a3f86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x50 lib/ubsan.c:151
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x187 lib/ubsan.c:322
 tcf_pedit_init.cold+0x1a/0x1f net/sched/act_pedit.c:238
 tcf_action_init_1+0x414/0x690 net/sched/act_api.c:1367
 tcf_action_init+0x530/0x8d0 net/sched/act_api.c:1432
 tcf_action_add+0xf9/0x480 net/sched/act_api.c:1956
 tc_ctl_action+0x346/0x470 net/sched/act_api.c:2015
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5993
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe36e9e1b59
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef796fe88 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe36e9e1b59
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00007fe36e9a5d00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe36e9a5d90
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

The 'shift' field is not validated, and any value above 31 will
trigger out-of-bounds. The issue predates the git history, but
syzbot was able to trigger it only after the commit mentioned in
the fixes tag, and this change only applies on top of such commit.

Address the issue bounding the 'shift' value to the maximum allowed
by the relevant operator.

Reported-and-tested-by: syzbot+8ed8fc4c57e9dcf23ca6@syzkaller.appspotmail.com
Fixes: 8b796475fd78 ("net/sched: act_pedit: really ensure the skb is writable")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index fec0f7fdb015..aeb8f84cbd9e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -225,6 +225,10 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	for (i = 0; i < p->tcfp_nkeys; ++i) {
 		u32 cur = p->tcfp_keys[i].off;
 
+		/* sanitize the shift value for any later use */
+		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
+					      p->tcfp_keys[i].shift);
+
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
-- 
2.35.1



