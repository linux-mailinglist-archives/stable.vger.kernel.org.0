Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EABF6432E0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiLETbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiLETbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:31:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C6CE037
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A9A961314
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8CEC433D7;
        Mon,  5 Dec 2022 19:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268404;
        bh=rFGEtCVS/LQTexZNB+ul0q2QkPV5NYH2AGRZbINoV84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpVcIWVmcxFehLEisaohrNepMFiG6pXrmDjEH30+kWtHNbncVt/obQTsMUsSKcHV6
         dhtHNgoyTivH84NsyrMytsYtg8oSiMNpSUsNOeLWRYtKdnxfY3iHm0BF63K3AnTygs
         5O2/lWLCTtLqAibcVApGP3cRtqjm3W6ywa9WAZas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 062/124] tipc: re-fetch skb cb after tipc_msg_validate
Date:   Mon,  5 Dec 2022 20:09:28 +0100
Message-Id: <20221205190810.182667063@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 3067bc61fcfe3081bf4807ce65560f499e895e77 ]

As the call trace shows, the original skb was freed in tipc_msg_validate(),
and dereferencing the old skb cb would cause an use-after-free crash.

  BUG: KASAN: use-after-free in tipc_crypto_rcv_complete+0x1835/0x2240 [tipc]
  Call Trace:
   <IRQ>
   tipc_crypto_rcv_complete+0x1835/0x2240 [tipc]
   tipc_crypto_rcv+0xd32/0x1ec0 [tipc]
   tipc_rcv+0x744/0x1150 [tipc]
  ...
  Allocated by task 47078:
   kmem_cache_alloc_node+0x158/0x4d0
   __alloc_skb+0x1c1/0x270
   tipc_buf_acquire+0x1e/0xe0 [tipc]
   tipc_msg_create+0x33/0x1c0 [tipc]
   tipc_link_build_proto_msg+0x38a/0x2100 [tipc]
   tipc_link_timeout+0x8b8/0xef0 [tipc]
   tipc_node_timeout+0x2a1/0x960 [tipc]
   call_timer_fn+0x2d/0x1c0
  ...
  Freed by task 47078:
   tipc_msg_validate+0x7b/0x440 [tipc]
   tipc_crypto_rcv_complete+0x4b5/0x2240 [tipc]
   tipc_crypto_rcv+0xd32/0x1ec0 [tipc]
   tipc_rcv+0x744/0x1150 [tipc]

This patch fixes it by re-fetching the skb cb from the new allocated skb
after calling tipc_msg_validate().

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/1b1cdba762915325bd8ef9a98d0276eb673df2a5.1669398403.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index f09316a9035f..d67440de011e 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1971,6 +1971,9 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	/* Ok, everything's fine, try to synch own keys according to peers' */
 	tipc_crypto_key_synch(rx, *skb);
 
+	/* Re-fetch skb cb as skb might be changed in tipc_msg_validate */
+	skb_cb = TIPC_SKB_CB(*skb);
+
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
 
-- 
2.35.1



