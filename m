Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331C5286D9
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388609AbfEWTNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388135AbfEWTNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:13:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687C720863;
        Thu, 23 May 2019 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638814;
        bh=lD4/6hQEBd8Jge6vEJoPNGZPleezE7ZlAsciEFCdsUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIq1p1G8eRndRdkSJ3HXKQ8Di80PmWyPHL0XybY3ZM/JvnAd+yQ6f6iddGzyCc1YO
         Q6yKDYNtVXgAA/Dab7BgMSjdz6gGFA2t9CUTaDt3PrMqyjOEO5pv5L3cT57aYXYbDV
         8TB6L0GqFrXCWvWo2az+NJlOeQ82aIfBOOdtTk8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 58/77] vti4: ipip tunnel deregistration fixes.
Date:   Thu, 23 May 2019 21:06:16 +0200
Message-Id: <20190523181727.976880575@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5483844c3fc18474de29f5d6733003526e0a9f78 ]

If tunnel registration failed during module initialization, the module
would fail to deregister the IPPROTO_COMP protocol and would attempt to
deregister the tunnel.

The tunnel was not deregistered during module-exit.

Fixes: dd9ee3444014e ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_vti.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 306603a7f3514..c07065b7e3b0e 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -663,9 +663,9 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
-	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
-xfrm_tunnel_failed:
 	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+xfrm_tunnel_failed:
+	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -680,6 +680,7 @@ pernet_dev_failed:
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
+	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&vti_esp4_protocol, IPPROTO_ESP);
-- 
2.20.1



