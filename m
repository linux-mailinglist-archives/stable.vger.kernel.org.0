Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4380D6433AD
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiLETih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiLETiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:38:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565D52708
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0075DB811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD09C433C1;
        Mon,  5 Dec 2022 19:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268908;
        bh=NWuLVmMsGZPO+wLbCrn+xo87uQhIInyOFWyLH0tu6ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDhgBqFPbFfbl6MMiJhlL7o7G4Us2Zr13YK2WSLr3TMTex3zT9g2kBePSwR0XO5/p
         ylXhhDiDL91gRcemLdhvBGCVu0Tuho9Nu9JlmwOjHFd3ISGPmt+lVtFmwxfiAeXaxS
         CA7G9PnMnoRo9FEWJZ2vOu19QJ0d8Thp6bI9wJ/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/120] tipc: re-fetch skb cb after tipc_msg_validate
Date:   Mon,  5 Dec 2022 20:09:56 +0100
Message-Id: <20221205190808.308354242@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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
index b5074957e881..4243d2ab8adf 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1982,6 +1982,9 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	/* Ok, everything's fine, try to synch own keys according to peers' */
 	tipc_crypto_key_synch(rx, *skb);
 
+	/* Re-fetch skb cb as skb might be changed in tipc_msg_validate */
+	skb_cb = TIPC_SKB_CB(*skb);
+
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
 
-- 
2.35.1



