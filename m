Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C549733B739
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhCON7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232406AbhCON6x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13E5B64EEE;
        Mon, 15 Mar 2021 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816710;
        bh=Vr0sgJqWyvNZnVFR/n03t2Gv7d6qsk5EVb5smonF9Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSwy3xkEViYcJeCPd6CxusuzSiD3lU1IJW4b4xWumMw9s9a0raiaL0vY90NqDwb7G
         ivCIeu9Hc8cuGC3dUxba9FC/HPIU6b9TZDYsrqQA7BB8WmaYxWT/4YeoMXcLh7sqa1
         iaFVmDqJQQPudMGFxyn2u+NpZ+d0rPM3DxPAE7iM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 069/290] ethtool: fix the check logic of at least one channel for RX/TX
Date:   Mon, 15 Mar 2021 14:52:42 +0100
Message-Id: <20210315135544.237279519@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Yinjun Zhang <yinjun.zhang@corigine.com>

commit a4fc088ad4ff4a99d01978aa41065132b574b4b2 upstream.

The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
count and skip the error path, since the attrs
tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
are NULL in this case when recent ethtool is used.

Tested using ethtool v5.10.

Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for TX/RX in the core")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
Link: https://lore.kernel.org/r/20210225125102.23989-1-simon.horman@netronome.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/channels.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -116,10 +116,9 @@ int ethnl_set_channels(struct sk_buff *s
 	struct ethtool_channels channels = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
-	const struct nlattr *err_attr;
+	u32 err_attr, max_rx_in_use = 0;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
-	u32 max_rx_in_use = 0;
 	int ret;
 
 	ret = ethnl_parse_header_dev_get(&req_info,
@@ -157,34 +156,35 @@ int ethnl_set_channels(struct sk_buff *s
 
 	/* ensure new channel counts are within limits */
 	if (channels.rx_count > channels.max_rx)
-		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
 	else if (channels.tx_count > channels.max_tx)
-		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
 	else if (channels.other_count > channels.max_other)
-		err_attr = tb[ETHTOOL_A_CHANNELS_OTHER_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_OTHER_COUNT;
 	else if (channels.combined_count > channels.max_combined)
-		err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
 	else
-		err_attr = NULL;
+		err_attr = 0;
 	if (err_attr) {
 		ret = -EINVAL;
-		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
 				    "requested channel count exceeds maximum");
 		goto out_ops;
 	}
 
 	/* ensure there is at least one RX and one TX channel */
 	if (!channels.combined_count && !channels.rx_count)
-		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_RX_COUNT;
 	else if (!channels.combined_count && !channels.tx_count)
-		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+		err_attr = ETHTOOL_A_CHANNELS_TX_COUNT;
 	else
-		err_attr = NULL;
+		err_attr = 0;
 	if (err_attr) {
 		if (mod_combined)
-			err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+			err_attr = ETHTOOL_A_CHANNELS_COMBINED_COUNT;
 		ret = -EINVAL;
-		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
+		NL_SET_ERR_MSG_ATTR(info->extack, tb[err_attr],
+				    "requested channel counts would result in no RX or TX channel being configured");
 		goto out_ops;
 	}
 


