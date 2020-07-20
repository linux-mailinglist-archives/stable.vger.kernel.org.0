Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426EB2266BE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbgGTQFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbgGTQFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:05:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066782064B;
        Mon, 20 Jul 2020 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261148;
        bh=FhFN68Ag34wWao+eeahWVS3aWBazngVxjZGA4gmgqWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afG5zuTNXIzIttGeqhSlT3PMwJktgaOCSDiEuujMTQFJ0YZ7GbKbJL1EbQM2sON+9
         IEO5pSAA6gQ+QIflB/U+JL4TovVZt12G0L4gdeDb6FuNPbrI4A5ZokiKRzde0r0o/T
         K0nySYPV4r+1njhUDKVOdfw1HP8ZpTPojjWoAPcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Wouters <pwouters@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 003/244] ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg
Date:   Mon, 20 Jul 2020 17:34:34 +0200
Message-Id: <20200720152826.026543682@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 5eff06902394425c722f0a44d9545909a8800f79 ]

IPv4 ping sockets don't set fl4.fl4_icmp_{type,code}, which leads to
incomplete IPsec ACQUIRE messages being sent to userspace. Currently,
both raw sockets and IPv6 ping sockets set those fields.

Expected output of "ip xfrm monitor":
    acquire proto esp
      sel src 10.0.2.15/32 dst 8.8.8.8/32 proto icmp type 8 code 0 dev ens4
      policy src 10.0.2.15/32 dst 8.8.8.8/32
        <snip>

Currently with ping sockets:
    acquire proto esp
      sel src 10.0.2.15/32 dst 8.8.8.8/32 proto icmp type 0 code 0 dev ens4
      policy src 10.0.2.15/32 dst 8.8.8.8/32
        <snip>

The Libreswan test suite found this problem after Fedora changed the
value for the sysctl net.ipv4.ping_group_range.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Paul Wouters <pwouters@redhat.com>
Tested-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -786,6 +786,9 @@ static int ping_v4_sendmsg(struct sock *
 			   inet_sk_flowi_flags(sk), faddr, saddr, 0, 0,
 			   sk->sk_uid);
 
+	fl4.fl4_icmp_type = user_icmph.type;
+	fl4.fl4_icmp_code = user_icmph.code;
+
 	security_sk_classify_flow(sk, flowi4_to_flowi(&fl4));
 	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt)) {


