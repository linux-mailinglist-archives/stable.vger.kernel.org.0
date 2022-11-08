Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A12621301
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiKHNpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbiKHNpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACCA4FF9B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38AE361582
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46402C433C1;
        Tue,  8 Nov 2022 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915115;
        bh=Jvi3UmdMO9kAqLvSP1WGtx9hxzJ0/Xb20qsgcfo9vwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAOyq98dr/nLmD73ncT0aweiGfFPcXQ05o0pLVgrlekSMjSdCStfUwB6j516rSSuq
         eCl/7y79fG0edVKPHB6RKCD3Q+5N9BMRSKipBCa/Aa3XqvIoSQVeAdh2hpE6KHog5j
         CgMa3SNLrHtcUmVJPh8r7AlolAC7RSYd1QBqvrnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/48] rose: Fix NULL pointer dereference in rose_send_frame()
Date:   Tue,  8 Nov 2022 14:39:00 +0100
Message-Id: <20221108133330.040041147@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit e97c089d7a49f67027395ddf70bf327eeac2611e ]

The syzkaller reported an issue:

KASAN: null-ptr-deref in range [0x0000000000000380-0x0000000000000387]
CPU: 0 PID: 4069 Comm: kworker/0:15 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: rcu_gp srcu_invoke_callbacks
RIP: 0010:rose_send_frame+0x1dd/0x2f0 net/rose/rose_link.c:101
Call Trace:
 <IRQ>
 rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
 rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
 rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
 call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
 [...]
 </IRQ>

It triggers NULL pointer dereference when 'neigh->dev->dev_addr' is
called in the rose_send_frame(). It's the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh', and
the 'dev' in 'rose_loopback_neigh' is initialized sa nullptr.

It had been fixed by commit 3b3fd068c56e3fbea30090859216a368398e39bf
("rose: Fix Null pointer dereference in rose_send_frame()") ever.
But it's introduced by commit 3c53cd65dece47dd1f9d3a809f32e59d1d87b2b8
("rose: check NULL rose_loopback_neigh->loopback") again.

We fix it by add NULL check in rose_transmit_clear_request(). When
the 'dev' in 'neigh' is NULL, we don't reply the request and just
clear it.

syzkaller don't provide repro, and I provide a syz repro like:
r0 = syz_init_net_socket$bt_sco(0x1f, 0x5, 0x2)
ioctl$sock_inet_SIOCSIFFLAGS(r0, 0x8914, &(0x7f0000000180)={'rose0\x00', 0x201})
r1 = syz_init_net_socket$rose(0xb, 0x5, 0x0)
bind$rose(r1, &(0x7f00000000c0)=@full={0xb, @dev, @null, 0x0, [@null, @null, @netrom, @netrom, @default, @null]}, 0x40)
connect$rose(r1, &(0x7f0000000240)=@short={0xb, @dev={0xbb, 0xbb, 0xbb, 0x1, 0x0}, @remote={0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0x1}, 0x1, @netrom={0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0x0, 0x0}}, 0x1c)

Fixes: 3c53cd65dece ("rose: check NULL rose_loopback_neigh->loopback")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 62055d3069d2..f3d7105c6cdd 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -239,6 +239,9 @@ void rose_transmit_clear_request(struct rose_neigh *neigh, unsigned int lci, uns
 	unsigned char *dptr;
 	int len;
 
+	if (!neigh->dev)
+		return;
+
 	len = AX25_BPQ_HEADER_LEN + AX25_MAX_HEADER_LEN + ROSE_MIN_LEN + 3;
 
 	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
-- 
2.35.1



