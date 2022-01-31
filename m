Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037314A43E1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350614AbiAaLYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376640AbiAaLVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:21:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613C3C0401F9;
        Mon, 31 Jan 2022 03:14:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22221B82A77;
        Mon, 31 Jan 2022 11:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3EBC36AE7;
        Mon, 31 Jan 2022 11:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627661;
        bh=TM6ShBcuDBeRXjnrT7eROLG26xrXJ3qDuQdpyK5UxLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNX9+gCO7hhP3kbZrGJRNnqZ6JnRWtilj1WKgOko8jhU0TBO+RdCaeBC7J2rEK8I/
         lXNNL8sLVObuWoR8zT4qq56MqJ+iYp8/enDGvro3qXSIUUKIXIfdKAap02+Yob12t4
         kLVyilf1e46St7EQQwfSmZ7H8wmLHrYeB4zB/OMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/171] net: bridge: vlan: fix single net device option dumping
Date:   Mon, 31 Jan 2022 11:57:01 +0100
Message-Id: <20220131105235.298947896@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit dcb2c5c6ca9b9177f04abaf76e5a983d177c9414 ]

When dumping vlan options for a single net device we send the same
entries infinitely because user-space expects a 0 return at the end but
we keep returning skb->len and restarting the dump on retry. Fix it by
returning the value from br_vlan_dump_dev() if it completed or there was
an error. The only case that must return skb->len is when the dump was
incomplete and needs to continue (-EMSGSIZE).

Reported-by: Benjamin Poirier <bpoirier@nvidia.com>
Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 19f65ab91a027..06f5caee495aa 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2105,7 +2105,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			goto out_err;
 		}
 		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
-		if (err && err != -EMSGSIZE)
+		/* if the dump completed without an error we return 0 here */
+		if (err != -EMSGSIZE)
 			goto out_err;
 	} else {
 		for_each_netdev_rcu(net, dev) {
-- 
2.34.1



