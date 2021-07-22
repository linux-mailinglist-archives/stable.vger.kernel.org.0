Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F403D2911
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGVQAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233401AbhGVP66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 767AC61353;
        Thu, 22 Jul 2021 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971971;
        bh=HLNRvvBjnuN0Hz1wec5vFYjOiLsBF/h0EvcK+c+6Wi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogFIJ5Z6jywxibLAI6+xKAVDt+SJq0oT/X+v205Ipux25jBO+KgG5n9eaNrSDK7La
         XzC4CGk+WSnSrmIJZhFaNSZYZ1ucVxtua3ZYWUKULE7PclUapzTIGqr4s+7m4wn+P/
         UhA4cIO3E7L7cdEywP0TyN3LVT2dvjB8C94rie0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        Guolin Yang <gyang@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 097/125] vmxnet3: fix cksum offload issues for tunnels with non-default udp ports
Date:   Thu, 22 Jul 2021 18:31:28 +0200
Message-Id: <20210722155627.922823708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>

commit b22580233d473dbf7bbfa4f6549c09e2c80e9e64 upstream.

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the inner
offload capability is to be restricted to UDP tunnels with default
Vxlan and Geneve ports.

This patch fixes the issue for tunnels with non-default ports using
features check capability and filtering appropriate features for such
tunnels.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -26,6 +26,10 @@
 
 
 #include "vmxnet3_int.h"
+#include <net/vxlan.h>
+#include <net/geneve.h>
+
+#define VXLAN_UDP_PORT 8472
 
 struct vmxnet3_stat_desc {
 	char desc[ETH_GSTRING_LEN];
@@ -277,6 +281,8 @@ netdev_features_t vmxnet3_features_check
 	if (VMXNET3_VERSION_GE_4(adapter) &&
 	    skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 l4_proto = 0;
+		u16 port;
+		struct udphdr *udph;
 
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
@@ -289,8 +295,20 @@ netdev_features_t vmxnet3_features_check
 			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 		}
 
-		if (l4_proto != IPPROTO_UDP)
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			udph = udp_hdr(skb);
+			port = be16_to_cpu(udph->dest);
+			/* Check if offloaded port is supported */
+			if (port != GENEVE_UDP_PORT &&
+			    port != IANA_VXLAN_UDP_PORT &&
+			    port != VXLAN_UDP_PORT) {
+				return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			}
+			break;
+		default:
 			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		}
 	}
 	return features;
 }


