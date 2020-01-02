Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD612F0EB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgABWRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:17:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgABWRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8421B21582;
        Thu,  2 Jan 2020 22:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003469;
        bh=3n6JM98xtiy1uktHS2Nh3Xj8yhMLZGMcf6245t9TvHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5mcARcVrvkSJXLyc0eaVQwJjYkTqQWrazdleUPgqUMnUpjFzPW3gRaLFdyhFAPv6
         KN4jNprohn57z0LgFGLBz0Lm3YHoOOKzWi+aYB7rWNKR1cReLDje2vM+AAQOMB3gAP
         3xfKxVseG3xXP1LsT3qDqrho6Bb1/hKkkDctZqLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Surendra Mobiya <surendra@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 147/191] cxgb4/cxgb4vf: fix flow control display for auto negotiation
Date:   Thu,  2 Jan 2020 23:07:09 +0100
Message-Id: <20200102215845.254839525@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 0caeaf6ad532f9be5a768a158627cb31921cc8b7 ]

As per 802.3-2005, Section Two, Annex 28B, Table 28B-2 [1], when
_only_ Rx pause is enabled, both symmetric and asymmetric pause
towards local device must be enabled. Also, firmware returns the local
device's flow control pause params as part of advertised capabilities
and negotiated params as part of current link attributes. So, fix up
ethtool's flow control pause params fetch logic to read from acaps,
instead of linkattr.

[1] https://standards.ieee.org/standard/802_3-2005.html

