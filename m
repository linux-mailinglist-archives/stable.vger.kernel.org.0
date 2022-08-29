Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881965A4AA4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiH2LpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbiH2Loc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9C479687;
        Mon, 29 Aug 2022 04:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27665611D9;
        Mon, 29 Aug 2022 11:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325FDC433C1;
        Mon, 29 Aug 2022 11:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771317;
        bh=0JJ46n42IKtZtpDM8UAUIp2F+fChe3VehSJ/hE/cZQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TywVb7igP3y4Sy+p4zR1su8ggwTDFQw/W1bPPZenmNtQBPTYaySWaGT+3RTaRn1bW
         qB5tAkEbhTspp2RDqnwBvlwvMhci3YktIXUQx3ln1QMrC3v2mDsNVL5H2tW96pkt4M
         fHUuG7baZRX8jWzPcfgVnjDj7X1sG5fyX8DXhkTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 016/158] xfrm: policy: fix metadata dst->dev xmit null pointer dereference
Date:   Mon, 29 Aug 2022 12:57:46 +0200
Message-Id: <20220829105809.497862509@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 17ecd4a4db4783392edd4944f5e8268205083f70 ]

When we try to transmit an skb with metadata_dst attached (i.e. dst->dev
== NULL) through xfrm interface we can hit a null pointer dereference[1]
in xfrmi_xmit2() -> xfrm_lookup_with_ifid() due to the check for a
loopback skb device when there's no policy which dereferences dst->dev
unconditionally. Not having dst->dev can be interepreted as it not being
a loopback device, so just add a check for a null dst_orig->dev.

With this fix xfrm interface's Tx error counters go up as usual.

[1] net-next calltrace captured via netconsole:
  BUG: kernel NULL pointer dereference, address: 00000000000000c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP
  CPU: 1 PID: 7231 Comm: ping Kdump: loaded Not tainted 5.19.0+ #24
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
  RIP: 0010:xfrm_lookup_with_ifid+0x5eb/0xa60
  Code: 8d 74 24 38 e8 26 a4 37 00 48 89 c1 e9 12 fc ff ff 49 63 ed 41 83 fd be 0f 85 be 01 00 00 41 be ff ff ff ff 45 31 ed 48 8b 03 <f6> 80 c0 00 00 00 08 75 0f 41 80 bc 24 19 0d 00 00 01 0f 84 1e 02
  RSP: 0018:ffffb0db82c679f0 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffffd0db7fcad430 RCX: ffffb0db82c67a10
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb0db82c67a80
  RBP: ffffb0db82c67a80 R08: ffffb0db82c67a14 R09: 0000000000000000
  R10: 0000000000000000 R11: ffff8fa449667dc8 R12: ffffffff966db880
  R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
  FS:  00007ff35c83f000(0000) GS:ffff8fa478480000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000c0 CR3: 000000001ebb7000 CR4: 0000000000350ee0
  Call Trace:
   <TASK>
   xfrmi_xmit+0xde/0x460
   ? tcf_bpf_act+0x13d/0x2a0
   dev_hard_start_xmit+0x72/0x1e0
   __dev_queue_xmit+0x251/0xd30
   ip_finish_output2+0x140/0x550
   ip_push_pending_frames+0x56/0x80
   raw_sendmsg+0x663/0x10a0
   ? try_charge_memcg+0x3fd/0x7a0
   ? __mod_memcg_lruvec_state+0x93/0x110
   ? sock_sendmsg+0x30/0x40
   sock_sendmsg+0x30/0x40
   __sys_sendto+0xeb/0x130
   ? handle_mm_fault+0xae/0x280
   ? do_user_addr_fault+0x1e7/0x680
   ? kvm_read_and_reset_apf_flags+0x3b/0x50
   __x64_sys_sendto+0x20/0x30
   do_syscall_64+0x34/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  RIP: 0033:0x7ff35cac1366
  Code: eb 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 55 48 83 ec 30 44 89 4c 24 2c 4c 89
  RSP: 002b:00007fff738e4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00007fff738e57b0 RCX: 00007ff35cac1366
  RDX: 0000000000000040 RSI: 0000557164e4b450 RDI: 0000000000000003
  RBP: 0000557164e4b450 R08: 00007fff738e7a2c R09: 0000000000000010
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
  R13: 00007fff738e5770 R14: 00007fff738e4030 R15: 0000001d00000001
   </TASK>
  Modules linked in: netconsole veth br_netfilter bridge bonding virtio_net [last unloaded: netconsole]
  CR2: 00000000000000c0

CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4f8bbb825abcb..cc6ab79609e29 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3162,7 +3162,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 	return dst;
 
 nopol:
-	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
+	if ((!dst_orig->dev || !(dst_orig->dev->flags & IFF_LOOPBACK)) &&
 	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
-- 
2.35.1



