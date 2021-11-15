Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3219445127F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbhKOTgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244726AbhKOTRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E43632C9;
        Mon, 15 Nov 2021 18:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000600;
        bh=KZ51aFIuzywb7/grdl9Zcnf9MqAlkUEytIqHnCzyb2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxWvVc4wphtfN7ToTS5Q5C5UWPCefmHLZkf49jAi68W2kIdA66gbOjG3OD+Rzqubg
         I7FKYgH2YFX4hAaL49igIbspKWPf2cB1JwhbvESwP2RHvdnwnOLPBMEV20DWkuh0aj
         NzuywHRSKf7bGJGsRkbfRpVdY73M0raVKiI3Knjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 721/849] ethtool: fix ethtool msg len calculation for pause stats
Date:   Mon, 15 Nov 2021 18:03:24 +0100
Message-Id: <20211115165444.647717195@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1aabe578dd86e9f2867c4db4fba9a15f4ba1825d ]

ETHTOOL_A_PAUSE_STAT_MAX is the MAX attribute id,
so we need to subtract non-stats and add one to
get a count (IOW -2+1 == -1).

Otherwise we'll see:

  ethnl cmd 21: calculated reply length 40, but consumed 52

Fixes: 9a27a33027f2 ("ethtool: add standard pause stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ethtool_netlink.h      | 3 +++
 include/uapi/linux/ethtool_netlink.h | 4 +++-
 net/ethtool/pause.c                  | 3 +--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 1e7bf78cb3829..aba348d58ff61 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -10,6 +10,9 @@
 #define __ETHTOOL_LINK_MODE_MASK_NWORDS \
 	DIV_ROUND_UP(__ETHTOOL_LINK_MODE_MASK_NBITS, 32)
 
+#define ETHTOOL_PAUSE_STAT_CNT	(__ETHTOOL_A_PAUSE_STAT_CNT -		\
+				 ETHTOOL_A_PAUSE_STAT_TX_FRAMES)
+
 enum ethtool_multicast_groups {
 	ETHNL_MCGRP_MONITOR,
 };
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index b3b93710eff70..010edbb7382d4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -405,7 +405,9 @@ enum {
 	ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
 	ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
 
-	/* add new constants above here */
+	/* add new constants above here
+	 * adjust ETHTOOL_PAUSE_STAT_CNT if adding non-stats!
+	 */
 	__ETHTOOL_A_PAUSE_STAT_CNT,
 	ETHTOOL_A_PAUSE_STAT_MAX = (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
 };
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 9009f412151e7..ee1e5806bc93a 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -56,8 +56,7 @@ static int pause_reply_size(const struct ethnl_req_info *req_base,
 
 	if (req_base->flags & ETHTOOL_FLAG_STATS)
 		n += nla_total_size(0) +	/* _PAUSE_STATS */
-			nla_total_size_64bit(sizeof(u64)) *
-				(ETHTOOL_A_PAUSE_STAT_MAX - 2);
+		     nla_total_size_64bit(sizeof(u64)) * ETHTOOL_PAUSE_STAT_CNT;
 	return n;
 }
 
-- 
2.33.0



