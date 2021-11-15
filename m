Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7334521AA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbhKPBGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245452AbhKOTUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EA356353D;
        Mon, 15 Nov 2021 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001294;
        bh=3rWkvLQMX4G20KChSH47VaCpvUP56uJTMo/FwsC88jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSSRngio2CXxc5+zrSRvM9j/zSGBjt+ithN4DuGeErmzxZrDNjNRksFFyX5Aqf8nW
         QVzkyZQavBxRxWpPzA0+SJkmVFNnFk2twZhMNEr15DHs1Uy7q6O40HsFFyzkN/2Sbm
         raMGF1cXUuCAZMm5BMbywHDmlKm1/r/Owew/RdB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 136/917] ifb: fix building without CONFIG_NET_CLS_ACT
Date:   Mon, 15 Nov 2021 17:53:51 +0100
Message-Id: <20211115165433.380288151@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 7444d706be31753f65052c7f6325fc8470cc1789 upstream.

The driver no longer depends on this option, but it fails to
build if it's disabled because the skb->tc_skip_classify is
hidden behind an #ifdef:

drivers/net/ifb.c:81:8: error: no member named 'tc_skip_classify' in 'struct sk_buff'
                skb->tc_skip_classify = 1;

Use the same #ifdef around the assignment.

Fixes: 046178e726c2 ("ifb: Depend on netfilter alternatively to tc")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ifb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -76,7 +76,9 @@ static void ifb_ri_tasklet(struct taskle
 
 	while ((skb = __skb_dequeue(&txp->tq)) != NULL) {
 		skb->redirected = 0;
+#ifdef CONFIG_NET_CLS_ACT
 		skb->tc_skip_classify = 1;
+#endif
 
 		u64_stats_update_begin(&txp->tsync);
 		txp->tx_packets++;


