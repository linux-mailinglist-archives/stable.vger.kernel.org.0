Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEECC29C351
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902137AbgJ0Oaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901946AbgJ0O3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22AF32222C;
        Tue, 27 Oct 2020 14:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808982;
        bh=c/9wlfARBEJpTCpm3PS07TAi8NtXw+RfVjcsG7o0TFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4VkuCXcYHqP4YrRtLdQOThujfeJUstWMA+cBvCqBCqkH2JVeUvXx/6Z+EdNN5Pb2
         YYEkcKGvd6R0+jjE4nz7ya1K0EcBpTBZf7bqVRj0y23Y6Vw8QLScMS6MwKX8P+mNie
         fqhkB8duuYaiZ+sN7ECYsznFWLUPrJW0CWZkkCAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 015/408] net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt
Date:   Tue, 27 Oct 2020 14:49:13 +0100
Message-Id: <20201027135455.763990155@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 13ba4c434422837d7c8c163f9c8d854e67bf3c99 ]

This patch add the initialization of skbcnt, similar to:

    e009f95b1543 can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbcnt

Let's play save and initialize this skbcnt as well.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1488,6 +1488,7 @@ j1939_session *j1939_session_fresh_new(s
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 


