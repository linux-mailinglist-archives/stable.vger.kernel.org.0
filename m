Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46741D857B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgERRyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731303AbgERRy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:54:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8739220715;
        Mon, 18 May 2020 17:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824468;
        bh=daS6GalhjnGYoPZ3TDKNy1AUcN8WR2LaRd4LmL2ZeTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMzwpjn/DgMehKt5ACzyEz2Nm0y2kuucjknlGs3nO+VRUSiCMnnZxkfKqP2ZZ0/IY
         AB6myI22hCyX49y/DY0kH/BdYwT4XIQEvZND/XZKbuSmYdqlVEfMOeK6YRcvc1q2fY
         n2lUN/8oMMh6WN+5Hn4PT4QThqNqUL2eBDkx8VZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?David=20Bala=C5=BEic?= <xerces9@gmail.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 023/147] pppoe: only process PADT targeted at local interfaces
Date:   Mon, 18 May 2020 19:35:46 +0200
Message-Id: <20200518173516.719890797@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit b8c158395119be62294da73646a3953c29ac974b ]

We don't want to disconnect a session because of a stray PADT arriving
while the interface is in promiscuous mode.
Furthermore, multicast and broadcast packets make no sense here, so
only PACKET_HOST is accepted.

Reported-by: David Balažic <xerces9@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/pppoe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -492,6 +492,9 @@ static int pppoe_disc_rcv(struct sk_buff
 	if (!skb)
 		goto out;
 
+	if (skb->pkt_type != PACKET_HOST)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 


