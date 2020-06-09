Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835B21F42C2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbgFIRrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:47:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732061AbgFIRrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0D6207F9;
        Tue,  9 Jun 2020 17:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724840;
        bh=uxgkLmEM+qRpdRQoAjDFTn3eJyZ9H2fvH5ojL6T9T60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMesLuVscIlxMrGCM4cUiH3H70+KmQIqJ6g019syGzvn+MkygQ5FxRQJa7tuQxb3O
         SFqs0Z9hbAT0p8tQTtVSX2DN5FcVfLtn/VIFMPLNKzbA1a7bRqWiRP9vxa5zRnLAqI
         vwwjDHIoH8b5MjIlyB4MsyHMl/8BC7RR4JlSXaN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?David=20Bala=C5=BEic?= <xerces9@gmail.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 14/36] pppoe: only process PADT targeted at local interfaces
Date:   Tue,  9 Jun 2020 19:44:14 +0200
Message-Id: <20200609173934.094297589@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609173933.288044334@linuxfoundation.org>
References: <20200609173933.288044334@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

We don't want to disconnect a session because of a stray PADT arriving
while the interface is in promiscuous mode.
Furthermore, multicast and broadcast packets make no sense here, so
only PACKET_HOST is accepted.

Reported-by: David Balažic <xerces9@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ppp/pppoe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -494,6 +494,9 @@ static int pppoe_disc_rcv(struct sk_buff
 	if (!skb)
 		goto out;
 
+	if (skb->pkt_type != PACKET_HOST)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 


