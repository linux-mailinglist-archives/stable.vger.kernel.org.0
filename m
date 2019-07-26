Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7EA76D9A
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388838AbfGZPct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388558AbfGZPct (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4DD22CC0;
        Fri, 26 Jul 2019 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155168;
        bh=shJTikug5vCmgXdjWixPN2Mt7ygPLs3Sk1CgBOOm6Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCz7GNDo95AuSpQJZ6a+YI8zxgxkV4pLij8p5sx4OqCL6i5Y0iJD/WFRA0w/vryjX
         jzuAWInBZauhMeMrWgZzHZM2I8cKEKKH1kXON6ldnpbxAXmzzbUmQmNGnlQbE4AZ8E
         sVNs8Kg1hlTuvQy0BfWdZ6y4R6bE/k1hF2k7VHq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 25/50] macsec: fix use-after-free of skb during RX
Date:   Fri, 26 Jul 2019 17:25:00 +0200
Message-Id: <20190726152303.159709857@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Steinmetz <ast@domdv.de>

[ Upstream commit 095c02da80a41cf6d311c504d8955d6d1c2add10 ]

Fix use-after-free of skb when rx_handler returns RX_HANDLER_PASS.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1103,10 +1103,9 @@ static rx_handler_result_t macsec_handle
 	}
 
 	skb = skb_unshare(skb, GFP_ATOMIC);
-	if (!skb) {
-		*pskb = NULL;
+	*pskb = skb;
+	if (!skb)
 		return RX_HANDLER_CONSUMED;
-	}
 
 	pulled_sci = pskb_may_pull(skb, macsec_extra_len(true));
 	if (!pulled_sci) {


