Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E12199052
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgCaJLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731655AbgCaJLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:11:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04A112072E;
        Tue, 31 Mar 2020 09:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645860;
        bh=Ir31/0y8fSK9qMMblVvVjGAsuQJhSa9cPlV8ZpRPg5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqgzl7u9/8Y7nafs38pS6JC7XrMXCi6qFl6tjv9Utg2c1pJJkDhW85oYPYN1UXGe5
         n2W/dCEhe7a/oKcEC4zAzxwHhBVzSOmG56SVkDu8M5SlTOJdHbpumOQrTJiDCJfO5b
         ThfozFnlkJUgxq7ipmul/h6em59aVQPjI2iiOMJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 017/155] net: dsa: Fix duplicate frames flooded by learning
Date:   Tue, 31 Mar 2020 10:57:37 +0200
Message-Id: <20200331085420.308929573@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 0e62f543bed03a64495bd2651d4fe1aa4bcb7fe5 ]

When both the switch and the bridge are learning about new addresses,
switch ports attached to the bridge would see duplicate ARP frames
because both entities would attempt to send them.

Fixes: 5037d532b83d ("net: dsa: add Broadcom tag RX/TX handler")
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_brcm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -140,6 +140,8 @@ static struct sk_buff *brcm_tag_rcv_ll(s
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
+	skb->offload_fwd_mark = 1;
+
 	return skb;
 }
 #endif


