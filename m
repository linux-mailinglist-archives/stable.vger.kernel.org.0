Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13B0A90B2
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389876AbfIDSLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389078AbfIDSLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB951206BA;
        Wed,  4 Sep 2019 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620670;
        bh=mZkrT94PMPHs9+bKmMZ5XhM9mmWORLtOLRehanlWqzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pygq+KcyTLdQgVMNRWJb8MwZb0lY7pCEqln7rniMQzZCmWCvVWPi/vPdqONyNK0Y+
         Um1eMNd23zlkXopR95ssbEe47tdGoRNmjS7FM2Yl0RImzodlA2EWAkxm+RsiibVWwj
         hYTBmfsm8+UoAhEIzJDOm0gdtjItokXzYrHsD2JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 050/143] ipv6: Fix return value of ipv6_mc_may_pull() for malformed packets
Date:   Wed,  4 Sep 2019 19:53:13 +0200
Message-Id: <20190904175316.027989092@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Commit ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and
ipv6_mc_check_mld() calls") replaces direct calls to pskb_may_pull()
in br_ipv6_multicast_mld2_report() with calls to ipv6_mc_may_pull(),
that returns -EINVAL on buffers too short to be valid IPv6 packets,
while maintaining the previous handling of the return code.

This leads to the direct opposite of the intended effect: if the
packet is malformed, -EINVAL evaluates as true, and we'll happily
proceed with the processing.

Return 0 if the packet is too short, in the same way as this was
fixed for IPv4 by commit 083b78a9ed64 ("ip: fix ip_mc_may_pull()
return value").

I don't have a reproducer for this, unlike the one referred to by
the IPv4 commit, but this is clearly broken.

Fixes: ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and ipv6_mc_check_mld() calls")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/addrconf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -206,7 +206,7 @@ static inline int ipv6_mc_may_pull(struc
 				   unsigned int len)
 {
 	if (skb_transport_offset(skb) + ipv6_transport_len(skb) < len)
-		return -EINVAL;
+		return 0;
 
 	return pskb_may_pull(skb, len);
 }


