Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB6834C777
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhC2IPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232818AbhC2ION (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3106197F;
        Mon, 29 Mar 2021 08:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005650;
        bh=TO5E2VfsyTREnWidqi4mMJ/6Hg/Y5gALTB5wcWzuZJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2a1TlKyjo5TfWT6xseu18+r7G6alWE4FvyTvUrUhMJk3UDyenQylAUxFjK6hH9qf
         f6rTzHBbGu7O4sbnTozOG3Jfl7/kV66X3sjGkmP36Ox2kAnhl4or/olrvJwbrCyi4x
         XyLO8nfsZhOQ6mcguAEZ15Bvh92YIa0c+Fftn42c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        William Tu <u9012063@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/111] selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed
Date:   Mon, 29 Mar 2021 09:58:15 +0200
Message-Id: <20210329075617.435790291@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 31254dc9566221429d2cfb45fd5737985d70f2b6 ]

When fixing the bpf test_tunnel.sh geneve failure. I only fixed the IPv4
part but forgot the IPv6 issue. Similar with the IPv4 fixes 557c223b643a
("selftests/bpf: No need to drop the packet when there is no geneve opt"),
when there is no tunnel option and bpf_skb_get_tunnel_opt() returns error,
there is no need to drop the packets and break all geneve rx traffic.
Just set opt_class to 0 and keep returning TC_ACT_OK at the end.

Fixes: 557c223b643a ("selftests/bpf: No need to drop the packet when there is no geneve opt")
Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: William Tu <u9012063@gmail.com>
Link: https://lore.kernel.org/bpf/20210309032214.2112438-1-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index b4e9a1d8c6cd..141670ab4e67 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -508,10 +508,8 @@ int _ip6geneve_get_tunnel(struct __sk_buff *skb)
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
-- 
2.30.1



