Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C19199119
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgCaJRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732012AbgCaJRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60405208E0;
        Tue, 31 Mar 2020 09:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646230;
        bh=TrQ9bXYqDqJZn6xqBTJRNSepK0YrBxb6BXjVJP/ryjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doEIbTNK9SvAicWzmFmZS8OxPTk9L+/yhDb/XxTN8pavbBeANzRDExN7Fzyw3qTPE
         nDPS6A0eve7jMJxAp+1/o/+89gjGibz3dAmePSoXG+dhNo/Qp4PK6zg6tCjafaUiSA
         IxgjCfZ6XdLmtt0Xkdohmuj888L1ZDurasYGPEEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 123/155] mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX
Date:   Tue, 31 Mar 2020 10:59:23 +0200
Message-Id: <20200331085432.156275849@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit b95d2ccd2ccb834394d50347d0e40dc38a954e4a upstream.

When a frame is transmitted via the nl80211 TX rather than as a
normal frame, IEEE80211_TX_CTRL_PORT_CTRL_PROTO wasn't set and
this will lead to wrong decisions (rate control etc.) being made
about the frame; fix this.

Fixes: 911806491425 ("mac80211: Add support for tx_control_port")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200326155333.f183f52b02f0.I4054e2a8c11c2ddcb795a0103c87be3538690243@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018, 2020 Intel Corporation
  *
  * Transmit and frame generation functions.
  */
@@ -5067,6 +5067,7 @@ int ieee80211_tx_control_port(struct wip
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ethhdr *ehdr;
+	u32 ctrl_flags = 0;
 	u32 flags;
 
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
@@ -5076,6 +5077,9 @@ int ieee80211_tx_control_port(struct wip
 	    proto != cpu_to_be16(ETH_P_PREAUTH))
 		return -EINVAL;
 
+	if (proto == sdata->control_port_protocol)
+		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+
 	if (unencrypted)
 		flags = IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	else
@@ -5101,7 +5105,7 @@ int ieee80211_tx_control_port(struct wip
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, ctrl_flags);
 	local_bh_enable();
 
 	return 0;


