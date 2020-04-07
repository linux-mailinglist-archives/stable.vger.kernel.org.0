Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFC91A0B8C
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgDGK1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbgDGK06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA9B2074F;
        Tue,  7 Apr 2020 10:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255217;
        bh=9yKfdel+qAZDrZmCqU4IVFOFzurKYm2wYy167EUh1lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvagsU0RA+O2WTJKe6f45AL/hrdSLvY7+LbwOgUZ/M0DuA/NSPaLZ8Lzsz7NEE0rb
         92OgLxpNVh1Y31tc1sp+TMmJ6bQikfmRtkiS+aSdUVRHuKBgGRKs5OnwVnlmaSl5w0
         mcmMhJOXTB+V+1rvnzajaB+aUOvblsiK2LoeXAd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 08/29] udp: initialize is_flist with 0 in udp_gro_receive
Date:   Tue,  7 Apr 2020 12:22:05 +0200
Message-Id: <20200407101453.015096017@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit bde1b56f898ca8112912d7b36e55e1543b3be0cf ]

Without NAPI_GRO_CB(skb)->is_flist initialized, when the dev doesn't
support NETIF_F_GRO_FRAGLIST, is_flist can still be set and fraglist
will be used in udp_gro_receive().

So fix it by initializing is_flist with 0 in udp_gro_receive.

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -453,6 +453,7 @@ struct sk_buff *udp_gro_receive(struct l
 	unsigned int off = skb_gro_offset(skb);
 	int flush = 1;
 
+	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
 		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
 


