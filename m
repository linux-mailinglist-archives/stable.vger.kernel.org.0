Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE60B1BC95A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgD1Sku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbgD1Skt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:40:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FA42076A;
        Tue, 28 Apr 2020 18:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099249;
        bh=VCDnRq6KNn8pBZy4kFj3bnJQnDEccmaJeGcDMIiba5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkGgvTfRWJJYv0McwQ8On/au//4BeAm/sPnC51jASY0m9HTS+IZNixrf95lC9gb2v
         M4vOY9V32QWpRw+7U6A5eN3Mq5gRZMRsiLCubHuw1LB/E19Vz80yCtIF3DwuSoFLPc
         WkEk2OBcgFQl66jGrNdpmVO2Afw6g7XsEQDmwtPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 081/168] xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
Date:   Tue, 28 Apr 2020 20:24:15 +0200
Message-Id: <20200428182242.430923255@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 0c922a4850eba2e668f73a3f1153196e09abb251 ]

IPSKB_XFRM_TRANSFORMED and IP6SKB_XFRM_TRANSFORMED are skb flags set by
xfrm code to tell other skb handlers that the packet has been passed
through the xfrm output functions. Simplify the code and just always
set them rather than conditionally based on netfilter enabled thus
making the flag available for other users.

Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/xfrm4_output.c |    2 --
 net/ipv6/xfrm6_output.c |    2 --
 2 files changed, 4 deletions(-)

--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -58,9 +58,7 @@ int xfrm4_output_finish(struct sock *sk,
 {
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 
-#ifdef CONFIG_NETFILTER
 	IPCB(skb)->flags |= IPSKB_XFRM_TRANSFORMED;
-#endif
 
 	return xfrm_output(sk, skb);
 }
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -111,9 +111,7 @@ int xfrm6_output_finish(struct sock *sk,
 {
 	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 
-#ifdef CONFIG_NETFILTER
 	IP6CB(skb)->flags |= IP6SKB_XFRM_TRANSFORMED;
-#endif
 
 	return xfrm_output(sk, skb);
 }


