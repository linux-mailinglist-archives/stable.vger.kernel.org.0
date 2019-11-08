Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB991F54FA
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbfKHS71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732610AbfKHS70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:59:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C78A22509;
        Fri,  8 Nov 2019 18:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239566;
        bh=HUYk6KNgE5pSGlS9Cxg+7svgrj5BvCJ4XZLP4/7PuCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBNU9IEVf6kZSB3ltfUh0K60OKHQwnlQt9rnb6oZjx3VOq2xAAloA4dImiAwZi3QV
         t06ENxwUM7rxpHxO8drPketSqSjxEH/FGG/QMAontCI2Gg2V9P7qiHiR7yGQg6IlHm
         5Q8TgeQh4iSVyHLZ0tDmbmTmpTbS7MuJ7zwd2f00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 46/62] vxlan: check tun_info options_len properly
Date:   Fri,  8 Nov 2019 19:50:34 +0100
Message-Id: <20191108174751.254850387@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit eadf52cf1852196a1363044dcda22fa5d7f296f7 ]

This patch is to improve the tun_info options_len by dropping
the skb when TUNNEL_VXLAN_OPT is set but options_len is less
than vxlan_metadata. This can void a potential out-of-bounds
access on ip_tun_info.

Fixes: ee122c79d422 ("vxlan: Flow based tunneling")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2169,8 +2169,11 @@ static void vxlan_xmit_one(struct sk_buf
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
-		if (info->options_len)
+		if (info->options_len) {
+			if (info->options_len < sizeof(*md))
+				goto drop;
 			md = ip_tunnel_info_opts(info);
+		}
 		ttl = info->key.ttl;
 		tos = info->key.tos;
 		label = info->key.label;


