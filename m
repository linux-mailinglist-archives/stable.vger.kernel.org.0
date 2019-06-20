Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF94D705
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfFTSPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbfFTSPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:15:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F9721655;
        Thu, 20 Jun 2019 18:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054504;
        bh=7Jwudyk8gLrRqbOd0GnOM9PbiioVLQlwYWYtl1inm6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7ebzLXkeYWfWJfzBVXE9y2pJFtjelgaOvSCDpUbNEDgmtGJZgsxBqR04klMniltI
         RtlfJNyJPmOFHt96Ji7tVNZ5WxFu83rcL/bAhRiZ5M18n8YMGORCMI6ES7+YZwJ0D/
         JkmGpa12j6sjvkXeq93/74L66FnXBz7FtKdnY7qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 22/98] net: ethtool: Allow matching on vlan DEI bit
Date:   Thu, 20 Jun 2019 19:56:49 +0200
Message-Id: <20190620174350.214938409@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit f0d2ca1531377e7da888913e277eefac05a59b6f ]

Using ethtool, users can specify a classification action matching on the
full vlan tag, which includes the DEI bit (also previously called CFI).

However, when converting the ethool_flow_spec to a flow_rule, we use
dissector keys to represent the matching patterns.

Since the vlan dissector key doesn't include the DEI bit, this
information was silently discarded when translating the ethtool
flow spec in to a flow_rule.

This commit adds the DEI bit into the vlan dissector key, and allows
propagating the information to the driver when parsing the ethtool flow
spec.

Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")
Reported-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/flow_dissector.h |    1 +
 net/core/ethtool.c           |    5 +++++
 2 files changed, 6 insertions(+)

--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -46,6 +46,7 @@ struct flow_dissector_key_tags {
 
 struct flow_dissector_key_vlan {
 	u16	vlan_id:12,
+		vlan_dei:1,
 		vlan_priority:3;
 	__be16	vlan_tpid;
 };
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -3022,6 +3022,11 @@ ethtool_rx_flow_rule_create(const struct
 			match->mask.vlan.vlan_id =
 				ntohs(ext_m_spec->vlan_tci) & 0x0fff;
 
+			match->key.vlan.vlan_dei =
+				!!(ext_h_spec->vlan_tci & htons(0x1000));
+			match->mask.vlan.vlan_dei =
+				!!(ext_m_spec->vlan_tci & htons(0x1000));
+
 			match->key.vlan.vlan_priority =
 				(ntohs(ext_h_spec->vlan_tci) & 0xe000) >> 13;
 			match->mask.vlan.vlan_priority =


