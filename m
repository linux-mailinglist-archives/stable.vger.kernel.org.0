Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0444E1CAF51
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgEHNQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbgEHMoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB47021974;
        Fri,  8 May 2020 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941870;
        bh=lbi4H41BSD2GduzmkGWXkVWkVYMWEtihHI4wer6yx9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuvAMw5+tlTCSgGqRcXDIKZOCiHuDYarvrPAAGXFX2v2UyiC1PFZ2JmtCOgkSgXfa
         zQnsWVL93a3pwYI38X/VJM/24PsidOeSnCSdbnWaUWviyFXbc/Itk9QPXAkIoaUQFP
         MBbTEcrKqwduCeBM3/Aoi+v7Vhf1Mzntfd/D+93c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Duyck <aduyck@mirantis.com>,
        Tom Herbert <tom@herbertland.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 188/312] flow_dissector: Check for IP fragmentation even if not using IPv4 address
Date:   Fri,  8 May 2020 14:32:59 +0200
Message-Id: <20200508123137.693611173@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <aduyck@mirantis.com>

commit 918c023f29ab2dd8c63cfcc6a1239ee15933871a upstream.

This patch corrects the logic for the IPv4 parsing so that it is consistent
with how we handle IPv6.  Specifically if we do not have the flow key
indicating we want the addresses we still may need to take a look at the IP
fragmentation bits and to see if we should stop after we have recognized
the L3 header.

Fixes: 807e165dc44f ("flow_dissector: Add control/reporting of fragmentation")
Signed-off-by: Alexander Duyck <aduyck@mirantis.com>
Acked-by: Tom Herbert <tom@herbertland.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/flow_dissector.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -178,15 +178,16 @@ ip:
 
 		ip_proto = iph->protocol;
 
-		if (!dissector_uses_key(flow_dissector,
-					FLOW_DISSECTOR_KEY_IPV4_ADDRS))
-			break;
+		if (dissector_uses_key(flow_dissector,
+				       FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+			key_addrs = skb_flow_dissector_target(flow_dissector,
+							      FLOW_DISSECTOR_KEY_IPV4_ADDRS,
+							      target_container);
 
-		key_addrs = skb_flow_dissector_target(flow_dissector,
-			      FLOW_DISSECTOR_KEY_IPV4_ADDRS, target_container);
-		memcpy(&key_addrs->v4addrs, &iph->saddr,
-		       sizeof(key_addrs->v4addrs));
-		key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+			memcpy(&key_addrs->v4addrs, &iph->saddr,
+			       sizeof(key_addrs->v4addrs));
+			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		}
 
 		if (ip_is_fragment(iph)) {
 			key_control->flags |= FLOW_DIS_IS_FRAGMENT;


