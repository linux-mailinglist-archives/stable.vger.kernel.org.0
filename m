Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EEA1D81DD
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgERRvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbgERRuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7981820674;
        Mon, 18 May 2020 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824236;
        bh=S2PjfQJo09RQhAQV6KCBLCWeUPBTH9UMZI6xUNXjn7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3Yj1jUpdLUlgi5mjJhPge+c9IAV5sbQJSxnzLROZfE/0WgJL3hbT0CJ7yPotL43s
         4uMb7CYWJO595/u/ArpG3zclP2Mywy7SIhPO35DNX9EGMnVChXsYwsBFDtNrh76Awv
         qjR8d+NGh7Jcu9FBTHlKEXP2dEpFuHJPttdho7V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?David=20Bala=C5=BEic?= <xerces9@gmail.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/80] pppoe: only process PADT targeted at local interfaces
Date:   Mon, 18 May 2020 19:36:30 +0200
Message-Id: <20200518173452.813559136@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
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
@@ -497,6 +497,9 @@ static int pppoe_disc_rcv(struct sk_buff
 	if (!skb)
 		goto out;
 
+	if (skb->pkt_type != PACKET_HOST)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 


