Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D5736446F
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhDSN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241591AbhDSN0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C98613EA;
        Mon, 19 Apr 2021 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838478;
        bh=2B1jNMZRBIspioCBuupPZPsxhTTj13ZGj5FxM4gSjF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QT4nu6txxNNq8EL26RNqUIrJOif1UZhrH6/RtAWPgselJBsNmTvbVYQS8XWfL7wd4
         LwhzORfuiLFn/XUdmzhPIisxS/4SXy1XFqH59zEq9RA8A6siULnTmKygSgnaANyUXR
         khnrywftdxs/jxhTpSGglhf0RgFni+r3lCyK0T5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 63/73] gro: ensure frag0 meets IP header alignment
Date:   Mon, 19 Apr 2021 15:06:54 +0200
Message-Id: <20210419130525.870105431@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 38ec4944b593fd90c5ef42aaaa53e66ae5769d04 upstream.

After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Guenter Roeck reported one failure in his tests using sh architecture.

After much debugging, we have been able to spot silent unaligned accesses
in inet_gro_receive()

The issue at hand is that upper networking stacks assume their header
is word-aligned. Low level drivers are supposed to reserve NET_IP_ALIGN
bytes before the Ethernet header to make that happen.

This patch hardens skb_gro_reset_offset() to not allow frag0 fast-path
if the fragment is not properly aligned.

Some arches like x86, arm64 and powerpc do not care and define NET_IP_ALIGN
as 0, this extra check will be a NOP for them.

Note that if frag0 is not used, GRO will call pskb_may_pull()
as many times as needed to pull network and transport headers.

Fixes: 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Fixes: 78a478d0efd9 ("gro: Inline skb_gro_header and cache frag0 virtual address")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5406,7 +5406,8 @@ static void skb_gro_reset_offset(struct
 
 	if (skb_mac_header(skb) == skb_tail_pointer(skb) &&
 	    pinfo->nr_frags &&
-	    !PageHighMem(skb_frag_page(frag0))) {
+	    !PageHighMem(skb_frag_page(frag0)) &&
+	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
 						    skb_frag_size(frag0),


