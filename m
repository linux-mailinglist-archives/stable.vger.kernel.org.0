Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F66433BA63
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhCOOJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhCOOD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC4264EF9;
        Mon, 15 Mar 2021 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817008;
        bh=pTG3Z6rK5ZitXlHEQVGe3NxxqXCpy4yN/VknZ6bwVPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEYoWASxjvcMpO+CbDt2qPJD17WaWKpJSV0ryrFeSerdgV8olONqmVlwwkI73lKyg
         +a+bW4Dx8tHip6t8NRRtCQAXCBZ45kgDnYK8EeHxHn7jjYN61vgbKhpGYrEBDLGgXU
         NlNx7CN+v5sv+lX1cFE3ABrd120+MP9ORoR1I1qE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Karas <bugs-a17@moonlit-rail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 257/306] net: expand textsearch ts_state to fit skb_seq_state
Date:   Mon, 15 Mar 2021 14:55:20 +0100
Message-Id: <20210315135516.336444112@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b228c9b058760500fda5edb3134527f629fc2dc3 ]

The referenced commit expands the skb_seq_state used by
skb_find_text with a 4B frag_off field, growing it to 48B.

This exceeds container ts_state->cb, causing a stack corruption:

[   73.238353] Kernel panic - not syncing: stack-protector: Kernel stack
is corrupted in: skb_find_text+0xc5/0xd0
[   73.247384] CPU: 1 PID: 376 Comm: nping Not tainted 5.11.0+ #4
[   73.252613] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.14.0-2 04/01/2014
[   73.260078] Call Trace:
[   73.264677]  dump_stack+0x57/0x6a
[   73.267866]  panic+0xf6/0x2b7
[   73.270578]  ? skb_find_text+0xc5/0xd0
[   73.273964]  __stack_chk_fail+0x10/0x10
[   73.277491]  skb_find_text+0xc5/0xd0
[   73.280727]  string_mt+0x1f/0x30
[   73.283639]  ipt_do_table+0x214/0x410

The struct is passed between skb_find_text and its callbacks
skb_prepare_seq_read, skb_seq_read and skb_abort_seq read through
the textsearch interface using TS_SKB_CB.

I assumed that this mapped to skb->cb like other .._SKB_CB wrappers.
skb->cb is 48B. But it maps to ts_state->cb, which is only 40B.

skb->cb was increased from 40B to 48B after ts_state was introduced,
in commit 3e3850e989c5 ("[NETFILTER]: Fix xfrm lookup in
ip_route_me_harder/ip6_route_me_harder").

Increase ts_state.cb[] to 48 to fit the struct.

Also add a BUILD_BUG_ON to avoid a repeat.

The alternative is to directly add a dependency from textsearch onto
linux/skbuff.h, but I think the intent is textsearch to have no such
dependencies on its callers.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=211911
Fixes: 97550f6fa592 ("net: compound page support in skb_seq_read")
Reported-by: Kris Karas <bugs-a17@moonlit-rail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/textsearch.h | 2 +-
 net/core/skbuff.c          | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/textsearch.h b/include/linux/textsearch.h
index 13770cfe33ad..6673e4d4ac2e 100644
--- a/include/linux/textsearch.h
+++ b/include/linux/textsearch.h
@@ -23,7 +23,7 @@ struct ts_config;
 struct ts_state
 {
 	unsigned int		offset;
-	char			cb[40];
+	char			cb[48];
 };
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 28b8242f18d7..2b784d62a9fe 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3622,6 +3622,8 @@ unsigned int skb_find_text(struct sk_buff *skb, unsigned int from,
 	struct ts_state state;
 	unsigned int ret;
 
+	BUILD_BUG_ON(sizeof(struct skb_seq_state) > sizeof(state.cb));
+
 	config->get_next_block = skb_ts_get_next_block;
 	config->finish = skb_ts_finish;
 
-- 
2.30.1



