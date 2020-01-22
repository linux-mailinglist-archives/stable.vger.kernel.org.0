Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0B144FF4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbgAVJml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387757AbgAVJml (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222B924687;
        Wed, 22 Jan 2020 09:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686160;
        bh=7B3vAG2RIkwU8Eh5pEf069RrjsX8ed1jhGzTsQLF7V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4U1HGSZhYHY4Ef07smhDjZBH4lQKaveyzCwR6SNhs8RA735u64DwUEl9kpb3Cljx
         DOsFC3lfUagSljHbNMlW0gfjlEqiou9UfsZtPqZhJ4EFH2+SRpWgVK0xnCjr7+jqrS
         4X4X0itG6kqhDOvCnkOAB7ZygnOLMJxFBfRxG9I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 069/103] net: dsa: tag_qca: fix doubled Tx statistics
Date:   Wed, 22 Jan 2020 10:29:25 +0100
Message-Id: <20200122092813.867796961@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
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
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u16 *phdr, hdr;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
 	if (skb_cow_head(skb, 0) < 0)
 		return NULL;
 


