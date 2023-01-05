Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6639465EBDA
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbjAENDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbjAENDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90585C1D5
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 604AA619F3
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F235C433EF;
        Thu,  5 Jan 2023 13:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923783;
        bh=AjZddvwv/iNSGb2P9PiFp0LlR5ZkuxJ48rbWw4i8HMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV3lfvF4uAX+STwy8/RniL2hyf2UJeKOkn1g31kFWg4WK//lGJDGFkY+/pCdxvSJW
         hjJxYgnaeWHTijBp0Qcex4FrOUN15rkeBTyrGSf509pgdPjCH2dZqxV9nPNB/B77eN
         fgRv5Z81j+EPSf+4+wFqy6vg6/q6Ue9bTRi/cAbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianlin Shi <jishi@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 101/251] net/tunnel: wait until all sk_user_data reader finish before releasing the sock
Date:   Thu,  5 Jan 2023 13:53:58 +0100
Message-Id: <20230105125339.445804110@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3cf7203ca620682165706f70a1b12b5194607dce ]

There is a race condition in vxlan that when deleting a vxlan device
during receiving packets, there is a possibility that the sock is
released after getting vxlan_sock vs from sk_user_data. Then in
later vxlan_ecn_decapsulate(), vxlan_get_sk_family() we will got
NULL pointer dereference. e.g.

   #0 [ffffa25ec6978a38] machine_kexec at ffffffff8c669757
   #1 [ffffa25ec6978a90] __crash_kexec at ffffffff8c7c0a4d
   #2 [ffffa25ec6978b58] crash_kexec at ffffffff8c7c1c48
   #3 [ffffa25ec6978b60] oops_end at ffffffff8c627f2b
   #4 [ffffa25ec6978b80] page_fault_oops at ffffffff8c678fcb
   #5 [ffffa25ec6978bd8] exc_page_fault at ffffffff8d109542
   #6 [ffffa25ec6978c00] asm_exc_page_fault at ffffffff8d200b62
      [exception RIP: vxlan_ecn_decapsulate+0x3b]
      RIP: ffffffffc1014e7b  RSP: ffffa25ec6978cb0  RFLAGS: 00010246
      RAX: 0000000000000008  RBX: ffff8aa000888000  RCX: 0000000000000000
      RDX: 000000000000000e  RSI: ffff8a9fc7ab803e  RDI: ffff8a9fd1168700
      RBP: ffff8a9fc7ab803e   R8: 0000000000700000   R9: 00000000000010ae
      R10: ffff8a9fcb748980  R11: 0000000000000000  R12: ffff8a9fd1168700
      R13: ffff8aa000888000  R14: 00000000002a0000  R15: 00000000000010ae
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #7 [ffffa25ec6978ce8] vxlan_rcv at ffffffffc10189cd [vxlan]
   #8 [ffffa25ec6978d90] udp_queue_rcv_one_skb at ffffffff8cfb6507
   #9 [ffffa25ec6978dc0] udp_unicast_rcv_skb at ffffffff8cfb6e45
  #10 [ffffa25ec6978dc8] __udp4_lib_rcv at ffffffff8cfb8807
  #11 [ffffa25ec6978e20] ip_protocol_deliver_rcu at ffffffff8cf76951
  #12 [ffffa25ec6978e48] ip_local_deliver at ffffffff8cf76bde
  #13 [ffffa25ec6978ea0] __netif_receive_skb_one_core at ffffffff8cecde9b
  #14 [ffffa25ec6978ec8] process_backlog at ffffffff8cece139
  #15 [ffffa25ec6978f00] __napi_poll at ffffffff8ceced1a
  #16 [ffffa25ec6978f28] net_rx_action at ffffffff8cecf1f3
  #17 [ffffa25ec6978fa0] __softirqentry_text_start at ffffffff8d4000ca
  #18 [ffffa25ec6978ff0] do_softirq at ffffffff8c6fbdc3

Reproducer: https://github.com/Mellanox/ovs-tests/blob/master/test-ovs-vxlan-remove-tunnel-during-traffic.sh

Fix this by waiting for all sk_user_data reader to finish before
releasing the sock.

Reported-by: Jianlin Shi <jishi@redhat.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: 6a93cc905274 ("udp-tunnel: Add a few more UDP tunnel APIs")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udp_tunnel.c b/net/ipv4/udp_tunnel.c
index 58bd39fb14b4..1f530a9b0357 100644
--- a/net/ipv4/udp_tunnel.c
+++ b/net/ipv4/udp_tunnel.c
@@ -163,6 +163,7 @@ EXPORT_SYMBOL_GPL(udp_tunnel_xmit_skb);
 void udp_tunnel_sock_release(struct socket *sock)
 {
 	rcu_assign_sk_user_data(sock->sk, NULL);
+	synchronize_rcu();
 	kernel_sock_shutdown(sock, SHUT_RDWR);
 	sock_release(sock);
 }
-- 
2.35.1



