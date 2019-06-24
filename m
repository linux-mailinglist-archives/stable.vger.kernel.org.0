Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CCE5084B
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbfFXKQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730716AbfFXKQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:19 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FE2205ED;
        Mon, 24 Jun 2019 10:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371379;
        bh=ItG58oxo55y7vmAp93rhq5C1zB1HpbpQeHMneZJ8HRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUpoiYiAhNlo8FjLoNJZA3kycTbkwJJFs2jpNbOWc4aAE/9dZHf3XszU07QFAlUl+
         kmZg5zg9iYnoxwYujFh2x3np7XVjZFcWFwLfw3qJ95elJDvCHpPT3OXwpRw63Q7me/
         2el5ezBZVDQ+JgDNjTamzyyBQIJHLciEz/MhSWoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 082/121] s390/qeth: handle limited IPv4 broadcast in L3 TX path
Date:   Mon, 24 Jun 2019 17:56:54 +0800
Message-Id: <20190624092325.041131363@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 72c87976c5abbf8a834ad85f10d03c0cd58b985c ]

When selecting the cast type of a neighbourless IPv4 skb (eg. on a raw
socket), qeth_l3 falls back to the packet's destination IP address.
For this case we should classify traffic sent to 255.255.255.255 as
broadcast.
This fixes DHCP requests, which were misclassified as unicast
(and for IQD interfaces thus ended up on the wrong HW queue).

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l3_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 53712cf26406..cb641fd303d3 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1906,6 +1906,8 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 	/* no neighbour (eg AF_PACKET), fall back to target's IP address ... */
 	switch (qeth_get_ip_version(skb)) {
 	case 4:
+		if (ipv4_is_lbcast(ip_hdr(skb)->daddr))
+			return RTN_BROADCAST;
 		return ipv4_is_multicast(ip_hdr(skb)->daddr) ?
 				RTN_MULTICAST : RTN_UNICAST;
 	case 6:
-- 
2.20.1



