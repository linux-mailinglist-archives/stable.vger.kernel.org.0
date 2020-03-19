Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E2F18B61C
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgCSNYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgCSNYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:24:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79A420724;
        Thu, 19 Mar 2020 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624257;
        bh=KHwXrlKcbaKW5OTF2R6Sp4xIzaqTtcNI8e891CLiBoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcZuTJIaNnayyTZR/6xH3ZFegckG4G2d6rrv/mlb0Vu1B3v3wOoKFCcMReoNOIgVo
         ObVJ5PyxkJVkSL9rVle5UDcbZxra6+rjqL1KCSj6+dBVD26iiSVZnMgIlzWAD5bkA/
         UAjXoLSBN1EahW0i7Z7YStDWDxpChcAeTjGNHzrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Matteo Croce <mcroce@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 60/60] ipv4: ensure rcu_read_lock() in cipso_v4_error()
Date:   Thu, 19 Mar 2020 14:04:38 +0100
Message-Id: <20200319123938.305603077@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

commit 3e72dfdf8227b052393f71d820ec7599909dddc2 upstream.

Similarly to commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in
ipv4_link_failure()"), __ip_options_compile() must be called under rcu
protection.

Fixes: 3da1ed7ac398 ("net: avoid use IPCB in cipso_v4_error")
Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/cipso_ipv4.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1724,6 +1724,7 @@ void cipso_v4_error(struct sk_buff *skb,
 {
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
+	int res;
 
 	if (ip_hdr(skb)->protocol == IPPROTO_ICMP || error != -EACCES)
 		return;
@@ -1735,7 +1736,11 @@ void cipso_v4_error(struct sk_buff *skb,
 
 	memset(opt, 0, sizeof(struct ip_options));
 	opt->optlen = ip_hdr(skb)->ihl*4 - sizeof(struct iphdr);
-	if (__ip_options_compile(dev_net(skb->dev), opt, skb, NULL))
+	rcu_read_lock();
+	res = __ip_options_compile(dev_net(skb->dev), opt, skb, NULL);
+	rcu_read_unlock();
+
+	if (res)
 		return;
 
 	if (gateway)


