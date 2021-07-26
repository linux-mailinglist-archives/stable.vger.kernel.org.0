Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CD3D6065
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhGZPWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237269AbhGZPWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 665AE60F5A;
        Mon, 26 Jul 2021 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315357;
        bh=DZtjGGNtt29N0t0MOvqpwQD/LJPMtuoT1jY/0WVijak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrUcH9ZIR9j+LwUao2Yj+ZM34HSC7tsij77CFBdDEPrFyEY3a+XvK0FDhrWUnhidL
         mFy49GJ/4fJURd+CVTo1FNxlsWPbkmZ/3+S4igkkT2OQK/vxCZM/AbE5opSaInqgTn
         oERh7S9RgfiBsxADcFC+3+qxMlSuPS1ykaTY7EBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/167] bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats
Date:   Mon, 26 Jul 2021 17:38:16 +0200
Message-Id: <20210726153841.512988993@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 54ea2f49fd9400dd698c25450be3352b5613b3b4 ]

The proc socket stats use sk_prot->inuse_idx value to record inuse sock
stats. We currently do not set this correctly from sockmap side. The
result is reading sock stats '/proc/net/sockstat' gives incorrect values.
The socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

To get the correct inuse_idx value move the core_initcall that initializes
the UDP proto handlers to late_initcall. This way it is initialized after
UDP has the chance to assign the inuse_idx value from the register protocol
handler.

Fixes: edc6741cc660 ("bpf: Add sockmap hooks for UDP sockets")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20210714154750.528206-1-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 7a94791efc1a..69c9663f9ee7 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -39,7 +39,7 @@ static int __init udp_bpf_v4_build_proto(void)
 	udp_bpf_rebuild_protos(&udp_bpf_prots[UDP_BPF_IPV4], &udp_prot);
 	return 0;
 }
-core_initcall(udp_bpf_v4_build_proto);
+late_initcall(udp_bpf_v4_build_proto);
 
 struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
 {
-- 
2.30.2



