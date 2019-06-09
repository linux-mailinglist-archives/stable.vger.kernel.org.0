Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E93AAE2
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfFIRWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbfFIQoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AB12083D;
        Sun,  9 Jun 2019 16:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098657;
        bh=ILBiED/nfE5AzbiBFDaFnu6kol9RSV5XGITdIeCvWfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgAlTO8QXZQrkCpUPhKDY/ow4GmPGRXsyOrGMFenmh8BPnsKf457QPjafcJ+ifU4O
         MEEV9n9hfqm753+17eYWjbxu1EhCbLrUL/AS6FXYbWEYxYNkza0yTy+bZDXZXxnGws
         T5ohdYVYJLAjCYOvvJIRsrM/vQmoyA7rHXbQHT9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Matz <olivier.matz@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 14/70] ipv6: fix EFAULT on sendto with icmpv6 and hdrincl
Date:   Sun,  9 Jun 2019 18:41:25 +0200
Message-Id: <20190609164128.293608314@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Matz <olivier.matz@6wind.com>

[ Upstream commit b9aa52c4cb457e7416cc0c95f475e72ef4a61336 ]

The following code returns EFAULT (Bad address):

  s = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
  setsockopt(s, SOL_IPV6, IPV6_HDRINCL, 1);
  sendto(ipv6_icmp6_packet, addr);   /* returns -1, errno = EFAULT */

The IPv4 equivalent code works. A workaround is to use IPPROTO_RAW
instead of IPPROTO_ICMPV6.

The failure happens because 2 bytes are eaten from the msghdr by
rawv6_probe_proto_opt() starting from commit 19e3c66b52ca ("ipv6
equivalent of "ipv4: Avoid reading user iov twice after
raw_probe_proto_opt""), but at that time it was not a problem because
IPV6_HDRINCL was not yet introduced.

Only eat these 2 bytes if hdrincl == 0.

Fixes: 715f504b1189 ("ipv6: add IPV6_HDRINCL option for raw sockets")
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -895,11 +895,14 @@ static int rawv6_sendmsg(struct sock *sk
 	opt = ipv6_fixup_options(&opt_space, opt);
 
 	fl6.flowi6_proto = proto;
-	rfv.msg = msg;
-	rfv.hlen = 0;
-	err = rawv6_probe_proto_opt(&rfv, &fl6);
-	if (err)
-		goto out;
+
+	if (!hdrincl) {
+		rfv.msg = msg;
+		rfv.hlen = 0;
+		err = rawv6_probe_proto_opt(&rfv, &fl6);
+		if (err)
+			goto out;
+	}
 
 	if (!ipv6_addr_any(daddr))
 		fl6.daddr = *daddr;


