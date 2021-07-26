Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320073D6063
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbhGZPWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237251AbhGZPWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAC4A60240;
        Mon, 26 Jul 2021 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315354;
        bh=I0f1Skd/hrroaJ7U4F+6AiGtkrnKuxZYobhWx1RwHlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7XdzVSAb9hCp0I4HNzYplxfe+smWr9YoTFhJpSU66jC03M0xDYmSfYLpA4Lc7X2Y
         xUIBTBUlBdTCM9PzM/3T7ekw45CtIfCq1VGedUffRvRQtbx8r1R1V926dC8Et12Yil
         zd68ABVpCmh8+qcnie3zy0sxYsfvYIZeE/6mFnpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/167] bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats
Date:   Mon, 26 Jul 2021 17:38:15 +0200
Message-Id: <20210726153841.483659503@linuxfoundation.org>
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
index bc7d2a586e18..f91ae827d47f 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -588,7 +588,7 @@ static int __init tcp_bpf_v4_build_proto(void)
 	tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
 	return 0;
 }
-core_initcall(tcp_bpf_v4_build_proto);
+late_initcall(tcp_bpf_v4_build_proto);
 
 static int tcp_bpf_assert_proto_ops(struct proto *ops)
 {
-- 
2.30.2



