Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9C014B985
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733078AbgA1OZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732685AbgA1OZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:25:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F692071E;
        Tue, 28 Jan 2020 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221547;
        bh=WOzg1VHjGzAsOAm8nzNjjHEfGl3A5OKtibNtSXTdt2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBv57GNPBDP3i22SWn1pAf1+RJyYuW8vX9S+hH0Smewik03zpcNyAks91YKQ/IqTq
         kbpJI5B1rvobdmsZhkBC1fePA37FgCMXOimdJ/NFFXgCtw4vAquRY1nelNpjJzDU5m
         Q8dAs7y9mRTfdYCaAUUzGfJU7+WPMa43AumVeFg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 232/271] net: ethtool: Add back transceiver type
Date:   Tue, 28 Jan 2020 15:06:21 +0100
Message-Id: <20200128135909.838035237@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 19cab8872692960535aa6d12e3a295ac51d1a648 upstream.

Commit 3f1ac7a700d0 ("net: ethtool: add new ETHTOOL_xLINKSETTINGS API")
deprecated the ethtool_cmd::transceiver field, which was fine in
premise, except that the PHY library was actually using it to report the
type of transceiver: internal or external.

Use the first word of the reserved field to put this __u8 transceiver
field back in. It is made read-only, and we don't expect the
ETHTOOL_xLINKSETTINGS API to be doing anything with this anyway, so this
is mostly for the legacy path where we do:

ethtool_get_settings()
-> dev->ethtool_ops->get_link_ksettings()
   -> convert_link_ksettings_to_legacy_settings()

to have no information loss compared to the legacy get_settings API.

Fixes: 3f1ac7a700d0 ("net: ethtool: add new ETHTOOL_xLINKSETTINGS API")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/ethtool.h |    6 +++++-
 net/core/ethtool.c           |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1687,6 +1687,8 @@ enum ethtool_reset_flags {
  *	%ethtool_link_mode_bit_indices for the link modes, and other
  *	link features that the link partner advertised through
  *	autonegotiation; 0 if unknown or not applicable.  Read-only.
+ * @transceiver: Used to distinguish different possible PHY types,
+ *	reported consistently by PHYLIB.  Read-only.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
  * fixed link mode and are writable if the driver supports multiple
@@ -1738,7 +1740,9 @@ struct ethtool_link_settings {
 	__u8	eth_tp_mdix;
 	__u8	eth_tp_mdix_ctrl;
 	__s8	link_mode_masks_nwords;
-	__u32	reserved[8];
+	__u8	transceiver;
+	__u8	reserved1[3];
+	__u32	reserved[7];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
 	 * __u32 map_supported[link_mode_masks_nwords];
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -514,6 +514,8 @@ convert_link_ksettings_to_legacy_setting
 		= link_ksettings->base.eth_tp_mdix;
 	legacy_settings->eth_tp_mdix_ctrl
 		= link_ksettings->base.eth_tp_mdix_ctrl;
+	legacy_settings->transceiver
+		= link_ksettings->base.transceiver;
 	return retval;
 }
 


