Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEED186953
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404314AbfHHTGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404305AbfHHTGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:06:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B40721874;
        Thu,  8 Aug 2019 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291171;
        bh=dNmTb3QINlrpcp+OKj14SrI5Ih/AaDAsr/lQUlLus38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pkvsv7wZBw832a7gqZe6sIEnqe0WyR7D5adWmFSx4uWunJqGO0+rZ04Ds9UGZFylb
         Erf7WjygUFdRcLFCe8f72cDPKrBK4lDsRsobvxwCMiSBJSaXQsTUDwjOFoVaGoNlbK
         r13Z6pdd4IIiou81k/YAi946K7pkmUpChsNuplM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 14/56] ipip: validate header length in ipip_tunnel_xmit
Date:   Thu,  8 Aug 2019 21:04:40 +0200
Message-Id: <20190808190453.428439547@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 47d858d0bdcd47cc1c6c9eeca91b091dd9e55637 ]

We need the same checks introduced by commit cb9f1b783850
("ip: validate header length on virtual device xmit") for
ipip tunnel.

Fixes: cb9f1b783850b ("ip: validate header length on virtual device xmit")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -275,6 +275,9 @@ static netdev_tx_t ipip_tunnel_xmit(stru
 	const struct iphdr  *tiph = &tunnel->parms.iph;
 	u8 ipproto;
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_error;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		ipproto = IPPROTO_IPIP;


