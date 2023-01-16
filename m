Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B0F66C985
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbjAPQut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbjAPQuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9CE43471
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 598E7B81094
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6942C433EF;
        Mon, 16 Jan 2023 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886995;
        bh=ELLYvq22cr0MtwuauAUhggt7fDKjx2Gu/0IsNWXibLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJFyQQOSBDkLbIgrjxWRg8DFSDYrnzZOzIGlBWl1OIdW3wzqIDxmlEBhnOGLW5UlC
         7Fvg7KmYfmav5PMTbI4Vbr8EsSJAHnFFuSDwD/dgDTPOX7M7FUxqnVCQy2p8T9TRJu
         f+gtssxHpzflW+/Vfna+u0U9Dcw3cCVlDAJcl6sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 639/658] net/sched: act_mpls: Fix warning during failed attribute validation
Date:   Mon, 16 Jan 2023 16:52:07 +0100
Message-Id: <20230116154938.737621418@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 9e17f99220d111ea031b44153fdfe364b0024ff2 ]

The 'TCA_MPLS_LABEL' attribute is of 'NLA_U32' type, but has a
validation type of 'NLA_VALIDATE_FUNCTION'. This is an invalid
combination according to the comment above 'struct nla_policy':

"
Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
   NLA_BINARY           Validation function called for the attribute.
   All other            Unused - but note that it's a union
"

This can trigger the warning [1] in nla_get_range_unsigned() when
validation of the attribute fails. Despite being of 'NLA_U32' type, the
associated 'min'/'max' fields in the policy are negative as they are
aliased by the 'validate' field.

Fix by changing the attribute type to 'NLA_BINARY' which is consistent
with the above comment and all other users of NLA_POLICY_VALIDATE_FN().
As a result, move the length validation to the validation function.

No regressions in MPLS tests:

 # ./tdc.py -f tc-tests/actions/mpls.json
 [...]
 # echo $?
 0

[1]
WARNING: CPU: 0 PID: 17743 at lib/nlattr.c:118
nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
Modules linked in:
CPU: 0 PID: 17743 Comm: syz-executor.0 Not tainted 6.1.0-rc8 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
[...]
Call Trace:
 <TASK>
 __netlink_policy_dump_write_attr+0x23d/0x990 net/netlink/policy.c:310
 netlink_policy_dump_write_attr+0x22/0x30 net/netlink/policy.c:411
 netlink_ack_tlv_fill net/netlink/af_netlink.c:2454 [inline]
 netlink_ack+0x546/0x760 net/netlink/af_netlink.c:2506
 netlink_rcv_skb+0x1b7/0x240 net/netlink/af_netlink.c:2546
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6109
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x38f/0x500 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x197/0x230 net/socket.c:2565
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lore.kernel.org/netdev/CAO4mrfdmjvRUNbDyP0R03_DrD_eFCLCguz6OxZ2TYRSv0K9gxA@mail.gmail.com/
Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Tested-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230107171004.608436-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mpls.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 0fccae356dc1..197915332b42 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -116,6 +116,11 @@ static int valid_label(const struct nlattr *attr,
 {
 	const u32 *label = nla_data(attr);
 
+	if (nla_len(attr) != sizeof(*label)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MPLS label length");
+		return -EINVAL;
+	}
+
 	if (*label & ~MPLS_LABEL_MASK || *label == MPLS_LABEL_IMPLNULL) {
 		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
 		return -EINVAL;
@@ -128,7 +133,8 @@ static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
 	[TCA_MPLS_UNSPEC]	= { .strict_start_type = TCA_MPLS_UNSPEC + 1 },
 	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
 	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
-	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
+	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+							 valid_label),
 	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
 	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
 	[TCA_MPLS_BOS]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),
-- 
2.35.1



