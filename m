Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB43AF625
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbfD3Lnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729985AbfD3Lni (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABDBC20449;
        Tue, 30 Apr 2019 11:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624617;
        bh=7s0gBaTgPBBpRFjLQzlVGyfJufIZqMhD323/zLd7+S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy7jnYw6tMaJv030Pm1BdIxM3p2XLnK/hOtHWhIkt9hFt5KoLGrAfJmZ2Gx3I+wVo
         o8PFc4yF4x0k3iWGo52IvTh1s1PlVxhlCFTfril0gQpj456KcS/TMI6MkCVp52KhlW
         1Qc3Fvb5zZwZF/KqDv0kjE8gZsh+dDEQn4kOpL44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Andrea Claudi <aclaudi@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 31/53] ipvs: fix warning on unused variable
Date:   Tue, 30 Apr 2019 13:38:38 +0200
Message-Id: <20190430113556.666157798@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

commit c93a49b9769e435990c82297aa0baa31e1538790 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_ctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -889,12 +889,13 @@ ip_vs_new_dest(struct ip_vs_service *svc
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


