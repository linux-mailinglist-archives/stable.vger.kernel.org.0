Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4832E452391
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380134AbhKPB1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243575AbhKOTGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2121E633DD;
        Mon, 15 Nov 2021 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000191;
        bh=QBsdyln2SKZI/ZQfSg6Vcp1uXI6xlx8e+SspF8hZUi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5T2hWNUJzONRGiJWY0hZSmqCEyk2/H3KgrX3Lt9qNrYObGYb9Fi9d8DrIx6/YdCX
         9wZ45NNzp2XuLqonJelvfHEV8rEyTV4mUbaX1qhXY01yw3eZ7pJk0CeXuwgmKR+CDO
         Q8StzgQs/0QVi/D11RQZITLct1L+0GDNoPCtv270=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 537/849] net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled
Date:   Mon, 15 Nov 2021 18:00:20 +0100
Message-Id: <20211115165438.429863173@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 829e050eea69c7442441b714b6f5b339b5b8c367 ]

Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
that return a count. When BRIDGE_CFM is not enabled these functions
simply return -EOPNOTSUPP but do not modify count parameter and
calling function then works with uninitialized variables.
Modify these inline functions to return zero in count parameter.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Cc: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7d3155283af93..f538fe3902da9 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1594,11 +1594,13 @@ static inline int br_cfm_status_fill_info(struct sk_buff *skb,
 
 static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
 {
+	*count = 0;
 	return -EOPNOTSUPP;
 }
 
 static inline int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
 {
+	*count = 0;
 	return -EOPNOTSUPP;
 }
 #endif
-- 
2.33.0



