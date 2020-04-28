Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FE61BCB84
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgD1S3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgD1S3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D290C20730;
        Tue, 28 Apr 2020 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098563;
        bh=BXPBF0HCqDhjEuLrlipSEpJlmx9iG2t73J30Yda2roE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=io9bwbM/xaoJVp1+XnGXJxRgom67PwqZP2NPznG3rUsOguf/h5T1+hOFMSNjMgO2V
         2CwTqEUXPe1vdfVOs75ucMKV2sw2+QtWVbqtS+mfQJrcgWjvSRHmK6ZXkh3084BVIN
         ZW42S7qfgfUbd1shRSUShgmcsHtivV77h0sGcb5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trev Larock <trev@larock.ca>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 073/167] vrf: Check skb for XFRM_TRANSFORMED flag
Date:   Tue, 28 Apr 2020 20:24:09 +0200
Message-Id: <20200428182234.157712774@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 16b9db1ce34ff00d6c18e82825125cfef0cdfb13 ]

To avoid a loop with qdiscs and xfrms, check if the skb has already gone
through the qdisc attached to the VRF device and then to the xfrm layer.
If so, no need for a second redirect.

Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
Reported-by: Trev Larock <trev@larock.ca>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -474,7 +474,8 @@ static struct sk_buff *vrf_ip6_out(struc
 	if (rt6_need_strict(&ipv6_hdr(skb)->daddr))
 		return skb;
 
-	if (qdisc_tx_is_default(vrf_dev))
+	if (qdisc_tx_is_default(vrf_dev) ||
+	    IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
 		return vrf_ip6_out_direct(vrf_dev, sk, skb);
 
 	return vrf_ip6_out_redirect(vrf_dev, skb);
@@ -686,7 +687,8 @@ static struct sk_buff *vrf_ip_out(struct
 	    ipv4_is_lbcast(ip_hdr(skb)->daddr))
 		return skb;
 
-	if (qdisc_tx_is_default(vrf_dev))
+	if (qdisc_tx_is_default(vrf_dev) ||
+	    IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
 		return vrf_ip_out_direct(vrf_dev, sk, skb);
 
 	return vrf_ip_out_redirect(vrf_dev, skb);


