Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD8620DC93
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbgF2UQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732810AbgF2TaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A732520B;
        Mon, 29 Jun 2020 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444925;
        bh=cL38UWE7GwcD4GEHg4xYrfg67HEgIfAslckE1BzZB+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhUZRdsC6wVLdI7k8BQ2jRf3APLDEXYOFxxhBLGxECVoY27JPDW6IbZ/plT1WYE2/
         Yr5z+hVCtQvysq52jU78J5opQy/k4Jbn/jJ+1BYq65ZhyS+3Y2Damr673/R7OL2oBI
         1lGYr1ZLIXZBzRsuJPQv4FYTIw7oaIczMcf4ay+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+51471b4aae195285a4a3@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 022/131] net: use correct this_cpu primitive in dev_recursion_level
Date:   Mon, 29 Jun 2020 11:33:13 -0400
Message-Id: <20200629153502.2494656-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 28b05b92886871bdd8e6a9df73e3a15845fe8ef4 upstream.

syzbot reports:
BUG: using __this_cpu_read() in preemptible code:
caller is dev_recursion_level include/linux/netdevice.h:3052 [inline]
 __this_cpu_preempt_check+0x246/0x270 lib/smp_processor_id.c:47
 dev_recursion_level include/linux/netdevice.h:3052 [inline]
 ip6_skb_dst_mtu include/net/ip6_route.h:245 [inline]

I erronously downgraded a this_cpu_read to __this_cpu_read when
moving dev_recursion_level() around.

Reported-by: syzbot+51471b4aae195285a4a3@syzkaller.appspotmail.com
Fixes: 97cdcf37b57e ("net: place xmit recursion in softnet data")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 41beebcc61f45..85dc3497c74f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3001,7 +3001,7 @@ DECLARE_PER_CPU_ALIGNED(struct softnet_data, softnet_data);
 
 static inline int dev_recursion_level(void)
 {
-	return __this_cpu_read(softnet_data.xmit.recursion);
+	return this_cpu_read(softnet_data.xmit.recursion);
 }
 
 #define XMIT_RECURSION_LIMIT	10
-- 
2.25.1

