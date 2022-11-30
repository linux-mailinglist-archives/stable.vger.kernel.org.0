Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2963DFA4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiK3StV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiK3StE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB084326D3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17DD461D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B24C433C1;
        Wed, 30 Nov 2022 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834139;
        bh=W//OmPfWRKXAljE4o/NC2tKrnsZmXO+aVCDxGZET3oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHgu/Xdn/yN0dJSvpUB2mlFaXgycLTMUOaA5e3aEl3FLJFNEnru7f6WprvFjtqCDM
         xjOxy12xjhpLVec3/85Jecf3BEMICpwXw0MbEFwFjtFRIUoFIA8wSYi15yDL8vfoTf
         9mKGrsqdPaF4a3ljZJ8MIc8Ftvk9mlozrB0j+Imc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roth Mark <rothm@mail.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/289] xfrm: Fix oops in __xfrm_state_delete()
Date:   Wed, 30 Nov 2022 19:21:42 +0100
Message-Id: <20221130180546.791932880@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

[ Upstream commit b97df039a68b2f3e848e238df5d5d06343ea497b ]

Kernel 5.14 added a new "byseq" index to speed
up xfrm_state lookups by sequence number in commit
fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")

While the patch was thorough, the function pfkey_send_new_mapping()
in net/af_key.c also modifies x->km.seq and never added
the current xfrm_state to the "byseq" index.

This leads to the following kernel Ooops:
    BUG: kernel NULL pointer dereference, address: 0000000000000000
    ..
    RIP: 0010:__xfrm_state_delete+0xc9/0x1c0
    ..
    Call Trace:
    <TASK>
    xfrm_state_delete+0x1e/0x40
    xfrm_del_sa+0xb0/0x110 [xfrm_user]
    xfrm_user_rcv_msg+0x12d/0x270 [xfrm_user]
    ? remove_entity_load_avg+0x8a/0xa0
    ? copy_to_user_state_extra+0x580/0x580 [xfrm_user]
    netlink_rcv_skb+0x51/0x100
    xfrm_netlink_rcv+0x30/0x50 [xfrm_user]
    netlink_unicast+0x1a6/0x270
    netlink_sendmsg+0x22a/0x480
    __sys_sendto+0x1a6/0x1c0
    ? __audit_syscall_entry+0xd8/0x130
    ? __audit_syscall_exit+0x249/0x2b0
    __x64_sys_sendto+0x23/0x30
    do_syscall_64+0x3a/0x90
    entry_SYSCALL_64_after_hwframe+0x61/0xcb

Exact location of the crash in __xfrm_state_delete():
    if (x->km.seq)
        hlist_del_rcu(&x->byseq);

The hlist_node "byseq" was never populated.

The bug only triggers if a new NAT traversal mapping (changed IP or port)
is detected in esp_input_done2() / esp6_input_done2(), which in turn
indirectly calls pfkey_send_new_mapping() *if* the kernel is compiled
with CONFIG_NET_KEY and "af_key" is active.

The PF_KEYv2 message SADB_X_NAT_T_NEW_MAPPING is not part of RFC 2367.
Various implementations have been examined how they handle
the "sadb_msg_seq" header field:

- racoon (Android): does not process SADB_X_NAT_T_NEW_MAPPING
- strongswan: does not care about sadb_msg_seq
- openswan: does not care about sadb_msg_seq

There is no standard how PF_KEYv2 sadb_msg_seq should be populated
for SADB_X_NAT_T_NEW_MAPPING and it's not used in popular
implementations either. Herbert Xu suggested we should just
use the current km.seq value as is. This fixes the root cause
of the oops since we no longer modify km.seq itself.

The update of "km.seq" looks like a copy'n'paste error
from pfkey_send_acquire(). SADB_ACQUIRE must indeed assign a unique km.seq
number according to RFC 2367. It has been verified that code paths
involving pfkey_send_acquire() don't cause the same Oops.

PF_KEYv2 SADB_X_NAT_T_NEW_MAPPING support was originally added here:
    https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

    commit cbc3488685b20e7b2a98ad387a1a816aada569d8
    Author:     Derek Atkins <derek@ihtfp.com>
    AuthorDate: Wed Apr 2 13:21:02 2003 -0800

        [IPSEC]: Implement UDP Encapsulation framework.

        In particular, implement ESPinUDP encapsulation for IPsec
        Nat Traversal.

A note on triggering the bug: I was not able to trigger it using VMs.
There is one VPN using a high latency link on our production VPN server
that triggered it like once a day though.

Link: https://github.com/strongswan/strongswan/issues/992
Link: https://lore.kernel.org/netdev/00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com/T/
Link: https://lore.kernel.org/netdev/20221027142455.3975224-1-chenzhihao@meizu.com/T/

Fixes: fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")
Reported-by: Roth Mark <rothm@mail.com>
Reported-by: Zhihao Chen <chenzhihao@meizu.com>
Tested-by: Roth Mark <rothm@mail.com>
Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Acked-by: Antony Antony <antony.antony@secunet.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 213287814328..95edcbedf6ef 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3394,7 +3394,7 @@ static int pfkey_send_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
 	hdr->sadb_msg_len = size / sizeof(uint64_t);
 	hdr->sadb_msg_errno = 0;
 	hdr->sadb_msg_reserved = 0;
-	hdr->sadb_msg_seq = x->km.seq = get_acqseq();
+	hdr->sadb_msg_seq = x->km.seq;
 	hdr->sadb_msg_pid = 0;
 
 	/* SA */
-- 
2.35.1



