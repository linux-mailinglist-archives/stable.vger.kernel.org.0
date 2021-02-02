Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF4130BFCC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhBBNmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232643AbhBBNkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:40:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D84B64ECF;
        Tue,  2 Feb 2021 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273174;
        bh=G1vWfuPLtO+6mrl0E/X5FPQ2dhucrqI1x+BbgCjv2MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo9nlJZQW+DvEPW3CzNumCa63oUd+oMRssgo1gY6je5WMIj/NX7D/61BheoaH/sjQ
         Icd3is9AKa/q9w/j5cf7+bQHnvijQZ9mh68U4+Scmh7v1WJER6lFiZyWrJR878NhrU
         ySqVY15MrxoaCzJqwIiQV4mW7B9YE4d1zn65cze8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ben Greear <greearb@candelatech.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Robert Hancock <hancockrwd@gmail.com>
Subject: [PATCH 5.10 001/142] iwlwifi: provide gso_type to GSO packets
Date:   Tue,  2 Feb 2021 14:36:04 +0100
Message-Id: <20210202132957.752590365@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 81a86e1bd8e7060ebba1718b284d54f1238e9bf9 upstream.

net/core/tso.c got recent support for USO, and this broke iwlfifi
because the driver implemented a limited form of GSO.

Providing ->gso_type allows for skb_is_gso_tcp() to provide
a correct result.

Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209913
Link: https://lore.kernel.org/r/20210125150949.619309-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -833,6 +833,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *s
 
 	next = skb_gso_segment(skb, netdev_flags);
 	skb_shinfo(skb)->gso_size = mss;
+	skb_shinfo(skb)->gso_type = ipv4 ? SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
 	if (WARN_ON_ONCE(IS_ERR(next)))
 		return -EINVAL;
 	else if (next)
@@ -855,6 +856,8 @@ iwl_mvm_tx_tso_segment(struct sk_buff *s
 
 		if (tcp_payload_len > mss) {
 			skb_shinfo(tmp)->gso_size = mss;
+			skb_shinfo(tmp)->gso_type = ipv4 ? SKB_GSO_TCPV4 :
+							   SKB_GSO_TCPV6;
 		} else {
 			if (qos) {
 				u8 *qc;


