Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A27145020
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387987AbgAVJoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387983AbgAVJoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5368024689;
        Wed, 22 Jan 2020 09:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686243;
        bh=ZtAQn9pOlzRRkNscpDhDOzMr9JNHvexryw/dtfmGIcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eE6CxPvBXpCm96el+Nqu1hbQd0Y64K+KBmFvh3N8EoUVMqBc02+nT8u0EHyFvt2Xe
         GxgbGT8cE9rHdRBG2B3PQpWidVJ9U7u9RfLD1MD+9nPhlnHHGnowzjZ1l4b5pfIFc0
         fsBn2BZw+xWj9Rcmr8jq5Dl9wSYYUDaFPmLX+GN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.19 066/103] batman-adv: Fix DAT candidate selection on little endian systems
Date:   Wed, 22 Jan 2020 10:29:22 +0100
Message-Id: <20200122092813.591204910@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 4cc4a1708903f404d2ca0dfde30e71e052c6cbc9 upstream.

The distributed arp table is using a DHT to store and retrieve MAC address
information for an IP address. This is done using unicast messages to
selected peers. The potential peers are looked up using the IP address and
the VID.

While the IP address is always stored in big endian byte order, this is not
the case of the VID. It can (depending on the host system) either be big
endian or little endian. The host must therefore always convert it to big
endian to ensure that all devices calculate the same peers for the same
lookup data.

Fixes: be1db4f6615b ("batman-adv: make the Distributed ARP Table vlan aware")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/distributed-arp-table.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -251,6 +251,7 @@ static u32 batadv_hash_dat(const void *d
 	u32 hash = 0;
 	const struct batadv_dat_entry *dat = data;
 	const unsigned char *key;
+	__be16 vid;
 	u32 i;
 
 	key = (const unsigned char *)&dat->ip;
@@ -260,7 +261,8 @@ static u32 batadv_hash_dat(const void *d
 		hash ^= (hash >> 6);
 	}
 
-	key = (const unsigned char *)&dat->vid;
+	vid = htons(dat->vid);
+	key = (__force const unsigned char *)&vid;
 	for (i = 0; i < sizeof(dat->vid); i++) {
 		hash += key[i];
 		hash += (hash << 10);


