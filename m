Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D0B20DD4E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgF2SlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgF2SlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F9124125;
        Mon, 29 Jun 2020 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443936;
        bh=R7Ov2awEkrZIyqcu8QasaYukANbO8HJ0R3f0yEw4k7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl3iI7PteN8xcIH8JJvpqjbX8/2TMlGokKC8TTu9V1fBcQf7tvQWSZDPuEPe5oQxN
         RvHC8LQDNfDXtZgsNJqsBpG57oIaGmYwnaYTpfKqhiTco54uj/8t2jtvob7Tr0nql3
         lkLPJGdQr4L12sfUdMiUHR8usBhkCFXvJa/FC6/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Cardwell <ncardwell@google.com>,
        Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 037/265] tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT
Date:   Mon, 29 Jun 2020 11:14:30 -0400
Message-Id: <20200629151818.2493727-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit b344579ca8478598937215f7005d6c7b84d28aee ]

Mirja Kuehlewind reported a bug in Linux TCP CUBIC Hystart, where
Hystart HYSTART_DELAY mechanism can exit Slow Start spuriously on an
ACK when the minimum rtt of a connection goes down. From inspection it
is clear from the existing code that this could happen in an example
like the following:

o The first 8 RTT samples in a round trip are 150ms, resulting in a
  curr_rtt of 150ms and a delay_min of 150ms.

o The 9th RTT sample is 100ms. The curr_rtt does not change after the
  first 8 samples, so curr_rtt remains 150ms. But delay_min can be
  lowered at any time, so delay_min falls to 100ms. The code executes
  the HYSTART_DELAY comparison between curr_rtt of 150ms and delay_min
  of 100ms, and the curr_rtt is declared far enough above delay_min to
  force a (spurious) exit of Slow start.

The fix here is simple: allow every RTT sample in a round trip to
lower the curr_rtt.

Fixes: ae27e98a5152 ("[TCP] CUBIC v2.3")
Reported-by: Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_cubic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 8f8eefd3a3ce1..c7bf5b26bf0c2 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -432,10 +432,9 @@ static void hystart_update(struct sock *sk, u32 delay)
 
 	if (hystart_detect & HYSTART_DELAY) {
 		/* obtain the minimum delay of more than sampling packets */
+		if (ca->curr_rtt > delay)
+			ca->curr_rtt = delay;
 		if (ca->sample_cnt < HYSTART_MIN_SAMPLES) {
-			if (ca->curr_rtt > delay)
-				ca->curr_rtt = delay;
-
 			ca->sample_cnt++;
 		} else {
 			if (ca->curr_rtt > ca->delay_min +
-- 
2.25.1

