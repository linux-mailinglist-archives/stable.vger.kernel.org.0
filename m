Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFF1EAE34
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgFASDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbgFASDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:03:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD5722077D;
        Mon,  1 Jun 2020 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034615;
        bh=p5Ivg2Y9Ngh2RYD9AbZRVypIHScyMu3J9hzghra5llY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+7wr0duMZfUrjCEb8wbOmUpG+teflp25QdBEI5OYziBKAQHhFpwTDXnKdKMGXCzI
         MyrdjV30/0iW9LO06i5f3PirM4GxigefOIRix1cf61TKwdfW5FJS4M3gotXZqX14Y6
         gwL1i4hqMdEo349HrnD9+ACFIi8zqzOCKYQMhE2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 06/95] net: ipip: fix wrong address family in init error path
Date:   Mon,  1 Jun 2020 19:53:06 +0200
Message-Id: <20200601174021.904485238@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 57ebc8f08504f176eb0f25b3e0fde517dec61a4f ]

In case of error with MPLS support the code is misusing AF_INET
instead of AF_MPLS.

Fixes: 1b69e7e6c4da ("ipip: support MPLS over IPv4")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -704,7 +704,7 @@ out:
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_MPLS)
-	xfrm4_tunnel_deregister(&mplsip_handler, AF_INET);
+	xfrm4_tunnel_deregister(&mplsip_handler, AF_MPLS);
 xfrm_tunnel_mplsip_failed:
 
 #endif


