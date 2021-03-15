Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A13133B65C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhCON5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231781AbhCON5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88A1F64F44;
        Mon, 15 Mar 2021 13:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816631;
        bh=jSKspWM7EfzKqcDjD2f4ifI8H3zPgj3EYllVYCjybuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9fO/iQqvEWiUxT7WRF3zjovtpqTJM4kONamUMjCZu2V7s246NLGmS0tLQuUFNv4S
         SeYCzPftNaFc4uO+C2JSMNTLxUXxHvM5VOWGKKia9iwa06ndDrpVY7tEqSH6gDVWbG
         +O2/6wd3Bc9LGxFER0jkZttfcChHVSbRG8ZD/9gw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        William Tu <u9012063@gmail.com>
Subject: [PATCH 5.10 023/290] selftests/bpf: No need to drop the packet when there is no geneve opt
Date:   Mon, 15 Mar 2021 14:51:56 +0100
Message-Id: <20210315135542.714939400@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hangbin Liu <liuhangbin@gmail.com>

commit 557c223b643a35effec9654958d8edc62fd2603a upstream.

In bpf geneve tunnel test we set geneve option on tx side. On rx side we
only call bpf_skb_get_tunnel_opt(). Since commit 9c2e14b48119 ("ip_tunnels:
Set tunnel option flag when tunnel metadata is present") geneve_rx() will
not add TUNNEL_GENEVE_OPT flag if there is no geneve option, which cause
bpf_skb_get_tunnel_opt() return ENOENT and _geneve_get_tunnel() in
test_tunnel_kern.c drop the packet.

As it should be valid that bpf_skb_get_tunnel_opt() return error when
there is not tunnel option, there is no need to drop the packet and
break all geneve rx traffic. Just set opt_class to 0 in this test and
keep returning TC_ACT_OK.

Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: William Tu <u9012063@gmail.com>
Link: https://lore.kernel.org/bpf/20210224081403.1425474-1-liuhangbin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -446,10 +446,8 @@ int _geneve_get_tunnel(struct __sk_buff
 	}
 
 	ret = bpf_skb_get_tunnel_opt(skb, &gopt, sizeof(gopt));
-	if (ret < 0) {
-		ERROR(ret);
-		return TC_ACT_SHOT;
-	}
+	if (ret < 0)
+		gopt.opt_class = 0;
 
 	bpf_trace_printk(fmt, sizeof(fmt),
 			key.tunnel_id, key.remote_ipv4, gopt.opt_class);


