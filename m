Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF52EF546A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfKHS7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388926AbfKHS73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:59:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DA02255C;
        Fri,  8 Nov 2019 18:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239569;
        bh=v9PPuIRY93R4lGfaNyPfFvpC2mtDl2BYQVLPH+Ij+Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRfG0CdDlHDoGXJ8AqdeJ2FTvu+H/l/R3+yxNxoM296xCqcf5HVWFRmcr55tds4mR
         RoFprwi0KIMaS+UToGZgBTTwP0/j/hXh5+ySmyOLoaA5v32HQoj9gtugjF9SW2fqhS
         Xm5YAyuRPOTF8nW2xfPLnciFmpdwJnsuetIaNg04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 47/62] erspan: fix the tun_info options_len check for erspan
Date:   Fri,  8 Nov 2019 19:50:35 +0100
Message-Id: <20191108174752.161636977@linuxfoundation.org>
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

[ Upstream commit 2eb8d6d2910cfe3dc67dc056f26f3dd9c63d47cd ]

The check for !md doens't really work for ip_tunnel_info_opts(info) which
only does info + 1. Also to avoid out-of-bounds access on info, it should
ensure options_len is not less than erspan_metadata in both erspan_xmit()
and ip6erspan_tunnel_xmit().

Fixes: 1a66a836da ("gre: add collect_md mode to ERSPAN tunnel")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -592,6 +592,9 @@ static void erspan_fb_xmit(struct sk_buf
 		truncate = true;
 	}
 
+	if (tun_info->options_len < sizeof(*md))
+		goto err_free_rt;
+
 	md = ip_tunnel_info_opts(tun_info);
 	if (!md)
 		goto err_free_rt;


