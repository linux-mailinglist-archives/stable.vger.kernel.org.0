Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C042144F8B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732757AbgAVJi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732769AbgAVJi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C242467E;
        Wed, 22 Jan 2020 09:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685936;
        bh=jlwuOc04JQ/mlkGK+K25zV2RTSgLEUG02HcCGOeRKdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCuv0VlvHhIASNl8ARt17H5ojjbeNXbWaoPPsafE7PqsCqpUCXd907E2vE7KcDOUw
         1rf6030EttarspBFD6V5yJxZKe6IlGJ0Q/ZUW/xVcfJFmMTX3cOIlTCSTzZAuLZtHo
         xVyTCOI0092MBwJuyd0MPbG4HZFruevsbxMIE9Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 43/65] net: dsa: tag_qca: fix doubled Tx statistics
Date:   Wed, 22 Jan 2020 10:29:28 +0100
Message-Id: <20200122092757.188372831@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

[ Upstream commit bd5874da57edd001b35cf28ae737779498c16a56 ]

DSA subsystem takes care of netdev statistics since commit 4ed70ce9f01c
("net: dsa: Refactor transmit path to eliminate duplication"), so
any accounting inside tagger callbacks is redundant and can lead to
messing up the stats.
This bug is present in Qualcomm tagger since day 0.

Fixes: cafdc45c949b ("net-next: dsa: add Qualcomm tag RX/TX handler")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_qca.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -41,9 +41,6 @@ static struct sk_buff *qca_tag_xmit(stru
 	struct dsa_slave_priv *p = netdev_priv(dev);
 	u16 *phdr, hdr;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
 	if (skb_cow_head(skb, 0) < 0)
 		return NULL;
 


