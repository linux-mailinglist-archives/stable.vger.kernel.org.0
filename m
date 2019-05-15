Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75511F06F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbfEOL0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729763AbfEOL0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A77DC206BF;
        Wed, 15 May 2019 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919607;
        bh=uOm5BvuEI4DDXppf2ixzVjQaw/JN4hbVR5wVHhA3v+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVA+x4vGXy9pT6+m1RHd31ZlWyda0hnTpxBDeuJSnOLUKSHUv5lSt0/Cj6WfzccDH
         t4LsKfuxozTLtSjREvmqsPR0YPcd5XkeL4XKqqlxKrigB/TFhX+dJQszfHi6nl0Nsh
         bScWfvc/ernyjSKbLypd9CeTb0z2sU4JVBAF+7uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Dutt <usdutt@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 025/137] nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands
Date:   Wed, 15 May 2019 12:55:06 +0200
Message-Id: <20190515090655.104251473@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d6db02a88a4aaa1cd7105137c67ddec7f3bdbc05 ]

This commit adds NL80211_FLAG_CLEAR_SKB flag to other NL commands
that carry key data to ensure they do not stick around on heap
after the SKB is freed.

Also introduced this flag for NL80211_CMD_VENDOR as there are sub
commands which configure the keys.

Signed-off-by: Sunil Dutt <usdutt@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d91a408db113e..156ce708b5330 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13596,7 +13596,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEAUTHENTICATE,
@@ -13647,7 +13648,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_UPDATE_CONNECT_PARAMS,
@@ -13655,7 +13657,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DISCONNECT,
@@ -13684,7 +13687,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMKSA,
@@ -14036,7 +14040,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_SET_QOS_MAP,
@@ -14091,7 +14096,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_pmk,
 		.policy = nl80211_policy,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMK,
-- 
2.20.1



