Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925483D5F45
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhGZPRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237461AbhGZPPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43E0F60FA0;
        Mon, 26 Jul 2021 15:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314972;
        bh=ykBmaihdzcKrVAtunhV0Q2SmtFMw9ytREoNZZNF6fMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeeCdo4EUtZMrduE7xL3JvnQe3Non06TfOKDh8nQ8e8sZ+68Jbzrf8117gXYeVphj
         jlPOxjcT3F3bQmUFC7Y9VYlZpM4ik4c2AR9Eb79jHenXlyLOzYdU2Z+FEW1jBaiqXc
         niL/X6LPotmJrGD9W8rbAHGIDyICOdgRka37x5oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/108] bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats
Date:   Mon, 26 Jul 2021 17:38:40 +0200
Message-Id: <20210726153832.944650532@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 228a4a7ba8e99bb9ef980b62f71e3be33f4aae69 ]

The proc socket stats use sk_prot->inuse_idx value to record inuse sock
stats. We currently do not set this correctly from sockmap side. The
result is reading sock stats '/proc/net/sockstat' gives incorrect values.
The socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

To get the correct inuse_idx value move the core_initcall that initializes
the TCP proto handlers to late_initcall. This way it is initialized after
TCP has the chance to assign the inuse_idx value from the register protocol
handler.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/bpf/20210712195546.423990-3-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 819255ee4e42..6a0c4326d9cf 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -636,7 +636,7 @@ static int __init tcp_bpf_v4_build_proto(void)
 	tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
 	return 0;
 }
-core_initcall(tcp_bpf_v4_build_proto);
+late_initcall(tcp_bpf_v4_build_proto);
 
 static void tcp_bpf_update_sk_prot(struct sock *sk, struct sk_psock *psock)
 {
-- 
2.30.2



