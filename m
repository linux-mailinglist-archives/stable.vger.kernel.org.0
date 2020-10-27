Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E7129B962
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802431AbgJ0Pse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901017AbgJ0PSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D742064B;
        Tue, 27 Oct 2020 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811904;
        bh=c/9wlfARBEJpTCpm3PS07TAi8NtXw+RfVjcsG7o0TFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tem1KIf8/J1zRaqlfFytUX0om6Ivn0D6jjEyL1Wy1By4jsfgh7lITU5a5aG9U6gB4
         gb7AWTV77AmoKm3zjBrleNun6NirrY4PgbUs5JbR+zImGRT8CnI8k8N7+elBi3tJC3
         sjW0zQMBngLeVZeQ3igs7seASt6h8C4oUqx7QHbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.9 024/757] net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt
Date:   Tue, 27 Oct 2020 14:44:34 +0100
Message-Id: <20201027135451.656263232@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
 


