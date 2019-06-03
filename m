Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8982C32C1C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfFCJNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfFCJNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A40527ECE;
        Mon,  3 Jun 2019 09:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553226;
        bh=zz6nIc3k7gAyUWzdxWk2pdSynpiasWuI7dZG9CC/uf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe+sSENlEHnXIyyfzJhztzE3Cs5YWCfDbOVCTm5eHV/hr413Im33rkyecmKoT71r/
         dGsVADvSy817s2+zGnQGXEJRNdGGgNSsDpubDNst1Y59J5ViNwPWrUPww06TYPz0/8
         HdyqPKupIvNozb+X4OGUgASkTsd7LcynFnaFNKMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Pablo Neira Ayuso <pablo@gnumonks.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 03/40] ethtool: Check for vlan etype or vlan tci when parsing flow_rule
Date:   Mon,  3 Jun 2019 11:08:56 +0200
Message-Id: <20190603090522.833590318@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit b73484b2fc0d0ba84a13e9d86eb4adcae718163b ]

When parsing an ethtool flow spec to build a flow_rule, the code checks
if both the vlan etype and the vlan tci are specified by the user to add
a FLOW_DISSECTOR_KEY_VLAN match.

However, when the user only specified a vlan etype or a vlan tci, this
check silently ignores these parameters.

For example, the following rule :

ethtool -N eth0 flow-type udp4 vlan 0x0010 action -1 loc 0

will result in no error being issued, but the equivalent rule will be
created and passed to the NIC driver :

ethtool -N eth0 flow-type udp4 action -1 loc 0

In the end, neither the NIC driver using the rule nor the end user have
a way to know that these keys were dropped along the way, or that
incorrect parameters were entered.

This kind of check should be left to either the driver, or the ethtool
flow spec layer.

This commit makes so that ethtool parameters are forwarded as-is to the
NIC driver.

Since none of the users of ethtool_rx_flow_rule_create are using the
VLAN dissector, I don't think this qualifies as a regression.

Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Pablo Neira Ayuso <pablo@gnumonks.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/ethtool.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -3008,11 +3008,12 @@ ethtool_rx_flow_rule_create(const struct
 		const struct ethtool_flow_ext *ext_h_spec = &fs->h_ext;
 		const struct ethtool_flow_ext *ext_m_spec = &fs->m_ext;
 
-		if (ext_m_spec->vlan_etype &&
-		    ext_m_spec->vlan_tci) {
+		if (ext_m_spec->vlan_etype) {
 			match->key.vlan.vlan_tpid = ext_h_spec->vlan_etype;
 			match->mask.vlan.vlan_tpid = ext_m_spec->vlan_etype;
+		}
 
+		if (ext_m_spec->vlan_tci) {
 			match->key.vlan.vlan_id =
 				ntohs(ext_h_spec->vlan_tci) & 0x0fff;
 			match->mask.vlan.vlan_id =
@@ -3022,7 +3023,10 @@ ethtool_rx_flow_rule_create(const struct
 				(ntohs(ext_h_spec->vlan_tci) & 0xe000) >> 13;
 			match->mask.vlan.vlan_priority =
 				(ntohs(ext_m_spec->vlan_tci) & 0xe000) >> 13;
+		}
 
+		if (ext_m_spec->vlan_etype ||
+		    ext_m_spec->vlan_tci) {
 			match->dissector.used_keys |=
 				BIT(FLOW_DISSECTOR_KEY_VLAN);
 			match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =


