Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4D4A4215
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349276AbiAaLKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40362 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348644AbiAaLF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E31B460F96;
        Mon, 31 Jan 2022 11:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CA0C340E8;
        Mon, 31 Jan 2022 11:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627157;
        bh=3hFFj0tKoi4W0dZl+5NryhfL92TrUgIrc2iiMZM4PNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqKpgcJ5/szGiyQlYsV5akHUiI22U8sUl/cdjZzfzW6WpNRNiS7NGLBeCd8g7rEol
         xQdIm7O7Md45mpqlKnUZ/oROweQ7Q1SeBHlGEUFpSGCBsY0tSMXu7W6AoRHnGiA3zl
         lP12NZVPuh8EXgXNcFm+8OQXMw1RjydvVisNYWWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Poirier <bpoirier@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/100] net: bridge: vlan: fix single net device option dumping
Date:   Mon, 31 Jan 2022 11:56:53 +0100
Message-Id: <20220131105223.546309373@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
index 08c77418c687b..1f508d998fb2d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1873,7 +1873,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
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



