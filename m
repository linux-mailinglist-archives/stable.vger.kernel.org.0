Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4966354A9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiKWJKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236913AbiKWJKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE34209
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20189B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50823C433C1;
        Wed, 23 Nov 2022 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194617;
        bh=36C+gVogxR2GlRPSxMvvXAApCHvSmIi/5WF++fmZTRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTvgfLjYi72lRvm2p/Ufyg6fDps3fW1QF0FBzXztsjab1j2IhO/D+rxArSMmMW3F9
         JHz428TokayShCBppO/VMv9zXc4rpX8ZWK5Rs+6r/50tmyoztKqbM4RVN238BqL/Um
         wqvWZteEHnOGU+UFdbuGcbB7wXFlNSR1C1/6mcHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/156] bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()
Date:   Wed, 23 Nov 2022 09:49:31 +0100
Message-Id: <20221123084558.395674277@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 6d81ea3765dfa6c8a20822613c81edad1c4a16a0 ]

During the error recovery sequence, the rtnl_lock is not held for the
entire duration and some datastructures may be freed during the sequence.
Check for the BNXT_STATE_OPEN flag instead of netif_running() to ensure
that the device is fully operational before proceeding to reconfigure
the coalescing settings.

This will fix a possible crash like this:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 10 PID: 181276 Comm: ethtool Kdump: loaded Tainted: G          IOE    --------- -  - 4.18.0-348.el8.x86_64 #1
Hardware name: Dell Inc. PowerEdge R740/0F9N89, BIOS 2.3.10 08/15/2019
RIP: 0010:bnxt_hwrm_set_coal+0x1fb/0x2a0 [bnxt_en]
Code: c2 66 83 4e 22 08 66 89 46 1c e8 10 cb 00 00 41 83 c6 01 44 39 b3 68 01 00 00 0f 8e a3 00 00 00 48 8b 93 c8 00 00 00 49 63 c6 <48> 8b 2c c2 48 8b 85 b8 02 00 00 48 85 c0 74 2e 48 8b 74 24 08 f6
RSP: 0018:ffffb11c8dcaba50 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8d168a8b0ac0 RCX: 00000000000000c5
RDX: 0000000000000000 RSI: ffff8d162f72c000 RDI: ffff8d168a8b0b28
RBP: 0000000000000000 R08: b6e1f68a12e9a7eb R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000037 R12: ffff8d168a8b109c
R13: ffff8d168a8b10aa R14: 0000000000000000 R15: ffffffffc01ac4e0
FS:  00007f3852e4c740(0000) GS:ffff8d24c0080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000041b3ee003 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ethnl_set_coalesce+0x3ce/0x4c0
 genl_family_rcv_msg_doit.isra.15+0x10f/0x150
 genl_family_rcv_msg+0xb3/0x160
 ? coalesce_fill_reply+0x480/0x480
 genl_rcv_msg+0x47/0x90
 ? genl_family_rcv_msg+0x160/0x160
 netlink_rcv_skb+0x4c/0x120
 genl_rcv+0x24/0x40
 netlink_unicast+0x196/0x230
 netlink_sendmsg+0x204/0x3d0
 sock_sendmsg+0x4c/0x50
 __sys_sendto+0xee/0x160
 ? syscall_trace_enter+0x1d3/0x2c0
 ? __audit_syscall_exit+0x249/0x2a0
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x5b/0x1a0
 entry_SYSCALL_64_after_hwframe+0x65/0xca
RIP: 0033:0x7f38524163bb

Fixes: 2151fe0830fd ("bnxt_en: Handle RESET_NOTIFY async event from firmware.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index d74c6a34b936..24282a426481 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -124,7 +124,7 @@ static int bnxt_set_coalesce(struct net_device *dev,
 	}
 
 reset_coalesce:
-	if (netif_running(dev)) {
+	if (test_bit(BNXT_STATE_OPEN, &bp->state)) {
 		if (update_stats) {
 			rc = bnxt_close_nic(bp, true, false);
 			if (!rc)
-- 
2.35.1



