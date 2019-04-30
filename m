Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCBDF7AE
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfD3LoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730079AbfD3LoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E825217D7;
        Tue, 30 Apr 2019 11:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624645;
        bh=vF4ZPpClpAQB+QotrzfB5epJk5/WOVDi92RBsgX1WyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caOJVb0DkSnIqTRRIva9GHepAlFwyXQZLz1MkH9t2ES+9rnv3JchWC1sCs682l3rI
         GEpjOF14cvw64mQjcPh2Kqi255UlWD5NskQ2JjB06Ib47HZUWW/5Urv1YM3CfXAzXH
         jc9hxiFLuprJrbBIXeGsyZCdmNlT9BDnAqjUdbFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Andrea Claudi <aclaudi@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/100] ipvs: fix warning on unused variable
Date:   Tue, 30 Apr 2019 13:37:48 +0200
Message-Id: <20190430113609.738750490@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c93a49b9769e435990c82297aa0baa31e1538790 ]

When CONFIG_IP_VS_IPV6 is not defined, build produced this warning:

net/netfilter/ipvs/ip_vs_ctl.c:899:6: warning: unused variable ‘ret’ [-Wunused-variable]
  int ret = 0;
      ^~~

Fix this by moving the declaration of 'ret' in the CONFIG_IP_VS_IPV6
section in the same function.

While at it, drop its unneeded initialisation.

Fixes: 098e13f5b21d ("ipvs: fix dependency on nf_defrag_ipv6")
Reported-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8fd8d06454d6..2d4e048762f6 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -896,12 +896,13 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 {
 	struct ip_vs_dest *dest;
 	unsigned int atype, i;
-	int ret = 0;
 
 	EnterFunction(2);
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (udest->af == AF_INET6) {
+		int ret;
+
 		atype = ipv6_addr_type(&udest->addr.in6);
 		if ((!(atype & IPV6_ADDR_UNICAST) ||
 			atype & IPV6_ADDR_LINKLOCAL) &&
-- 
2.19.1