Fixes: c3168cabe1af ("cxgb4/cxgbvf: Handle 32-bit fw port capabilities")
Signed-off-by: Surendra Mobiya <surendra@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h          |    1 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c  |    4 +--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c          |   21 ++++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c |    4 +--
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h  |    1 
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c      |   18 ++++++++++-------
 6 files changed, 30 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -503,6 +503,7 @@ struct link_config {
 
 	enum cc_pause  requested_fc;     /* flow control user has requested */
 	enum cc_pause  fc;               /* actual link flow control */
+	enum cc_pause  advertised_fc;    /* actual advertised flow control */
 
 	enum cc_fec    requested_fec;	 /* Forward Error Correction: */
 	enum cc_fec    fec;		 /* requested and actual in use */
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -793,8 +793,8 @@ static void get_pauseparam(struct net_de
 	struct port_info *p = netdev_priv(dev);
 
 	epause->autoneg = (p->link_cfg.requested_fc & PAUSE_AUTONEG) != 0;
-	epause->rx_pause = (p->link_cfg.fc & PAUSE_RX) != 0;
-	epause->tx_pause = (p->link_cfg.fc & PAUSE_TX) != 0;
+	epause->rx_pause = (p->link_cfg.advertised_fc & PAUSE_RX) != 0;
+	epause->tx_pause = (p->link_cfg.advertised_fc & PAUSE_TX) != 0;
 }
 
 static int set_pauseparam(struct net_device *dev,
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -4089,7 +4089,8 @@ static inline fw_port_cap32_t cc_to_fwca
 		if (cc_pause & PAUSE_TX)
 			fw_pause |= FW_PORT_CAP32_802_3_PAUSE;
 		else
-			fw_pause |= FW_PORT_CAP32_802_3_ASM_DIR;
+			fw_pause |= FW_PORT_CAP32_802_3_ASM_DIR |
+				    FW_PORT_CAP32_802_3_PAUSE;
 	} else if (cc_pause & PAUSE_TX) {
 		fw_pause |= FW_PORT_CAP32_802_3_ASM_DIR;
 	}
@@ -8563,17 +8564,17 @@ static fw_port_cap32_t lstatus_to_fwcap(
 void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 {
 	const struct fw_port_cmd *cmd = (const void *)rpl;
-	int action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
-	struct adapter *adapter = pi->adapter;
+	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
 	struct link_config *lc = &pi->link_cfg;
-	int link_ok, linkdnrc;
-	enum fw_port_type port_type;
+	struct adapter *adapter = pi->adapter;
+	unsigned int speed, fc, fec, adv_fc;
 	enum fw_port_module_type mod_type;
-	unsigned int speed, fc, fec;
-	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
+	int action, link_ok, linkdnrc;
+	enum fw_port_type port_type;
 
 	/* Extract the various fields from the Port Information message.
 	 */
+	action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
 	switch (action) {
 	case FW_PORT_ACTION_GET_PORT_INFO: {
 		u32 lstatus = be32_to_cpu(cmd->u.info.lstatus_to_modtype);
@@ -8611,6 +8612,7 @@ void t4_handle_get_port_info(struct port
 	}
 
 	fec = fwcap_to_cc_fec(acaps);
+	adv_fc = fwcap_to_cc_pause(acaps);
 	fc = fwcap_to_cc_pause(linkattr);
 	speed = fwcap_to_speed(linkattr);
 
@@ -8667,7 +8669,9 @@ void t4_handle_get_port_info(struct port
 	}
 
 	if (link_ok != lc->link_ok || speed != lc->speed ||
-	    fc != lc->fc || fec != lc->fec) {	/* something changed */
+	    fc != lc->fc || adv_fc != lc->advertised_fc ||
+	    fec != lc->fec) {
+		/* something changed */
 		if (!link_ok && lc->link_ok) {
 			lc->link_down_rc = linkdnrc;
 			dev_warn_ratelimited(adapter->pdev_dev,
@@ -8677,6 +8681,7 @@ void t4_handle_get_port_info(struct port
 		}
 		lc->link_ok = link_ok;
 		lc->speed = speed;
+		lc->advertised_fc = adv_fc;
 		lc->fc = fc;
 		lc->fec = fec;
 
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1690,8 +1690,8 @@ static void cxgb4vf_get_pauseparam(struc
 	struct port_info *pi = netdev_priv(dev);
 
 	pauseparam->autoneg = (pi->link_cfg.requested_fc & PAUSE_AUTONEG) != 0;
-	pauseparam->rx_pause = (pi->link_cfg.fc & PAUSE_RX) != 0;
-	pauseparam->tx_pause = (pi->link_cfg.fc & PAUSE_TX) != 0;
+	pauseparam->rx_pause = (pi->link_cfg.advertised_fc & PAUSE_RX) != 0;
+	pauseparam->tx_pause = (pi->link_cfg.advertised_fc & PAUSE_TX) != 0;
 }
 
 /*
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
@@ -135,6 +135,7 @@ struct link_config {
 
 	enum cc_pause	requested_fc;	/* flow control user has requested */
 	enum cc_pause	fc;		/* actual link flow control */
+	enum cc_pause   advertised_fc;  /* actual advertised flow control */
 
 	enum cc_fec	auto_fec;	/* Forward Error Correction: */
 	enum cc_fec	requested_fec;	/*   "automatic" (IEEE 802.3), */
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -1913,16 +1913,16 @@ static const char *t4vf_link_down_rc_str
 static void t4vf_handle_get_port_info(struct port_info *pi,
 				      const struct fw_port_cmd *cmd)
 {
-	int action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
-	struct adapter *adapter = pi->adapter;
+	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
 	struct link_config *lc = &pi->link_cfg;
-	int link_ok, linkdnrc;
-	enum fw_port_type port_type;
+	struct adapter *adapter = pi->adapter;
+	unsigned int speed, fc, fec, adv_fc;
 	enum fw_port_module_type mod_type;
-	unsigned int speed, fc, fec;
-	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
+	int action, link_ok, linkdnrc;
+	enum fw_port_type port_type;
 
 	/* Extract the various fields from the Port Information message. */
+	action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
 	switch (action) {
 	case FW_PORT_ACTION_GET_PORT_INFO: {
 		u32 lstatus = be32_to_cpu(cmd->u.info.lstatus_to_modtype);
@@ -1982,6 +1982,7 @@ static void t4vf_handle_get_port_info(st
 	}
 
 	fec = fwcap_to_cc_fec(acaps);
+	adv_fc = fwcap_to_cc_pause(acaps);
 	fc = fwcap_to_cc_pause(linkattr);
 	speed = fwcap_to_speed(linkattr);
 
@@ -2012,7 +2013,9 @@ static void t4vf_handle_get_port_info(st
 	}
 
 	if (link_ok != lc->link_ok || speed != lc->speed ||
-	    fc != lc->fc || fec != lc->fec) {	/* something changed */
+	    fc != lc->fc || adv_fc != lc->advertised_fc ||
+	    fec != lc->fec) {
+		/* something changed */
 		if (!link_ok && lc->link_ok) {
 			lc->link_down_rc = linkdnrc;
 			dev_warn_ratelimited(adapter->pdev_dev,
@@ -2022,6 +2025,7 @@ static void t4vf_handle_get_port_info(st
 		}
 		lc->link_ok = link_ok;
 		lc->speed = speed;
+		lc->advertised_fc = adv_fc;
 		lc->fc = fc;
 		lc->fec = fec;
 


