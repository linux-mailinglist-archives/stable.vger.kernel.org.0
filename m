Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CAF34C896
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhC2IX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233087AbhC2IVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED5F261878;
        Mon, 29 Mar 2021 08:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006098;
        bh=e53U7nlaCOALcoWHSz0ckvm1wTTWN1D9h3L20DQAsZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpZZMhEjl3l5vCXxNxi04Lcb0L+e0wcRHZvv1qYFBvxeXtqAYHP4LdLbnXg15PJpF
         OumpJ4c9iu2s/T3dUQrR0K64db4LAAxqUof2Akxma+FjmqXoPnbicXsGloVwi/PP48
         toP/KYiiKFvEuJWEKsxDrylAwsM2UxIIGOZEEsHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        William Tu <u9012063@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/221] selftests/bpf: Set gopt opt_class to 0 if get tunnel opt failed
Date:   Mon, 29 Mar 2021 09:57:29 +0200
Message-Id: <20210329075633.141934628@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 9afe947cfae9..ba6eadfec565 100644
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



