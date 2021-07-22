Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D1C3D2A3A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhGVQKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhGVQIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD6F61DAF;
        Thu, 22 Jul 2021 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972522;
        bh=K8+Q1lv9vsgYBDytnr10no5EHQMGDOxtlBJUJ8l692Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR+h40ekJOsOUnMhx9e/u59r4RHq4mZhnUlOCTsr0afrB+l/tZTThK2S30QMoIKVf
         erLRw0JUaVDkMzWrdWLUfUO3beDC0i7kerHPH9A0kJmHmMM8VmAwVtil3EBMNwkGmz
         ph3SVJOFzzy9HV1nLRO8PFQ+hlITaPgy9k9Rf/eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 143/156] tcp: consistently disable header prediction for mptcp
Date:   Thu, 22 Jul 2021 18:31:58 +0200
Message-Id: <20210722155632.970065618@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 71158bb1f2d2da61385c58fc1114e1a1c19984ba upstream.

The MPTCP receive path is hooked only into the TCP slow-path.
The DSS presence allows plain MPTCP traffic to hit that
consistently.

Since commit e1ff9e82e2ea ("net: mptcp: improve fallback to TCP"),
when an MPTCP socket falls back to TCP, it can hit the TCP receive
fast-path, and delay or stop triggering the event notification.

Address the issue explicitly disabling the header prediction
for MPTCP sockets.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/200
Fixes: e1ff9e82e2ea ("net: mptcp: improve fallback to TCP")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -682,6 +682,10 @@ static inline u32 __tcp_set_rto(const st
 
 static inline void __tcp_fast_path_on(struct tcp_sock *tp, u32 snd_wnd)
 {
+	/* mptcp hooks are only on the slow path */
+	if (sk_is_mptcp((struct sock *)tp))
+		return;
+
 	tp->pred_flags = htonl((tp->tcp_header_len << 26) |
 			       ntohl(TCP_FLAG_ACK) |
 			       snd_wnd);


