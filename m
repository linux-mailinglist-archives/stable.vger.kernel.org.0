Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E17D2D0422
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgLFLnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729144AbgLFLnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:23 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 08/39] tcp: Set INET_ECN_xmit configuration in tcp_reinit_congestion_control
Date:   Sun,  6 Dec 2020 12:17:12 +0100
Message-Id: <20201206111555.080174878@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 55472017a4219ca965a957584affdb17549ae4a4 ]

When setting congestion control via a BPF program it is seen that the
SYN/ACK for packets within a given flow will not include the ECT0 flag. A
bit of simple printk debugging shows that when this is configured without
BPF we will see the value INET_ECN_xmit value initialized in
tcp_assign_congestion_control however when we configure this via BPF the
socket is in the closed state and as such it isn't configured, and I do not
see it being initialized when we transition the socket into the listen
state. The result of this is that the ECT0 bit is configured based on
whatever the default state is for the socket.

Any easy way to reproduce this is to monitor the following with tcpdump:
tools/testing/selftests/bpf/test_progs -t bpf_tcp_ca

Without this patch the SYN/ACK will follow whatever the default is. If dctcp
all SYN/ACK packets will have the ECT0 bit set, and if it is not then ECT0
will be cleared on all SYN/ACK packets. With this patch applied the SYN/ACK
bit matches the value seen on the other packets in the given stream.

Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_cong.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -197,6 +197,11 @@ static void tcp_reinit_congestion_contro
 	icsk->icsk_ca_setsockopt = 1;
 	memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
 
+	if (ca->flags & TCP_CONG_NEEDS_ECN)
+		INET_ECN_xmit(sk);
+	else
+		INET_ECN_dontxmit(sk);
+
 	if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		tcp_init_congestion_control(sk);
 }


