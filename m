Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AAB19B069
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbgDAQ0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387675AbgDAQ0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:26:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF14220BED;
        Wed,  1 Apr 2020 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758404;
        bh=OVm+jbi7TFRfCADhUrWLyr18JMH1hHF+qU86kaYm5/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jiFwkUOZrvTAGkQK53VcPTKsN78gwkOiA/aCILYobfC/Kav9txgHcqpWGPF/IdHGY
         PRVKGP/Rjs1yP0et8fCUGl/9PH9A2EdU+nh/uXr5mJGB/JAGUTvsFcDOZzzWrOQA2O
         eMOEKGHdTnJXtq5PKNblPcPNsUzNd7BLUCm80YbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/116] mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX
Date:   Wed,  1 Apr 2020 18:17:34 +0200
Message-Id: <20200401161552.658638343@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b95d2ccd2ccb834394d50347d0e40dc38a954e4a ]

When a frame is transmitted via the nl80211 TX rather than as a
normal frame, IEEE80211_TX_CTRL_PORT_CTRL_PROTO wasn't set and
this will lead to wrong decisions (rate control etc.) being made
about the frame; fix this.

Fixes: 911806491425 ("mac80211: Add support for tx_control_port")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200326155333.f183f52b02f0.I4054e2a8c11c2ddcb795a0103c87be3538690243@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018, 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -4840,6 +4840,7 @@ int ieee80211_tx_control_port(struct wip
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ethhdr *ehdr;
+	u32 ctrl_flags = 0;
 	u32 flags;
 
 	/* Only accept CONTROL_PORT_PROTOCOL configured in CONNECT/ASSOCIATE
@@ -4849,6 +4850,9 @@ int ieee80211_tx_control_port(struct wip
 	    proto != cpu_to_be16(ETH_P_PREAUTH))
 		return -EINVAL;
 
+	if (proto == sdata->control_port_protocol)
+		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+
 	if (unencrypted)
 		flags = IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	else
@@ -4874,7 +4878,7 @@ int ieee80211_tx_control_port(struct wip
 	skb_reset_mac_header(skb);
 
 	local_bh_disable();
-	__ieee80211_subif_start_xmit(skb, skb->dev, flags, 0);
+	__ieee80211_subif_start_xmit(skb, skb->dev, flags, ctrl_flags);
 	local_bh_enable();
 
 	return 0;


