Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881D82DEF35
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgLSNAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgLSM7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:51 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 29/49] ch_ktls: fix build warning for ipv4-only config
Date:   Sat, 19 Dec 2020 13:58:33 +0100
Message-Id: <20201219125346.104892973@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a54ba3465d86fa5dd7d41bb88c0b5e71fb3b627e ]

When CONFIG_IPV6 is disabled, clang complains that a variable
is uninitialized for non-IPv4 data:

drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1046:6: error: variable 'cntrl1' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (tx_info->ip_family == AF_INET) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c:1059:2: note: uninitialized use occurs here
        cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
        ^~~~~~

Replace the preprocessor conditional with the corresponding C version,
and make the ipv4 case unconditional in this configuration to improve
readability and avoid the warning.

Fixes: 86716b51d14f ("ch_ktls: Update cheksum information")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201203222641.964234-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chcr_ktls.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -921,9 +921,7 @@ chcr_ktls_write_tcp_options(struct chcr_
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
 	u32 ctrl, iplen, maclen;
-#if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *ip6;
-#endif
 	unsigned int ndesc;
 	struct tcphdr *tcp;
 	int len16, pktlen;
@@ -971,17 +969,15 @@ chcr_ktls_write_tcp_options(struct chcr_
 	cpl->len = htons(pktlen);
 
 	memcpy(buf, skb->data, pktlen);
-	if (tx_info->ip_family == AF_INET) {
+	if (!IS_ENABLED(CONFIG_IPV6) || tx_info->ip_family == AF_INET) {
 		/* we need to correct ip header len */
 		ip = (struct iphdr *)(buf + maclen);
 		ip->tot_len = htons(pktlen - maclen);
 		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP);
-#if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
 		ip6->payload_len = htons(pktlen - maclen - iplen);
 		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP6);
-#endif
 	}
 
 	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |


