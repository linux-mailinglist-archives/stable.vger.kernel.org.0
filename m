Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95153284D2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhCAQni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhCAQhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:37:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD1664EAE;
        Mon,  1 Mar 2021 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615987;
        bh=1UJIM5Q7m9CRmqAmkHg982t69I14t9vxTAJCAWmR4mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wtkpKUcbSxVMw2PPSq44Qi7BFLUL0md2vrefkj4ahklRtH2uJuv66C/SXqYiu7EQG
         7qDt9v+FOh0fq+qeXKdKEVaAprv54nshchuaJVOi4Whko9717Ds7DAw5d+rwVEOzfy
         c1FpofVBIxUfcdMvKKIK9DkmsXpSkBVIoMJj/A3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Harald Welte <laforge@gnumonks.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 129/134] gtp: use icmp_ndo_send helper
Date:   Mon,  1 Mar 2021 17:13:50 +0100
Message-Id: <20210301161019.944129071@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit e0fce6f945a26d4e953a147fe7ca11410322c9fe upstream.

Because gtp is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -560,8 +560,8 @@ static int gtp_build_skb_ip4(struct sk_b
 	    mtu < ntohs(iph->tot_len)) {
 		netdev_dbg(dev, "packet too big, fragmentation needed\n");
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-			  htonl(mtu));
+		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+			      htonl(mtu));
 		goto err_rt;
 	}
 


