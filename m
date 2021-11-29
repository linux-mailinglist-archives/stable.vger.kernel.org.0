Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E315D46257B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhK2WkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbhK2WkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BE6C0800C9;
        Mon, 29 Nov 2021 10:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C03D4B815E0;
        Mon, 29 Nov 2021 18:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA539C53FAD;
        Mon, 29 Nov 2021 18:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211125;
        bh=OLIjOVpAZr3WQu451s1pGvvPn88OPDhxU3OmxKfXEPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6+T5g9L3SwP1NR1bNNoQfgbgjaCKIUBswK45PzYfN8BMJPuUUa8rCTpYvgjRpK0m
         477PdzLY8G56LE4lDOOXGP/vT7IJ0hPPqAwas5iWCQxTPlRdDyYoQNb2aiC+ftunxZ
         ThF0jrTCNR+1RUVVxY5I/yK/UKN8fpWZ/ucevf/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/179] mptcp: fix delack timer
Date:   Mon, 29 Nov 2021 19:18:18 +0100
Message-Id: <20211129181722.360957073@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee50e67ba0e17b1a1a8d76691d02eadf9e0f392c ]

To compute the rtx timeout schedule_3rdack_retransmission() does multiple
things in the wrong way: srtt_us is measured in usec/8 and the timeout
itself is an absolute value.

Fixes: ec3edaa7ca6ce02f ("mptcp: Add handling of outgoing MP_JOIN requests")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau>@linux.intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 350348f070700..3fcc2e0c8a5df 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -434,9 +434,10 @@ static void schedule_3rdack_retransmission(struct sock *sk)
 
 	/* reschedule with a timeout above RTT, as we must look only for drop */
 	if (tp->srtt_us)
-		timeout = tp->srtt_us << 1;
+		timeout = usecs_to_jiffies(tp->srtt_us >> (3 - 1));
 	else
 		timeout = TCP_TIMEOUT_INIT;
+	timeout += jiffies;
 
 	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
 	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
-- 
2.33.0



